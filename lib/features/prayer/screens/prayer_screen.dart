import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:adhan_dart/adhan_dart.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import '../../../core/hijri.dart';
import '../../../core/prayer_api_service.dart';
import '../../../core/prayer_scheduler.dart';
import '../../../core/notifications.dart';
import '../../../core/skin.dart';
import '../data/cities.dart';
import '../providers/prayer_settings_provider.dart';
import 'adhkar_screen.dart';
import 'prayer_settings_screen.dart';

/// User pref: prayer reminders enabled (opt-in, off by default per PRD P0-13)
final prayerRemindersEnabledProvider = StateProvider<bool>((ref) {
  if (!Hive.isBoxOpen('settings')) return false;
  return Hive.box('settings').get('prayer_reminders_enabled',
      defaultValue: false) as bool;
});

final prayerDataProvider = FutureProvider<_PrayerData>((ref) async {
  // Watching settings makes the whole screen recompute the moment the user
  // changes method / madhab / city — no manual refresh plumbing.
  final methodKey = ref.watch(prayerMethodProvider);
  final madhab = ref.watch(prayerMadhabProvider);
  final cityIndex = ref.watch(prayerCityProvider);
  final info = methodByKey(methodKey);
  final hanafi = madhab == 'hanafi';

  double? lat;
  double? lng;
  String locationName = '';
  bool isApproximate = false;

  if (cityIndex >= 0 && cityIndex < kCities.length) {
    final city = kCities[cityIndex];
    lat = city.lat;
    lng = city.lng;
    locationName = '${city.name}, ${city.country}';
  } else {
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
        // Fall through to timezone-based estimate.
      }
    }

    if (lat == null || lng == null) {
      final offsetMinutes = DateTime.now().timeZoneOffset.inMinutes;
      var estLng = (offsetMinutes / 60.0) * 15.0;
      if (estLng > 180) estLng -= 360;
      if (estLng < -180) estLng += 360;
      lat = 22.0;
      lng = estLng;
      locationName =
          'Approximate (from timezone) — enable location or pick a city';
      isApproximate = true;
    }
  }

  // The 7-day reminder scheduler re-arms from these on boot, without GPS.
  PrayerSettings.cacheCoords(lat, lng);

  if (info.aladhanId != null) {
    final apiTimes = await PrayerApiService.fetchByCoordinates(
      lat,
      lng,
      method: info.aladhanId,
      school: hanafi ? 1 : 0,
    );
    if (apiTimes != null) {
      return _buildFromApi(apiTimes, lat, lng, locationName, info.label,
          isApproximate: isApproximate);
    }
  }
  return _calculatePrayers(lat, lng, locationName, info, hanafi,
      isApproximate: isApproximate);
});

_PrayerData _buildFromApi(
  Map<String, String> timings,
  double lat,
  double lng,
  String locationName,
  String methodLabel, {
  bool isApproximate = false,
}) {
  final now = DateTime.now();
  final timeFormat = DateFormat('hh:mm a');
  final prayerNames = ['Fajr', 'Sunrise', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];

  // API returns HH:mm in the queried coordinates' local timezone.
  // We construct the DateTime in the device's local timezone — this is
  // accurate when query coords ≈ device location (the common case after
  // GPS or timezone-based fallback). For a future manual city-picker
  // (cross-timezone), parse `meta.timezone` from the API response and
  // use tz.TZDateTime.from to convert.
  DateTime? nextPrayerTime;
  String? nextPrayerName;
  final List<_PrayerTime> prayers = [];

  for (final name in prayerNames) {
    final raw = timings[name] ?? '00:00';
    final parts = raw.split(':');
    final h = int.tryParse(parts[0]) ?? 0;
    final m = int.tryParse(parts[1]) ?? 0;
    final dt = DateTime(now.year, now.month, now.day, h, m);
    final formatted = timeFormat.format(dt);
    final isNext = dt.isAfter(now) &&
        (nextPrayerTime == null || dt.isBefore(nextPrayerTime));
    if (isNext) {
      nextPrayerTime = dt;
      nextPrayerName = name;
    }
    prayers.add(_PrayerTime(name, formatted, false, dt));
  }

  for (int i = 0; i < prayers.length; i++) {
    if (prayers[i].name == nextPrayerName) {
      prayers[i] = _PrayerTime(
          prayers[i].name, prayers[i].time, true, prayers[i].dateTime);
    }
  }

  final coordinates = Coordinates(lat, lng);
  final qiblaDirection = Qibla.qibla(coordinates);

  return _PrayerData(
    prayers: prayers,
    locationName: locationName,
    qiblaDirection: qiblaDirection,
    method: '$methodLabel (online)',
    isApproximate: isApproximate,
  );
}

