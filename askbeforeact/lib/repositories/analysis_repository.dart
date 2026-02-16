import 'dart:typed_data';
import '../models/analysis_model.dart';
import '../services/gemini_service.dart';
import '../services/firestore_service.dart';
import '../services/storage_service.dart';

/// Repository for analysis operations
class AnalysisRepository {
  final GeminiService _geminiService;
  final FirestoreService _firestoreService;
  final StorageService _storageService;

  AnalysisRepository({
    required GeminiService geminiService,
    required FirestoreService firestoreService,
    required StorageService storageService,
  })  : _geminiService = geminiService,
        _firestoreService = firestoreService,
        _storageService = storageService;

  /// Analyze text content
  Future<AnalysisModel> analyzeText({
    required String userId,
    required String text,
  }) async {
    try {
      // Analyze with Gemini
      final geminiResponse = await _geminiService.analyzeText(text);

      // Create analysis model
      final analysis = _geminiService.createAnalysisModel(
        userId: userId,
        type: 'text',
        content: text,
        geminiResponse: geminiResponse,
      );

      // Save to Firestore
      final analysisId = await _firestoreService.createAnalysis(analysis);

      // Increment user's analysis count
      await _firestoreService.incrementUserAnalysisCount(userId);

      // Return analysis with ID
      return analysis.copyWith(id: analysisId);
    } catch (e) {
      throw Exception('Failed to analyze text: $e');
    }
  }

  /// Analyze URL
  Future<AnalysisModel> analyzeUrl({
    required String userId,
    required String url,
  }) async {
    try {
      // Analyze with Gemini
      final geminiResponse = await _geminiService.analyzeUrl(url);

      // Create analysis model
      final analysis = _geminiService.createAnalysisModel(
        userId: userId,
        type: 'url',
        content: url,
        geminiResponse: geminiResponse,
      );

      // Save to Firestore
      final analysisId = await _firestoreService.createAnalysis(analysis);

      // Increment user's analysis count
      await _firestoreService.incrementUserAnalysisCount(userId);

      // Return analysis with ID
      return analysis.copyWith(id: analysisId);
    } catch (e) {
      throw Exception('Failed to analyze URL: $e');
    }
  }

  /// Analyze screenshot/image
  Future<AnalysisModel> analyzeScreenshot({
    required String userId,
    required Uint8List imageBytes,
  }) async {
    try {
      // Upload screenshot to Firebase Storage
      final imageUrl = await _storageService.uploadScreenshot(
        imageBytes: imageBytes,
        userId: userId,
      );

      // Analyze with Gemini
      final geminiResponse = await _geminiService.analyzeImage(imageBytes);

      // Create analysis model
      final analysis = _geminiService.createAnalysisModel(
        userId: userId,
        type: 'screenshot',
        content: imageUrl,
        geminiResponse: geminiResponse,
      );

      // Save to Firestore
      final analysisId = await _firestoreService.createAnalysis(analysis);

      // Increment user's analysis count
      await _firestoreService.incrementUserAnalysisCount(userId);

      // Return analysis with ID
      return analysis.copyWith(id: analysisId);
    } catch (e) {
      throw Exception('Failed to analyze screenshot: $e');
    }
  }

  /// Get user's analysis history
  Future<List<AnalysisModel>> getUserAnalyses(String userId, {int limit = 30}) async {
    try {
      return await _firestoreService.getUserAnalyses(userId, limit: limit);
    } catch (e) {
      throw Exception('Failed to get user analyses: $e');
    }
  }

  /// Get user's analysis history stream (real-time)
  Stream<List<AnalysisModel>> getUserAnalysesStream(String userId, {int limit = 30}) {
    try {
      return _firestoreService.getUserAnalysesStream(userId, limit: limit);
    } catch (e) {
      throw Exception('Failed to stream user analyses: $e');
    }
  }

  /// Get analysis by ID
  Future<AnalysisModel?> getAnalysisById(String analysisId) async {
    try {
      return await _firestoreService.getAnalysisById(analysisId);
    } catch (e) {
      throw Exception('Failed to get analysis: $e');
    }
  }

  /// Delete analysis
  Future<void> deleteAnalysis(String analysisId, String? imageUrl) async {
    try {
      // Delete from Firestore
      await _firestoreService.deleteAnalysis(analysisId);

      // Delete image from Storage if it exists
      if (imageUrl != null && imageUrl.isNotEmpty) {
        try {
          await _storageService.deleteFile(imageUrl);
        } catch (e) {
          // Continue even if image deletion fails
          print('Warning: Failed to delete image: $e');
        }
      }
    } catch (e) {
      throw Exception('Failed to delete analysis: $e');
    }
  }

  /// Get user statistics
  Future<Map<String, dynamic>> getUserStatistics(String userId) async {
    try {
      final totalAnalyses = await _firestoreService.getUserAnalysisCount(userId);
      final highRiskCount = await _firestoreService.getUserHighRiskCount(userId);
      
      return {
        'totalAnalyses': totalAnalyses,
        'highRiskCount': highRiskCount,
        'lowRiskCount': totalAnalyses - highRiskCount,
      };
    } catch (e) {
      throw Exception('Failed to get user statistics: $e');
    }
  }

  /// Check if anonymous user has reached limit (3 analyses)
  Future<bool> hasAnonymousUserReachedLimit(String userId) async {
    try {
      final count = await _firestoreService.getUserAnalysisCount(userId);
      return count >= 3;
    } catch (e) {
      throw Exception('Failed to check anonymous limit: $e');
    }
  }
}
