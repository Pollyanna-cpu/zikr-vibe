import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Whether user chose "Use without account".
final skippedAuthProvider = StateProvider<bool>((ref) {
  final box = Hive.box('settings');
  return box.get('skipped_auth', defaultValue: false) as bool;
});

void skipAuth(dynamic ref) {
  Hive.box('settings').put('skipped_auth', true);
  ref.read(skippedAuthProvider.notifier).state = true;
}

void resetSkippedAuth(dynamic ref) {
  Hive.box('settings').put('skipped_auth', false);
  ref.read(skippedAuthProvider.notifier).state = false;
}

/// Whether the user has seen the 3-page intro (privacy / sacred / circle).
/// First-time signup OR first guest entry sets this on completion so the
/// onboarding doesn't re-fire on every app open.
final onboardingSeenProvider = StateProvider<bool>((ref) {
  final box = Hive.box('settings');
  return box.get('onboarding_seen', defaultValue: false) as bool;
});

void markOnboardingSeen(dynamic ref) {
  Hive.box('settings').put('onboarding_seen', true);
  ref.read(onboardingSeenProvider.notifier).state = true;
}
