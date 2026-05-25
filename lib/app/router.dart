import 'package:flutter/material.dart';
import 'package:career_guidance_app/features/ai/ai_screen.dart';
import 'package:career_guidance_app/features/auth/auth_screen.dart';
import 'package:career_guidance_app/features/main/main_shell.dart';
import 'package:career_guidance_app/features/modules/modules_screen.dart';
import 'package:career_guidance_app/features/profile/profile_screen.dart';
import 'package:career_guidance_app/features/recommendations/recommendations_screen.dart';
import 'package:career_guidance_app/features/splash/splash_screen.dart';
import 'package:career_guidance_app/features/testing/test_screen.dart';
import 'package:career_guidance_app/features/language/language_screen.dart';

class AppRouter {
  static const String splash = '/';
  static const String auth = '/auth';
  static const String main = '/main';
  static const String modules = '/modules';
  static const String testing = '/testing';
  static const String recommendations = '/recommendations';
  static const String ai = '/ai';
  static const String profile = '/profile';
  static const String language = '/language';

  static Map<String, WidgetBuilder> get routes => {
        splash: (_) => const SplashScreen(),
        auth: (_) => const AuthScreen(),
        main: (_) => const MainShell(),
        modules: (_) => const ModulesScreen(),
        testing: (_) => const TestScreen(),
        recommendations: (_) => const RecommendationsScreen(),
        ai: (_) => const AiScreen(),
        profile: (_) => const ProfileScreen(),
        language: (context) => const LanguageScreen(),
      };
}