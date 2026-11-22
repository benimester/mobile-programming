import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Typography scale of the design.
abstract final class AppTextStyles {
  static const title = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const heading = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const body = TextStyle(fontSize: 16, color: AppColors.textPrimary);

  static const caption = TextStyle(
    fontSize: 13,
    color: AppColors.textSecondary,
  );

  static const button = TextStyle(fontSize: 17, fontWeight: FontWeight.w600);
}
