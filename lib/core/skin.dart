import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// A complete visual identity for the app.
/// Like Octopus card faces — same card, different art. $10 each.
class ZikrSkin {
  final String id;
  final String name;
  final String nameAr;
  final String description;
  final bool isFree;
  final double priceUsd;

  // Primary
  final Color primary;
  final Color primaryLight;
  final Color primarySoft;

  // Accent
  final Color accent;
  final Color accentLight;
  final Color accentSoft;

  // Surface
  final Color surface;
  final Color surfaceWarm;
  final Color surfaceCard;

  // Text
  final Color ink;
  final Color inkSoft;
  final Color inkMuted;

  // Misc
  final Color divider;
  final Color tapGlow;
  final Color error;
  final double patternOpacity;

  /// Which geometric pattern to draw.
  /// 'octagram' = 8-point star (mosque ceilings)
  /// 'arabesque' = interlocking petal/rose curves
  final String patternStyle;

  // Dark mode overrides
  final Color darkSurface;
  final Color darkOnSurface;
  final Color darkPrimary;
  final Color darkNavBg;

  const ZikrSkin({
    required this.id,
    required this.name,
    required this.nameAr,
    this.description = '',
    this.isFree = false,
    this.priceUsd = 9.99,
    required this.primary,
    required this.primaryLight,
    required this.primarySoft,
    required this.accent,
    required this.accentLight,
    required this.accentSoft,
    required this.surface,
    required this.surfaceWarm,
    this.surfaceCard = Colors.white,
    required this.ink,
    required this.inkSoft,
    required this.inkMuted,
    required this.divider,
    required this.tapGlow,
    this.error = const Color(0xFFCC3D3D),
    this.patternOpacity = 0.018,
    this.patternStyle = 'octagram',
    this.darkSurface = const Color(0xFF111115),
    this.darkOnSurface = const Color(0xFFE8E8ED),
    this.darkPrimary = const Color(0xFFD4BE6A),
    this.darkNavBg = const Color(0xFF1A1A1F),
  });
}

// ---------------------------------------------------------------------------
// Presets
// ---------------------------------------------------------------------------

class ZikrSkins {
  /// Default — deep mosque green + antique gold. For everyone.
  static const mosque = ZikrSkin(
    id: 'mosque',
    name: 'Mosque',
    nameAr: 'مسجد',
    description: 'Deep green & gold. Inspired by mosque domes.',
    isFree: true,
    priceUsd: 0,
    primary: Color(0xFF0A4D38),
    primaryLight: Color(0xFF147A5A),
    primarySoft: Color(0xFFE8F5EF),
    accent: Color(0xFFBFA14A),
    accentLight: Color(0xFFD4BE6A),
    accentSoft: Color(0xFFFDF8E8),
    surface: Color(0xFFFAF9F6),
    surfaceWarm: Color(0xFFF5F2EC),
    ink: Color(0xFF1B1B1F),
    inkSoft: Color(0xFF5A5A6E),
    inkMuted: Color(0xFF9E9EB0),
    divider: Color(0xFFE8E8ED),
    tapGlow: Color(0xFF0A4D38),
    patternStyle: 'octagram',
  );

  /// Rosewater — dusty pink + warm gold arabesque. For her.
  /// Inspired by Ottoman rose gardens, Turkish mosque tiles in pink
  /// tones, and the rosewater served after prayer.
  static const rosewater = ZikrSkin(
    id: 'rosewater',
    name: 'Rosewater',
    nameAr: 'ماء الورد',
    description: 'Dusty rose & gold. Arabesque patterns.',
    isFree: true, // free for now — monetize later
    priceUsd: 0,
    // Dusty pink — not bubblegum, think dried Damascus roses
    primary: Color(0xFFA4566E),
    primaryLight: Color(0xFFC47A90),
    primarySoft: Color(0xFFFCEDF2),
    // Warm gold — like the gold leaf on Quran covers
    accent: Color(0xFFC9A84C),
    accentLight: Color(0xFFDDC06A),
    accentSoft: Color(0xFFFDF6E4),
    // Surfaces — warm cream, not cold white
    surface: Color(0xFFFDF8F6),
    surfaceWarm: Color(0xFFF9F0EC),
    surfaceCard: Color(0xFFFFFBF9),
    // Text — warm charcoal, not pure black
    ink: Color(0xFF2D1F24),
    inkSoft: Color(0xFF6E525C),
    inkMuted: Color(0xFFB0949D),
    // Dividers — blush pink, barely visible
    divider: Color(0xFFF2E2E7),
    tapGlow: Color(0xFFA4566E),
    error: Color(0xFFCC3D3D),
    patternOpacity: 0.030,
    patternStyle: 'arabesque',
    // Dark mode — deep wine + rose gold
    darkSurface: Color(0xFF1A0E12),
    darkOnSurface: Color(0xFFF0D8E0),
    darkPrimary: Color(0xFFE8A0B8),
    darkNavBg: Color(0xFF221418),
  );

  static const List<ZikrSkin> all = [rosewater, mosque];

  static ZikrSkin byId(String id) =>
      all.firstWhere((s) => s.id == id, orElse: () => rosewater);
}

// ---------------------------------------------------------------------------
// Riverpod provider + Hive persistence
// ---------------------------------------------------------------------------

class SkinNotifier extends StateNotifier<ZikrSkin> {
  SkinNotifier() : super(ZikrSkins.rosewater) {
    _load();
  }

  void _load() {
    final box = Hive.box('settings');
    final id = box.get('skin_id', defaultValue: 'rosewater') as String;
    state = ZikrSkins.byId(id);
  }

  void select(ZikrSkin skin) {
    state = skin;
    Hive.box('settings').put('skin_id', skin.id);
  }

  bool isOwned(ZikrSkin skin) {
    if (skin.isFree) return true;
    final box = Hive.box('settings');
    final owned = box.get('owned_skins', defaultValue: <String>[]);
    return (owned as List).contains(skin.id);
  }

  void unlock(String skinId) {
    final box = Hive.box('settings');
    final owned =
        List<String>.from(box.get('owned_skins', defaultValue: <String>[]) as List);
    if (!owned.contains(skinId)) {
      owned.add(skinId);
      box.put('owned_skins', owned);
    }
  }
}

final skinProvider = StateNotifierProvider<SkinNotifier, ZikrSkin>((ref) {
  return SkinNotifier();
});
