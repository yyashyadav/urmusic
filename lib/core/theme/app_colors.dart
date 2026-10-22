import 'package:flutter/material.dart';

/// Clean, minimalist AMOLED color system inspired by BlackHole.
/// High contrast, minimal noise, and professional dark aesthetic.
class AppColors {
  AppColors._();

  // Backgrounds
  static const Color background = Color(0xFF000000); // True AMOLED black
  static const Color surface = Color(0xFF121212);    // Clean dark surface
  static const Color surfaceElevated = Color(0xFF181818);
  static const Color surfaceHighlight = Color(0xFF242424);

  // Accent (Crisp clean green like Spotify / BlackHole)
  static const Color accent = Color(0xFF1DB954);
  static const Color accentLight = Color(0xFF1ED760);

  // Text
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB3B3B3);
  static const Color textMuted = Color(0xFF737373);

  // Borders & Dividers
  static const Color border = Color(0xFF222222);
  static const Color divider = Color(0xFF1A1A1A);

  // Subtle iOS Frosted Glass Tokens
  static const Color glassSurface = Color(0xDD0D0D11); // Translucent dark blur base
  static const Color glassBorder = Color(0x1FFFFFFF);  // Subtle hairline highlight border
}
