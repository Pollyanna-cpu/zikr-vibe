import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/prayer_scheduler.dart';
import '../../../core/skin.dart';
import '../data/cities.dart';
import '../providers/prayer_settings_provider.dart';

/// Opt-in for the Aladhan online source (off = fully local). Kept here, not
/// in the provider file, because only this screen touches it.
final prayerApiOptInProvider = StateProvider<bool>((ref) =>
    Hive.box('settings').get('prayer_api_opt_in', defaultValue: false)
        as bool);

class PrayerSettingsScreen extends ConsumerWidget {
  const PrayerSettingsScreen({super.key});

  /// Any change that affects computed times or reminder content re-arms the
  /// 7-day schedule. Fire-and-forget: the scheduler no-ops on web/disabled.
  void _rearm() => unawaited(PrayerScheduler.reschedule());

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final skin = ref.watch(skinProvider);
    final methodKey = ref.watch(prayerMethodProvider);
    final madhab = ref.watch(prayerMadhabProvider);
    final cityIndex = ref.watch(prayerCityProvider);
    final offset = ref.watch(prayerReminderOffsetProvider);
    final enabledPrayers = ref.watch(prayerEnabledPrayersProvider);
    final hijriAdj = ref.watch(hijriAdjustmentProvider);
    final apiOptIn = ref.watch(prayerApiOptInProvider);
    final settings = Hive.box('settings');

    final method = methodByKey(methodKey);
    final cityLabel = (cityIndex >= 0 && cityIndex < kCities.length)
        ? '${kCities[cityIndex].name}, ${kCities[cityIndex].country}'
        : 'Automatic (GPS)';

