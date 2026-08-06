import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart' show PlatformException;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();
  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;

    tz.initializeTimeZones();

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _plugin.initialize(
      const InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      ),
    );

    // Android 13+ (API 33) requires explicit POST_NOTIFICATIONS runtime
    // permission — without it, scheduled prayer reminders silently no-op.
    if (!kIsWeb && Platform.isAndroid) {
      await _plugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    }

    _initialized = true;
  }

  static const NotificationDetails _prayerDetails = NotificationDetails(
    android: AndroidNotificationDetails(
      'prayer_reminders',
      'Prayer Reminders',
      channelDescription: 'Notifications before prayer times',
      importance: Importance.high,
      priority: Priority.high,
    ),
    iOS: DarwinNotificationDetails(),
  );

  /// Prayer reminders own notification ids [100, 200) so they can be
  /// cancelled as a block without touching anything else.
  static const int prayerIdStart = 100;
  static const int prayerIdEnd = 200;

  /// Schedule one prayer reminder at an absolute time. Tries an exact alarm
  /// first (Android 12 grants it by default; 14+ usually denies) and falls
  /// back to inexact — which Doze may delay by up to ~15 minutes — rather
  /// than dragging the user through the system settings page.
  static Future<bool> schedulePrayerAt({
    required int id,
    required String title,
    required String body,
    required DateTime time,
  }) async {
    if (time.isBefore(DateTime.now())) return false;
    final tzTime = tz.TZDateTime.from(time, tz.local);

    var mode = AndroidScheduleMode.inexactAllowWhileIdle;
    if (!kIsWeb && Platform.isAndroid) {
      final android = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      final canExact = await android?.canScheduleExactNotifications() ?? false;
      if (canExact) mode = AndroidScheduleMode.exactAllowWhileIdle;
    }

    try {
      await _plugin.zonedSchedule(
        id,
        title,
        body,
        tzTime,
        _prayerDetails,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: mode,
      );
      return true;
    } on PlatformException {
      // Exact permission revoked between check and call — retry inexact.
      if (mode == AndroidScheduleMode.exactAllowWhileIdle) {
        await _plugin.zonedSchedule(
          id,
          title,
          body,
          tzTime,
          _prayerDetails,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        );
        return true;
      }
      return false;
    }
  }

  /// Cancel every pending prayer reminder, leaving other notifications alone.
  static Future<void> cancelPrayerReminders() async {
    final pending = await _plugin.pendingNotificationRequests();
    for (final p in pending) {
      if (p.id >= prayerIdStart && p.id < prayerIdEnd) {
        await _plugin.cancel(p.id);
      }
    }
  }

  /// Circle nudge: "Your circle is 3/5 today"
  static Future<void> showCircleNudge({
    required String circleName,
    required int active,
    required int total,
  }) async {
    await _plugin.show(
      900, // fixed ID for circle nudge
      'Dhikr Circle',
      '$circleName: $active of $total remembered today. Your \u2713 keeps the streak alive.',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'circle_nudge',
          'Circle Reminders',
          channelDescription: 'Gentle nudges about your dhikr circle',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }

  /// Cancel all scheduled notifications
  static Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }
}
