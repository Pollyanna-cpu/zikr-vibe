import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/analytics.dart';
import '../../dhikr/providers/dhikr_provider.dart';

class StreakState {
  final int currentStreak;
  final int longestStreak;
  final int lifetimeTotal;
  final Set<String> activeDates; // 'yyyy-MM-dd' format
  final String? lastActiveDate;

  const StreakState({
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.lifetimeTotal = 0,
    this.activeDates = const {},
    this.lastActiveDate,
  });

  bool isActiveOn(DateTime date) {
    final key = _dateKey(date);
    return activeDates.contains(key);
  }

  static String _dateKey(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}

class StreakNotifier extends StateNotifier<StreakState> {
  StreakNotifier(this._ref) : super(const StreakState()) {
    _load();
    // Keep lifetimeTotal reactive: any time the user taps the counter, adds
    // a group, resets, etc., dhikrProvider emits a new state and we recompute
    // the total so Profile / Streak screen don't show stale numbers.
    _ref.listen<DhikrState>(dhikrProvider, (_, next) {
      _refreshLifetimeTotal(next);
    });
  }

  final Ref _ref;

  void _load() {
    final box = Hive.box('dhikr_sessions');

    // Lifetime total: monotonic Hive counter written by DhikrNotifier.tap().
    // Migration for pre-existing installs (key absent): seed it from the sum
    // of live counters — best available approximation — then it only grows.
    final storedTotal = box.get('lifetime_total');
    int total;
    if (storedTotal is int) {
      total = storedTotal;
    } else {
      final saved = box.get('counter_groups');
      total = 0;
      if (saved is List) {
        for (final g in saved) {
          if (g is Map) {
            final c = g['count'];
            if (c is int) total += c;
          }
        }
      }
      box.put('lifetime_total', total);
    }

    // Load active dates. Same defensive parse — drop non-stringable items.
    final dates = box.get('active_dates');
    final Set<String> activeDates = {};
    if (dates is List) {
      for (final d in dates) {
        if (d == null) continue;
        activeDates.add(d.toString());
      }
    }

    // Calculate streak
    final today = _todayKey();
    int streak = 0;
    int longestStreak = box.get('longest_streak', defaultValue: 0) as int;
    DateTime check = DateTime.now();

    // Count backwards from today
    while (true) {
      final key = StreakState._dateKey(check);
      if (activeDates.contains(key)) {
        streak++;
        check = check.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }

    if (streak > longestStreak) {
      longestStreak = streak;
      box.put('longest_streak', longestStreak);
    }

    state = StreakState(
      currentStreak: streak,
      longestStreak: longestStreak,
      lifetimeTotal: total,
      activeDates: activeDates,
      lastActiveDate: activeDates.isEmpty ? null : today,
    );
  }

  /// Mark today as active (called when user taps counter)
  void markTodayActive() {
    final today = _todayKey();
    if (state.activeDates.contains(today)) return; // Already marked

    final updated = {...state.activeDates, today};
    final box = Hive.box('dhikr_sessions');
    box.put('active_dates', updated.toList());

    // Sync to Supabase (fire-and-forget, local-first)
    _syncPresenceToSupabase(today);

    // Recalculate streak
    int streak = 0;
    DateTime check = DateTime.now();
    while (true) {
      final key = StreakState._dateKey(check);
      if (updated.contains(key)) {
        streak++;
        check = check.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }

    int longest = state.longestStreak;
    if (streak > longest) {
      longest = streak;
      box.put('longest_streak', longest);
    }

    state = StreakState(
      currentStreak: streak,
      longestStreak: longest,
      lifetimeTotal: state.lifetimeTotal,
      activeDates: updated,
      lastActiveDate: today,
    );

    Analytics.streakDay2IfNew(streak);
  }

  /// Re-read the monotonic lifetime counter after any dhikr mutation. Called
  /// by the ref.listen on dhikrProvider above; cheap because it's one box get.
  void _refreshLifetimeTotal(DhikrState dhikr) {
    final box = Hive.box('dhikr_sessions');
    final stored = box.get('lifetime_total');
    final total = stored is int ? stored : state.lifetimeTotal;
    if (total == state.lifetimeTotal) return;
    state = StreakState(
      currentStreak: state.currentStreak,
      longestStreak: state.longestStreak,
      lifetimeTotal: total,
      activeDates: state.activeDates,
      lastActiveDate: state.lastActiveDate,
    );
  }

  static String _todayKey() => StreakState._dateKey(DateTime.now());

  /// Fire-and-forget sync to Supabase
  Future<void> _syncPresenceToSupabase(String dateKey) async {
    try {
      final client = Supabase.instance.client;
      final user = client.auth.currentUser;
      if (user == null) return;

      await client.from('daily_presence').upsert({
        'user_id': user.id,
        'date': dateKey,
        'active': true,
      });
    } catch (_) {
      // Offline or not configured — local data is source of truth
    }
  }
}

final streakProvider =
    StateNotifierProvider<StreakNotifier, StreakState>((ref) {
  return StreakNotifier(ref);
});
