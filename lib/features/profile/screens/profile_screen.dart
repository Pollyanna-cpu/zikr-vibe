import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/auth_prefs.dart';
import '../../../core/skin.dart';
import '../../auth/providers/auth_provider.dart';
import '../../iap/iap_service.dart';
import '../../streak/providers/streak_provider.dart';
import '../../groups/providers/groups_provider.dart';
import 'skin_selector_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final skin = ref.watch(skinProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Avatar
            CircleAvatar(
              radius: 48,
              backgroundColor: skin.primary.withValues(alpha: 0.1),
              child: Text(
                (user?.userMetadata?['display_name'] as String?)
                        ?.substring(0, 1)
                        .toUpperCase() ??
                    '?',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                  color: skin.primary,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Name
            Text(
              user?.userMetadata?['display_name'] as String? ??
                  user?.email ??
                  'User',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 4),
            Text(
              user?.email ?? '',
              style: Theme.of(context).textTheme.bodyMedium,
            ),

            const SizedBox(height: 32),

            // Stats cards — live data
            Builder(builder: (context) {
              final streak = ref.watch(streakProvider);
              final circles = ref.watch(circlesProvider);
              final groupCount = circles.valueOrNull?.length ?? 0;
              return Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      label: 'Total Dhikr',
                      value: '${streak.lifetimeTotal}',
                      icon: Icons.touch_app_rounded,
                      skin: skin,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      label: 'Streak',
                      value: '${streak.currentStreak}d',
                      icon: Icons.local_fire_department_rounded,
                      skin: skin,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      label: 'Groups',
                      value: '$groupCount',
                      icon: Icons.group_rounded,
                      skin: skin,
                    ),
                  ),
                ],
              );
            }),

            const SizedBox(height: 32),

            // Settings list
            _SettingsTile(
              icon: Icons.calculate_rounded,
              label: 'Prayer Calculation Method',
              skin: skin,
              onTap: () {},
            ),
            _SettingsTile(
              icon: Icons.notifications_rounded,
              label: 'Notification Settings',
              skin: skin,
              onTap: () {},
            ),
            _SettingsTile(
              icon: Icons.palette_rounded,
              label: 'Appearance',
              subtitle: skin.name,
              skin: skin,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SkinSelectorScreen()),
                );
              },
            ),
            _SettingsTile(
              icon: Icons.info_outline_rounded,
              label: 'About Zikr Vibe',
              skin: skin,
              onTap: () {},
            ),
            _SettingsTile(
              icon: Icons.restore_rounded,
              label: 'Restore Purchases',
              skin: skin,
              onTap: () async {
                final ok =
                    await ref.read(iapServiceProvider).restorePurchases();
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(ok
                        ? 'Restoring purchases…'
                        : 'Store not available on this device'),
                    duration: const Duration(seconds: 3),
                  ),
                );
              },
            ),

            const SizedBox(height: 32),

            // Guest-first: signed-out users get an opt-in Sign In entry
            // (sync + circles); signed-in users get Sign Out. Nobody is
            // ever forced through /login to use the counter.
            if (user == null)
              _SettingsTile(
                icon: Icons.login_rounded,
                label: 'Sign In',
                subtitle: 'Sync across devices · join circles',
                skin: skin,
                onTap: () => context.go('/login'),
              )
            else
              TextButton(
                onPressed: () async {
                  await ref.read(authServiceProvider).signOut();
                  resetSkippedAuth(ref);
                  if (context.mounted) context.go('/dhikr');
                },
                child: Text(
                  'Sign Out',
                  style: TextStyle(color: skin.error),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final ZikrSkin skin;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.skin,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: skin.primary, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: skin.ink,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(fontSize: 12, color: skin.inkMuted),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? subtitle;
  final ZikrSkin skin;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.label,
    this.subtitle,
    required this.skin,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: skin.inkMuted),
      title: Text(label),
      subtitle: subtitle != null
          ? Text(subtitle!, style: TextStyle(color: skin.primary, fontSize: 12))
          : null,
      trailing: Icon(Icons.chevron_right_rounded, color: skin.inkMuted),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }
}
