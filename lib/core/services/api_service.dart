import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:career_guidance_app/core/constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String baseUrl = AppConstants.baseUrl;

  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<dynamic> getRequest(String endpoint) async {
    final response = await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  Future<dynamic> postRequest(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: await _getHeaders(),
      body: jsonEncode(data),
    );

    return _handleResponse(response);
  }

  Future<dynamic> putRequest(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    final response = await http.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: await _getHeaders(),
      body: jsonEncode(data),
    );

    return _handleResponse(response);
  }

  Future<dynamic> deleteRequest(String endpoint) async {
    final response = await http.delete(
      Uri.parse('$baseUrl$endpoint'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  dynamic _handleResponse(http.Response response) {
    final decodedBody =
        response.body.isNotEmpty ? jsonDecode(response.body) : null;

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return decodedBody;
    } else {
      throw Exception(
        decodedBody?['message'] ?? 'Server error: ${response.statusCode}',
      );
    }
  }
}