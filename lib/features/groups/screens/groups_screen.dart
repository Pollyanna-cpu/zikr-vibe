import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme.dart';

/// Companion Circles — presence, not competition
class GroupsScreen extends ConsumerWidget {
  const GroupsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Demo data — will be replaced with Supabase when configured
    // ignore: dead_code
    const hasCircles = false; // TODO: replace with provider

    return Scaffold(
      backgroundColor: ZikrColors.marble,
      appBar: AppBar(
        title: const Text('Dhikr Circles'),
        backgroundColor: Colors.transparent,
      ),
      body: hasCircles
          ? _CirclesList()
          : _EmptyState(
              onCreateCircle: () => _showCreateSheet(context, ref),
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
              'A private space to be present with family or friends.\nMembers see that you did dhikr today — nothing more.',
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
                onPressed: () {
                  final name = controller.text.trim();
                  if (name.isNotEmpty) {
                    // TODO: Create circle via Supabase
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Circle "$name" created. Configure Supabase to invite friends.'),
                        behavior: SnackBarBehavior.floating,
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
}

/// Empty state — first time user
class _EmptyState extends StatelessWidget {
  final VoidCallback onCreateCircle;

  const _EmptyState({required this.onCreateCircle});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Circle illustration
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

            // Privacy note
            Container(
              margin: const EdgeInsets.only(top: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: ZikrColors.goldSoft,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.lock_outline_rounded, size: 14, color: ZikrColors.gold),
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
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
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
              onPressed: () {
                // TODO: Join circle by code
              },
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

/// Mock circle list — preview of what it looks like with data
class _CirclesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Demo data
    final circles = [
      _CircleDemo('Family', 14, [
        _MemberDemo('Ahmad', true),
        _MemberDemo('Fatima', true),
        _MemberDemo('Yusuf', false),
      ]),
    ];

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        for (final circle in circles) ...[
          _CircleCard(circle: circle),
          const SizedBox(height: 16),
        ],
      ],
    );
  }
}

class _CircleDemo {
  final String name;
  final int sharedStreak;
  final List<_MemberDemo> members;
  _CircleDemo(this.name, this.sharedStreak, this.members);
}

class _MemberDemo {
  final String name;
  final bool activeToday;
  _MemberDemo(this.name, this.activeToday);
}

class _CircleCard extends StatelessWidget {
  final _CircleDemo circle;

  const _CircleCard({required this.circle});

  @override
  Widget build(BuildContext context) {
    final active = circle.members.where((m) => m.activeToday).length;
    final total = circle.members.length;

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
          // Header
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
              // Shared streak badge
              if (circle.sharedStreak > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: ZikrColors.emeraldSoft,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('🔥', style: TextStyle(fontSize: 12)),
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

          // Presence summary
          Text(
            '$active of $total remembered today',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: ZikrColors.inkMuted,
            ),
          ),

          const SizedBox(height: 16),

          // Members
          for (final member in circle.members) ...[
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  // Avatar
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: member.activeToday
                        ? ZikrColors.emeraldSoft
                        : ZikrColors.marble,
                    child: Text(
                      member.name[0],
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
                  // Name
                  Text(
                    member.name,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      color: ZikrColors.ink,
                    ),
                  ),
                  const Spacer(),
                  // Status
                  if (member.activeToday)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: ZikrColors.emeraldSoft,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '✓ today',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: ZikrColors.emerald,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  else
                    Text(
                      'yesterday',
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
