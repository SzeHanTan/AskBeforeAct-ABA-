import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Helper utility functions
class Helpers {
  /// Get risk level color based on score
  static Color getRiskColor(int riskScore) {
    if (riskScore <= 30) {
      return AppColors.riskLow;
    } else if (riskScore <= 70) {
      return AppColors.riskMedium;
    } else {
      return AppColors.riskHigh;
    }
  }

  /// Get risk level text based on score
  static String getRiskLevel(int riskScore) {
    if (riskScore <= 30) {
      return 'Low Risk';
    } else if (riskScore <= 70) {
      return 'Medium Risk';
    } else {
      return 'High Risk';
    }
  }

  /// Show success snackbar
  static void showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Show error snackbar
  static void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Show info snackbar
  static void showInfo(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.info,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
