import 'package:adhan_dart/adhan_dart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// One calculation method the user can pick. `aladhanId` maps to the Aladhan
/// API's `method` parameter for the opt-in online path; null means the method
/// has no Aladhan equivalent and the app always computes locally for it.
class PrayerMethodInfo {
  final String key;
  final String label;
  final CalculationParameters Function() build;
  final int? aladhanId;

  const PrayerMethodInfo(this.key, this.label, this.build, this.aladhanId);
}

/// Everything adhan_dart 1.2.0 ships. Order = display order (most widely
/// used first).
const List<PrayerMethodInfo> kPrayerMethods = [
  PrayerMethodInfo('umm_al_qura', 'Umm al-Qura (Makkah)',
      CalculationMethodParameters.ummAlQura, 4),
  PrayerMethodInfo('mwl', 'Muslim World League',
      CalculationMethodParameters.muslimWorldLeague, 3),
  PrayerMethodInfo('north_america', 'ISNA (North America)',
      CalculationMethodParameters.northAmerica, 2),
  PrayerMethodInfo('egyptian', 'Egyptian General Authority',
      CalculationMethodParameters.egyptian, 5),
  PrayerMethodInfo('karachi', 'Univ. of Islamic Sciences, Karachi',
      CalculationMethodParameters.karachi, 1),
  PrayerMethodInfo(
      'dubai', 'Dubai', CalculationMethodParameters.dubai, 16),
  PrayerMethodInfo(
      'kuwait', 'Kuwait', CalculationMethodParameters.kuwait, 9),
  PrayerMethodInfo('qatar', 'Qatar', CalculationMethodParameters.qatar, 10),
  PrayerMethodInfo('singapore', 'Singapore (MUIS)',
      CalculationMethodParameters.singapore, 11),
  PrayerMethodInfo('turkiye', 'Türkiye (Diyanet)',
      CalculationMethodParameters.turkiye, 13),
  PrayerMethodInfo(
      'tehran', 'Tehran', CalculationMethodParameters.tehran, 7),
  PrayerMethodInfo('moonsighting', 'Moonsighting Committee',
      CalculationMethodParameters.moonsightingCommittee, 15),
  PrayerMethodInfo(
      'morocco', 'Morocco', CalculationMethodParameters.morocco, null),
];

PrayerMethodInfo methodByKey(String key) => kPrayerMethods
    .firstWhere((m) => m.key == key, orElse: () => kPrayerMethods.first);

const kObligatoryPrayers = ['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];

/// Plain Hive readers usable outside Riverpod (boot-time scheduler runs
/// before any widget exists). Providers below initialize from these and
/// write back through them so both worlds stay in sync.
class PrayerSettings {
  static Box get _box => Hive.box('settings');

  static String methodKey() =>
      _box.get('prayer_method', defaultValue: 'umm_al_qura') as String;
  static bool isHanafi() =>
      _box.get('prayer_madhab', defaultValue: 'shafi') == 'hanafi';
  static int cityIndex() => _box.get('prayer_city', defaultValue: -1) as int;
  static int reminderOffset() =>
      _box.get('prayer_reminder_offset', defaultValue: 10) as int;
  static bool remindersEnabled() =>
      _box.get('prayer_reminders_enabled', defaultValue: false) as bool;
  static int hijriAdjustment() =>
      _box.get('hijri_adjustment', defaultValue: 0) as int;

  static Set<String> enabledPrayers() {
    final raw = _box.get('prayer_notify_set') as String?;
    if (raw == null || raw.isEmpty) return kObligatoryPrayers.toSet();
    return raw.split(',').where((s) => s.isNotEmpty).toSet();
  }

  static void setEnabledPrayers(Set<String> v) =>
      _box.put('prayer_notify_set', v.join(','));

  /// Coordinates from the last successful prayer computation, so the boot
  /// scheduler can re-arm reminders without touching GPS (no permission
  /// prompt before the first frame).
  static ({double lat, double lng})? cachedCoords() {
    final raw = _box.get('prayer_last_coords') as String?;
    if (raw == null) return null;
    final parts = raw.split(',');
    final lat = double.tryParse(parts[0]);
    final lng = parts.length > 1 ? double.tryParse(parts[1]) : null;
    if (lat == null || lng == null) return null;
    return (lat: lat, lng: lng);
  }

  static void cacheCoords(double lat, double lng) =>
      _box.put('prayer_last_coords', '$lat,$lng');

  /// CalculationParameters for the currently selected method + madhab.
  static CalculationParameters buildParams() {
    final params = methodByKey(methodKey()).build();
    params.madhab = isHanafi() ? Madhab.hanafi : Madhab.shafi;
    return params;
  }
}

final prayerMethodProvider =
    StateProvider<String>((ref) => PrayerSettings.methodKey());

final prayerMadhabProvider = StateProvider<String>(
    (ref) => PrayerSettings.isHanafi() ? 'hanafi' : 'shafi');

/// Index into [kCities]; -1 = automatic (GPS with timezone fallback).
final prayerCityProvider =
    StateProvider<int>((ref) => PrayerSettings.cityIndex());

final prayerReminderOffsetProvider =
    StateProvider<int>((ref) => PrayerSettings.reminderOffset());

final prayerEnabledPrayersProvider =
    StateProvider<Set<String>>((ref) => PrayerSettings.enabledPrayers());

final hijriAdjustmentProvider =
    StateProvider<int>((ref) => PrayerSettings.hijriAdjustment());
