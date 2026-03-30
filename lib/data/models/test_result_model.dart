import 'profession_model.dart';

class TestResultModel {
  final int id;
  final int userId;
  final String summary;
  final List<ProfessionModel> recommendedProfessions;

  TestResultModel({
    required this.id,
    required this.userId,
    required this.summary,
    required this.recommendedProfessions,
  });

  factory TestResultModel.fromJson(Map<String, dynamic> json) {
    return TestResultModel(
      id: json['id'],
      userId: json['userId'],
      summary: json['summary'] ?? '',
      recommendedProfessions: (json['recommendedProfessions'] as List<dynamic>? ?? [])
          .map((e) => ProfessionModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'summary': summary,
      'recommendedProfessions':
          recommendedProfessions.map((e) => e.toJson()).toList(),
    };
  }
}