_PrayerData _calculatePrayers(
  double lat,
  double lng,
  String locationName,
  PrayerMethodInfo info,
  bool hanafi, {
  bool isApproximate = false,
}) {
  final coordinates = Coordinates(lat, lng);
  final params = info.build();
  params.madhab = hanafi ? Madhab.hanafi : Madhab.shafi;
  final now = DateTime.now();
  final prayerTimes = PrayerTimes(
    coordinates: coordinates,
    date: now,
    calculationParameters: params,
  );

  final nextPrayer = prayerTimes.nextPrayer();
  final timeFormat = DateFormat('hh:mm a');

  // adhan_dart returns DateTime in UTC; DateFormat formats in the device's
  // local timezone, so the displayed times automatically follow the phone.
  final prayers = [
    _PrayerTime('Fajr', timeFormat.format(prayerTimes.fajr.toLocal()),
        nextPrayer == Prayer.fajr, prayerTimes.fajr.toLocal()),
    _PrayerTime('Sunrise', timeFormat.format(prayerTimes.sunrise.toLocal()),
        nextPrayer == Prayer.sunrise, prayerTimes.sunrise.toLocal()),
    _PrayerTime('Dhuhr', timeFormat.format(prayerTimes.dhuhr.toLocal()),
        nextPrayer == Prayer.dhuhr, prayerTimes.dhuhr.toLocal()),
    _PrayerTime('Asr', timeFormat.format(prayerTimes.asr.toLocal()),
        nextPrayer == Prayer.asr, prayerTimes.asr.toLocal()),
    _PrayerTime('Maghrib', timeFormat.format(prayerTimes.maghrib.toLocal()),
        nextPrayer == Prayer.maghrib, prayerTimes.maghrib.toLocal()),
    _PrayerTime('Isha', timeFormat.format(prayerTimes.isha.toLocal()),
        nextPrayer == Prayer.isha, prayerTimes.isha.toLocal()),
  ];

  final qiblaDirection = Qibla.qibla(coordinates);

  return _PrayerData(
    prayers: prayers,
    locationName: locationName,
    qiblaDirection: qiblaDirection,
    method: info.label,
    isApproximate: isApproximate,
  );
}

class _PrayerData {
  final List<_PrayerTime> prayers;
  final String locationName;
  final double qiblaDirection;
  final String method;
  final bool isApproximate;

  _PrayerData({
    required this.prayers,
    required this.locationName,
    required this.qiblaDirection,
    required this.method,
    this.isApproximate = false,
  });
}

class PrayerScreen extends ConsumerWidget {
  const PrayerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prayerAsync = ref.watch(prayerDataProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Prayer Times'),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune_rounded),
            tooltip: 'Calculation & reminder settings',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const PrayerSettingsScreen()),
              );
            },
          ),
        ],
      ),
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

class _PrayerBody extends ConsumerWidget {
  final _PrayerData data;

