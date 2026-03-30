import 'profession_model.dart';

class RecommendationResponseModel {
  final String dominantField;
  final String summary;
  final List<ProfessionModel> professions;

  RecommendationResponseModel({
    required this.dominantField,
    required this.summary,
    required this.professions,
  });

  factory RecommendationResponseModel.fromJson(Map<String, dynamic> json) {
    return RecommendationResponseModel(
      dominantField: json['dominantField'] ?? '',
      summary: json['summary'] ?? '',
      professions: (json['professions'] as List<dynamic>? ?? [])
          .map((e) => ProfessionModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dominantField': dominantField,
      'summary': summary,
      'professions': professions.map((e) => e.toJson()).toList(),
    };
  }
}