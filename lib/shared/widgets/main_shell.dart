import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../l10n/app_localizations.dart';

class MainShell extends StatelessWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith('/dhikr')) return 0;
    if (location.startsWith('/groups')) return 1;
    if (location.startsWith('/prayer')) return 2;
    if (location.startsWith('/profile')) return 3;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex(context),
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/dhikr');
            case 1:
              context.go('/groups');
            case 2:
              context.go('/prayer');
            case 3:
              context.go('/profile');
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.touch_app_rounded),
            label: t.navDhikr,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.group_rounded),
            label: t.navGroups,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.mosque_rounded),
            label: t.navPrayer,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_rounded),
            label: t.navProfile,
          ),
        ],
      ),
    );
  }
}
