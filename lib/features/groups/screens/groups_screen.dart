import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme.dart';
import '../../../features/auth/providers/auth_provider.dart';
import '../providers/groups_provider.dart';
import '../models/circle_model.dart';

/// Companion Circles — presence, not competition
class GroupsScreen extends ConsumerWidget {
  const GroupsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final circlesAsync = ref.watch(circlesProvider);

    return Scaffold(
      backgroundColor: ZikrColors.marble,
      appBar: AppBar(
        title: const Text('Dhikr Circles'),
        backgroundColor: Colors.transparent,
      ),
      body: user == null
          ? _NotLoggedIn()
          : circlesAsync.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text('Error: $err')),
              data: (circles) => circles.isEmpty
                  ? _EmptyState(
                      onCreateCircle: () =>
                          _showCreateSheet(context, ref),
                      onJoinCircle: () =>
                          _showJoinSheet(context, ref),
                    )
                  : _CirclesList(
                      circles: circles,
                      onCreateCircle: () =>
                          _showCreateSheet(context, ref),
                      onJoinCircle: () =>
                          _showJoinSheet(context, ref),
                    ),
            ),
    );
  }

  void _showCreateSheet(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(
          24, 24, 24,
          MediaQuery.of(ctx).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36, height: 4,
                decoration: BoxDecoration(
                  color: ZikrColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'New dhikr circle',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: ZikrColors.ink,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'A private space to be present with family or friends.\n'
              'Members see that you did dhikr today — nothing more.',
              style: GoogleFonts.inter(
                fontSize: 13,
                color: ZikrColors.inkSoft,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: controller,
              autofocus: true,
              textCapitalization: TextCapitalization.words,
              style: GoogleFonts.inter(fontSize: 16),
              decoration: InputDecoration(
                hintText: 'e.g. Family, Mosque friends',
                hintStyle: GoogleFonts.inter(color: ZikrColors.inkMuted),
                filled: true,
                fillColor: ZikrColors.marble,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 14,
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () async {
                  final name = controller.text.trim();
                  if (name.isEmpty) return;
                  final client = ref.read(supabaseClientProvider);
                  final user = ref.read(currentUserProvider);
                  if (client == null || user == null) return;

                  final inviteCode =
                      await createCircle(client, user.id, name);
                  if (!ctx.mounted) return;
                  Navigator.pop(ctx);

                  ref.invalidate(circlesProvider);

                  if (inviteCode != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Circle "$name" created! Invite code: $inviteCode'),
                        behavior: SnackBarBehavior.floating,
                        action: SnackBarAction(
                          label: 'Copy',
                          onPressed: () {
                            Clipboard.setData(
                                ClipboardData(text: inviteCode));
                          },
                        ),
                      ),
                    );
                  }
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: ZikrColors.emerald,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Create Circle',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showJoinSheet(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(
          24, 24, 24,
          MediaQuery.of(ctx).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36, height: 4,
                decoration: BoxDecoration(
                  color: ZikrColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Join a circle',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: ZikrColors.ink,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: controller,
              autofocus: true,
              textCapitalization: TextCapitalization.characters,
              style: GoogleFonts.inter(fontSize: 16, letterSpacing: 2),
              decoration: InputDecoration(
                hintText: 'Paste invite code',
                hintStyle: GoogleFonts.inter(
                    color: ZikrColors.inkMuted, letterSpacing: 0),
                filled: true,
                fillColor: ZikrColors.marble,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 14,
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () async {
                  final code = controller.text.trim();
                  if (code.isEmpty) return;
                  final client = ref.read(supabaseClientProvider);
                  final user = ref.read(currentUserProvider);
                  if (client == null || user == null) return;

                  final success =
                      await joinCircle(client, user.id, code);
                  if (!ctx.mounted) return;
                  Navigator.pop(ctx);

                  ref.invalidate(circlesProvider);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(success
                          ? 'Joined circle!'
                          : 'Invalid invite code.'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: ZikrColors.emerald,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Join',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotLoggedIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Sign in to create or join circles',
        style: GoogleFonts.inter(color: ZikrColors.inkMuted, fontSize: 15),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onCreateCircle;
  final VoidCallback onJoinCircle;

  const _EmptyState({
    required this.onCreateCircle,
    required this.onJoinCircle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: ZikrColors.emeraldSoft,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.people_outline_rounded,
                size: 36,
                color: ZikrColors.emerald,
              ),
            ),
            const SizedBox(height: 28),
            Text(
              'Dhikr Circles',
              style: GoogleFonts.inter(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: ZikrColors.ink,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'A quiet space to be present with family or friends.\n'
              'See who remembered today — not how much.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: ZikrColors.inkSoft,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              margin: const EdgeInsets.only(top: 12),
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: ZikrColors.goldSoft,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.lock_outline_rounded,
                      size: 14, color: ZikrColors.gold),
                  const SizedBox(width: 8),
                  Text(
                    'Your count stays private. Always.',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: ZikrColors.gold,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            TextButton(
              onPressed: onCreateCircle,
              style: TextButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                backgroundColor: ZikrColors.emerald,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Create Your First Circle',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: onJoinCircle,
              child: Text(
                'Join with invite code',
                style: GoogleFonts.inter(
                  color: ZikrColors.inkMuted,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CirclesList extends StatelessWidget {
  final List<Circle> circles;
  final VoidCallback onCreateCircle;
  final VoidCallback onJoinCircle;

  const _CirclesList({
    required this.circles,
    required this.onCreateCircle,
    required this.onJoinCircle,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        for (final circle in circles) ...[
          _CircleCard(circle: circle),
          const SizedBox(height: 16),
        ],
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: onCreateCircle,
              child: Text('+ Create',
                  style: GoogleFonts.inter(color: ZikrColors.emerald)),
            ),
            const SizedBox(width: 16),
            TextButton(
              onPressed: onJoinCircle,
              child: Text('Join',
                  style: GoogleFonts.inter(color: ZikrColors.inkMuted)),
            ),
          ],
        ),
      ],
    );
  }
}

class _CircleCard extends StatelessWidget {
  final Circle circle;

  const _CircleCard({required this.circle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ZikrColors.divider, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                circle.name,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: ZikrColors.ink,
                ),
              ),
              const Spacer(),
              if (circle.sharedStreak > 0)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: ZikrColors.emeraldSoft,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('\u{1F525}',
                          style: TextStyle(fontSize: 12)),
                      const SizedBox(width: 4),
                      Text(
                        '${circle.sharedStreak}d together',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: ZikrColors.emerald,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            circle.presenceSummary,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: ZikrColors.inkMuted,
            ),
          ),
          const SizedBox(height: 16),
          for (final member in circle.members) ...[
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: member.activeToday
                        ? ZikrColors.emeraldSoft
                        : ZikrColors.marble,
                    child: Text(
                      member.displayName.isNotEmpty
                          ? member.displayName[0]
                          : '?',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: member.activeToday
                            ? ZikrColors.emerald
                            : ZikrColors.inkMuted,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    member.displayName,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      color: ZikrColors.ink,
                    ),
                  ),
                  const Spacer(),
                  if (member.activeToday)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: ZikrColors.emeraldSoft,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '\u2713 today',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: ZikrColors.emerald,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  else
                    Text(
                      member.lastActiveLabel ?? '',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: ZikrColors.inkMuted,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
