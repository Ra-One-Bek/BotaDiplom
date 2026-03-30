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

  List<ProfessionModel> get professions =>
      recommendationData?.professions ?? [];

  String get summary => recommendationData?.summary ?? '';

  String get dominantField => recommendationData?.dominantField ?? '';

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