  const _PrayerBody({required this.data});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final skin = ref.watch(skinProvider);
    final hijriAdjustment = ref.watch(hijriAdjustmentProvider);
    final now = DateTime.now();
    final hijri = HijriDate.fromGregorian(now, adjustment: hijriAdjustment);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: skin.primary,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Text(
                      hijri.format(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      DateFormat('EEEE, d MMMM yyyy').format(now),
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.location_on_rounded,
                            color: Colors.white70, size: 16),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            data.locationName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
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
              // Second settings entry, inside the card: on web the AppBar is
              // covered by the fixed beta banner in index.html, which would
              // otherwise make settings unreachable there.
              Positioned(
                top: 4,
                right: 4,
                child: IconButton(
                  icon: const Icon(Icons.tune_rounded,
                      color: Colors.white70, size: 20),
                  tooltip: 'Calculation & reminder settings',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const PrayerSettingsScreen()),
                    );
                  },
                ),
              ),
            ],
          ),

          if (data.isApproximate) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: skin.surfaceCard,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: skin.divider),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline_rounded,
                      size: 16, color: skin.inkMuted),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Times follow your phone’s timezone. Enable location — or pick a city in settings — for precise times.',
                      style: TextStyle(color: skin.inkMuted, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 24),

          ...data.prayers.map((prayer) => _PrayerCard(prayer: prayer)),

          const SizedBox(height: 12),

          if (kIsWeb) const _WebReminderNote() else const _ReminderToggle(),

          const SizedBox(height: 12),

          _QiblaCompass(
            qiblaBearing: data.qiblaDirection,
            isApproximate: data.isApproximate,
          ),

          const SizedBox(height: 12),

          const _AdhkarEntryCard(),

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
  final DateTime dateTime;

  _PrayerTime(this.name, this.time, this.isNext, this.dateTime);
}

class _PrayerCard extends ConsumerWidget {
  final _PrayerTime prayer;

  const _PrayerCard({required this.prayer});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final skin = ref.watch(skinProvider);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: prayer.isNext
            ? skin.primary.withValues(alpha: 0.08)
            : skin.surfaceCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: prayer.isNext ? skin.primary : skin.divider,
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
              decoration: BoxDecoration(
                color: skin.primary,
                shape: BoxShape.circle,
              ),
            ),
          Text(
            prayer.name,
            style: TextStyle(
              fontSize: 16,
              fontWeight: prayer.isNext ? FontWeight.w600 : FontWeight.w400,
              color: skin.ink,
            ),
          ),
          const Spacer(),
          Text(
            prayer.time,
            style: TextStyle(
              fontSize: 16,
              fontWeight: prayer.isNext ? FontWeight.w600 : FontWeight.w400,
              color: prayer.isNext ? skin.primary : skin.inkMuted,
            ),
          ),
        ],
      ),
    );
  }
}

/// Web can't fire scheduled local notifications (no background timer API),
/// so instead of a toggle that silently does nothing we say it plainly.
class _WebReminderNote extends ConsumerWidget {
  const _WebReminderNote();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final skin = ref.watch(skinProvider);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: skin.surfaceCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: skin.divider),
      ),
      child: Row(
        children: [
          Icon(Icons.notifications_none_rounded,
              color: skin.inkMuted, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Adhan reminders work in the Android app. On the web, times and qibla are always available.',
              style: TextStyle(color: skin.inkMuted, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

/// Opt-in toggle. On: arms the next 7 days of reminders (per-prayer choices
/// and lead time live in settings). Off: cancels the whole block.
class _ReminderToggle extends ConsumerWidget {
  const _ReminderToggle();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final skin = ref.watch(skinProvider);
    final enabled = ref.watch(prayerRemindersEnabledProvider);
    final offset = ref.watch(prayerReminderOffsetProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: enabled ? skin.primarySoft : skin.surfaceCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: enabled ? skin.primary : skin.divider,
          width: enabled ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            enabled
                ? Icons.notifications_active_rounded
                : Icons.notifications_none_rounded,
            color: enabled ? skin.primary : skin.inkMuted,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  enabled ? 'Reminders on' : 'Prayer reminders',
                  style: TextStyle(
                    color: skin.ink,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  enabled
                      ? (offset == 0
                          ? 'At prayer time · next 7 days'
                          : '$offset min before · next 7 days')
                      : 'Off by default. Your dhikr stays private.',
                  style: TextStyle(color: skin.inkMuted, fontSize: 12),
                ),
              ],
            ),
          ),
          Switch(
            value: enabled,
            activeThumbColor: skin.primary,
            onChanged: (val) async {
              Hive.box('settings').put('prayer_reminders_enabled', val);
              ref.read(prayerRemindersEnabledProvider.notifier).state = val;
              if (val) {
                final count = await PrayerScheduler.reschedule();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(count > 0
                          ? 'Reminders set for the next $count prayers'
                          : 'Reminders will start once times are loaded'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              } else {
                await NotificationService.cancelPrayerReminders();
              }
            },
          ),
        ],
      ),
    );
  }
}

