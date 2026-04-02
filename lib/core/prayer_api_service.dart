import 'dart:convert';
import 'package:http/http.dart' as http;

class PrayerApiService {
  static const _baseUrl = 'https://api.aladhan.com/v1';

  /// Fetch prayer times by coordinates. Free API, no key needed.
  /// Returns map: {'Fajr': '05:12', 'Dhuhr': '12:30', ...}
  static Future<Map<String, String>?> fetchByCoordinates(
    double lat,
    double lng, {
    int? method, // 3 = MWL, 4 = Umm Al-Qura, 2 = ISNA
  }) async {
    try {
      final params = {
        'latitude': lat.toString(),
        'longitude': lng.toString(),
        'method': (method ?? 4).toString(), // default Umm Al-Qura
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
