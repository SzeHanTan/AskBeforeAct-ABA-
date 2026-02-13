/// Environment configuration
class EnvConfig {
  // Gemini API Key for AI fraud detection
  static const String geminiApiKey = 'AIzaSyD3ueKs0ziIhGIXlTcJ1nXPRVBfjUyjvDQ';

  // Firebase config (optional, can use firebase_options.dart)
  static const String firebaseApiKey = String.fromEnvironment(
    'FIREBASE_API_KEY',
    defaultValue: '',
  );

  static const String firebaseProjectId = String.fromEnvironment(
    'FIREBASE_PROJECT_ID',
    defaultValue: '',
  );

  /// Check if running in debug mode
  static bool get isDebug {
    bool inDebugMode = false;
    assert(inDebugMode = true);
    return inDebugMode;
  }
}