/// Entry to the bundled adhkar collection — fully offline, no account.
class _AdhkarEntryCard extends ConsumerWidget {
  const _AdhkarEntryCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final skin = ref.watch(skinProvider);
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AdhkarScreen()),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: skin.surfaceCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: skin.divider),
        ),
        child: Row(
          children: [
            Icon(Icons.auto_stories_rounded, color: skin.primary, size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Morning & Evening Adhkar',
                    style: TextStyle(
                      color: skin.ink,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Foundational remembrances, offline',
                    style: TextStyle(color: skin.inkMuted, fontSize: 12),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: skin.inkMuted),
          ],
        ),
      ),
    );
  }
}

/// Live Qibla compass — needle rotates as device heading changes,
/// pointing toward Mecca from current GPS coordinates.
///
/// Bearing comes from `Qibla.qibla(coordinates)` (degrees from true north).
/// Device heading from flutter_compass is degrees from true north on iOS
/// (CLLocationManager.trueHeading) and on Android (rotation vector +
/// geomagnetic field) — no manual declination correction needed. When
/// `isApproximate` is true the underlying coordinates are estimated from
/// the device's timezone, so the bearing has a corresponding margin —
/// we surface that to the user instead of pretending it's GPS-precise.
class _QiblaCompass extends ConsumerStatefulWidget {
  final double qiblaBearing;
  final bool isApproximate;

  const _QiblaCompass({
    required this.qiblaBearing,
    this.isApproximate = false,
  });

  @override
  ConsumerState<_QiblaCompass> createState() => _QiblaCompassState();
}

class _QiblaCompassState extends ConsumerState<_QiblaCompass> {
  StreamSubscription<CompassEvent>? _sub;
  double? _heading;

  @override
  void initState() {
    super.initState();
    final stream = FlutterCompass.events;
    if (stream != null) {
      _sub = stream.listen((event) {
        if (!mounted) return;
        setState(() => _heading = event.heading);
      });
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final skin = ref.watch(skinProvider);
    final heading = _heading;
    final qiblaFromDevice = heading == null
        ? null
        : (widget.qiblaBearing - heading) * (math.pi / 180);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: skin.surfaceCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: skin.divider),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 56,
            height: 56,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: skin.divider, width: 1.5),
                  ),
                ),
                if (qiblaFromDevice != null)
                  Transform.rotate(
                    angle: qiblaFromDevice,
                    child: Icon(Icons.navigation_rounded,
                        color: skin.primary, size: 36),
                  )
                else
                  Icon(Icons.explore_rounded,
                      color: skin.inkMuted, size: 28),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Qibla',
                  style: TextStyle(
                    color: skin.ink,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  heading == null
                      ? 'Mecca is ${widget.qiblaBearing.toStringAsFixed(1)}° from true north (compass unavailable)'
                      : widget.isApproximate
                          ? 'Point the arrow up — direction approximate, enable location for precision'
                          : 'Point the arrow up to face Mecca',
                  style: TextStyle(color: skin.inkMuted, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
