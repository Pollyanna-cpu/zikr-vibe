import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/analytics.dart';
import '../models/counter_group.dart';

/// Dhikr state: multiple persistent counter groups
class DhikrState {
  final List<CounterGroup> groups;
  final int activeIndex;

  /// Taps made today (date-keyed, so it survives counter resets and
  /// rolls over at midnight — unlike summing live counter values).
  final int todayCount;

  const DhikrState({
    required this.groups,
    this.activeIndex = 0,
    this.todayCount = 0,
  });

  CounterGroup get active {
    if (groups.isEmpty) return defaultGroups().first;
    final idx = activeIndex.clamp(0, groups.length - 1);
    return groups[idx];
  }

  DhikrState copyWith({
    List<CounterGroup>? groups,
    int? activeIndex,
    int? todayCount,
  }) {
    return DhikrState(
      groups: groups ?? this.groups,
      activeIndex: activeIndex ?? this.activeIndex,
      todayCount: todayCount ?? this.todayCount,
    );
  }
}

class DhikrNotifier extends StateNotifier<DhikrState> {
  DhikrNotifier() : super(DhikrState(groups: defaultGroups())) {
    _loadFromStorage();
  }

  /// Load persisted counters from Hive
  void _loadFromStorage() {
    final box = Hive.box('dhikr_sessions');
    final saved = box.get('counter_groups');
    List<CounterGroup>? groups;
    if (saved != null && saved is List) {
      try {
        final parsed = saved
            .map((m) => CounterGroup.fromMap(Map<dynamic, dynamic>.from(m)))
            .toList();
        if (parsed.isNotEmpty) groups = parsed;
      } catch (e) {
        debugPrint('[Dhikr] Corrupted Hive counter_groups, using defaults: $e');
      }
    }

    // Today's tap count — keyed by date, so stale entries never leak in.
    final daily = box.get('daily_counts');
    int todayCount = 0;
    if (daily is Map) {
      final v = daily[_todayKey()];
      if (v is int) todayCount = v;
    }

    state = DhikrState(
      groups: groups ?? state.groups,
      todayCount: todayCount,
    );
  }

  static String _todayKey() {
    final d = DateTime.now();
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  /// Save all counters to Hive
  void _persist() {
    final box = Hive.box('dhikr_sessions');
    box.put('counter_groups', state.groups.map((g) => g.toMap()).toList());
  }

  /// Milestone counts for tasbih cycle
  static const _milestones = {33, 66, 99, 100};

  /// Tap: increment active counter by 1
  void tap() {
    final group = state.active;
    if (group.isAtMax) {
      HapticFeedback.heavyImpact();
      return;
    }

    Analytics.dhikrStartIfFirstToday();

    group.count += 1;

    // Haptic feedback: strong pulse at tasbih milestones, light tap otherwise
    if (_milestones
        .contains(group.count % 100 == 0 ? 100 : group.count % 100)) {
      HapticFeedback.heavyImpact();
    } else {
      HapticFeedback.lightImpact();
    }

    if (group.count == 100) {
      Analytics.dhikrComplete100();
    }

    // True lifetime total: monotonic, survives counter resets. Kept in Hive
    // (not derived from live counters) — Profile/Streak read this key.
    final box = Hive.box('dhikr_sessions');
    final lifetime = box.get('lifetime_total');
    box.put('lifetime_total', (lifetime is int ? lifetime : 0) + 1);

    // Per-day tap counts: date-keyed map, midnight-correct "today".
    final today = _todayKey();
    final raw = box.get('daily_counts');
    final daily =
        raw is Map ? Map<dynamic, dynamic>.from(raw) : <dynamic, dynamic>{};
    final prev = daily[today];
    final todayCount = (prev is int ? prev : 0) + 1;
    daily[today] = todayCount;
    // Prune: keep the most recent 90 dates so the box never grows unbounded.
    if (daily.length > 90) {
      final keys = daily.keys.map((k) => k.toString()).toList()..sort();
      while (keys.length > 90) {
        daily.remove(keys.removeAt(0));
      }
    }
    box.put('daily_counts', daily);

    state = state.copyWith(groups: [...state.groups], todayCount: todayCount);
    _persist();
  }

  /// Check if current count just hit a milestone
  bool get isAtMilestone {
    final c = state.active.count;
    if (c == 0) return false;
    final mod = c % 100;
    return _milestones.contains(mod == 0 ? 100 : mod);
  }

  /// Switch to group by index
  void switchGroup(int index) {
    if (index < 0 || index >= state.groups.length) return;
    HapticFeedback.selectionClick();
    state = state.copyWith(activeIndex: index);
  }

  /// Reset active group counter (with confirmation handled in UI)
  void resetActive() {
    state.active.count = 0;
    HapticFeedback.mediumImpact();
    state = state.copyWith(groups: [...state.groups]);
    _persist();
  }

  /// Add a new group (max 5). Trims and clamps the name; rejects empty.
  /// Returns true if the group was added.
  bool addGroup(String name) {
    if (state.groups.length >= 5) return false;
    final cleaned = name.trim();
    if (cleaned.isEmpty) return false;
    final clamped = cleaned.length > 30 ? cleaned.substring(0, 30) : cleaned;
    final newGroup = CounterGroup(
      id: 'g${DateTime.now().millisecondsSinceEpoch}',
      name: clamped,
    );
    final updated = [...state.groups, newGroup];
    state = DhikrState(groups: updated, activeIndex: updated.length - 1);
    _persist();
    return true;
  }

  /// Rename a group. Same trim/clamp/empty rules as addGroup.
  void renameGroup(int index, String newName) {
    if (index < 0 || index >= state.groups.length) return;
    final cleaned = newName.trim();
    if (cleaned.isEmpty) return;
    final clamped = cleaned.length > 30 ? cleaned.substring(0, 30) : cleaned;
    state.groups[index].name = clamped;
    state = state.copyWith(groups: [...state.groups]);
    _persist();
  }

  /// Delete a group (min 1 must remain)
  void deleteGroup(int index) {
    if (state.groups.length <= 1) return;
    final updated = [...state.groups]..removeAt(index);
    final newIndex = state.activeIndex >= updated.length
        ? updated.length - 1
        : state.activeIndex;
    state = DhikrState(groups: updated, activeIndex: newIndex);
    _persist();
  }
}

final dhikrProvider = StateNotifierProvider<DhikrNotifier, DhikrState>((ref) {
  return DhikrNotifier();
});
