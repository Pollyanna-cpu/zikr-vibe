import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'analytics_stub.dart' if (dart.library.js_interop) 'analytics_web.dart'
    as platform;

class Analytics {
  static void event(String name, {Map<String, Object?>? params}) {
    if (!kIsWeb) return;
    platform.gtagEvent(name, params ?? const {});
  }

  static void dhikrStartIfFirstToday() {
    final box = Hive.box('dhikr_sessions');
    final today = _yyyymmdd(DateTime.now());
    final last = box.get('analytics_last_dhikr_start_day');
    if (last == today) return;
    box.put('analytics_last_dhikr_start_day', today);
    event('dhikr_start');
  }

  static void dhikrComplete100() {
    event('dhikr_complete_100');
  }

  static void streakDay2IfNew(int streakDays) {
    if (streakDays < 2) return;
    final box = Hive.box('dhikr_sessions');
    if (box.get('analytics_fired_streak_day_2') == true) return;
    box.put('analytics_fired_streak_day_2', true);
    event('streak_day_2');
  }

  static String _yyyymmdd(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}
