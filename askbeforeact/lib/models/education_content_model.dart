import 'package:cloud_firestore/cloud_firestore.dart';

/// Education content model
class EducationContentModel {
  final String id;
  final String title;
  final String description;
  final List<String> warningSigns;
  final List<String> preventionTips;
  final String example;
  final int order;

  EducationContentModel({
    required this.id,
    required this.title,
    required this.description,
    required this.warningSigns,
    required this.preventionTips,
    required this.example,
    required this.order,
  });

  /// Create from Firestore document
  factory EducationContentModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    return EducationContentModel(
      id: doc.id,
      title: data['title'] as String? ?? '',
      description: data['description'] as String? ?? '',
      warningSigns: List<String>.from(data['warningSigns'] as List? ?? []),
      preventionTips: List<String>.from(data['preventionTips'] as List? ?? []),
      example: data['example'] as String? ?? '',
      order: data['order'] as int? ?? 0,
    );
  }

  /// Create from JSON
  factory EducationContentModel.fromJson(Map<String, dynamic> json) {
    return EducationContentModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      warningSigns: List<String>.from(json['warningSigns'] as List),
      preventionTips: List<String>.from(json['preventionTips'] as List),
      example: json['example'] as String,
      order: json['order'] as int,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'warningSigns': warningSigns,
      'preventionTips': preventionTips,
      'example': example,
      'order': order,
    };
  }

  /// Get icon emoji based on content type
  String get icon {
    switch (id) {
      case 'phishing':
        return '🎣';
      case 'romance':
        return '💔';
      case 'payment':
        return '💳';
      case 'job':
        return '💼';
      case 'tech_support':
        return '🔧';
      default:
        return '⚠️';
    }
  }

  /// Get color based on content type
  int get colorValue {
    switch (id) {
      case 'phishing':
        return 0xFF3B82F6; // Blue
      case 'romance':
        return 0xFFEC4899; // Pink
      case 'payment':
        return 0xFF10B981; // Green
      case 'job':
        return 0xFFF59E0B; // Orange
      case 'tech_support':
        return 0xFF8B5CF6; // Purple
      default:
        return 0xFF64748B; // Gray
    }
  }
}
