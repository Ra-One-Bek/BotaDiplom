import 'package:career_guidance_app/core/services/api_service.dart';
import 'package:career_guidance_app/data/models/answer_model.dart';
import 'package:career_guidance_app/data/models/question_model.dart';

class TestRepository {
  final ApiService _apiService = ApiService();

  Future<List<QuestionModel>> getQuestions() async {
    final response = await _apiService.getRequest('/tests/questions');

    return (response as List<dynamic>)
        .map((e) => QuestionModel.fromJson(e))
        .toList();
  }

  Future<dynamic> submitAnswers({
    required int userId,
    required List<AnswerModel> answers,
  }) async {
    return await _apiService.postRequest(
      '/tests/submit',
      {
        'userId': userId,
        'answers': answers.map((e) => e.toJson()).toList(),
      },
    );
  }

  Future<dynamic> getResult(int userId) async {
    return await _apiService.getRequest('/tests/result/$userId');
  }
}