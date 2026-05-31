import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/university_model.dart';

class UniversityService {
  static const String baseUrl = 'http://localhost:3000/api';

  Future<List<UniversityModel>> getUniversities() async {
    final response = await http.get(
      Uri.parse('$baseUrl/universities'),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        'Не удалось получить университеты. Код: ${response.statusCode}. Тело: ${response.body}',
      );
    }

    final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;

    return data
        .map((item) => UniversityModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}