import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'auth_prefs.dart';
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

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);
  final skippedAuth = ref.watch(skippedAuthProvider);
  final onboardingSeen = ref.watch(onboardingSeenProvider);

  return GoRouter(
    initialLocation: '/dhikr',
    redirect: (context, state) {
      // If a deep-link invite is pending, route to /groups so the user
      // can confirm joining the circle. The screen consumes the pending
      // code from Hive on display.
      final pendingInvite = DeepLinks.peekPending();
      if (pendingInvite != null &&
          state.matchedLocation != '/groups' &&
          state.matchedLocation != '/onboarding') {
        final supabaseConfigured = ref.read(supabaseClientProvider) != null;
        final isLoggedIn = authState.valueOrNull != null;
        if (!supabaseConfigured || skippedAuth || isLoggedIn) {
          return '/groups';
        }
      }

      // Skip auth redirect if Supabase not configured
      if (ref.read(supabaseClientProvider) == null) return null;

      final isLoggedIn = authState.valueOrNull != null;
      final isAuthRoute = state.matchedLocation == '/login' ||
          state.matchedLocation == '/onboarding';
      final pastAuth = isLoggedIn || skippedAuth;

      // Past auth (logged in or guest) but onboarding not yet seen → show it
      // once. Onboarding's Skip/Get Started both set the flag.
      if (pastAuth &&
          !onboardingSeen &&
          state.matchedLocation != '/onboarding') {
        return '/onboarding';
      }

      // Not past auth and not on /login → send to login. /onboarding is
      // reachable only after auth is established.
      if (!pastAuth && !isAuthRoute) return '/login';
      if (pastAuth && state.matchedLocation == '/login') return '/dhikr';
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
