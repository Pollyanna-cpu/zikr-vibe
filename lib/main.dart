import 'dart:async' show unawaited;
import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app.dart';
import 'core/auth_session_guard.dart';
import 'core/constants.dart';
import 'core/deep_links.dart';
import 'core/notifications.dart';
import 'core/prayer_scheduler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Serve Inter from bundled assets only (assets/google_fonts/). Runtime
  // fetching hits fonts.gstatic.com, which the web CSP blocks (and which is
  // unreachable in China) — with it enabled, every Text on the page can
  // render blank. Bundled files + no-fetch = text always renders.
  GoogleFonts.config.allowRuntimeFetching = false;

  // Surface uncaught Flutter framework errors instead of letting release builds
  // freeze the UI silently. Logs to console + (in debug) shows the red screen.
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint('[FlutterError] ${details.exceptionAsString()}');
  };

  // Initialize Hive. If a box file is corrupted (low-storage / forced kill
  // mid-write) openBox throws - wipe the bad box and retry once. If retry
  // still fails, surface the error rather than crashing into a black screen
  // before runApp even fires.
  try {
    await Hive.initFlutter();
    for (final boxName in const ['dhikr_sessions', 'settings']) {
      try {
        await Hive.openBox(boxName);
      } catch (e) {
        debugPrint('[main] Hive.openBox($boxName) failed: $e - wiping + retry');
        await Hive.deleteBoxFromDisk(boxName);
        await Hive.openBox(boxName);
      }
    }
  } catch (e, st) {
    debugPrint('[main] Hive init failed permanently: $e\n$st');
    runApp(_BootErrorApp(message: 'Storage init failed: $e'));
    return;
  }

  // Initialize Supabase. If config is bad or network is unreachable at boot,
  // fall through to guest mode rather than crashing the whole app.
  if (AppConstants.supabaseUrl != 'YOUR_SUPABASE_URL') {
    try {
      await Supabase.initialize(
        url: AppConstants.supabaseUrl,
        anonKey: AppConstants.supabaseAnonKey,
      );
      DeepLinks.attachAuthListener();

      // Validate any cached session against the server. The Flutter SDK
      // restores the last user object from secure storage on init, but if
      // the refresh token has been revoked / expired (the 4/13 -> 5/8 case),
      // the cached session is a zombie: UI shows currentUser != null but
      // every request is rejected by RLS as anon. Force-refresh - if it
      // fails, sign out so currentUser becomes null and the router pushes
      // the user to /login for a fresh sign-in.
      final cached = Supabase.instance.client.auth.currentSession;
      if (cached != null) {
        try {
          await Supabase.instance.client.auth.refreshSession();
        } on AuthException catch (e) {
          if (isRetryableAuthError(e)) {
            debugPrint('[main] Cached session refresh retryable, keeping: $e');
          } else {
            debugPrint('[main] Cached session refresh failed, clearing: $e');
            Hive.box('settings').put('skipped_auth', false);
            try {
              await Supabase.instance.client.auth.signOut();
            } catch (_) {/* already gone */}
          }
        } catch (e) {
          debugPrint(
              '[main] Cached session refresh unknown error, keeping: $e');
        }
      }
    } catch (e) {
      debugPrint('[main] Supabase init failed, continuing in guest mode: $e');
    }
  }

  // Initialize notifications
  await NotificationService.init();

  // Slide the 7-day prayer-reminder window forward on every boot, from
  // cached coordinates — no GPS prompt before the first frame. No-op on
  // web and when reminders are off.
  if (!kIsWeb) {
    unawaited(PrayerScheduler.reschedule());
  }

  // Initialize deep links - capture cold-start invite from
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
      // Some platforms throw if no link configured - safe to ignore.
    }
  }

  runApp(
    const ProviderScope(
      child: ZikrVibeApp(),
    ),
  );
}

/// Last-resort UI shown only when Hive can't open at all (twice, after wipe).
/// Tells the user what happened and suggests reinstall - beats a black screen.
class _BootErrorApp extends StatelessWidget {
  final String message;
  const _BootErrorApp({required this.message});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(32),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.warning_amber_rounded, size: 48),
                const SizedBox(height: 16),
                const Text(
                  'Zikr Vibe could not start',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Try reinstalling the app or freeing up storage.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.black45),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
