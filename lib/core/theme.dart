import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'skin.dart';

/// Backward-compatible static colors — defaults to Mosque skin.
/// New code should use `ref.watch(skinProvider)` instead.
class ZikrColors {
  static const Color emerald = Color(0xFF0A4D38);
  static const Color emeraldLight = Color(0xFF147A5A);
  static const Color emeraldSoft = Color(0xFFE8F5EF);
  static const Color gold = Color(0xFFBFA14A);
  static const Color goldLight = Color(0xFFD4BE6A);
  static const Color goldSoft = Color(0xFFFDF8E8);
  static const Color marble = Color(0xFFFAF9F6);
  static const Color marbleWarm = Color(0xFFF5F2EC);
  static const Color ink = Color(0xFF1B1B1F);
  static const Color inkSoft = Color(0xFF5A5A6E);
  static const Color inkMuted = Color(0xFF9E9EB0);
  static const Color divider = Color(0xFFE8E8ED);
  static const Color error = Color(0xFFCC3D3D);
  static const Color tapGlow = Color(0xFF0A4D38);
}

class ZikrTheme {
  /// Generate a light theme from any skin.
  static ThemeData lightFrom(ZikrSkin skin) {
    final base = ThemeData(useMaterial3: true, brightness: Brightness.light);

    return base.copyWith(
      colorScheme: ColorScheme.light(
        primary: skin.primary,
        onPrimary: Colors.white,
        secondary: skin.accent,
        surface: skin.surface,
        onSurface: skin.ink,
      ),
      scaffoldBackgroundColor: skin.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: skin.ink,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: skin.ink,
          letterSpacing: -0.3,
        ),
      ),
      textTheme: GoogleFonts.interTextTheme(base.textTheme),
      cardTheme: CardThemeData(
        color: skin.surfaceCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: skin.divider, width: 0.5),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: skin.surfaceCard,
        selectedItemColor: skin.primary,
        unselectedItemColor: skin.inkMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: const TextStyle(
            fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.3),
        unselectedLabelStyle: const TextStyle(
            fontSize: 11, fontWeight: FontWeight.w400),
      ),
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        titleTextStyle: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: skin.ink,
        ),
      ),
    );
  }

  /// Generate a dark theme from any skin.
  static ThemeData darkFrom(ZikrSkin skin) {
    final base = ThemeData(useMaterial3: true, brightness: Brightness.dark);

    return base.copyWith(
      colorScheme: ColorScheme.dark(
        primary: skin.darkPrimary,
        onPrimary: skin.ink,
        secondary: skin.accent,
        surface: skin.darkSurface,
        onSurface: skin.darkOnSurface,
      ),
      scaffoldBackgroundColor: skin.darkSurface,
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: skin.darkNavBg,
        selectedItemColor: skin.darkPrimary,
        unselectedItemColor: skin.inkMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
    );
  }

  /// Legacy getters — default to Rosewater.
  static ThemeData get light => lightFrom(ZikrSkins.rosewater);
  static ThemeData get dark => darkFrom(ZikrSkins.rosewater);
}
