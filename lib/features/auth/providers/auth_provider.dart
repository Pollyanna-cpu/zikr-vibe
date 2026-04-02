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

  /// Sign up with email and password
  Future<AuthResponse> signUpWithEmail(
    String email,
    String password,
    String displayName,
  ) async {
    if (_client == null) throw Exception('Supabase not configured');
    final response = await _client.auth.signUp(
      email: email,
      password: password,
      data: {'display_name': displayName},
    );

    // Create user profile in our table
    if (response.user != null) {
      await _client.from('users').upsert({
        'id': response.user!.id,
        'email': email,
        'display_name': displayName,
        'auth_provider': 'email',
      });
    }

    return response;
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
