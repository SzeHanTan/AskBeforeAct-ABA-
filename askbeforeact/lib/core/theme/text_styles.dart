import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Application text styles
class AppTextStyles {
  // Headings
  static const h1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const h2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const h3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // Body text
  static const bodyLarge = TextStyle(
    fontSize: 16,
    color: AppColors.textPrimary,
  );

  static const bodyMedium = TextStyle(
    fontSize: 14,
    color: AppColors.textPrimary,
  );

  static const bodySmall = TextStyle(
    fontSize: 12,
    color: AppColors.textSecondary,
  );

  // Button text
  static const button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  // Caption
  static const caption = TextStyle(
    fontSize: 12,
    color: AppColors.textSecondary,
  );
}