    return Scaffold(
      appBar: AppBar(title: const Text('Prayer Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SectionLabel('CALCULATION', skin: skin),
          _PickerTile(
            skin: skin,
            icon: Icons.calculate_rounded,
            label: 'Calculation method',
            value: method.label,
            onTap: () => _pickMethod(context, ref),
          ),
          _PickerTile(
            skin: skin,
            icon: Icons.location_city_rounded,
            label: 'Location',
            value: cityLabel,
            onTap: () => _pickCity(context, ref),
          ),
          const SizedBox(height: 8),
          Text('Asr time (madhab)',
              style: TextStyle(color: skin.inkMuted, fontSize: 12)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              ChoiceChip(
                label: const Text('Shafi (standard)'),
                selected: madhab == 'shafi',
                onSelected: (_) {
                  settings.put('prayer_madhab', 'shafi');
                  ref.read(prayerMadhabProvider.notifier).state = 'shafi';
                  _rearm();
                },
              ),
              ChoiceChip(
                label: const Text('Hanafi (later Asr)'),
                selected: madhab == 'hanafi',
                onSelected: (_) {
                  settings.put('prayer_madhab', 'hanafi');
                  ref.read(prayerMadhabProvider.notifier).state = 'hanafi';
                  _rearm();
                },
              ),
            ],
          ),

          const SizedBox(height: 24),
          _SectionLabel('REMINDERS', skin: skin),
          Text('Lead time',
              style: TextStyle(color: skin.inkMuted, fontSize: 12)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              for (final m in const [0, 5, 10, 15])
                ChoiceChip(
                  label: Text(m == 0 ? 'At prayer time' : '$m min before'),
                  selected: offset == m,
                  onSelected: (_) {
                    settings.put('prayer_reminder_offset', m);
                    ref.read(prayerReminderOffsetProvider.notifier).state = m;
                    _rearm();
                  },
                ),
            ],
          ),
          const SizedBox(height: 8),
          for (final prayer in kObligatoryPrayers)
            SwitchListTile(
              title: Text(prayer, style: TextStyle(color: skin.ink)),
              value: enabledPrayers.contains(prayer),
              activeThumbColor: skin.primary,
              contentPadding: EdgeInsets.zero,
              dense: true,
              onChanged: (on) {
                final next = {...enabledPrayers};
                on ? next.add(prayer) : next.remove(prayer);
                PrayerSettings.setEnabledPrayers(next);
                ref.read(prayerEnabledPrayersProvider.notifier).state = next;
                _rearm();
              },
            ),
          Text(
            'Reminders cover the next 7 days and refresh every time you open the app. Exact timing may vary slightly when battery optimization is on.',
            style: TextStyle(color: skin.inkMuted, fontSize: 12),
          ),

          const SizedBox(height: 24),
          _SectionLabel('HIJRI DATE', skin: skin),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Adjustment for local moonsighting',
                  style: TextStyle(color: skin.ink, fontSize: 14),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.remove_circle_outline_rounded),
                color: skin.inkMuted,
                onPressed: hijriAdj > -3
                    ? () {
                        settings.put('hijri_adjustment', hijriAdj - 1);
                        ref.read(hijriAdjustmentProvider.notifier).state =
                            hijriAdj - 1;
                      }
                    : null,
              ),
              Text(
                hijriAdj > 0 ? '+$hijriAdj d' : '$hijriAdj d',
                style: TextStyle(
                    color: skin.ink,
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline_rounded),
                color: skin.inkMuted,
                onPressed: hijriAdj < 3
                    ? () {
                        settings.put('hijri_adjustment', hijriAdj + 1);
                        ref.read(hijriAdjustmentProvider.notifier).state =
                            hijriAdj + 1;
                      }
                    : null,
              ),
            ],
          ),

          const SizedBox(height: 24),
          _SectionLabel('DATA SOURCE', skin: skin),
          SwitchListTile(
            title: Text('Use Aladhan online timings',
                style: TextStyle(color: skin.ink, fontSize: 14)),
            subtitle: Text(
              'Off (default): everything is calculated on your device and your location never leaves it. On: coordinates are sent to aladhan.com for authoritative timings.',
              style: TextStyle(color: skin.inkMuted, fontSize: 12),
            ),
            value: apiOptIn,
            activeThumbColor: skin.primary,
            contentPadding: EdgeInsets.zero,
            onChanged: (on) {
              settings.put('prayer_api_opt_in', on);
              ref.read(prayerApiOptInProvider.notifier).state = on;
              // Times themselves recompute on next prayer-screen load.
            },
          ),

          const SizedBox(height: 16),
          Text(
            'No account needed. Nothing is tracked.',
            textAlign: TextAlign.center,
            style: TextStyle(color: skin.inkMuted, fontSize: 12),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _pickMethod(BuildContext context, WidgetRef ref) {
    final skin = ref.read(skinProvider);
    final current = ref.read(prayerMethodProvider);
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => ListView(
        children: [
          for (final m in kPrayerMethods)
            ListTile(
              title: Text(m.label, style: TextStyle(color: skin.ink)),
              trailing: m.key == current
                  ? Icon(Icons.check_rounded, color: skin.primary)
                  : null,
              onTap: () {
                Hive.box('settings').put('prayer_method', m.key);
                ref.read(prayerMethodProvider.notifier).state = m.key;
                _rearm();
                Navigator.pop(sheetContext);
              },
            ),
        ],
      ),
    );
  }

  void _pickCity(BuildContext context, WidgetRef ref) {
    final skin = ref.read(skinProvider);
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (sheetContext) {
        var query = '';
        return StatefulBuilder(
          builder: (context, setSheetState) {
            final matches = kCities
                .asMap()
                .entries
                .where((e) =>
                    query.isEmpty ||
                    e.value.name.toLowerCase().contains(query) ||
                    e.value.country.toLowerCase().contains(query))
                .toList();
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.75,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                    child: TextField(
                      autofocus: false,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.search_rounded),
                        hintText: 'Search city or country',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      onChanged: (v) =>
                          setSheetState(() => query = v.trim().toLowerCase()),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      children: [
                        ListTile(
                          leading:
                              Icon(Icons.my_location_rounded, color: skin.primary),
                          title: Text('Automatic (GPS)',
                              style: TextStyle(color: skin.ink)),
                          onTap: () => _selectCity(sheetContext, ref, -1),
                        ),
                        for (final e in matches)
                          ListTile(
                            title: Text(e.value.name,
                                style: TextStyle(color: skin.ink)),
                            subtitle: Text(e.value.country,
                                style: TextStyle(
                                    color: skin.inkMuted, fontSize: 12)),
                            onTap: () => _selectCity(sheetContext, ref, e.key),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _selectCity(BuildContext sheetContext, WidgetRef ref, int index) {
    Hive.box('settings').put('prayer_city', index);
    ref.read(prayerCityProvider.notifier).state = index;
    _rearm();
    Navigator.pop(sheetContext);
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  final ZikrSkin skin;

  const _SectionLabel(this.text, {required this.skin});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          color: skin.inkMuted,
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _PickerTile extends StatelessWidget {
  final ZikrSkin skin;
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  const _PickerTile({
    required this.skin,
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: skin.inkMuted),
      title: Text(label, style: TextStyle(color: skin.ink, fontSize: 14)),
      subtitle: Text(value,
          style: TextStyle(color: skin.primary, fontSize: 12)),
      trailing: Icon(Icons.chevron_right_rounded, color: skin.inkMuted),
      contentPadding: EdgeInsets.zero,
      onTap: onTap,
    );
  }
}
