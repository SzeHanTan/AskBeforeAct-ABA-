import 'package:cloud_firestore/cloud_firestore.dart';

/// Analysis result model
class AnalysisModel {
  final String id;
  final String userId;
  final String type; // 'screenshot' | 'text' | 'url'
  final String content;
  final int riskScore;
  final String riskLevel; // 'low' | 'medium' | 'high'
  final String scamType;
  final List<String> redFlags;
  final List<String> recommendations;
  final String confidence; // 'low' | 'medium' | 'high'
  final DateTime createdAt;

  AnalysisModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.content,
    required this.riskScore,
    required this.riskLevel,
    required this.scamType,
    required this.redFlags,
    required this.recommendations,
    required this.confidence,
    required this.createdAt,
  });

  /// Create AnalysisModel from Firestore document
  factory AnalysisModel.fromMap(Map<String, dynamic> map, String id) {
    return AnalysisModel(
      id: id,
      userId: map['userId'] as String,
      type: map['type'] as String,
      content: map['content'] as String,
      riskScore: map['riskScore'] as int,
      riskLevel: map['riskLevel'] as String,
      scamType: map['scamType'] as String,
      redFlags: List<String>.from(map['redFlags'] as List),
      recommendations: List<String>.from(map['recommendations'] as List),
      confidence: map['confidence'] as String,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  /// Convert AnalysisModel to Firestore document
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'type': type,
      'content': content,
      'riskScore': riskScore,
      'riskLevel': riskLevel,
      'scamType': scamType,
      'redFlags': redFlags,
      'recommendations': recommendations,
      'confidence': confidence,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  /// Create a copy with updated fields
  AnalysisModel copyWith({
    String? id,
    String? userId,
    String? type,
    String? content,
    int? riskScore,
    String? riskLevel,
    String? scamType,
    List<String>? redFlags,
    List<String>? recommendations,
    String? confidence,
    DateTime? createdAt,
  }) {
    return AnalysisModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      content: content ?? this.content,
      riskScore: riskScore ?? this.riskScore,
      riskLevel: riskLevel ?? this.riskLevel,
      scamType: scamType ?? this.scamType,
      redFlags: redFlags ?? this.redFlags,
      recommendations: recommendations ?? this.recommendations,
      confidence: confidence ?? this.confidence,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
