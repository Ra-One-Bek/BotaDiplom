import 'package:career_guidance_app/core/services/api_service.dart';
import 'package:career_guidance_app/data/models/recommendation_response_model.dart';

class RecommendationsRepository {
  final ApiService _apiService = ApiService();

  Future<RecommendationResponseModel> getRecommendations(int userId) async {
    final response = await _apiService.getRequest('/recommendations/$userId');
    return RecommendationResponseModel.fromJson(response);
  }
}