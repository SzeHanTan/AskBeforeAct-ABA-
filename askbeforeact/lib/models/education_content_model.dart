/// Education content model
class EducationContentModel {
  final String id;
  final String title;
  final String description;
  final String icon;
  final List<String> warningSigns;
  final List<String> preventionTips;
  final String example;
  final int order;

  EducationContentModel({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.warningSigns,
    required this.preventionTips,
    required this.example,
    required this.order,
  });

  /// Create from JSON
  factory EducationContentModel.fromJson(Map<String, dynamic> json) {
    return EducationContentModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String,
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
      'icon': icon,
      'warningSigns': warningSigns,
      'preventionTips': preventionTips,
      'example': example,
      'order': order,
    };
  }
}
