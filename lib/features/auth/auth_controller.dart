import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:career_guidance_app/data/repositories/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();

  bool isLoading = false;
  String? errorMessage;
  Map<String, dynamic>? userData;
  String? accessToken;

  bool _isDisposed = false;

  static final AuthController instance = AuthController._internal();

  factory AuthController() {
    return instance;
  }

  AuthController._internal();

  void _safeNotify() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  int? get currentUserId {
    final id = userData?['id'];
    if (id is int) return id;
    if (id is String) return int.tryParse(id);
    return null;
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      isLoading = true;
      errorMessage = null;
      _safeNotify();

      final response = await _authRepository.login(
        email: email,
        password: password,
      );

      accessToken = response['accessToken'] as String?;
      userData = Map<String, dynamic>.from(response['user'] as Map);

      final prefs = await SharedPreferences.getInstance();
      if (accessToken != null) {
        await prefs.setString('token', accessToken!);
      }
      await prefs.setString('user', jsonEncode(userData));

      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      isLoading = false;
      _safeNotify();
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
      _safeNotify();

      final response = await _authRepository.register(
        name: name,
        email: email,
        password: password,
      );

      accessToken = response['accessToken'] as String?;
      userData = Map<String, dynamic>.from(response['user'] as Map);

      final prefs = await SharedPreferences.getInstance();
      if (accessToken != null) {
        await prefs.setString('token', accessToken!);
      }
      await prefs.setString('user', jsonEncode(userData));

      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      isLoading = false;
      _safeNotify();
    }
  }

  Future<void> loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final user = prefs.getString('user');

    if (token != null && user != null) {
      accessToken = token;
      userData = Map<String, dynamic>.from(jsonDecode(user) as Map);
      _safeNotify();
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    accessToken = null;
    userData = null;
    _safeNotify();
  }
}