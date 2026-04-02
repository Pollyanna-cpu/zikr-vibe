import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme.dart';
import '../providers/streak_provider.dart';

class StreakScreen extends ConsumerWidget {
  const StreakScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streak = ref.watch(streakProvider);
    final now = DateTime.now();

    return Scaffold(
      backgroundColor: ZikrColors.marble,
      appBar: AppBar(
        title: const Text('Your Journey'),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),

            // Streak hero card
            _StreakHeroCard(streak: streak),

            const SizedBox(height: 32),

            // Stats row
            Row(
              children: [
                Expanded(child: _StatTile(
                  label: 'Current',
                  value: '${streak.currentStreak}',
                  unit: 'days',
                  color: ZikrColors.emerald,
                )),
                const SizedBox(width: 12),
                Expanded(child: _StatTile(
                  label: 'Longest',
                  value: '${streak.longestStreak}',
                  unit: 'days',
                  color: ZikrColors.gold,
                )),
                const SizedBox(width: 12),
                Expanded(child: _StatTile(
                  label: 'Lifetime',
                  value: _formatCount(streak.lifetimeTotal),
                  unit: 'dhikr',
                  color: ZikrColors.inkSoft,
                )),
              ],
            ),

            const SizedBox(height: 32),

            // Calendar
            Text(
              'This Month',
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: ZikrColors.ink,
              ),
            ),
            const SizedBox(height: 16),
            _MonthCalendar(
              year: now.year,
              month: now.month,
              activeDates: streak.activeDates,
            ),

            const SizedBox(height: 24),

            // Previous month
            Text(
              _monthName(now.month == 1 ? 12 : now.month - 1),
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: ZikrColors.ink,
              ),
            ),
            const SizedBox(height: 16),
            _MonthCalendar(
              year: now.month == 1 ? now.year - 1 : now.year,
              month: now.month == 1 ? 12 : now.month - 1,
              activeDates: streak.activeDates,
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 10000) return '${(count / 1000).toStringAsFixed(1)}K';
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}K';
    return '$count';
  }

  String _monthName(int month) {
    const names = [
      '', 'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return names[month];
  }
}

/// Big streak number with fire indicator
class _StreakHeroCard extends StatelessWidget {
  final StreakState streak;

  const _StreakHeroCard({required this.streak});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: ZikrColors.divider, width: 0.5),
      ),
      child: Column(
        children: [
          // Fire emoji for active streaks
          if (streak.currentStreak > 0) ...[
            Text(
              streak.currentStreak >= 30 ? '🔥🔥🔥' :
              streak.currentStreak >= 7 ? '🔥🔥' : '🔥',
              style: const TextStyle(fontSize: 28),
            ),
            const SizedBox(height: 8),
          ],
          Text(
            '${streak.currentStreak}',
            style: GoogleFonts.inter(
              fontSize: 64,
              fontWeight: FontWeight.w700,
              color: streak.currentStreak > 0 ? ZikrColors.emerald : ZikrColors.inkMuted,
              height: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            streak.currentStreak == 1 ? 'day streak' : 'day streak',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: ZikrColors.inkMuted,
            ),
          ),
        ],
      ),
    );
  }
}

/// Single stat tile
class _StatTile extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final Color color;

  const _StatTile({
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: ZikrColors.divider, width: 0.5),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: GoogleFonts.inter(fontSize: 11, color: ZikrColors.inkMuted),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          Text(
            unit,
            style: GoogleFonts.inter(fontSize: 11, color: ZikrColors.inkMuted),
          ),
        ],
      ),
    );
  }
}

/// Calendar grid showing active/inactive days
class _MonthCalendar extends StatelessWidget {
  final int year;
  final int month;
  final Set<String> activeDates;

  const _MonthCalendar({
    required this.year,
    required this.month,
    required this.activeDates,
  });

  @override
  Widget build(BuildContext context) {
    final firstDay = DateTime(year, month, 1);
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final startWeekday = firstDay.weekday % 7; // 0=Sun
    final today = DateTime.now();

    return Column(
      children: [
        // Weekday headers
        Row(
          children: ['S', 'M', 'T', 'W', 'T', 'F', 'S']
              .map((d) => Expanded(
                    child: Center(
                      child: Text(
                        d,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: ZikrColors.inkMuted,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ))
              .toList(),
        ),
        const SizedBox(height: 8),

        // Day grid
        ...List.generate(6, (week) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              children: List.generate(7, (weekday) {
                final dayIndex = week * 7 + weekday - startWeekday + 1;
                if (dayIndex < 1 || dayIndex > daysInMonth) {
                  return const Expanded(child: SizedBox(height: 36));
                }

                final date = DateTime(year, month, dayIndex);
                final dateKey =
                    '$year-${month.toString().padLeft(2, '0')}-${dayIndex.toString().padLeft(2, '0')}';
                final isActive = activeDates.contains(dateKey);
                final isToday = date.year == today.year &&
                    date.month == today.month &&
                    date.day == today.day;
                final isFuture = date.isAfter(today);

                return Expanded(
                  child: Container(
                    height: 36,
                    margin: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: isActive
                          ? ZikrColors.emerald
                          : isToday
                              ? ZikrColors.emeraldSoft
                              : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        '$dayIndex',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: isToday ? FontWeight.w600 : FontWeight.w400,
                          color: isActive
                              ? Colors.white
                              : isFuture
                                  ? ZikrColors.inkMuted.withValues(alpha: 0.3)
                                  : ZikrColors.ink,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          );
        }),
      ],
    );
  }
}
