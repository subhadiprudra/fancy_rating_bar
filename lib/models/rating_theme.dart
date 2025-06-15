import 'package:flutter/material.dart';

class RatingTheme {
  final String name;
  final Gradient background;
  final Color dialogColor;
  final Gradient buttonGradient;
  final Gradient progressGradient;
  final Color textColor;
  final Color textSecondaryColor;
  final Color textMutedColor;
  final Color starColor;
  final Color accentColor;

  const RatingTheme({
    required this.name,
    required this.background,
    required this.dialogColor,
    required this.buttonGradient,
    required this.progressGradient,
    required this.textColor,
    required this.textSecondaryColor,
    required this.textMutedColor,
    required this.starColor,
    required this.accentColor,
  });
}

class RatingThemes {
  // Aurora theme (updated)
  static const aurora = RatingTheme(
    name: 'Aurora',
    background: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF4C1D95), Color(0xFF1E3A8A), Color(0xFF312E81)],
    ),
    dialogColor: Color(0x1AFFFFFF),
    buttonGradient: LinearGradient(
      colors: [Color(0xFF9333EA), Color(0xFFEC4899)],
    ),
    progressGradient: LinearGradient(
      colors: [Color(0xFFA855F7), Color(0xFFF472B6)],
    ),
    textColor: Colors.white,
    textSecondaryColor: Color(0xB3FFFFFF),
    textMutedColor: Color(0x80FFFFFF),
    starColor: Color(0xFFFBBF24),
    accentColor: Color(0x409333EA),
  );

  // Sunset theme (updated)
  static const sunset = RatingTheme(
    name: 'Sunset',
    background: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF7C2D12), Color(0xFF991B1B), Color(0xFF831843)],
    ),
    dialogColor: Color(0x33000000),
    buttonGradient: LinearGradient(
      colors: [Color(0xFFEA580C), Color(0xFFDC2626)],
    ),
    progressGradient: LinearGradient(
      colors: [Color(0xFFFB923C), Color(0xFFF87171)],
    ),
    textColor: Colors.white,
    textSecondaryColor: Color(0xCCFFEDD5),
    textMutedColor: Color(0x99FFEDD5),
    starColor: Color(0xFFFBBF24),
    accentColor: Color(0x40EA580C),
  );

  // Ocean theme (updated)
  static const ocean = RatingTheme(
    name: 'Ocean',
    background: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF1E3A8A), Color(0xFF164E63), Color(0xFF134E4A)],
    ),
    dialogColor: Color(0x1AFFFFFF),
    buttonGradient: LinearGradient(
      colors: [Color(0xFF0891B2), Color(0xFF2563EB)],
    ),
    progressGradient: LinearGradient(
      colors: [Color(0xFF22D3EE), Color(0xFF3B82F6)],
    ),
    textColor: Colors.white,
    textSecondaryColor: Color(0xCCECFEFF),
    textMutedColor: Color(0x99ECFEFF),
    starColor: Color(0xFFFDE047),
    accentColor: Color(0x400891B2),
  );

  // Forest theme (new)
  static const forest = RatingTheme(
    name: 'Forest',
    background: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF14532D), Color(0xFF065F46), Color(0xFF134E4A)],
    ),
    dialogColor: Color(0x33000000),
    buttonGradient: LinearGradient(
      colors: [Color(0xFF059669), Color(0xFF16A34A)],
    ),
    progressGradient: LinearGradient(
      colors: [Color(0xFF34D399), Color(0xFF4ADE80)],
    ),
    textColor: Colors.white,
    textSecondaryColor: Color(0xCCD1FAE5),
    textMutedColor: Color(0x99D1FAE5),
    starColor: Color(0xFFFBBF24),
    accentColor: Color(0x4010B981),
  );

  // Midnight theme (new)
  static const midnight = RatingTheme(
    name: 'Midnight',
    background: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF111827), Color(0xFF0F172A), Color(0xFF000000)],
    ),
    dialogColor: Color(0x0DFFFFFF),
    buttonGradient: LinearGradient(
      colors: [Color(0xFF374151), Color(0xFF334155)],
    ),
    progressGradient: LinearGradient(
      colors: [Color(0xFF9CA3AF), Color(0xFF94A3B8)],
    ),
    textColor: Colors.white,
    textSecondaryColor: Color(0xCCD1D5DB),
    textMutedColor: Color(0x999CA3AF),
    starColor: Color(0xFFFBBF24),
    accentColor: Color(0x406B7280),
  );

  // Neon theme (updated)
  static const neon = RatingTheme(
    name: 'Neon',
    background: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF000000), Color(0xFF2E1065), Color(0xFF000000)],
    ),
    dialogColor: Color(0x99000000),
    buttonGradient: LinearGradient(
      colors: [Color(0xFFEC4899), Color(0xFF8B5CF6)],
    ),
    progressGradient: LinearGradient(
      colors: [Color(0xFFF472B6), Color(0xFFA855F7)],
    ),
    textColor: Colors.white,
    textSecondaryColor: Color(0xE6FBCFE8),
    textMutedColor: Color(0xB3F9A8D4),
    starColor: Color(0xFFFDE047),
    accentColor: Color(0x66EC4899),
  );

  // Update the list of all themes
  static List<RatingTheme> get allThemes => [
        aurora,
        sunset,
        ocean,
        forest,
        midnight,
        neon,
      ];
}
