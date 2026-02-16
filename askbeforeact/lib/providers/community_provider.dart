import 'package:flutter/foundation.dart';
import '../models/community_post_model.dart';
import '../models/podcast_model.dart';
import '../repositories/community_repository.dart';

/// Community state provider
class CommunityProvider extends ChangeNotifier {
  final CommunityRepository _communityRepository;

  CommunityProvider({required CommunityRepository communityRepository})
      : _communityRepository = communityRepository;

  // State
  List<CommunityPostModel> _posts = [];
  String _selectedScamType = 'all';
  bool _isLoading = false;
  bool _isPosting = false;
  String? _error;
  
  // Podcast state
  PodcastModel? _todaysPodcast;
  List<PodcastModel> _recentPodcasts = [];
  bool _isPodcastLoading = false;
  bool _isGeneratingPodcast = false;
  String? _podcastError;
  String _selectedDateRange = 'today'; // today, 3days, week, month

  // Getters
  List<CommunityPostModel> get posts => _posts;
  String get selectedScamType => _selectedScamType;
  bool get isLoading => _isLoading;
  bool get isPosting => _isPosting;
  String? get error => _error;
  
  // Podcast getters
  PodcastModel? get todaysPodcast => _todaysPodcast;
  List<PodcastModel> get recentPodcasts => _recentPodcasts;
  bool get isPodcastLoading => _isPodcastLoading;
  bool get isGeneratingPodcast => _isGeneratingPodcast;
  String? get podcastError => _podcastError;
  String get selectedDateRange => _selectedDateRange;

  /// Load community posts
  Future<void> loadPosts({String? scamType, int limit = 50}) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _posts = await _communityRepository.getPosts(
        scamType: scamType,
        limit: limit,
      );

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Create new post
  Future<bool> createPost({
    required String userId,
    required String userName,
    required bool isAnonymous,
    required String scamType,
    required String content,
  }) async {
    try {
      _isPosting = true;
      _error = null;
      notifyListeners();

      await _communityRepository.createPost(
        userId: userId,
        userName: userName,
        isAnonymous: isAnonymous,
        scamType: scamType,
        content: content,
      );

      // Reload posts to include the new one
      await loadPosts(scamType: _selectedScamType);

      _isPosting = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _isPosting = false;
      notifyListeners();
      return false;
    }
  }

  /// Upvote a post
  Future<void> upvotePost({
    required String postId,
    required String userId,
  }) async {
    try {
      await _communityRepository.upvotePost(
        postId: postId,
        userId: userId,
      );

      // Update local post
      final postIndex = _posts.indexWhere((p) => p.id == postId);
      if (postIndex != -1) {
        final post = _posts[postIndex];
        final currentVote = post.voters[userId];
        
        int upvotes = post.upvotes;
        int downvotes = post.downvotes;
        final voters = Map<String, String>.from(post.voters);

        // Remove previous vote
        if (currentVote == 'up') {
          upvotes--;
          voters.remove(userId);
        } else if (currentVote == 'down') {
          downvotes--;
          upvotes++;
          voters[userId] = 'up';
        } else {
          upvotes++;
          voters[userId] = 'up';
        }

        _posts[postIndex] = CommunityPostModel(
          id: post.id,
          userId: post.userId,
          userName: post.userName,
          isAnonymous: post.isAnonymous,
          scamType: post.scamType,
          content: post.content,
          upvotes: upvotes,
          downvotes: downvotes,
          netVotes: upvotes - downvotes,
          voters: voters,
          reported: post.reported,
          reportCount: post.reportCount,
          createdAt: post.createdAt,
        );

        notifyListeners();
      }
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
    }
  }

  /// Downvote a post
  Future<void> downvotePost({
    required String postId,
    required String userId,
  }) async {
    try {
      await _communityRepository.downvotePost(
        postId: postId,
        userId: userId,
      );

      // Update local post
      final postIndex = _posts.indexWhere((p) => p.id == postId);
      if (postIndex != -1) {
        final post = _posts[postIndex];
        final currentVote = post.voters[userId];
        
        int upvotes = post.upvotes;
        int downvotes = post.downvotes;
        final voters = Map<String, String>.from(post.voters);

        // Remove previous vote
        if (currentVote == 'down') {
          downvotes--;
          voters.remove(userId);
        } else if (currentVote == 'up') {
          upvotes--;
          downvotes++;
          voters[userId] = 'down';
        } else {
          downvotes++;
          voters[userId] = 'down';
        }

        _posts[postIndex] = CommunityPostModel(
          id: post.id,
          userId: post.userId,
          userName: post.userName,
          isAnonymous: post.isAnonymous,
          scamType: post.scamType,
          content: post.content,
          upvotes: upvotes,
          downvotes: downvotes,
          netVotes: upvotes - downvotes,
          voters: voters,
          reported: post.reported,
          reportCount: post.reportCount,
          createdAt: post.createdAt,
        );

        notifyListeners();
      }
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
    }
  }

