import 'package:flutter/foundation.dart';
import '../models/education_content_model.dart';
import '../models/scam_news_model.dart';
import '../services/education_service.dart';

/// Provider for education content and scam news
class EducationProvider with ChangeNotifier {
  final EducationService _educationService;

  List<EducationContentModel> _educationContent = [];
  List<ScamNewsModel> _scamNews = [];
  bool _isLoadingContent = false;
  bool _isLoadingNews = false;
  String? _error;

  EducationProvider({EducationService? educationService})
      : _educationService = educationService ?? EducationService();

  List<EducationContentModel> get educationContent => _educationContent;
  List<ScamNewsModel> get scamNews => _scamNews;
  bool get isLoadingContent => _isLoadingContent;
  bool get isLoadingNews => _isLoadingNews;
  String? get error => _error;

  /// Load education content from Firebase
  Future<void> loadEducationContent() async {
    _isLoadingContent = true;
    _error = null;
    notifyListeners();

    try {
      _educationContent = await _educationService.getEducationContentWithFallback();
      _error = null;
    } catch (e) {
      _error = 'Failed to load education content: $e';
      print(_error);
    } finally {
      _isLoadingContent = false;
      notifyListeners();
    }
  }

  /// Stream education content
  Stream<List<EducationContentModel>> streamEducationContent() {
    return _educationService.getEducationContent();
  }

  /// Load scam news from Firebase
  Future<void> loadScamNews({int limit = 20}) async {
    _isLoadingNews = true;
    _error = null;
    notifyListeners();

    try {
      final newsStream = _educationService.getScamNews(limit: limit);
      await for (final news in newsStream) {
        _scamNews = news;
        _isLoadingNews = false;
        notifyListeners();
        break;
      }
    } catch (e) {
      _error = 'Failed to load scam news: $e';
      _scamNews = [];
      print(_error);
    } finally {
      _isLoadingNews = false;
      notifyListeners();
    }
  }

  /// Stream scam news
  Stream<List<ScamNewsModel>> streamScamNews({int limit = 20}) {
    return _educationService.getScamNews(limit: limit);
  }

  /// Search scam news
  Future<List<ScamNewsModel>> searchNews(String query) async {
    try {
      return await _educationService.searchScamNews(query);
    } catch (e) {
      print('Error searching news: $e');
      return [];
    }
  }

  /// Get education content by ID
  Future<EducationContentModel?> getContentById(String id) async {
    try {
      return await _educationService.getEducationContentById(id);
    } catch (e) {
      print('Error getting content by ID: $e');
      return null;
    }
  }

  /// Refresh all data
  Future<void> refreshAll() async {
    await Future.wait([
      loadEducationContent(),
      loadScamNews(),
    ]);
  }
}
