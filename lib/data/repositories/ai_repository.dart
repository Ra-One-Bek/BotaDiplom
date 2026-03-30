import 'package:career_guidance_app/core/services/api_service.dart';

class AiRepository {
  final ApiService _apiService = ApiService();

  Future<String> sendQuestion(String question) async {
    final response = await _apiService.postRequest(
      '/ai/ask',
      {
        'question': question,
      },
    );

    return response['answer'] ?? 'Нет ответа от AI';
    
  }
}