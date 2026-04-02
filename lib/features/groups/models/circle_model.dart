// Dhikr Circle — companion model (presence, not competition)
//
// Design principles:
// - Members see WHO showed up, never HOW MUCH
// - Shared Streak: one person breaks, whole group resets (Duolingo model)
// - System nudges, not personal monitoring ("Your circle missed today")
// - Never expose which member broke the streak

class Circle {
  final String id;
  final String name;
  final String adminId;
  final String inviteCode;
  final List<CircleMember> members;
  final int sharedStreak;
  final int longestSharedStreak;

  const Circle({
    required this.id,
    required this.name,
    required this.adminId,
    required this.inviteCode,
    this.members = const [],
    this.sharedStreak = 0,
    this.longestSharedStreak = 0,
  });

  /// How many members were active today
  int get activeTodayCount =>
      members.where((m) => m.activeToday).length;

  /// Is everyone active today?
  bool get allActiveToday =>
      members.isNotEmpty && activeTodayCount == members.length;

  /// Display: "3 of 5 remembered today"
  String get presenceSummary =>
      '$activeTodayCount of ${members.length} remembered today';
}

class CircleMember {
  final String userId;
  final String displayName;
  final bool activeToday;
  final String? lastActiveLabel; // "today", "yesterday", "3 days ago"

  const CircleMember({
    required this.userId,
    required this.displayName,
    required this.activeToday,
    this.lastActiveLabel,
  });
}

/// Shared Streak rules:
///
/// 1. ALL members must do dhikr each day to keep the streak alive
/// 2. If ANY member misses a day, the shared streak resets to 0
/// 3. The app does NOT reveal which member broke it
///    — Just: "Your circle's streak was reset. Start again together."
/// 4. Mercy rule: 1 grace day per week (same as personal streak)
/// 5. New members joining don't break the streak
///
/// Why this works (Duolingo data):
/// - Users with Friend Streak complete daily tasks 22% more often
/// - The FEAR of breaking someone else's streak is stronger than
///   the desire to maintain your own
/// - It's quiet accountability: no one says "do your dhikr",
///   the shared streak number does it for them
///
/// System nudge (NOT from a specific person):
/// - 8pm local: "Your circle is 4/5 today. Your ✓ keeps the streak alive."
/// - Never: "Ahmad hasn't done dhikr yet" ← this is surveillance, not support
