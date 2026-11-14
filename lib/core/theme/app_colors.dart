import 'package:flutter/material.dart';

/// All colors of the design live here, so no widget hardcodes a color.
abstract final class AppColors {
  static const primary = Color(0xFF7B4AE2);
  static const background = Colors.white;
  static const surfaceMuted = Color(0xFFF3F3F3);

  static const textPrimary = Color(0xFF111111);
  static const textSecondary = Color(0xFF8A8A8A);

  // Macro nutrient rings on the Home screen.
  static const fat = Color(0xFFF5C84C);
  static const protein = Color(0xFF3B82F6);
  static const carbs = Color(0xFF8B6CF0);
}
