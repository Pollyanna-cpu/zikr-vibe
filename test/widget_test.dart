import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:zikr_vibe/app.dart';

void main() {
  testWidgets('App launches and shows dhikr counter', (WidgetTester tester) async {
    await Hive.initFlutter();
    await Hive.openBox('dhikr_sessions');
    await Hive.openBox('settings');

    await tester.pumpWidget(
      const ProviderScope(child: ZikrVibeApp()),
    );

    // Verify default counter group is visible
    expect(find.text('SubhanAllah'), findsOneWidget);
    expect(find.text('0'), findsOneWidget);
  });
}
