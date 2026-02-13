/// General application constants
class AppConstants {
  // File upload
  static const maxFileSize = 5 * 1024 * 1024; // 5MB
  static const allowedImageTypes = ['image/jpeg', 'image/png'];

  // Text limits
  static const maxTextLength = 5000;
  static const maxPostLength = 500;
  static const minPostLength = 50;

  // Anonymous user limits
  static const anonymousAnalysisLimit = 3;

  // Analysis history
  static const historyLimit = 30;

  // API timeouts
  static const apiTimeout = Duration(seconds: 30);

  // Scam types
  static const scamTypes = [
    'phishing',
    'romance',
    'payment',
    'job',
    'tech_support',
    'other',
  ];

  // Risk levels
  static const riskLevelLow = 'low';
  static const riskLevelMedium = 'medium';
  static const riskLevelHigh = 'high';
}
