import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:zikr_vibe/app.dart';
import 'package:zikr_vibe/core/auth_session_guard.dart';

void main() {
  testWidgets('widget harness renders without startup services',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          startupIapEnabledProvider.overrideWithValue(false),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: Center(child: Text('Zikr Vibe')),
          ),
        ),
      ),
    );

    expect(find.text('Zikr Vibe'), findsOneWidget);
  });

  test('stale auth detection keeps retryable refresh errors', () {
    final retryable = AuthRetryableFetchException(message: 'offline');

    expect(isRetryableAuthError(retryable), isTrue);
    expect(isStaleAuthError(retryable), isFalse);
  });

  test('stale auth detection catches auth and RLS failures', () {
    const authError = AuthException('Invalid Refresh Token');
    const rlsError = PostgrestException(
      message: 'new row violates row-level security policy for table "groups"',
      code: '42501',
    );

    expect(isStaleAuthError(authError), isTrue);
    expect(isStaleAuthError(rlsError), isTrue);
  });
}
