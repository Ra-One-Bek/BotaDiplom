import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:career_guidance_app/data/models/assessment_module_model.dart';
import 'package:career_guidance_app/data/models/module_question_model.dart';
import 'package:career_guidance_app/data/models/module_submit_model.dart';
import 'package:career_guidance_app/data/models/modules_progress_model.dart';

class AssessmentService {
  static const String baseUrl = 'http://localhost:3000/api';

  Future<List<AssessmentModuleModel>> getModules({
    String? accessToken,
  }) async {
    final response = await http.get(
      Uri.parse('$baseUrl/assessment/modules'),
      headers: _headers(accessToken),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        'Не удалось получить список модулей. Код: ${response.statusCode}. Тело: ${response.body}',
      );
    }

    final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;

    return data
        .map((item) => AssessmentModuleModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<ModulesProgressModel> getModulesProgress({
    required int userId,
    String? accessToken,
  }) async {
    final response = await http.get(
      Uri.parse('$baseUrl/assessment/modules/progress/$userId'),
      headers: _headers(accessToken),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        'Не удалось получить прогресс модулей. Код: ${response.statusCode}. Тело: ${response.body}',
      );
    }

    final Map<String, dynamic> data =
        jsonDecode(response.body) as Map<String, dynamic>;

    return ModulesProgressModel.fromJson(data);
  }

  Future<ModuleQuestionsResponseModel> getModuleQuestions({
    required String moduleCode,
    String? accessToken,
  }) async {
    final response = await http.get(
      Uri.parse('$baseUrl/assessment/modules/$moduleCode/questions'),
      headers: _headers(accessToken),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        'Не удалось получить вопросы модуля. Код: ${response.statusCode}. Тело: ${response.body}',
      );
    }

    final Map<String, dynamic> data =
        jsonDecode(response.body) as Map<String, dynamic>;

    return ModuleQuestionsResponseModel.fromJson(data);
  }

  Future<void> submitModule({
    required String moduleCode,
    required int userId,
    required List<ModuleAnswerSubmitItem> answers,
    String? accessToken,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/assessment/modules/$moduleCode/submit'),
      headers: _headers(accessToken),
      body: jsonEncode({
        'userId': userId,
        'answers': answers.map((e) => e.toJson()).toList(),
      }),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        'Не удалось отправить модуль. Код: ${response.statusCode}. Тело: ${response.body}',
      );
    }
  }

  Map<String, String> _headers(String? accessToken) {
    return {
      'Content-Type': 'application/json',
      if (accessToken != null && accessToken.isNotEmpty)
        'Authorization': 'Bearer $accessToken',
    };
  }
  
  Future<Map<String, dynamic>> getRecommendations({
    required int userId,
    String? accessToken,
  }) async {
    final response = await http.get(
      Uri.parse('$baseUrl/assessment/recommendations/$userId'),
      headers: _headers(accessToken),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        'Не удалось получить рекомендации. Код: ${response.statusCode}. Тело: ${response.body}',
      );
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }
}