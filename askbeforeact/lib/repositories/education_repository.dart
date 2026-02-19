import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/education_content_model.dart';
import '../models/scam_news_model.dart';

/// Repository for education content and scam news
class EducationRepository {
  final FirebaseFirestore _firestore;

  EducationRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Get all education content ordered by order field
  Stream<List<EducationContentModel>> getEducationContent() {
    return _firestore
        .collection('education_content')
        .orderBy('order')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => EducationContentModel.fromFirestore(doc))
            .toList());
  }

  /// Get education content by ID
  Future<EducationContentModel?> getEducationContentById(String id) async {
    try {
      final doc = await _firestore.collection('education_content').doc(id).get();
      
      if (!doc.exists) {
        return null;
      }
      
      return EducationContentModel.fromFirestore(doc);
    } catch (e) {
      print('Error fetching education content: $e');
      return null;
    }
  }

  /// Get scam news articles ordered by publication date
  Stream<List<ScamNewsModel>> getScamNews({int limit = 20}) {
    return _firestore
        .collection('scam_news')
        .orderBy('pubDate', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ScamNewsModel.fromFirestore(doc))
            .toList());
  }

  /// Get paginated scam news
  Future<List<ScamNewsModel>> getScamNewsPaginated({
    int limit = 20,
    DocumentSnapshot? lastDocument,
  }) async {
    try {
      Query query = _firestore
          .collection('scam_news')
          .orderBy('pubDate', descending: true)
          .limit(limit);

      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }

      final snapshot = await query.get();
      
      return snapshot.docs
          .map((doc) => ScamNewsModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Error fetching paginated scam news: $e');
      return [];
    }
  }

  /// Search scam news by title or content
  Future<List<ScamNewsModel>> searchScamNews(String query) async {
    try {
      if (query.isEmpty) {
        return [];
      }

      final snapshot = await _firestore
          .collection('scam_news')
          .orderBy('pubDate', descending: true)
          .limit(50)
          .get();

      final allNews = snapshot.docs
          .map((doc) => ScamNewsModel.fromFirestore(doc))
          .toList();

      final searchQuery = query.toLowerCase();
      
      return allNews.where((news) {
        return news.title.toLowerCase().contains(searchQuery) ||
            news.contentSnippet.toLowerCase().contains(searchQuery);
      }).toList();
    } catch (e) {
      print('Error searching scam news: $e');
      return [];
    }
  }

  /// Get count of news articles
  Future<int> getScamNewsCount() async {
    try {
      final snapshot = await _firestore
          .collection('scam_news')
          .count()
          .get();
      
      return snapshot.count ?? 0;
    } catch (e) {
      print('Error getting scam news count: $e');
      return 0;
    }
  }

  /// Get recent news (last 24 hours)
  Stream<List<ScamNewsModel>> getRecentScamNews() {
    final yesterday = DateTime.now().subtract(const Duration(hours: 24));
    
    return _firestore
        .collection('scam_news')
        .where('pubDate', isGreaterThan: Timestamp.fromDate(yesterday))
        .orderBy('pubDate', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ScamNewsModel.fromFirestore(doc))
            .toList());
  }
}
