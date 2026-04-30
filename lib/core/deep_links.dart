import 'dart:async';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Deep link handler for circle invites.
///
/// Accepts:
///   - Universal Links / App Links: https://zikrvibe.com/join/<CODE>
///   - Custom scheme (Android intent / iOS): zikrvibe://join/<CODE>
///
/// Stores the invite code in Hive `settings` under `pending_invite_code`.
/// The Circles screen reads this on next open and triggers `joinCircle()`.
///
/// Privacy note: invite codes are short opaque tokens. They identify a circle,
/// not a user. No analytics, no IP logging — `app_links` is local OS routing.
/// On `signedOut` we clear any pending invite code so the next account on this
/// device does not silently inherit the previous user's circle invite.
class DeepLinks {
  static const String _scheme = 'zikrvibe';
  static const String _host = 'zikrvibe.com';
  static const String _pendingKey = 'pending_invite_code';

  static StreamSubscription<AuthState>? _authSub;

  /// Wire up the auth-state listener so signOut wipes any pending invite code.
  /// Call once at app boot (after `Supabase.initialize` and `Hive` open).
  /// Idempotent — re-calling cancels the previous subscription first.
  static void attachAuthListener() {
    _authSub?.cancel();
    _authSub = Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      if (data.event == AuthChangeEvent.signedOut) {
        if (Hive.isBoxOpen('settings')) {
          Hive.box('settings').delete(_pendingKey);
        }
      }
    });
  }

  /// Parse a deep-link URI and persist any extracted invite code.
  /// Returns the code if one was found, otherwise `null`.
  static String? consume(Uri uri) {
    final code = _extractInviteCode(uri);
    if (code == null || code.isEmpty) return null;
    if (Hive.isBoxOpen('settings')) {
      Hive.box('settings').put(_pendingKey, code);
    }
    return code;
  }

  static String? _extractInviteCode(Uri uri) {
    final isOurHost = uri.host == _host || uri.host == 'www.$_host';
    final isOurScheme = uri.scheme == _scheme;
    if (!isOurHost && !isOurScheme) return null;

    final segments = uri.pathSegments;
    // Expect /join/<CODE>
    final joinIdx = segments.indexOf('join');
    if (joinIdx == -1 || joinIdx + 1 >= segments.length) return null;
    return segments[joinIdx + 1].trim();
  }

  /// Read and clear the pending invite code (one-shot).
  static String? takePending() {
    if (!Hive.isBoxOpen('settings')) return null;
    final box = Hive.box('settings');
    final code = box.get(_pendingKey) as String?;
    if (code != null) box.delete(_pendingKey);
    return code;
  }

  /// Peek without clearing (for UI decisions).
  static String? peekPending() {
    if (!Hive.isBoxOpen('settings')) return null;
    return Hive.box('settings').get(_pendingKey) as String?;
  }
}
