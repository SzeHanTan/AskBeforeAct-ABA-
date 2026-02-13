import 'package:cloud_firestore/cloud_firestore.dart';

/// Community post model
class CommunityPostModel {
  final String id;
  final String userId;
  final String userName;
  final bool isAnonymous;
  final String scamType;
  final String content;
  final int upvotes;
  final int downvotes;
  final int netVotes;
  final Map<String, String> voters; // {userId: 'up' | 'down'}
  final bool reported;
  final int reportCount;
  final DateTime createdAt;

  CommunityPostModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.isAnonymous,
    required this.scamType,
    required this.content,
    this.upvotes = 0,
    this.downvotes = 0,
    this.netVotes = 0,
    this.voters = const {},
    this.reported = false,
    this.reportCount = 0,
    required this.createdAt,
  });

  /// Create from Firestore document
  factory CommunityPostModel.fromMap(Map<String, dynamic> map, String id) {
    return CommunityPostModel(
      id: id,
      userId: map['userId'] as String,
      userName: map['userName'] as String,
      isAnonymous: map['isAnonymous'] as bool,
      scamType: map['scamType'] as String,
      content: map['content'] as String,
      upvotes: map['upvotes'] as int? ?? 0,
      downvotes: map['downvotes'] as int? ?? 0,
      netVotes: map['netVotes'] as int? ?? 0,
      voters: Map<String, String>.from(map['voters'] as Map? ?? {}),
      reported: map['reported'] as bool? ?? false,
      reportCount: map['reportCount'] as int? ?? 0,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  /// Convert to Firestore document
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'isAnonymous': isAnonymous,
      'scamType': scamType,
      'content': content,
      'upvotes': upvotes,
      'downvotes': downvotes,
      'netVotes': netVotes,
      'voters': voters,
      'reported': reported,
      'reportCount': reportCount,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
