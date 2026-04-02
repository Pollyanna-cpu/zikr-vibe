import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme.dart';
import '../../auth/providers/auth_provider.dart';
import '../../streak/providers/streak_provider.dart';
import '../../groups/providers/groups_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Avatar
            CircleAvatar(
              radius: 48,
              backgroundColor: ZikrColors.emerald.withValues(alpha: 0.1),
              child: Text(
                (user?.userMetadata?['display_name'] as String?)
                        ?.substring(0, 1)
                        .toUpperCase() ??
                    '?',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                  color: ZikrColors.emerald,
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
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      label: 'Streak',
                      value: '${streak.currentStreak}d',
                      icon: Icons.local_fire_department_rounded,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      label: 'Groups',
                      value: '$groupCount',
                      icon: Icons.group_rounded,
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
              onTap: () {},
            ),
            _SettingsTile(
              icon: Icons.notifications_rounded,
              label: 'Notification Settings',
              onTap: () {},
            ),
            _SettingsTile(
              icon: Icons.dark_mode_rounded,
              label: 'Appearance',
              onTap: () {},
            ),
            _SettingsTile(
              icon: Icons.info_outline_rounded,
              label: 'About Zikr Vibe',
              onTap: () {},
            ),

            const SizedBox(height: 32),

            // Sign out
            TextButton(
              onPressed: () => ref.read(authServiceProvider).signOut(),
              child: const Text(
                'Sign Out',
                style: TextStyle(color: ZikrColors.error),
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

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: ZikrColors.emerald, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: ZikrColors.ink,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: ZikrColors.inkMuted,
              ),
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
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: ZikrColors.inkMuted),
      title: Text(label),
      trailing: const Icon(Icons.chevron_right_rounded, color: ZikrColors.inkMuted),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }
}
