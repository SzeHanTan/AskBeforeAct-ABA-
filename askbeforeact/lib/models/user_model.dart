import 'package:cloud_firestore/cloud_firestore.dart';

/// User data model
class UserModel {
  final String id;
  final String email;
  final String displayName;
  final DateTime createdAt;
  final int analysisCount;
  final bool isAnonymous;

  UserModel({
    required this.id,
    required this.email,
    required this.displayName,
    required this.createdAt,
    this.analysisCount = 0,
    this.isAnonymous = false,
  });

  /// Create UserModel from Firestore document
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      email: map['email'] as String,
      displayName: map['displayName'] as String,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      analysisCount: map['analysisCount'] as int? ?? 0,
      isAnonymous: map['isAnonymous'] as bool? ?? false,
    );
  }

  /// Convert UserModel to Firestore document
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'createdAt': Timestamp.fromDate(createdAt),
      'analysisCount': analysisCount,
      'isAnonymous': isAnonymous,
    };
  }

  /// Create a copy with updated fields
  UserModel copyWith({
    String? id,
    String? email,
    String? displayName,
    DateTime? createdAt,
    int? analysisCount,
    bool? isAnonymous,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      createdAt: createdAt ?? this.createdAt,
      analysisCount: analysisCount ?? this.analysisCount,
      isAnonymous: isAnonymous ?? this.isAnonymous,
    );
  }
}
