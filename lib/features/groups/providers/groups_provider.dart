import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../../features/auth/providers/auth_provider.dart';
import '../models/circle_model.dart';

/// Fetches user's circles from Supabase
final circlesProvider = FutureProvider<List<Circle>>((ref) async {
  final client = ref.watch(supabaseClientProvider);
  final user = ref.watch(currentUserProvider);
  if (client == null || user == null) return [];

  // Get groups the user is a member of
  final membershipRows = await client
      .from('memberships')
      .select('group_id')
      .eq('user_id', user.id);

  if (membershipRows.isEmpty) return [];

  final groupIds =
      (membershipRows as List).map((r) => r['group_id'] as String).toList();

  // Get group details
  final groupRows =
      await client.from('groups').select().inFilter('id', groupIds);

  final today = DateTime.now().toIso8601String().substring(0, 10);

  final circles = <Circle>[];
  for (final g in groupRows) {
    // Get members for this group
    final memberRows = await client
        .from('memberships')
        .select('user_id, users(display_name)')
        .eq('group_id', g['id']);

    final memberUserIds =
        (memberRows as List).map((r) => r['user_id'] as String).toList();

    // Check today's presence for all members
    final presenceRows = await client
        .from('daily_presence')
        .select('user_id')
        .inFilter('user_id', memberUserIds)
        .eq('date', today);

    final activeUserIds =
        (presenceRows as List).map((r) => r['user_id'] as String).toSet();

    final members = memberRows.map<CircleMember>((m) {
      final uid = m['user_id'] as String;
      final name = m['users']?['display_name'] as String? ?? 'Member';
      return CircleMember(
        userId: uid,
        displayName: name,
        activeToday: activeUserIds.contains(uid),
        lastActiveLabel: activeUserIds.contains(uid) ? 'today' : null,
      );
    }).toList();

    circles.add(Circle(
      id: g['id'],
      name: g['name'],
      adminId: g['admin_id'] ?? '',
      inviteCode: g['invite_code'],
      members: members,
      sharedStreak: g['shared_streak'] ?? 0,
      longestSharedStreak: g['longest_shared_streak'] ?? 0,
    ));
  }

  return circles;
});

/// Create a new circle
Future<String?> createCircle(SupabaseClient client, String userId, String name) async {
  final inviteCode = const Uuid().v4().substring(0, 8).toUpperCase();

  final result = await client.from('groups').insert({
    'name': name,
    'admin_id': userId,
    'invite_code': inviteCode,
    'member_count': 1,
  }).select('id').single();

  final groupId = result['id'] as String;

  // Add creator as first member
  await client.from('memberships').insert({
    'group_id': groupId,
    'user_id': userId,
  });

  return inviteCode;
}

/// Join a circle by invite code
Future<bool> joinCircle(SupabaseClient client, String userId, String code) async {
  final groups = await client
      .from('groups')
      .select('id')
      .eq('invite_code', code.toUpperCase())
      .limit(1);

  if (groups.isEmpty) return false;

  final groupId = groups[0]['id'] as String;

  // Check if already a member
  final existing = await client
      .from('memberships')
      .select('id')
      .eq('group_id', groupId)
      .eq('user_id', userId)
      .limit(1);

  if (existing.isNotEmpty) return true; // Already a member

  await client.from('memberships').insert({
    'group_id': groupId,
    'user_id': userId,
  });

  return true;
}
