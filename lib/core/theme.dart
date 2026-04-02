import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Zikr Vibe — Premium Islamic color system
/// Inspired by mosque interiors: deep greens, warm golds, cool marble whites
class ZikrColors {
  // Primary — Deep forest green (mosque domes)
  static const Color emerald = Color(0xFF0A4D38);
  static const Color emeraldLight = Color(0xFF147A5A);
  static const Color emeraldSoft = Color(0xFFE8F5EF);

  // Accent — Warm antique gold (Quran gilding)
  static const Color gold = Color(0xFFBFA14A);
  static const Color goldLight = Color(0xFFD4BE6A);
  static const Color goldSoft = Color(0xFFFDF8E8);

  // Surface — Cool marble
  static const Color marble = Color(0xFFFAF9F6);
  static const Color marbleWarm = Color(0xFFF5F2EC);

  // Text
  static const Color ink = Color(0xFF1B1B1F);
  static const Color inkSoft = Color(0xFF5A5A6E);
  static const Color inkMuted = Color(0xFF9E9EB0);

  // Divider
  static const Color divider = Color(0xFFE8E8ED);

  // Semantic
  static const Color error = Color(0xFFCC3D3D);

  // Counter glow
  static const Color tapGlow = Color(0xFF0A4D38);
}

class ZikrTheme {
  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
    );

    return base.copyWith(
      colorScheme: const ColorScheme.light(
        primary: ZikrColors.emerald,
        onPrimary: Colors.white,
        secondary: ZikrColors.gold,
        surface: ZikrColors.marble,
        onSurface: ZikrColors.ink,
      ),
      scaffoldBackgroundColor: ZikrColors.marble,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: ZikrColors.ink,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: ZikrColors.ink,
          letterSpacing: -0.3,
        ),
      ),
      textTheme: GoogleFonts.interTextTheme(base.textTheme),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: ZikrColors.divider, width: 0.5),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: ZikrColors.emerald,
        unselectedItemColor: ZikrColors.inkMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.3),
        unselectedLabelStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.w400),
      ),
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        titleTextStyle: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: ZikrColors.ink,
        ),
      ),
    );
  }

  static ThemeData get dark {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
    );

    return base.copyWith(
      colorScheme: const ColorScheme.dark(
        primary: ZikrColors.goldLight,
        onPrimary: ZikrColors.ink,
        secondary: ZikrColors.gold,
        surface: Color(0xFF111115),
        onSurface: Color(0xFFE8E8ED),
      ),
      scaffoldBackgroundColor: const Color(0xFF111115),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF1A1A1F),
        selectedItemColor: ZikrColors.goldLight,
        unselectedItemColor: ZikrColors.inkMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
    );
  }
}
