import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/analytics.dart';

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
  StreakNotifier() : super(const StreakState()) {
    _load();
  }

  void _load() {
    final box = Hive.box('dhikr_sessions');

    // Load counter groups to calculate total
    final saved = box.get('counter_groups');
    int total = 0;
    if (saved != null && saved is List) {
      for (final g in saved) {
        total += (g['count'] as int? ?? 0);
      }
    }

    // Load active dates
    final dates = box.get('active_dates');
    final Set<String> activeDates = {};
    if (dates != null && dates is List) {
      for (final d in dates) {
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

  /// Refresh totals from counter data
  void refreshTotal(int total) {
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

final streakProvider = StateNotifierProvider<StreakNotifier, StreakState>((ref) {
  return StreakNotifier();
});
