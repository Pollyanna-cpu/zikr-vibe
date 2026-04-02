import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme.dart';

class PrayerScreen extends ConsumerWidget {
  const PrayerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Placeholder prayer times — will use adhan library
    final prayers = [
      _PrayerTime('Fajr', '04:52 AM', false),
      _PrayerTime('Dhuhr', '12:18 PM', false),
      _PrayerTime('Asr', '03:42 PM', true), // next prayer
      _PrayerTime('Maghrib', '06:31 PM', false),
      _PrayerTime('Isha', '07:51 PM', false),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Prayer Times')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Location header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: ZikrColors.emerald,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                children: [
                  Icon(Icons.location_on_rounded, color: Colors.white, size: 24),
                  SizedBox(height: 8),
                  Text(
                    'Loading location...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Calculation: Umm al-Qura',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Prayer times list
            ...prayers.map((prayer) => _PrayerCard(prayer: prayer)),

            const Spacer(),

            // Qibla button
            OutlinedButton.icon(
              onPressed: () {
                // TODO: Qibla compass screen
              },
              icon: const Icon(Icons.explore_rounded),
              label: const Text('Qibla Compass'),
              style: OutlinedButton.styleFrom(
                foregroundColor: ZikrColors.emerald,
                side: const BorderSide(color: ZikrColors.emerald),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _PrayerTime {
  final String name;
  final String time;
  final bool isNext;

  _PrayerTime(this.name, this.time, this.isNext);
}

class _PrayerCard extends StatelessWidget {
  final _PrayerTime prayer;

  const _PrayerCard({required this.prayer});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: prayer.isNext ? ZikrColors.emerald.withValues(alpha: 0.08) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: prayer.isNext ? ZikrColors.emerald : ZikrColors.divider,
          width: prayer.isNext ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          if (prayer.isNext)
            Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.only(right: 12),
              decoration: const BoxDecoration(
                color: ZikrColors.emerald,
                shape: BoxShape.circle,
              ),
            ),
          Text(
            prayer.name,
            style: TextStyle(
              fontSize: 16,
              fontWeight: prayer.isNext ? FontWeight.w600 : FontWeight.w400,
              color: ZikrColors.ink,
            ),
          ),
          const Spacer(),
          Text(
            prayer.time,
            style: TextStyle(
              fontSize: 16,
              fontWeight: prayer.isNext ? FontWeight.w600 : FontWeight.w400,
              color: prayer.isNext ? ZikrColors.emerald : ZikrColors.inkMuted,
            ),
          ),
        ],
      ),
    );
  }
}
