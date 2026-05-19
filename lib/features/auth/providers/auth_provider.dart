import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabaseClientProvider = Provider<SupabaseClient?>((ref) {
  try {
    return Supabase.instance.client;
  } catch (_) {
    return null; // Supabase not initialized yet
  }
});

/// Watches auth state changes
final authStateProvider = StreamProvider<Session?>((ref) {
  final client = ref.watch(supabaseClientProvider);
  if (client == null) return Stream.value(null);
  return client.auth.onAuthStateChange.map((event) => event.session);
});

/// Current user provider
final currentUserProvider = Provider<User?>((ref) {
  final session = ref.watch(authStateProvider).valueOrNull;
  return session?.user;
});

/// Auth actions
class AuthService {
  final SupabaseClient? _client;

  AuthService(this._client);

  /// Sign in with email and password
  Future<AuthResponse> signInWithEmail(String email, String password) async {
    if (_client == null) throw Exception('Supabase not configured');
    return await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  /// Sign up with email and password.
  ///
  /// `data['display_name']` lands in `auth.users.raw_user_meta_data`, where
  /// the `handle_new_user()` AFTER INSERT trigger reads it to auto-populate
  /// `public.users` / `public.streaks` / `public.notification_prefs`. The
  /// trigger runs as `SECURITY DEFINER` so it bypasses RLS — much cleaner
  /// than upserting from the client right after signUp returned, where
  /// `auth.uid()` may not yet be set on the new session and the RLS
  /// `WITH CHECK (auth.uid() = id)` policy rejects the row (PostgrestException
  /// 42501). Don't mirror the trigger here.
  Future<AuthResponse> signUpWithEmail(
    String email,
    String password,
    String displayName,
  ) async {
    if (_client == null) throw Exception('Supabase not configured');
    return await _client.auth.signUp(
      email: email,
      password: password,
      data: {'display_name': displayName},
    );
  }

  /// Sign in with Google
  Future<bool> signInWithGoogle() async {
    if (_client == null) throw Exception('Supabase not configured');
    return await _client.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: 'io.supabase.zikrvibe://login-callback/',
    );
  }

  /// Sign in with Apple
  Future<bool> signInWithApple() async {
    if (_client == null) throw Exception('Supabase not configured');
    return await _client.auth.signInWithOAuth(
      OAuthProvider.apple,
      redirectTo: 'io.supabase.zikrvibe://login-callback/',
    );
  }

  /// Delete the current user's server-side account data, then sign out.
  ///
  /// Calls the `delete_account` SECURITY DEFINER RPC (see migration
  /// `007_delete_account_rpc.sql`) which removes the caller's row from
  /// `public.users` and cascades to `daily_presence`, `streaks`,
  /// `memberships`, and `notification_prefs`. The `auth.users` row is
  /// not removed — Supabase doesn't expose that to client SDKs — so the
  /// email cannot be reused for a fresh signup until support deletes the
  /// auth row. This matches what the privacy policy and Play Data Safety
  /// form promise: "Deleting your account removes profile, daily presence
  /// history, streaks, notification preferences, and Circle memberships."
  ///
  /// signOut is called after the RPC so the auth state listener routes
  /// the user back to /login.
  Future<void> deleteAccount() async {
    if (_client == null) throw Exception('Supabase not configured');
    await _client.rpc('delete_account');
    await _client.auth.signOut();
  }

  /// Sign out
  Future<void> signOut() async {
    await _client?.auth.signOut();
  }
}

final authServiceProvider = Provider<AuthService>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return AuthService(client);
});
