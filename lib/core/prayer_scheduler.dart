import 'package:adhan_dart/adhan_dart.dart';
import 'package:flutter/foundation.dart' show debugPrint, kIsWeb;
import 'package:intl/intl.dart';

import '../features/prayer/data/cities.dart';
import '../features/prayer/providers/prayer_settings_provider.dart';
import 'notifications.dart';

/// Pre-schedules prayer reminders for the next 7 days as local notifications.
///
/// Re-run from three places so the window keeps sliding without any
/// background service: app boot, every prayer-screen load, and after a
/// settings change. If the app is not opened for 7 straight days the
/// reminders run out — documented limitation; a background rescheduler is
/// deliberately out of scope (battery-optimization kills make it unreliable
/// anyway, and it would add the app's first background dependency).
///
/// 5 prayers × 7 days = 35 pending notifications, safely under iOS's cap
/// of 64. All computation is local; nothing leaves the device.
class PrayerScheduler {
  static const int _baseId = 100;
  static const int _idLimit = 200;
  static const int days = 7;

  /// Recompute and re-arm everything. Returns the number of reminders
  /// scheduled (0 when disabled, on web, or with no known location).
  static Future<int> reschedule() async {
    if (kIsWeb) return 0;

    await NotificationService.cancelPrayerReminders();
    if (!PrayerSettings.remindersEnabled()) return 0;

    // Manual city wins; otherwise last coordinates the prayer screen used.
    final cityIndex = PrayerSettings.cityIndex();
    double lat, lng;
    if (cityIndex >= 0 && cityIndex < kCities.length) {
      lat = kCities[cityIndex].lat;
      lng = kCities[cityIndex].lng;
    } else {
      final cached = PrayerSettings.cachedCoords();
      if (cached == null) return 0;
      lat = cached.lat;
      lng = cached.lng;
    }

    final params = PrayerSettings.buildParams();
    final coordinates = Coordinates(lat, lng);
    final offset = PrayerSettings.reminderOffset();
    final enabled = PrayerSettings.enabledPrayers();
    final timeFormat = DateFormat('h:mm a');
    final now = DateTime.now();

    int id = _baseId;
    int count = 0;

    for (int d = 0; d < days && id < _idLimit; d++) {
      // Local noon anchor avoids UTC-midnight day-shift at the date line.
      final date = DateTime(now.year, now.month, now.day + d, 12);
      final times = PrayerTimes(
        coordinates: coordinates,
        date: date,
        calculationParameters: params,
      );

      final five = <(String, DateTime)>[
        ('Fajr', times.fajr.toLocal()),
        ('Dhuhr', times.dhuhr.toLocal()),
        ('Asr', times.asr.toLocal()),
        ('Maghrib', times.maghrib.toLocal()),
        ('Isha', times.isha.toLocal()),
      ];

      for (final (name, at) in five) {
        if (id >= _idLimit) break;
        if (!enabled.contains(name)) continue;
        final fireAt = at.subtract(Duration(minutes: offset));
        if (fireAt.isBefore(now)) continue;

        final clock = timeFormat.format(at);
        final ok = await NotificationService.schedulePrayerAt(
          id: id++,
          title: offset == 0 ? name : '$name in $offset min',
          body:
              offset == 0 ? 'It is time for $name — $clock' : '$name at $clock',
          time: fireAt,
        );
        if (ok) count++;
      }
    }

    debugPrint('[PrayerScheduler] armed $count reminders '
        '(offset ${offset}m, ${enabled.length} prayers, $days days)');
    return count;
  }
}
