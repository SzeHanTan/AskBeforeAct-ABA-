import '../models/community_post_model.dart';
import '../models/podcast_model.dart';
import '../services/firestore_service.dart';
import '../services/podcast_service.dart';

/// Repository for community operations
class CommunityRepository {
  final FirestoreService _firestoreService;
  final PodcastService _podcastService;

  CommunityRepository({
    required FirestoreService firestoreService,
    required PodcastService podcastService,
  })  : _firestoreService = firestoreService,
        _podcastService = podcastService;

  /// Create new community post
  Future<String> createPost({
    required String userId,
    required String userName,
    required bool isAnonymous,
    required String scamType,
    required String content,
  }) async {
    try {
      // Validate content length (max 500 chars)
      if (content.length > 500) {
        throw Exception('Post content must be 500 characters or less');
      }

      // Create post model
      final post = CommunityPostModel(
        id: '', // Will be set by Firestore
        userId: userId,
        userName: isAnonymous ? 'Anonymous' : userName,
        isAnonymous: isAnonymous,
        scamType: scamType,
        content: content,
        createdAt: DateTime.now(),
      );

      // Save to Firestore
      final postId = await _firestoreService.createCommunityPost(post);

      return postId;
    } catch (e) {
      throw Exception('Failed to create post: $e');
    }
  }

  /// Get community posts with optional filter
  Future<List<CommunityPostModel>> getPosts({
    String? scamType,
    int limit = 50,
  }) async {
    try {
      return await _firestoreService.getCommunityPosts(
        scamType: scamType,
        limit: limit,
      );
    } catch (e) {
      throw Exception('Failed to get posts: $e');
    }
  }

  /// Get community posts stream (real-time)
  Stream<List<CommunityPostModel>> getPostsStream({
    String? scamType,
    int limit = 50,
  }) {
    try {
      return _firestoreService.getCommunityPostsStream(
        scamType: scamType,
        limit: limit,
      );
    } catch (e) {
      throw Exception('Failed to stream posts: $e');
    }
  }

  /// Get post by ID
  Future<CommunityPostModel?> getPostById(String postId) async {
    try {
      return await _firestoreService.getCommunityPostById(postId);
    } catch (e) {
      throw Exception('Failed to get post: $e');
    }
  }

  /// Upvote a post
  Future<void> upvotePost({
    required String postId,
    required String userId,
  }) async {
    try {
      await _firestoreService.voteOnPost(
        postId: postId,
        userId: userId,
        voteType: 'up',
      );
    } catch (e) {
      throw Exception('Failed to upvote post: $e');
    }
  }

  /// Downvote a post
  Future<void> downvotePost({
    required String postId,
    required String userId,
  }) async {
    try {
      await _firestoreService.voteOnPost(
        postId: postId,
        userId: userId,
        voteType: 'down',
      );
    } catch (e) {
      throw Exception('Failed to downvote post: $e');
    }
  }

  /// Report a post
  Future<void> reportPost(String postId) async {
    try {
      await _firestoreService.reportPost(postId);
    } catch (e) {
      throw Exception('Failed to report post: $e');
    }
  }

  /// Delete a post (user's own post or admin)
  Future<void> deletePost(String postId) async {
    try {
      await _firestoreService.deleteCommunityPost(postId);
    } catch (e) {
      throw Exception('Failed to delete post: $e');
    }
  }

  /// Get user's vote on a post
  String? getUserVote(CommunityPostModel post, String userId) {
    return post.voters[userId];
  }

  /// Check if user has voted on a post
  bool hasUserVoted(CommunityPostModel post, String userId) {
    return post.voters.containsKey(userId);
  }

