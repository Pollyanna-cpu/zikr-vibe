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

  /// Rosewater — luminous blush pink + champagne gold. For her.
  /// Inspired by Kris Jenner's golden glow, Rhode Skin aesthetics,
  /// silk-on-light warmth. Not berry, not bubblegum — champagne blush.
  static const rosewater = ZikrSkin(
    id: 'rosewater',
    name: 'Rosewater',
    nameAr: 'ماء الورد',
    description: 'Dusty rose & warm gold. Luminous.',
    isFree: true, // free for now — monetize later
    priceUsd: 0,
    // Dusty rose — warm pink, less brown than nude, more luminous
    primary: Color(0xFFDB9A9F),
    primaryLight: Color(0xFFE8B5B9),
    primarySoft: Color(0xFFFCEFF0),
    // Champagne gold — warm, silky, light-through-curtain gold
    accent: Color(0xFFC5A76D),
    accentLight: Color(0xFFD9C08C),
    accentSoft: Color(0xFFFDF5E8),
    // Surfaces — warm cream, desaturated from dusty pink for legibility
    // (5/7 phone-test fix: previous #FAF2EE read as "too pink" on OLED).
    surface: Color(0xFFFBF6F3),
    surfaceWarm: Color(0xFFF2EAE5),
    surfaceCard: Color(0xFFFFFCFA),
    // Text — warm brown, deepened for AA-grade contrast on warm surface.
    // (5/7 phone-test fix: previous ink/inkSoft/inkMuted read as "too faint".)
    ink: Color(0xFF1A100C),
    inkSoft: Color(0xFF4A3D36),
    inkMuted: Color(0xFF7A6459),
    // Dividers — slightly more visible than the old champagne whisper
    divider: Color(0xFFE8DCD4),
    tapGlow: Color(0xFFE8B5B9),
    error: Color(0xFFCC3D3D),
    patternOpacity: 0.025,
    patternStyle: 'arabesque',
    // Dark mode — deep wine + rose gold
    darkSurface: Color(0xFF1A0E12),
    darkOnSurface: Color(0xFFF0D8E0),
    darkPrimary: Color(0xFFE8A0B8),
    darkNavBg: Color(0xFF221418),
  );

  /// Pink Sand — bright warm pink. Dawn over Wadi Rum dunes.
  static const pinkSand = ZikrSkin(
    id: 'pink_sand',
    name: 'Pink Sand',
    nameAr: 'رمال وردية',
    description: 'Bright rose. Dawn over Wadi Rum.',
    isFree: false, // paid via Google Play IAP
    priceUsd: 1.99,
    primary: Color(0xFFEEB7C3),
    primaryLight: Color(0xFFF4CDD6),
    primarySoft: Color(0xFFFDF0F3),
    accent: Color(0xFFC5A76D),
    accentLight: Color(0xFFD9C08C),
    accentSoft: Color(0xFFFDF5E8),
    surface: Color(0xFFFFF5F7),
    surfaceWarm: Color(0xFFFBECEF),
    surfaceCard: Color(0xFFFFFAFB),
    ink: Color(0xFF2C1F1A),
    inkSoft: Color(0xFF7A6459),
    inkMuted: Color(0xFFB8A198),
    divider: Color(0xFFF5E4E8),
    tapGlow: Color(0xFFF4CDD6),
    error: Color(0xFFCC3D3D),
    patternOpacity: 0.02,
    patternStyle: 'arabesque',
    darkSurface: Color(0xFF1A0E12),
    darkOnSurface: Color(0xFFF5D8E0),
    darkPrimary: Color(0xFFF0B8C8),
    darkNavBg: Color(0xFF221418),
  );

  /// Misty Rose — lavender pink. Cream fog over rose gardens.
  static const mistyRose = ZikrSkin(
    id: 'misty_rose',
    name: 'Misty Rose',
    nameAr: 'ضباب الورد',
    description: 'Lavender pink. Soft and dreamy.',
    isFree: false, // paid via Google Play IAP
    priceUsd: 1.99,
    primary: Color(0xFFF8CDED),
    primaryLight: Color(0xFFFBDDF3),
    primarySoft: Color(0xFFFEF4FC),
    accent: Color(0xFFC5A76D),
    accentLight: Color(0xFFD9C08C),
    accentSoft: Color(0xFFFDF5E8),
    surface: Color(0xFFFFF6FD),
    surfaceWarm: Color(0xFFFBEEF8),
    surfaceCard: Color(0xFFFFFAFE),
    ink: Color(0xFF2A1A28),
    inkSoft: Color(0xFF6E5A6A),
    inkMuted: Color(0xFFAA98A6),
    divider: Color(0xFFF5E6F2),
    tapGlow: Color(0xFFFBDDF3),
    error: Color(0xFFCC3D3D),
    patternOpacity: 0.02,
    patternStyle: 'arabesque',
    darkSurface: Color(0xFF180E18),
    darkOnSurface: Color(0xFFF5D8F0),
    darkPrimary: Color(0xFFF8CDED),
    darkNavBg: Color(0xFF201420),
  );

  /// Mint Fog — fresh mint green. Morning dew on leaves.
  static const mintFog = ZikrSkin(
    id: 'mint_fog',
    name: 'Mint Fog',
    nameAr: 'نعناع الضباب',
    description: 'Fresh mint. Cool and calm.',
    isFree: false, // paid via Google Play IAP
    priceUsd: 1.99,
    primary: Color(0xFFC6F0E0),
    primaryLight: Color(0xFFD8F5EA),
    primarySoft: Color(0xFFEFFBF5),
    accent: Color(0xFF8DB5A0),
    accentLight: Color(0xFFA8CCBA),
    accentSoft: Color(0xFFE8F5EF),
    surface: Color(0xFFF5FCFA),
    surfaceWarm: Color(0xFFEDF8F3),
    surfaceCard: Color(0xFFFAFEFC),
    ink: Color(0xFF1A2820),
    inkSoft: Color(0xFF5A6E62),
    inkMuted: Color(0xFF98AEA2),
    divider: Color(0xFFE2F2EA),
    tapGlow: Color(0xFFD8F5EA),
    error: Color(0xFFCC3D3D),
    patternOpacity: 0.02,
    patternStyle: 'octagram',
    darkSurface: Color(0xFF0E1812),
    darkOnSurface: Color(0xFFD8F0E5),
    darkPrimary: Color(0xFFC6F0E0),
    darkNavBg: Color(0xFF142018),
  );

  /// Haze Lilac — soft purple. Twilight clouds.
  static const hazeLilac = ZikrSkin(
    id: 'haze_lilac',
    name: 'Haze Lilac',
    nameAr: 'ضباب أرجواني',
    description: 'Soft lilac. Twilight sky.',
    isFree: false, // paid via Google Play IAP
    priceUsd: 1.99,
    primary: Color(0xFFD6CEF8),
    primaryLight: Color(0xFFE2DCFB),
    primarySoft: Color(0xFFF3F1FE),
    accent: Color(0xFFA098C0),
    accentLight: Color(0xFFB8B0D4),
    accentSoft: Color(0xFFF0EEF8),
    surface: Color(0xFFF8F6FF),
    surfaceWarm: Color(0xFFF2F0FA),
    surfaceCard: Color(0xFFFCFBFF),
    ink: Color(0xFF1E1A2C),
    inkSoft: Color(0xFF5E5A6E),
    inkMuted: Color(0xFF9E98AE),
    divider: Color(0xFFEAE6F5),
    tapGlow: Color(0xFFE2DCFB),
    error: Color(0xFFCC3D3D),
    patternOpacity: 0.02,
    patternStyle: 'arabesque',
    darkSurface: Color(0xFF12101A),
    darkOnSurface: Color(0xFFE0D8F5),
    darkPrimary: Color(0xFFD6CEF8),
    darkNavBg: Color(0xFF1A1822),
  );

  /// Pearl Mist — soft cream pink. Morning fog over Gulf waters.
  static const pearlMist = ZikrSkin(
    id: 'pearl_mist',
    name: 'Pearl Mist',
    nameAr: 'ضباب اللؤلؤ',
    description: 'Soft cream pink. Gulf morning mist.',
    isFree: false, // paid via Google Play IAP
    priceUsd: 1.99,
    primary: Color(0xFFE7C9CF),
    primaryLight: Color(0xFFF0DAE0),
    primarySoft: Color(0xFFFCF4F6),
    accent: Color(0xFFC5A76D),
    accentLight: Color(0xFFD9C08C),
    accentSoft: Color(0xFFFDF5E8),
    surface: Color(0xFFFFF8F9),
    surfaceWarm: Color(0xFFF9F0F2),
    surfaceCard: Color(0xFFFFFCFD),
    ink: Color(0xFF2C1F1A),
    inkSoft: Color(0xFF7A6459),
    inkMuted: Color(0xFFB8A198),
    divider: Color(0xFFF5EAED),
    tapGlow: Color(0xFFF0DAE0),
    error: Color(0xFFCC3D3D),
    patternOpacity: 0.018,
    patternStyle: 'arabesque',
    darkSurface: Color(0xFF1A0E12),
    darkOnSurface: Color(0xFFF5E0E5),
    darkPrimary: Color(0xFFEBD0D8),
    darkNavBg: Color(0xFF221418),
  );

  /// Ruby Petals — deep berry pink. Bold and confident.
  static const rubyPetals = ZikrSkin(
    id: 'ruby_petals',
    name: 'Ruby Petals',
    nameAr: 'بتلات الياقوت',
    description: 'Deep berry. Bold and warm.',
    isFree: false, // paid via Google Play IAP
    priceUsd: 1.99,
    primary: Color(0xFFA55166),
    primaryLight: Color(0xFFBE7585),
    primarySoft: Color(0xFFF2E0E5),
    accent: Color(0xFFC5A76D),
    accentLight: Color(0xFFD9C08C),
    accentSoft: Color(0xFFFDF5E8),
    surface: Color(0xFFFAF2F4),
    surfaceWarm: Color(0xFFF4E4E8),
    surfaceCard: Color(0xFFFFF8F9),
    ink: Color(0xFF2C1A20),
    inkSoft: Color(0xFF6E5A60),
    inkMuted: Color(0xFFAA98A0),
    divider: Color(0xFFF0E2E6),
    tapGlow: Color(0xFFBE7585),
    error: Color(0xFFCC3D3D),
    patternOpacity: 0.03,
    patternStyle: 'arabesque',
    darkSurface: Color(0xFF1A0E12),
    darkOnSurface: Color(0xFFF0D0D8),
    darkPrimary: Color(0xFFBE7585),
    darkNavBg: Color(0xFF221418),
  );

  static const List<ZikrSkin> all = [rosewater, mosque, pinkSand, pearlMist, mistyRose, mintFog, hazeLilac, rubyPetals];

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
}

final skinProvider = StateNotifierProvider<SkinNotifier, ZikrSkin>((ref) {
  return SkinNotifier();
});

/// Reactive set of skin ids the user owns. Separate from [skinProvider] so
/// the skin selector and any owned-state UI rebuild the moment IAP unlocks
/// or restores a skin — previously `unlock()` only wrote Hive and the UI
/// stayed visually locked until manual rebuild.
class OwnedSkinsNotifier extends StateNotifier<Set<String>> {
  OwnedSkinsNotifier() : super(const {}) {
    _load();
  }

  void _load() {
    final box = Hive.box('settings');
    final raw = box.get('owned_skins', defaultValue: <String>[]) as List;
    state = raw.map((e) => e.toString()).toSet();
  }

  void unlock(String skinId) {
    if (state.contains(skinId)) return;
    final updated = {...state, skinId};
    state = updated;
    Hive.box('settings').put('owned_skins', updated.toList());
  }

  bool isOwned(ZikrSkin skin) => skin.isFree || state.contains(skin.id);
}

final ownedSkinsProvider =
    StateNotifierProvider<OwnedSkinsNotifier, Set<String>>((ref) {
  return OwnedSkinsNotifier();
});
