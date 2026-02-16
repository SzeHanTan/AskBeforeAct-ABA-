import 'package:cloud_firestore/cloud_firestore.dart';

/// Daily podcast summary model
class PodcastModel {
  final String id;
  final DateTime date; // Date of the podcast (daily)
  final String title;
  final String script; // AI-generated podcast script
  final int postCount; // Number of posts summarized
  final List<String> topScamTypes; // Top scam types discussed
  final List<String> keyInsights; // Key insights from the day
  final String duration; // Estimated duration (e.g., "2 minutes")
  final DateTime createdAt;
  final bool isGenerated; // Whether the podcast has been generated

  PodcastModel({
    required this.id,
    required this.date,
    required this.title,
    required this.script,
    required this.postCount,
    required this.topScamTypes,
    required this.keyInsights,
    required this.duration,
    required this.createdAt,
    this.isGenerated = true,
  });

  /// Create from Firestore document
  factory PodcastModel.fromMap(Map<String, dynamic> map, String id) {
    return PodcastModel(
      id: id,
      date: (map['date'] as Timestamp).toDate(),
      title: map['title'] as String,
      script: map['script'] as String,
      postCount: map['postCount'] as int? ?? 0,
      topScamTypes: List<String>.from(map['topScamTypes'] as List? ?? []),
      keyInsights: List<String>.from(map['keyInsights'] as List? ?? []),
      duration: map['duration'] as String? ?? '2 minutes',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      isGenerated: map['isGenerated'] as bool? ?? true,
    );
  }

  /// Convert to Firestore document
  Map<String, dynamic> toMap() {
    return {
      'date': Timestamp.fromDate(date),
      'title': title,
      'script': script,
      'postCount': postCount,
      'topScamTypes': topScamTypes,
      'keyInsights': keyInsights,
      'duration': duration,
      'createdAt': Timestamp.fromDate(createdAt),
      'isGenerated': isGenerated,
    };
  }

  /// Copy with method for updates
  PodcastModel copyWith({
    String? id,
    DateTime? date,
    String? title,
    String? script,
    int? postCount,
    List<String>? topScamTypes,
    List<String>? keyInsights,
    String? duration,
    DateTime? createdAt,
    bool? isGenerated,
  }) {
    return PodcastModel(
      id: id ?? this.id,
      date: date ?? this.date,
      title: title ?? this.title,
      script: script ?? this.script,
      postCount: postCount ?? this.postCount,
      topScamTypes: topScamTypes ?? this.topScamTypes,
      keyInsights: keyInsights ?? this.keyInsights,
      duration: duration ?? this.duration,
      createdAt: createdAt ?? this.createdAt,
      isGenerated: isGenerated ?? this.isGenerated,
    );
  }
}
