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
        // Guest-first: everyone can land on /groups; the screen itself
        // asks for sign-in when the invite actually needs an account.
        return '/groups';
      }

      // Guest-first (Yun 8/05): the app opens straight into the counter —
      // no account wall. /login is opt-in, reached from Profile, for people
      // who want sync/circles. Signed-out ≠ locked out.
      final isLoggedIn = authState.valueOrNull != null;

      // First run: show the 3-page intro once, then land on the counter.
      if (!onboardingSeen && state.matchedLocation != '/onboarding') {
        return '/onboarding';
      }

      // Already signed in — /login has nothing to offer.
      if (isLoggedIn && state.matchedLocation == '/login') return '/dhikr';
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
