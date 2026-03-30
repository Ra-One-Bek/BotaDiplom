import 'package:career_guidance_app/core/services/api_service.dart';

class AuthRepository {
  final ApiService _apiService = ApiService();

  Future<dynamic> login({
    required String email,
    required String password,
  }) async {
    return await _apiService.postRequest('/auth/login', {
      'email': email,
      'password': password,
    });
  }

  Future<dynamic> register({
    required String name,
    required String email,
    required String password,
  }) async {
    return await _apiService.postRequest('/auth/register', {
      'name': name,
      'email': email,
      'password': password,
    });
  }
}