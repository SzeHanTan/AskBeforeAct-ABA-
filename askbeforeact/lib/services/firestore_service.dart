import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/analysis_model.dart';
import '../models/community_post_model.dart';
import '../models/user_model.dart';
import '../models/podcast_model.dart';

/// Firestore Database Service
class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection references
  CollectionReference get _usersCollection => _firestore.collection('users');
  CollectionReference get _analysesCollection => _firestore.collection('analyses');
  CollectionReference get _communityPostsCollection => _firestore.collection('communityPosts');
  CollectionReference get _educationContentCollection => _firestore.collection('educationContent');
  CollectionReference get _podcastsCollection => _firestore.collection('podcasts');

  // ==================== USER OPERATIONS ====================

  /// Create or update user document
  Future<void> createOrUpdateUser(UserModel user) async {
    try {
      await _usersCollection.doc(user.id).set(user.toMap(), SetOptions(merge: true));
    } catch (e) {
      throw Exception('Failed to create/update user: $e');
    }
  }

  /// Get user by ID
  Future<UserModel?> getUserById(String userId) async {
    try {
      final doc = await _usersCollection.doc(userId).get();
      if (!doc.exists) return null;
      return UserModel.fromMap(doc.data() as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }

  /// Update user analysis count
  Future<void> incrementUserAnalysisCount(String userId) async {
    try {
      await _usersCollection.doc(userId).update({
        'analysisCount': FieldValue.increment(1),
      });
    } catch (e) {
      throw Exception('Failed to update analysis count: $e');
    }
  }

  /// Get user's analysis count
  Future<int> getUserAnalysisCount(String userId) async {
    try {
      final doc = await _usersCollection.doc(userId).get();
      if (!doc.exists) return 0;
      final data = doc.data() as Map<String, dynamic>;
      return data['analysisCount'] as int? ?? 0;
    } catch (e) {
      throw Exception('Failed to get analysis count: $e');
    }
  }

  // ==================== ANALYSIS OPERATIONS ====================

  /// Create new analysis
  Future<String> createAnalysis(AnalysisModel analysis) async {
    try {
      final docRef = await _analysesCollection.add(analysis.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create analysis: $e');
    }
  }

  /// Get analysis by ID
  Future<AnalysisModel?> getAnalysisById(String analysisId) async {
    try {
      final doc = await _analysesCollection.doc(analysisId).get();
      if (!doc.exists) return null;
      return AnalysisModel.fromMap(
        doc.data() as Map<String, dynamic>,
        doc.id,
      );
    } catch (e) {
      throw Exception('Failed to get analysis: $e');
    }
  }

  /// Get user's analyses (last 30, most recent first)
  Future<List<AnalysisModel>> getUserAnalyses(String userId, {int limit = 30}) async {
    try {
      final querySnapshot = await _analysesCollection
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .get();

      return querySnapshot.docs
          .map((doc) => AnalysisModel.fromMap(
                doc.data() as Map<String, dynamic>,
                doc.id,
              ))
          .toList();
    } catch (e) {
      throw Exception('Failed to get user analyses: $e');
    }
  }

  /// Get user's analyses stream (real-time updates)
  Stream<List<AnalysisModel>> getUserAnalysesStream(String userId, {int limit = 30}) {
    try {
      return _analysesCollection
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => AnalysisModel.fromMap(
                    doc.data() as Map<String, dynamic>,
                    doc.id,
                  ))
              .toList());
    } catch (e) {
      throw Exception('Failed to stream user analyses: $e');
    }
  }

  /// Get user's high-risk analyses count
  Future<int> getUserHighRiskCount(String userId) async {
    try {
      final querySnapshot = await _analysesCollection
          .where('userId', isEqualTo: userId)
          .where('riskLevel', isEqualTo: 'high')
          .get();

      return querySnapshot.docs.length;
    } catch (e) {
      throw Exception('Failed to get high-risk count: $e');
    }
  }

  /// Delete analysis
  Future<void> deleteAnalysis(String analysisId) async {
    try {
      await _analysesCollection.doc(analysisId).delete();
    } catch (e) {
      throw Exception('Failed to delete analysis: $e');
    }
  }

  // ==================== COMMUNITY POST OPERATIONS ====================

  /// Create new community post
  Future<String> createCommunityPost(CommunityPostModel post) async {
    try {
      final docRef = await _communityPostsCollection.add(post.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create community post: $e');
    }
  }

  /// Get community post by ID
  Future<CommunityPostModel?> getCommunityPostById(String postId) async {
    try {
      final doc = await _communityPostsCollection.doc(postId).get();
      if (!doc.exists) return null;
      return CommunityPostModel.fromMap(
        doc.data() as Map<String, dynamic>,
        doc.id,
      );
    } catch (e) {
      throw Exception('Failed to get community post: $e');
    }
  }

  /// Get community posts (with optional filter by scam type)
  Future<List<CommunityPostModel>> getCommunityPosts({
    String? scamType,
    int limit = 50,
  }) async {
    try {
      Query query = _communityPostsCollection
          .orderBy('createdAt', descending: true)
          .limit(limit);

      if (scamType != null && scamType != 'all') {
        query = query.where('scamType', isEqualTo: scamType);
      }

      final querySnapshot = await query.get();

      return querySnapshot.docs
          .map((doc) => CommunityPostModel.fromMap(
                doc.data() as Map<String, dynamic>,
                doc.id,
              ))
          .toList();
    } catch (e) {
      throw Exception('Failed to get community posts: $e');
    }
  }

  /// Get community posts stream (real-time updates)
  Stream<List<CommunityPostModel>> getCommunityPostsStream({
    String? scamType,
    int limit = 50,
  }) {
    try {
      Query query = _communityPostsCollection
          .orderBy('createdAt', descending: true)
          .limit(limit);

      if (scamType != null && scamType != 'all') {
        query = query.where('scamType', isEqualTo: scamType);
      }

      return query.snapshots().map((snapshot) => snapshot.docs
          .map((doc) => CommunityPostModel.fromMap(
                doc.data() as Map<String, dynamic>,
                doc.id,
              ))
          .toList());
    } catch (e) {
      throw Exception('Failed to stream community posts: $e');
    }
  }

  /// Vote on community post
  Future<void> voteOnPost({
    required String postId,
    required String userId,
    required String voteType, // 'up' or 'down'
  }) async {
    try {
      final postRef = _communityPostsCollection.doc(postId);
      
      await _firestore.runTransaction((transaction) async {
        final postDoc = await transaction.get(postRef);
        
        if (!postDoc.exists) {
          throw Exception('Post not found');
        }

        final data = postDoc.data() as Map<String, dynamic>;
        final voters = Map<String, String>.from(data['voters'] as Map? ?? {});
        final currentVote = voters[userId];

        int upvotes = data['upvotes'] as int? ?? 0;
        int downvotes = data['downvotes'] as int? ?? 0;

        // Remove previous vote if exists
        if (currentVote == 'up') {
          upvotes--;
        } else if (currentVote == 'down') {
          downvotes--;
        }

        // Add new vote if different from previous
        if (currentVote != voteType) {
          if (voteType == 'up') {
            upvotes++;
            voters[userId] = 'up';
          } else if (voteType == 'down') {
            downvotes++;
            voters[userId] = 'down';
          }
        } else {
          // Remove vote if same as previous (toggle off)
          voters.remove(userId);
        }

        final netVotes = upvotes - downvotes;

        transaction.update(postRef, {
          'upvotes': upvotes,
          'downvotes': downvotes,
          'netVotes': netVotes,
          'voters': voters,
        });
      });
    } catch (e) {
      throw Exception('Failed to vote on post: $e');
    }
  }

  /// Report community post
  Future<void> reportPost(String postId) async {
    try {
      await _communityPostsCollection.doc(postId).update({
        'reported': true,
        'reportCount': FieldValue.increment(1),
      });
    } catch (e) {
      throw Exception('Failed to report post: $e');
    }
  }

  /// Delete community post
  Future<void> deleteCommunityPost(String postId) async {
    try {
      await _communityPostsCollection.doc(postId).delete();
    } catch (e) {
      throw Exception('Failed to delete community post: $e');
    }
  }

  // ==================== EDUCATION CONTENT OPERATIONS ====================

  /// Get all education content
  Future<List<Map<String, dynamic>>> getEducationContent() async {
    try {
      final querySnapshot = await _educationContentCollection.get();
      return querySnapshot.docs
          .map((doc) => {
                'id': doc.id,
                ...doc.data() as Map<String, dynamic>,
              })
          .toList();
    } catch (e) {
      throw Exception('Failed to get education content: $e');
    }
  }

  /// Get education content by scam type
  Future<Map<String, dynamic>?> getEducationContentByType(String scamType) async {
    try {
      final doc = await _educationContentCollection.doc(scamType).get();
      if (!doc.exists) return null;
      return {
        'id': doc.id,
        ...doc.data() as Map<String, dynamic>,
      };
    } catch (e) {
      throw Exception('Failed to get education content: $e');
    }
  }

  /// Create or update education content (admin only)
  Future<void> createOrUpdateEducationContent({
    required String scamType,
    required Map<String, dynamic> content,
  }) async {
    try {
      await _educationContentCollection.doc(scamType).set(content, SetOptions(merge: true));
    } catch (e) {
      throw Exception('Failed to create/update education content: $e');
    }
  }

  // ==================== STATISTICS ====================

  /// Get total analyses count
  Future<int> getTotalAnalysesCount() async {
    try {
      final querySnapshot = await _analysesCollection.count().get();
      return querySnapshot.count ?? 0;
    } catch (e) {
      throw Exception('Failed to get total analyses count: $e');
    }
  }

  /// Get total community posts count
  Future<int> getTotalCommunityPostsCount() async {
    try {
      final querySnapshot = await _communityPostsCollection.count().get();
      return querySnapshot.count ?? 0;
    } catch (e) {
      throw Exception('Failed to get total community posts count: $e');
    }
  }

  /// Get total users count
  Future<int> getTotalUsersCount() async {
    try {
      final querySnapshot = await _usersCollection.count().get();
      return querySnapshot.count ?? 0;
    } catch (e) {
      throw Exception('Failed to get total users count: $e');
    }
  }

  // ==================== PODCAST OPERATIONS ====================

  /// Create new podcast
  Future<String> createPodcast(PodcastModel podcast) async {
    try {
      final docRef = await _podcastsCollection.add(podcast.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create podcast: $e');
    }
  }

  /// Get podcast by ID
  Future<PodcastModel?> getPodcastById(String podcastId) async {
    try {
      final doc = await _podcastsCollection.doc(podcastId).get();
      if (!doc.exists) return null;
      return PodcastModel.fromMap(
        doc.data() as Map<String, dynamic>,
        doc.id,
      );
    } catch (e) {
      throw Exception('Failed to get podcast: $e');
    }
  }

  /// Get podcast by date (daily podcast)
  Future<PodcastModel?> getPodcastByDate(DateTime date) async {
    try {
      // Normalize date to start of day
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final querySnapshot = await _podcastsCollection
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('date', isLessThan: Timestamp.fromDate(endOfDay))
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) return null;

      final doc = querySnapshot.docs.first;
      return PodcastModel.fromMap(
        doc.data() as Map<String, dynamic>,
        doc.id,
      );
    } catch (e) {
      throw Exception('Failed to get podcast by date: $e');
    }
  }

  /// Get recent podcasts (last N days)
  Future<List<PodcastModel>> getRecentPodcasts({int limit = 7}) async {
    try {
      final querySnapshot = await _podcastsCollection
          .orderBy('date', descending: true)
          .limit(limit)
          .get();

      return querySnapshot.docs
          .map((doc) => PodcastModel.fromMap(
                doc.data() as Map<String, dynamic>,
                doc.id,
              ))
          .toList();
    } catch (e) {
      throw Exception('Failed to get recent podcasts: $e');
    }
  }

  /// Get podcasts stream (real-time updates)
  Stream<List<PodcastModel>> getPodcastsStream({int limit = 7}) {
    try {
      return _podcastsCollection
          .orderBy('date', descending: true)
          .limit(limit)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => PodcastModel.fromMap(
                    doc.data() as Map<String, dynamic>,
                    doc.id,
                  ))
              .toList());
    } catch (e) {
      throw Exception('Failed to stream podcasts: $e');
    }
  }

  /// Update podcast
  Future<void> updatePodcast(String podcastId, Map<String, dynamic> updates) async {
    try {
      await _podcastsCollection.doc(podcastId).update(updates);
    } catch (e) {
      throw Exception('Failed to update podcast: $e');
    }
  }

  /// Delete podcast
  Future<void> deletePodcast(String podcastId) async {
    try {
      await _podcastsCollection.doc(podcastId).delete();
    } catch (e) {
      throw Exception('Failed to delete podcast: $e');
    }
  }

  /// Get community posts for a specific date range (for podcast generation)
  Future<List<CommunityPostModel>> getCommunityPostsByDateRange({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final querySnapshot = await _communityPostsCollection
          .where('createdAt', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where('createdAt', isLessThan: Timestamp.fromDate(endDate))
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => CommunityPostModel.fromMap(
                doc.data() as Map<String, dynamic>,
                doc.id,
              ))
          .toList();
    } catch (e) {
      throw Exception('Failed to get community posts by date range: $e');
    }
  }
}