  /// Get available scam types for filtering
  List<Map<String, String>> getScamTypeFilters() {
    return [
      {'value': 'all', 'label': 'All Types'},
      {'value': 'phishing', 'label': 'Phishing'},
      {'value': 'romance', 'label': 'Romance Scams'},
      {'value': 'payment', 'label': 'Payment Fraud'},
      {'value': 'job', 'label': 'Job Scams'},
      {'value': 'tech_support', 'label': 'Tech Support'},
      {'value': 'investment', 'label': 'Investment Scams'},
      {'value': 'lottery', 'label': 'Lottery/Prize'},
      {'value': 'impersonation', 'label': 'Impersonation'},
      {'value': 'other', 'label': 'Other'},
    ];
  }

  // ==================== PODCAST OPERATIONS ====================

  /// Generate podcast for a specific date range
  Future<PodcastModel> generatePodcastWithDateRange({
    required DateTime startDate,
    required DateTime endDate,
    required String dateRangeLabel,
  }) async {
    try {
      // Get posts from the date range
      final posts = await _firestoreService.getCommunityPostsByDateRange(
        startDate: startDate,
        endDate: endDate,
      );

      // Generate podcast using AI
      final podcast = await _podcastService.generateDailyPodcast(
        posts: posts,
        date: endDate, // Use end date as the podcast date
        startDate: startDate,
        dateRangeLabel: dateRangeLabel,
      );

      // Don't save to Firestore for custom date ranges (only for daily)
      // This allows users to regenerate with different ranges

      return podcast;
    } catch (e) {
      throw Exception('Failed to generate podcast: $e');
    }
  }

  /// Generate daily podcast for a specific date
  Future<PodcastModel> generateDailyPodcast({DateTime? date}) async {
    try {
      final targetDate = date ?? DateTime.now();
      
      // Check if podcast already exists for this date
      final existingPodcast = await _firestoreService.getPodcastByDate(targetDate);
      if (existingPodcast != null) {
        return existingPodcast;
      }

      // Get posts from the target date
      final startOfDay = DateTime(targetDate.year, targetDate.month, targetDate.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));
      
      final posts = await _firestoreService.getCommunityPostsByDateRange(
        startDate: startOfDay,
        endDate: endOfDay,
      );

      // Generate podcast using AI
      final podcast = await _podcastService.generateDailyPodcast(
        posts: posts,
        date: targetDate,
      );

      // Save to Firestore
      final podcastId = await _firestoreService.createPodcast(podcast);

      return podcast.copyWith(id: podcastId);
    } catch (e) {
      throw Exception('Failed to generate daily podcast: $e');
    }
  }

  /// Get today's podcast (or generate if not exists)
  Future<PodcastModel> getTodaysPodcast({bool forceRegenerate = false}) async {
    try {
      final today = DateTime.now();
      
      if (!forceRegenerate) {
        final existingPodcast = await _firestoreService.getPodcastByDate(today);
        if (existingPodcast != null) {
          return existingPodcast;
        }
      }

      // Generate new podcast
      return await generateDailyPodcast(date: today);
    } catch (e) {
      throw Exception('Failed to get today\'s podcast: $e');
    }
  }

  /// Get podcast by date
  Future<PodcastModel?> getPodcastByDate(DateTime date) async {
    try {
      return await _firestoreService.getPodcastByDate(date);
    } catch (e) {
      throw Exception('Failed to get podcast by date: $e');
    }
  }

  /// Get recent podcasts (last N days)
  Future<List<PodcastModel>> getRecentPodcasts({int limit = 7}) async {
    try {
      return await _firestoreService.getRecentPodcasts(limit: limit);
    } catch (e) {
      throw Exception('Failed to get recent podcasts: $e');
    }
  }

  /// Get podcasts stream (real-time updates)
  Stream<List<PodcastModel>> getPodcastsStream({int limit = 7}) {
    try {
      return _firestoreService.getPodcastsStream(limit: limit);
    } catch (e) {
      throw Exception('Failed to stream podcasts: $e');
    }
  }

  /// Delete podcast (admin only)
  Future<void> deletePodcast(String podcastId) async {
    try {
      await _firestoreService.deletePodcast(podcastId);
    } catch (e) {
      throw Exception('Failed to delete podcast: $e');
    }
  }
}
