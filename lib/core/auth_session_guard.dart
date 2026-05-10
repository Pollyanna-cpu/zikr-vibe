import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'auth_prefs.dart';

bool isRetryableAuthError(Object error) => error is AuthRetryableFetchException;

bool isStaleAuthError(Object error) {
  if (error is AuthRetryableFetchException) return false;

  if (error is AuthException) {
    return true;
  }

  if (error is PostgrestException) {
    final code = error.code;
    final message = error.message.toLowerCase();
    return code == '42501' ||
        code == 'PGRST301' ||
        message.contains('row-level security') ||
        message.contains('authentication required') ||
        message.contains('jwt expired') ||
        message.contains('invalid jwt');
  }

  return false;
}

Future<void> clearStaleAuthSession(
  dynamic ref,
  SupabaseClient client, {
  required String reason,
}) async {
  debugPrint('[Auth] Clearing stale session: $reason');
  resetSkippedAuth(ref);
  try {
    await client.auth.signOut();
  } catch (_) {
    // The local session may already be gone after Supabase processed the error.
  }
}
