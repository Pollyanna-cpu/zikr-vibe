import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
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
