import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../core/config/env_config.dart';
import '../models/community_post_model.dart';
import '../models/podcast_model.dart';

/// Service for generating AI-powered podcast summaries
class PodcastService {
  late final GenerativeModel _model;

  PodcastService() {
    // Use Gemini 2.5 Flash for podcast generation
    _model = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: EnvConfig.geminiApiKey,
      generationConfig: GenerationConfig(
        temperature: 0.7, // More creative for podcast scripts
        topK: 40,
        topP: 0.95,
        maxOutputTokens: 4096, // Longer output for podcast scripts
      ),
    );
  }

  /// Generate podcast summary from community posts with custom date range
  Future<PodcastModel> generateDailyPodcast({
    required List<CommunityPostModel> posts,
    required DateTime date,
    DateTime? startDate,
    String? dateRangeLabel,
  }) async {
    try {
      if (posts.isEmpty) {
        return _createEmptyPodcast(date, dateRangeLabel: dateRangeLabel);
      }

      // Prepare posts summary for AI
      final postsSummary = _preparePostsSummary(posts);
      
      // Generate podcast script using Gemini
      final podcastData = await _generatePodcastScript(postsSummary, posts.length, dateRangeLabel);

      // Create title with date range if provided
      String finalTitle = podcastData['title'] as String;
      if (dateRangeLabel != null) {
        finalTitle = '$finalTitle ($dateRangeLabel)';
      }

      // Create podcast model
      return PodcastModel(
        id: '', // Will be set by Firestore
        date: date,
        title: finalTitle,
        script: podcastData['script'] as String,
        postCount: posts.length,
        topScamTypes: List<String>.from(podcastData['topScamTypes']),
        keyInsights: List<String>.from(podcastData['keyInsights']),
        duration: podcastData['duration'] as String,
        createdAt: DateTime.now(),
        isGenerated: true,
      );
    } catch (e) {
      throw Exception('Failed to generate podcast: $e');
    }
  }

  /// Prepare posts summary for AI processing
  String _preparePostsSummary(List<CommunityPostModel> posts) {
    final buffer = StringBuffer();
    
    // Group posts by scam type
    final Map<String, List<CommunityPostModel>> postsByType = {};
    for (final post in posts) {
      postsByType.putIfAbsent(post.scamType, () => []).add(post);
    }

    buffer.writeln('COMMUNITY POSTS SUMMARY:');
    buffer.writeln('Total Posts: ${posts.length}');
    buffer.writeln('\nPosts by Scam Type:');
    
    postsByType.forEach((scamType, typePosts) {
      buffer.writeln('\n$scamType (${typePosts.length} posts):');
      
      // Include top 3 posts per type (by net votes)
      final topPosts = typePosts
          .toList()
          ..sort((a, b) => b.netVotes.compareTo(a.netVotes));
      
      for (var i = 0; i < topPosts.length && i < 3; i++) {
        final post = topPosts[i];
        buffer.writeln('  - ${post.content.substring(0, post.content.length > 100 ? 100 : post.content.length)}...');
        buffer.writeln('    (${post.upvotes} upvotes, ${post.netVotes} net votes)');
      }
    });

    return buffer.toString();
  }

  /// Generate podcast script using Gemini AI
  Future<Map<String, dynamic>> _generatePodcastScript(
    String postsSummary,
    int postCount,
    String? dateRangeLabel,
  ) async {
    final timeContext = dateRangeLabel ?? 'today';
    final prompt = '''
You are a professional podcast host creating a fraud awareness podcast called "AskBeforeAct".
Your goal is to create an engaging, informative, and conversational 1-2 minute podcast script that summarizes community posts about scams and fraud from $timeContext.

Based on the following community posts from $timeContext:

$postsSummary

Create a podcast script that:
1. Has a catchy, welcoming opening (mention the time period: $timeContext)
2. Summarizes the key scam trends and patterns from these posts
3. Highlights the most important warnings and insights
4. Provides actionable advice for listeners
5. Has an encouraging closing that promotes community engagement
6. Is conversational and easy to listen to (not too formal)
7. Is approximately 1-2 minutes when read aloud (around 250-350 words)

Return your response as JSON with this structure:
{
  "title": "A catchy title for this episode (e.g., 'Romance Scams on the Rise: What You Need to Know')",
  "script": "The complete podcast script with natural pauses and conversational tone",
  "topScamTypes": ["scam_type1", "scam_type2", "scam_type3"],
  "keyInsights": ["insight1", "insight2", "insight3"],
  "duration": "1-2 minutes"
}

Important:
- Make the script sound natural and conversational, like a real podcast host
- Use phrases like "Today in our community...", "One user shared...", "Here's what we learned..."
- Include specific examples from the posts (anonymized)
- End with a call-to-action to share experiences in the community
- Keep it concise but informative
- Return ONLY valid JSON without any markdown formatting or code blocks
''';

    final response = await _model.generateContent([Content.text(prompt)]);
    final responseText = response.text;

    if (responseText == null || responseText.isEmpty) {
      throw Exception('Empty response from Gemini API');
    }

    // Clean the response text
    String cleanedText = responseText.trim();
    if (cleanedText.startsWith('```json')) {
      cleanedText = cleanedText.substring(7);
    } else if (cleanedText.startsWith('```')) {
      cleanedText = cleanedText.substring(3);
    }
    if (cleanedText.endsWith('```')) {
      cleanedText = cleanedText.substring(0, cleanedText.length - 3);
    }
    cleanedText = cleanedText.trim();

    final jsonResponse = jsonDecode(cleanedText);
    return _validatePodcastResponse(jsonResponse);
  }

  /// Validate and normalize podcast response
  Map<String, dynamic> _validatePodcastResponse(Map<String, dynamic> response) {
    return {
      'title': response['title'] as String? ?? 'Daily Fraud Awareness Update',
      'script': response['script'] as String? ?? 'No posts available for today.',
      'topScamTypes': (response['topScamTypes'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          ['other'],
      'keyInsights': (response['keyInsights'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          ['Stay vigilant and verify before you trust'],
      'duration': response['duration'] as String? ?? '1-2 minutes',
    };
  }

  /// Create empty podcast for days with no posts
  PodcastModel _createEmptyPodcast(DateTime date, {String? dateRangeLabel}) {
    String title = dateRangeLabel != null 
        ? 'No Activity in $dateRangeLabel'
        : 'No Activity Today';
    
    String script = dateRangeLabel != null
        ? '''
Hello and welcome to AskBeforeAct! 

For the period of $dateRangeLabel, we have some great news - our community had zero new scam reports! 
This could mean our awareness efforts are working, or it might just be a quiet period.

Remember, even during quiet times, it's important to stay vigilant. Scammers never take a break, 
and they're always coming up with new tactics.

If you encounter anything suspicious, don't hesitate to share it with our community. 
Your experience could help protect others.

Stay safe out there, and thank you for being part of our community!
'''
        : '''
Hello and welcome to AskBeforeAct Daily! 

Today, we have some great news - our community had zero new scam reports! 
This could mean our awareness efforts are working, or it might just be a quiet day.

Remember, even on quiet days, it's important to stay vigilant. Scammers never take a day off, 
and they're always coming up with new tactics.

If you encounter anything suspicious, don't hesitate to share it with our community. 
Your experience could help protect others.

Stay safe out there, and we'll see you tomorrow with more updates!
''';

    return PodcastModel(
      id: '',
      date: date,
      title: title,
      script: script,
      postCount: 0,
      topScamTypes: [],
      keyInsights: ['No scam reports in this period', 'Stay vigilant', 'Share your experiences'],
      duration: '1 minute',
      createdAt: DateTime.now(),
      isGenerated: true,
    );
  }

  /// Get estimated reading time for script
  String estimateReadingTime(String script) {
    // Average reading speed: 150 words per minute
    final wordCount = script.split(RegExp(r'\s+')).length;
    final minutes = (wordCount / 150).ceil();
    
    if (minutes < 1) {
      return '< 1 minute';
    } else if (minutes == 1) {
      return '1 minute';
    } else {
      return '$minutes minutes';
    }
  }
}
