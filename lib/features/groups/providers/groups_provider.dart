import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/auth_session_guard.dart';
import '../../../features/auth/providers/auth_provider.dart';
import '../models/circle_model.dart';

/// Fetches user's circles from Supabase
final circlesProvider = FutureProvider<List<Circle>>((ref) async {
  final client = ref.watch(supabaseClientProvider);
  final user = ref.watch(currentUserProvider);
  if (client == null || user == null) return [];

  try {
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
  } catch (e) {
    debugPrint('[Groups] circlesProvider error: $e');
    if (isStaleAuthError(e)) {
      await clearStaleAuthSession(
        ref,
        client,
        reason: 'groups fetch failed with stale auth: $e',
      );
      return [];
    }
    rethrow;
  }
});

/// Create a new circle.
///
/// Returns the invite code on success. Returns `null` on any failure -
/// caller surfaces a SnackBar.
///
/// Uses the `create_circle` SECURITY DEFINER RPC so the client never inserts
/// directly into `groups` or `memberships`. That keeps Create aligned with
/// Join Circle's RPC path and avoids direct PostgREST INSERT RLS edge cases.
Future<String?> createCircle(
  dynamic ref,
  SupabaseClient client,
  String name,
) async {
  try {
    final result = await client.rpc('create_circle', params: {
      'p_name': name.trim(),
    });
    return result as String?;
  } on PostgrestException catch (e) {
    debugPrint('[Groups] createCircle Postgrest ${e.code}: ${e.message}');
    if (isStaleAuthError(e)) {
      await clearStaleAuthSession(
        ref,
        client,
        reason: 'createCircle failed with stale auth: $e',
      );
    }
    return null;
  } on AuthException catch (e) {
    debugPrint('[Groups] createCircle auth: $e');
    if (isStaleAuthError(e)) {
      await clearStaleAuthSession(
        ref,
        client,
        reason: 'createCircle auth failed: $e',
      );
    }
    return null;
  } catch (e) {
    debugPrint('[Groups] createCircle error: $e');
    return null;
  }
}

/// Join a circle by invite code
///
/// Uses the `join_group_by_invite_code` SECURITY DEFINER RPC so the client
/// never reads `groups` directly with `invite_code`. The RPC validates auth,
/// looks up the group atomically, and inserts the membership in one round trip.
/// Returns `true` on success (joined or already a member), `false` if the code
/// is invalid or the call fails.
Future<bool> joinCircle(
  dynamic ref,
  SupabaseClient client,
  String userId,
  String code,
) async {
  try {
    final result = await client.rpc(
      'join_group_by_invite_code',
      params: {'code': code.toUpperCase()},
    );
    return result != null;
  } on PostgrestException catch (e) {
    debugPrint('[Groups] joinCircle Postgrest ${e.code}: ${e.message}');
    if (isStaleAuthError(e)) {
      await clearStaleAuthSession(
        ref,
        client,
        reason: 'joinCircle failed with stale auth: $e',
      );
    }
    return false;
  } on AuthException catch (e) {
    debugPrint('[Groups] joinCircle auth: $e');
    if (isStaleAuthError(e)) {
      await clearStaleAuthSession(
        ref,
        client,
        reason: 'joinCircle auth failed: $e',
      );
    }
    return false;
  } catch (e) {
    debugPrint('[Groups] joinCircle error: $e');
    // RPC raises 'Invalid invite code' / 'Authentication required' on failure.
    return false;
  }
}
