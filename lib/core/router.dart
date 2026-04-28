import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'deep_links.dart';
import '../features/auth/providers/auth_provider.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/onboarding_screen.dart';
import '../shared/widgets/main_shell.dart';
import '../features/dhikr/screens/dhikr_screen.dart';
import '../features/groups/screens/groups_screen.dart';
import '../features/prayer/screens/prayer_screen.dart';
import '../features/profile/screens/profile_screen.dart';
import '../features/streak/screens/streak_screen.dart';

/// Whether user chose "Use without account"
final skippedAuthProvider = StateProvider<bool>((ref) {
  final box = Hive.box('settings');
  return box.get('skipped_auth', defaultValue: false) as bool;
});

void skipAuth(dynamic ref) {
  Hive.box('settings').put('skipped_auth', true);
  ref.read(skippedAuthProvider.notifier).state = true;
}

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);
  final skippedAuth = ref.watch(skippedAuthProvider);

  return GoRouter(
    initialLocation: '/dhikr',
    redirect: (context, state) {
      // If a deep-link invite is pending, route to /groups so the user
      // can confirm joining the circle. The screen consumes the pending
      // code from Hive on display.
      final pendingInvite = DeepLinks.peekPending();
      if (pendingInvite != null && state.matchedLocation != '/groups') {
        // Only redirect once we're past auth gating (handled below).
        // If user must auth first, fall through to login redirect; the
        // pending code stays in Hive and we'll catch it after login.
        final supabaseConfigured =
            ref.read(supabaseClientProvider) != null;
        final isLoggedIn = authState.valueOrNull != null;
        if (!supabaseConfigured || skippedAuth || isLoggedIn) {
          return '/groups';
        }
      }

      // Skip auth redirect if Supabase not configured
      if (ref.read(supabaseClientProvider) == null) return null;

      // Skip auth if user chose "Use without account"
      if (skippedAuth) return null;

      final isLoggedIn = authState.valueOrNull != null;
      final isAuthRoute = state.matchedLocation == '/login' ||
          state.matchedLocation == '/onboarding';

      if (!isLoggedIn && !isAuthRoute) return '/login';
      if (isLoggedIn && isAuthRoute) return '/dhikr';
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: '/dhikr',
            builder: (context, state) => const DhikrScreen(),
          ),
          GoRoute(
            path: '/groups',
            builder: (context, state) => const GroupsScreen(),
          ),
          GoRoute(
            path: '/prayer',
            builder: (context, state) => const PrayerScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
          GoRoute(
            path: '/streak',
            builder: (context, state) => const StreakScreen(),
          ),
        ],
      ),
    ],
  );
});
