import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
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

  /// Schedule a prayer reminder
  static Future<void> schedulePrayerReminder({
    required int id,
    required String prayerName,
    required DateTime time,
    int offsetMinutes = 10,
  }) async {
    final scheduledTime = time.subtract(Duration(minutes: offsetMinutes));
    if (scheduledTime.isBefore(DateTime.now())) return;

    final tzTime = tz.TZDateTime.from(scheduledTime, tz.local);

    await _plugin.zonedSchedule(
      id,
      'Prayer Time',
      '$prayerName in $offsetMinutes minutes',
      tzTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'prayer_reminders',
          'Prayer Reminders',
          channelDescription: 'Notifications before prayer times',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
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
