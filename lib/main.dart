import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app.dart';
import 'core/constants.dart';
import 'core/deep_links.dart';
import 'core/notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive for local storage
  await Hive.initFlutter();
  await Hive.openBox('dhikr_sessions');
  await Hive.openBox('settings');

  // Initialize Supabase
  if (AppConstants.supabaseUrl != 'YOUR_SUPABASE_URL') {
    await Supabase.initialize(
      url: AppConstants.supabaseUrl,
      anonKey: AppConstants.supabaseAnonKey,
    );
    // Wipe any pending invite code on signOut so the next account on this
    // device does not inherit the previous user's circle invite.
    DeepLinks.attachAuthListener();
  }

  // Initialize notifications
  await NotificationService.init();

  // Initialize deep links — capture cold-start invite from
  // https://zikrvibe.com/join/<CODE> (and the app_links app:// variant).
  // Skipped on web because app_links ships only mobile/desktop bindings.
  if (!kIsWeb) {
    try {
      final appLinks = AppLinks();
      final initialUri = await appLinks.getInitialLink();
      if (initialUri != null) {
        DeepLinks.consume(initialUri);
      }
      // Listen for warm-start links while the app is running.
      appLinks.uriLinkStream.listen(DeepLinks.consume);
    } catch (_) {
      // Some platforms throw if no link configured — safe to ignore.
    }
  }

  runApp(
    const ProviderScope(
      child: ZikrVibeApp(),
    ),
  );
}
