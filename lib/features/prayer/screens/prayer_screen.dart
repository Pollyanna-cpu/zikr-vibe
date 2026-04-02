import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:adhan_dart/adhan_dart.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import '../../../core/theme.dart';

final prayerDataProvider = FutureProvider<_PrayerData>((ref) async {
  double lat = 25.2048;
  double lng = 55.2708;
  String locationName = 'Dubai (default)';

  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
  }

  if (permission != LocationPermission.denied &&
      permission != LocationPermission.deniedForever) {
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
        timeLimit: const Duration(seconds: 10),
      );
      lat = position.latitude;
      lng = position.longitude;
      locationName = '${lat.toStringAsFixed(2)}, ${lng.toStringAsFixed(2)}';
    } catch (_) {
      // Fall back to Dubai
    }
  }

  return _calculatePrayers(lat, lng, locationName);
});

_PrayerData _calculatePrayers(double lat, double lng, String locationName) {
  final coordinates = Coordinates(lat, lng);
  final params = CalculationMethodParameters.ummAlQura();
  final now = DateTime.now();
  final prayerTimes = PrayerTimes(
    coordinates: coordinates,
    date: now,
    calculationParameters: params,
  );

  final nextPrayer = prayerTimes.nextPrayer();
  final timeFormat = DateFormat('hh:mm a');

  final prayers = [
    _PrayerTime('Fajr', timeFormat.format(prayerTimes.fajr),
        nextPrayer == Prayer.fajr),
    _PrayerTime('Sunrise', timeFormat.format(prayerTimes.sunrise),
        nextPrayer == Prayer.sunrise),
    _PrayerTime('Dhuhr', timeFormat.format(prayerTimes.dhuhr),
        nextPrayer == Prayer.dhuhr),
    _PrayerTime('Asr', timeFormat.format(prayerTimes.asr),
        nextPrayer == Prayer.asr),
    _PrayerTime('Maghrib', timeFormat.format(prayerTimes.maghrib),
        nextPrayer == Prayer.maghrib),
    _PrayerTime('Isha', timeFormat.format(prayerTimes.isha),
        nextPrayer == Prayer.isha),
  ];

  final qiblaDirection = Qibla.qibla(coordinates);

  return _PrayerData(
    prayers: prayers,
    locationName: locationName,
    qiblaDirection: qiblaDirection,
    method: 'Umm al-Qura',
  );
}

class _PrayerData {
  final List<_PrayerTime> prayers;
  final String locationName;
  final double qiblaDirection;
  final String method;

  _PrayerData({
    required this.prayers,
    required this.locationName,
    required this.qiblaDirection,
    required this.method,
  });
}

class PrayerScreen extends ConsumerWidget {
  const PrayerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prayerAsync = ref.watch(prayerDataProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Prayer Times')),
      body: prayerAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text('Could not load prayer times:\n$err',
                textAlign: TextAlign.center),
          ),
        ),
        data: (data) => _PrayerBody(data: data),
      ),
    );
  }
}

class _PrayerBody extends StatelessWidget {
  final _PrayerData data;

  const _PrayerBody({required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: ZikrColors.emerald,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Icon(Icons.location_on_rounded,
                    color: Colors.white, size: 24),
                const SizedBox(height: 8),
                Text(
                  data.locationName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Calculation: ${data.method}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          ...data.prayers.map((prayer) => _PrayerCard(prayer: prayer)),

          const Spacer(),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              border: Border.all(color: ZikrColors.emerald),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.explore_rounded,
                    color: ZikrColors.emerald, size: 20),
                const SizedBox(width: 10),
                Text(
                  'Qibla: ${data.qiblaDirection.toStringAsFixed(1)}\u00B0',
                  style: const TextStyle(
                    color: ZikrColors.emerald,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
        ],
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
        color: prayer.isNext
            ? ZikrColors.emerald.withValues(alpha: 0.08)
            : Colors.white,
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
