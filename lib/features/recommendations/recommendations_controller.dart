import 'package:flutter/material.dart';
import 'package:career_guidance_app/data/models/profession_model.dart';
import 'package:career_guidance_app/data/models/recommendation_response_model.dart';
import 'package:career_guidance_app/data/repositories/recommendations_repository.dart';
import 'package:career_guidance_app/features/auth/auth_controller.dart';

class RecommendationsController extends ChangeNotifier {
  final RecommendationsRepository _repository = RecommendationsRepository();

  bool isLoading = false;
  String? errorMessage;
  RecommendationResponseModel? recommendationData;

  ProfessionModel? get topProfession => recommendationData?.topProfession;
  List<ProfessionModel> get alternatives =>
      recommendationData?.alternatives ?? [];
  Map<String, dynamic> get profile => recommendationData?.profile ?? {};

  String get title => recommendationData?.explanation.title ?? '';
  String get summary => recommendationData?.explanation.summary ?? '';

  String get finalDirection =>
      recommendationData?.hybridRecommendation.finalDirection ?? '';

  String get ruleBasedDirection =>
      recommendationData?.hybridRecommendation.ruleBasedDirection ?? '';

  String get mlPredictedDirection =>
      recommendationData?.hybridRecommendation.mlPredictedDirection ?? '';

  double get mlConfidence =>
      recommendationData?.hybridRecommendation.mlConfidence ?? 0;

  String get modelVersion =>
      recommendationData?.hybridRecommendation.modelVersion ?? '';

  String get source =>
      recommendationData?.hybridRecommendation.source ?? '';

  Future<void> loadRecommendations() async {
    try {
      final userId = AuthController.instance.currentUserId;
      if (userId == null) {
        throw Exception('Пользователь не авторизован');
      }

      isLoading = true;
      errorMessage = null;
      notifyListeners();

      recommendationData = await _repository.getRecommendations(userId);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}