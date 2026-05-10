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

  /// Sign out
  Future<void> signOut() async {
    await _client?.auth.signOut();
  }
}

final authServiceProvider = Provider<AuthService>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return AuthService(client);
});
