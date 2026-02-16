import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import '../models/analysis_model.dart';
import '../repositories/analysis_repository.dart';

/// Analysis state provider
class AnalysisProvider extends ChangeNotifier {
  final AnalysisRepository _analysisRepository;

  AnalysisProvider({required AnalysisRepository analysisRepository})
      : _analysisRepository = analysisRepository;

  // State
  List<AnalysisModel> _analyses = [];
  AnalysisModel? _currentAnalysis;
  bool _isAnalyzing = false;
  bool _isLoading = false;
  String? _error;
  Map<String, dynamic>? _statistics;

  // Getters
  List<AnalysisModel> get analyses => _analyses;
  AnalysisModel? get currentAnalysis => _currentAnalysis;
  bool get isAnalyzing => _isAnalyzing;
  bool get isLoading => _isLoading;
  String? get error => _error;
  Map<String, dynamic>? get statistics => _statistics;

  /// Analyze text content
  Future<AnalysisModel?> analyzeText({
    required String userId,
    required String text,
  }) async {
    try {
      _isAnalyzing = true;
      _error = null;
      notifyListeners();

      final analysis = await _analysisRepository.analyzeText(
        userId: userId,
        text: text,
      );

      _currentAnalysis = analysis;
      _analyses.insert(0, analysis); // Add to beginning of list
      _isAnalyzing = false;
      notifyListeners();

      return analysis;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _isAnalyzing = false;
      notifyListeners();
      return null;
    }
  }

  /// Analyze URL
  Future<AnalysisModel?> analyzeUrl({
    required String userId,
    required String url,
  }) async {
    try {
      _isAnalyzing = true;
      _error = null;
      notifyListeners();

      final analysis = await _analysisRepository.analyzeUrl(
        userId: userId,
        url: url,
      );

      _currentAnalysis = analysis;
      _analyses.insert(0, analysis); // Add to beginning of list
      _isAnalyzing = false;
      notifyListeners();

      return analysis;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _isAnalyzing = false;
      notifyListeners();
      return null;
    }
  }

  /// Analyze screenshot
  Future<AnalysisModel?> analyzeScreenshot({
    required String userId,
    required Uint8List imageBytes,
  }) async {
    try {
      _isAnalyzing = true;
      _error = null;
      notifyListeners();

      final analysis = await _analysisRepository.analyzeScreenshot(
        userId: userId,
        imageBytes: imageBytes,
      );

      _currentAnalysis = analysis;
      _analyses.insert(0, analysis); // Add to beginning of list
      _isAnalyzing = false;
      notifyListeners();

      return analysis;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _isAnalyzing = false;
      notifyListeners();
      return null;
    }
  }

  /// Load user's analysis history
  Future<void> loadUserAnalyses(String userId, {int limit = 30}) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _analyses = await _analysisRepository.getUserAnalyses(userId, limit: limit);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load user statistics
  Future<void> loadUserStatistics(String userId) async {
    try {
      _statistics = await _analysisRepository.getUserStatistics(userId);
      notifyListeners();
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
    }
  }

  /// Get analysis by ID
  Future<AnalysisModel?> getAnalysisById(String analysisId) async {
    try {
      return await _analysisRepository.getAnalysisById(analysisId);
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return null;
    }
  }

  /// Delete analysis
  Future<bool> deleteAnalysis(String analysisId, String? imageUrl) async {
    try {
      await _analysisRepository.deleteAnalysis(analysisId, imageUrl);
      
      // Remove from local list
      _analyses.removeWhere((analysis) => analysis.id == analysisId);
      
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  /// Check if anonymous user has reached limit
  Future<bool> hasAnonymousUserReachedLimit(String userId) async {
    try {
      return await _analysisRepository.hasAnonymousUserReachedLimit(userId);
    } catch (e) {
      return false;
    }
  }

  /// Set current analysis (for viewing details)
  void setCurrentAnalysis(AnalysisModel analysis) {
    _currentAnalysis = analysis;
    notifyListeners();
  }

  /// Clear current analysis
  void clearCurrentAnalysis() {
    _currentAnalysis = null;
    notifyListeners();
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Clear all data
  void clear() {
    _analyses = [];
    _currentAnalysis = null;
    _statistics = null;
    _error = null;
    notifyListeners();
  }

  /// Get risk level color
  String getRiskLevelColor(String riskLevel) {
    switch (riskLevel.toLowerCase()) {
      case 'low':
        return '#4CAF50'; // Green
      case 'medium':
        return '#FF9800'; // Orange
      case 'high':
        return '#F44336'; // Red
      default:
        return '#9E9E9E'; // Grey
    }
  }

  /// Get risk level emoji
  String getRiskLevelEmoji(String riskLevel) {
    switch (riskLevel.toLowerCase()) {
      case 'low':
        return '🟢';
      case 'medium':
        return '🟡';
      case 'high':
        return '🔴';
      default:
        return '⚪';
    }
  }

  /// Get scam type display name
  String getScamTypeDisplayName(String scamType) {
    switch (scamType.toLowerCase()) {
      case 'phishing':
        return 'Phishing';
      case 'romance':
        return 'Romance Scam';
      case 'payment':
        return 'Payment Fraud';
      case 'job':
        return 'Job Scam';
      case 'tech_support':
        return 'Tech Support Scam';
      case 'investment':
        return 'Investment Scam';
      case 'lottery':
        return 'Lottery/Prize Scam';
      case 'impersonation':
        return 'Impersonation';
      case 'other':
        return 'Other';
      default:
        return scamType;
    }
  }
}
