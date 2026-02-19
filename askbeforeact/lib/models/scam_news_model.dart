import 'package:cloud_firestore/cloud_firestore.dart';

/// Model for scam news articles fetched from Google News
class ScamNewsModel {
  final String id;
  final String title;
  final String link;
  final DateTime pubDate;
  final String contentSnippet;
  final String source;
  final DateTime createdAt;
  final DateTime updatedAt;

  ScamNewsModel({
    required this.id,
    required this.title,
    required this.link,
    required this.pubDate,
    required this.contentSnippet,
    required this.source,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create from Firestore document
  factory ScamNewsModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    return ScamNewsModel(
      id: doc.id,
      title: data['title'] as String? ?? '',
      link: data['link'] as String? ?? '',
      pubDate: (data['pubDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      contentSnippet: data['contentSnippet'] as String? ?? '',
      source: data['source'] as String? ?? 'Google News',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  /// Create from JSON
  factory ScamNewsModel.fromJson(Map<String, dynamic> json) {
    return ScamNewsModel(
      id: json['id'] as String,
      title: json['title'] as String,
      link: json['link'] as String,
      pubDate: json['pubDate'] is Timestamp 
          ? (json['pubDate'] as Timestamp).toDate()
          : DateTime.parse(json['pubDate'] as String),
      contentSnippet: json['contentSnippet'] as String,
      source: json['source'] as String,
      createdAt: json['createdAt'] is Timestamp
          ? (json['createdAt'] as Timestamp).toDate()
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] is Timestamp
          ? (json['updatedAt'] as Timestamp).toDate()
          : DateTime.parse(json['updatedAt'] as String),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'link': link,
      'pubDate': Timestamp.fromDate(pubDate),
      'contentSnippet': contentSnippet,
      'source': source,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  /// Get formatted date string
  String get formattedDate {
    final now = DateTime.now();
    final difference = now.difference(pubDate);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes} minutes ago';
      }
      return '${difference.inHours} hours ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${pubDate.day}/${pubDate.month}/${pubDate.year}';
    }
  }
}
