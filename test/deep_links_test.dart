import 'package:flutter_test/flutter_test.dart';
import 'package:zikr_vibe/core/deep_links.dart';

void main() {
  group('DeepLinks.consume invite code extraction', () {
    // Hive 'settings' box is not open in these tests — consume() still
    // returns the extracted code, it just skips persistence.

    test('accepts https App Link', () {
      final code =
          DeepLinks.consume(Uri.parse('https://zikrvibe.com/join/AB12CD34'));
      expect(code, 'AB12CD34');
    });

    test('accepts www host variant', () {
      final code = DeepLinks.consume(
          Uri.parse('https://www.zikrvibe.com/join/AB12CD34'));
      expect(code, 'AB12CD34');
    });

    test('accepts custom scheme zikrvibe://join/<CODE>', () {
      // 'join' parses as the URI host here, not a path segment.
      final code = DeepLinks.consume(Uri.parse('zikrvibe://join/AB12CD34'));
      expect(code, 'AB12CD34');
    });

    test('accepts custom scheme with host-style path', () {
      final code = DeepLinks.consume(
          Uri.parse('zikrvibe://zikrvibe.com/join/AB12CD34'));
      expect(code, 'AB12CD34');
    });

    test('lowercases input is canonicalized to uppercase', () {
      final code =
          DeepLinks.consume(Uri.parse('https://zikrvibe.com/join/ab12cd34'));
      expect(code, 'AB12CD34');
    });

    test('rejects malformed codes', () {
      expect(
          DeepLinks.consume(Uri.parse('https://zikrvibe.com/join/short')),
          isNull);
      expect(
          DeepLinks.consume(
              Uri.parse('https://zikrvibe.com/join/TOOLONG123')),
          isNull);
      expect(DeepLinks.consume(Uri.parse('https://zikrvibe.com/join/')),
          isNull);
    });

    test('rejects foreign hosts', () {
      expect(DeepLinks.consume(Uri.parse('https://evil.com/join/AB12CD34')),
          isNull);
      expect(
          DeepLinks.consume(
              Uri.parse('https://zikrvibe.com.evil.com/join/AB12CD34')),
          isNull);
    });

    test('rejects non-join paths on our host', () {
      expect(DeepLinks.consume(Uri.parse('https://zikrvibe.com/AB12CD34')),
          isNull);
    });
  });
}
