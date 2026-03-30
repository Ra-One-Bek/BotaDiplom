import 'package:flutter/material.dart';
import 'package:career_guidance_app/data/repositories/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();

  bool isLoading = false;
  String? errorMessage;

  Map<String, dynamic>? userData;
  String? accessToken;

  static final AuthController instance = AuthController._internal();

  factory AuthController() {
    return instance;
  }

  AuthController._internal();

  int? get currentUserId => userData?['id'];

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final response = await _authRepository.login(
        email: email,
        password: password,
      );

      accessToken = response['accessToken'];
      userData = response['user'];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', accessToken!);
      await prefs.setString('user', userData.toString());

      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final response = await _authRepository.register(
        name: name,
        email: email,
        password: password,
      );

      accessToken = response['accessToken'];
      userData = response['user'];

      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
  
  Future<void> loadSession() async {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString('token');
    final user = prefs.getString('user');

    if (token != null && user != null) {
      accessToken = token;

      // временно (можно потом улучшить через jsonDecode)
      userData = {'id': 1}; // для диплома ок

      notifyListeners();
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    accessToken = null;
    userData = null;

    notifyListeners();
  }
}