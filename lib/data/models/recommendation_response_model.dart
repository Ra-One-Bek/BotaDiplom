import 'profession_model.dart';

class HybridRecommendationModel {
  final String finalDirection;
  final String source;
  final String ruleBasedDirection;
  final String mlPredictedDirection;
  final double mlConfidence;
  final Map<String, dynamic> mlProbabilities;
  final String modelVersion;

  HybridRecommendationModel({
    required this.finalDirection,
    required this.source,
    required this.ruleBasedDirection,
    required this.mlPredictedDirection,
    required this.mlConfidence,
    required this.mlProbabilities,
    required this.modelVersion,
  });

  factory HybridRecommendationModel.fromJson(Map json) {
    return HybridRecommendationModel(
      finalDirection: json['finalDirection'] ?? '',
      source: json['source'] ?? '',
      ruleBasedDirection: json['ruleBasedDirection'] ?? '',
      mlPredictedDirection: json['mlPredictedDirection'] ?? '',
      mlConfidence: (json['mlConfidence'] ?? 0).toDouble(),
      mlProbabilities: Map<String, dynamic>.from(json['mlProbabilities'] ?? {}),
      modelVersion: json['modelVersion'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'finalDirection': finalDirection,
      'source': source,
      'ruleBasedDirection': ruleBasedDirection,
      'mlPredictedDirection': mlPredictedDirection,
      'mlConfidence': mlConfidence,
      'mlProbabilities': mlProbabilities,
      'modelVersion': modelVersion,
    };
  }
}

class ExplanationModel {
  final String title;
  final String summary;

  ExplanationModel({
    required this.title,
    required this.summary,
  });

  factory ExplanationModel.fromJson(Map json) {
    return ExplanationModel(
      title: json['title'] ?? '',
      summary: json['summary'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'summary': summary,
    };
  }
}

class RecommendationResponseModel {
  final Map<String, dynamic> profile;
  final ProfessionModel? topProfession;
  final List<ProfessionModel> alternatives;
  final HybridRecommendationModel hybridRecommendation;
  final ExplanationModel explanation;

  RecommendationResponseModel({
    required this.profile,
    required this.topProfession,
    required this.alternatives,
    required this.hybridRecommendation,
    required this.explanation,
  });

  factory RecommendationResponseModel.fromJson(Map json) {
    return RecommendationResponseModel(
      profile: Map<String, dynamic>.from(json['profile'] ?? {}),
      topProfession: json['topProfession'] != null
          ? ProfessionModel.fromJson(json['topProfession'])
          : null,
      alternatives: (json['alternatives'] as List? ?? [])
          .map((e) => ProfessionModel.fromJson(e))
          .toList(),
      hybridRecommendation: HybridRecommendationModel.fromJson(
        json['hybridRecommendation'] ?? {},
      ),
      explanation: ExplanationModel.fromJson(json['explanation'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'profile': profile,
      'topProfession': topProfession?.toJson(),
      'alternatives': alternatives.map((e) => e.toJson()).toList(),
      'hybridRecommendation': hybridRecommendation.toJson(),
      'explanation': explanation.toJson(),
    };
  }
}