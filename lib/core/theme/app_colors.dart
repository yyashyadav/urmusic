import 'package:flutter/material.dart';

/// Modern Obsidian Dark & Royal Purple color system matching UIDesign screens.
class AppColors {
  AppColors._();

  // Backgrounds
  static const Color background = Color(0xFF090A0F); // Deep Midnight Obsidian
  static const Color surface = Color(0xFF12141F);    // Dark card surface
  static const Color surfaceElevated = Color(0xFF171A29);
  static const Color surfaceHighlight = Color(0xFF22263C);

  // Search & input
  static const Color searchField = Color(0xFF131522);
  static const Color searchBorder = Color(0xFF222638);

  // Accent (Vibrant Royal Purple matching UIDesign)
  static const Color accent = Color(0xFF7C4DFF);
  static const Color accentLight = Color(0xFFA78BFA);
  static const Color accentDark = Color(0xFF6D28D9);

  // Text
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF64748B);

  // Borders & Dividers
  static const Color border = Color(0xFF1E2235);
  static const Color divider = Color(0xFF171A28);

  // Frosted Glass & Navigation
  static const Color glassSurface = Color(0xF20B0D16);
  static const Color glassBorder = Color(0x18FFFFFF);

  // Gradients for Mixes and Browse Categories
  static const LinearGradient dailyMixGradient = LinearGradient(
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
    colors: [Color(0xFF4C1D95), Color(0xFF7C3AED), Color(0xFF8B5CF6)],
  );

  static const LinearGradient chillMixGradient = LinearGradient(
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
    colors: [Color(0xFF065F46), Color(0xFF059669), Color(0xFF10B981)],
  );

  static const LinearGradient focusMixGradient = LinearGradient(
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
    colors: [Color(0xFF9F1239), Color(0xFFE11D48), Color(0xFFFB923C)],
  );

  static const LinearGradient roadTripGradient = LinearGradient(
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
    colors: [Color(0xFF1E3A8A), Color(0xFF2563EB), Color(0xFF3B82F6)],
  );

  static const LinearGradient popGradient = LinearGradient(
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
    colors: [Color(0xFFBE123C), Color(0xFFF43F5E), Color(0xFFFB923C)],
  );

  static const LinearGradient hipHopGradient = LinearGradient(
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
    colors: [Color(0xFF4C1D95), Color(0xFF6D28D9), Color(0xFF7C3AED)],
  );

  static const LinearGradient chillGradient = LinearGradient(
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
    colors: [Color(0xFF064E3B), Color(0xFF059669), Color(0xFF10B981)],
  );

  static const LinearGradient focusGradient = LinearGradient(
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
    colors: [Color(0xFF1E3A8A), Color(0xFF1D4ED8), Color(0xFF2563EB)],
  );

  static const LinearGradient workoutGradient = LinearGradient(
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
    colors: [Color(0xFF881337), Color(0xFFBE123C), Color(0xFFE11D48)],
  );

  static const LinearGradient partyGradient = LinearGradient(
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
    colors: [Color(0xFF581C87), Color(0xFF7E22CE), Color(0xFF9333EA)],
  );
}
