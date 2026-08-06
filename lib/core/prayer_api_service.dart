import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive_flutter/hive_flutter.dart';

class PrayerApiService {
  static const _baseUrl = 'https://api.aladhan.com/v1';

  /// Hive `settings` key controlling whether to call the third-party Aladhan
  /// API. When `false` (the default) we never send lat/lng off-device — the
  /// caller falls back to local `adhan_dart` calculation. User can opt in via
  /// a settings toggle to get Aladhan's authoritative timings.
  ///
  /// Privacy note: calling Aladhan transmits the user's coordinates to a
  /// third-party server on every prayer-screen open. Local calculation has
  /// the same accuracy for nearly every method/madhab combination.
  static const String _optInKey = 'prayer_api_opt_in';

  static bool isApiOptedIn() {
    if (!Hive.isBoxOpen('settings')) return false;
    return Hive.box('settings').get(_optInKey, defaultValue: false) as bool;
  }

  /// Fetch prayer times by coordinates. Free API, no key needed.
  /// Returns `null` if the user has not opted in (default), so the caller
  /// uses local `adhan_dart` instead. Returns `null` on network error too.
  static Future<Map<String, String>?> fetchByCoordinates(
    double lat,
    double lng, {
    int? method, // 3 = MWL, 4 = Umm Al-Qura, 2 = ISNA
    int school = 0, // Asr madhab: 0 = Shafi, 1 = Hanafi
  }) async {
    if (!isApiOptedIn()) return null; // Privacy default: stay local-only.
    try {
      final params = {
        'latitude': lat.toString(),
        'longitude': lng.toString(),
        'method': (method ?? 4).toString(), // default Umm Al-Qura
        'school': school.toString(),
      };
      final uri = Uri.parse('$_baseUrl/timings/${DateTime.now().millisecondsSinceEpoch ~/ 1000}')
          .replace(queryParameters: params);

      final response = await http.get(uri).timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final timings = data['data']['timings'] as Map<String, dynamic>;
        return {
          'Fajr': timings['Fajr'] as String,
          'Sunrise': timings['Sunrise'] as String,
          'Dhuhr': timings['Dhuhr'] as String,
          'Asr': timings['Asr'] as String,
          'Maghrib': timings['Maghrib'] as String,
          'Isha': timings['Isha'] as String,
        };
      }
    } catch (_) {}
    return null; // fallback to local adhan_dart
  }
}