  /// Report a post
  Future<bool> reportPost(String postId) async {
    try {
      await _communityRepository.reportPost(postId);
      
      // Update local post
      final postIndex = _posts.indexWhere((p) => p.id == postId);
      if (postIndex != -1) {
        final post = _posts[postIndex];
        _posts[postIndex] = CommunityPostModel(
          id: post.id,
          userId: post.userId,
          userName: post.userName,
          isAnonymous: post.isAnonymous,
          scamType: post.scamType,
          content: post.content,
          upvotes: post.upvotes,
          downvotes: post.downvotes,
          netVotes: post.netVotes,
          voters: post.voters,
          reported: true,
          reportCount: post.reportCount + 1,
          createdAt: post.createdAt,
        );
        notifyListeners();
      }
      
      return true;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  /// Delete a post
  Future<bool> deletePost(String postId) async {
    try {
      await _communityRepository.deletePost(postId);
      
      // Remove from local list
      _posts.removeWhere((post) => post.id == postId);
      notifyListeners();
      
      return true;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  /// Filter posts by scam type
  void filterByScamType(String scamType) {
    _selectedScamType = scamType;
    loadPosts(scamType: scamType);
  }

  /// Get scam type filters
  List<Map<String, String>> getScamTypeFilters() {
    return _communityRepository.getScamTypeFilters();
  }

  /// Get user's vote on a post
  String? getUserVote(CommunityPostModel post, String userId) {
    return _communityRepository.getUserVote(post, userId);
  }

  /// Check if user has voted on a post
  bool hasUserVoted(CommunityPostModel post, String userId) {
    return _communityRepository.hasUserVoted(post, userId);
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Clear all data
  void clear() {
    _posts = [];
    _selectedScamType = 'all';
    _error = null;
    _todaysPodcast = null;
    _recentPodcasts = [];
    _podcastError = null;
    notifyListeners();
  }

  // ==================== PODCAST OPERATIONS ====================

  /// Load today's podcast
  Future<void> loadTodaysPodcast({bool forceRegenerate = false}) async {
    try {
      _isPodcastLoading = true;
      _podcastError = null;
      notifyListeners();

      _todaysPodcast = await _communityRepository.getTodaysPodcast(
        forceRegenerate: forceRegenerate,
      );

      _isPodcastLoading = false;
      notifyListeners();
    } catch (e) {
      _podcastError = e.toString().replaceAll('Exception: ', '');
      _isPodcastLoading = false;
      notifyListeners();
    }
  }

  /// Generate daily podcast manually
  Future<bool> generateDailyPodcast({DateTime? date}) async {
    try {
      _isGeneratingPodcast = true;
      _podcastError = null;
      notifyListeners();

      final podcast = await _communityRepository.generateDailyPodcast(
        date: date ?? DateTime.now(),
      );

      // Update today's podcast if it's for today
      final today = DateTime.now();
      final podcastDate = podcast.date;
      if (podcastDate.year == today.year &&
          podcastDate.month == today.month &&
          podcastDate.day == today.day) {
        _todaysPodcast = podcast;
      }

      // Reload recent podcasts
      await loadRecentPodcasts();

      _isGeneratingPodcast = false;
      notifyListeners();
      return true;
    } catch (e) {
      _podcastError = e.toString().replaceAll('Exception: ', '');
      _isGeneratingPodcast = false;
      notifyListeners();
      return false;
    }
  }

  /// Load recent podcasts (last 7 days)
  Future<void> loadRecentPodcasts({int limit = 7}) async {
    try {
      _isPodcastLoading = true;
      _podcastError = null;
      notifyListeners();

      _recentPodcasts = await _communityRepository.getRecentPodcasts(
        limit: limit,
      );

      _isPodcastLoading = false;
      notifyListeners();
    } catch (e) {
      _podcastError = e.toString().replaceAll('Exception: ', '');
      _isPodcastLoading = false;
      notifyListeners();
    }
  }

  /// Get podcast by date
  Future<PodcastModel?> getPodcastByDate(DateTime date) async {
    try {
      return await _communityRepository.getPodcastByDate(date);
    } catch (e) {
      _podcastError = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return null;
    }
  }

  /// Clear podcast error
  void clearPodcastError() {
    _podcastError = null;
    notifyListeners();
  }

  /// Generate podcast with custom date range
  Future<void> generatePodcastWithDateRange(String dateRange) async {
    try {
      _isGeneratingPodcast = true;
      _podcastError = null;
      _selectedDateRange = dateRange;
      notifyListeners();

      final now = DateTime.now();
      DateTime startDate;
      DateTime endDate = now;
      String dateRangeLabel;

      switch (dateRange) {
        case 'today':
          startDate = DateTime(now.year, now.month, now.day);
          endDate = startDate.add(const Duration(days: 1));
          dateRangeLabel = 'Today';
          break;
        case '3days':
          startDate = DateTime(now.year, now.month, now.day).subtract(const Duration(days: 2));
          endDate = DateTime(now.year, now.month, now.day).add(const Duration(days: 1));
          dateRangeLabel = 'Last 3 Days';
          break;
        case 'week':
          startDate = DateTime(now.year, now.month, now.day).subtract(const Duration(days: 6));
          endDate = DateTime(now.year, now.month, now.day).add(const Duration(days: 1));
          dateRangeLabel = 'Last Week';
          break;
        case 'month':
          startDate = DateTime(now.year, now.month - 1, now.day);
          endDate = DateTime(now.year, now.month, now.day).add(const Duration(days: 1));
          dateRangeLabel = 'Last Month';
          break;
        default:
          startDate = DateTime(now.year, now.month, now.day);
          endDate = startDate.add(const Duration(days: 1));
          dateRangeLabel = 'Today';
      }

      final podcast = await _communityRepository.generatePodcastWithDateRange(
        startDate: startDate,
        endDate: endDate,
        dateRangeLabel: dateRangeLabel,
      );

      _todaysPodcast = podcast;
      _isGeneratingPodcast = false;
      notifyListeners();
    } catch (e) {
      _podcastError = e.toString().replaceAll('Exception: ', '');
      _isGeneratingPodcast = false;
      notifyListeners();
    }
  }

  /// Change date range selection
  void changeDateRange(String dateRange) {
    if (_selectedDateRange != dateRange) {
      generatePodcastWithDateRange(dateRange);
    }
  }
}
