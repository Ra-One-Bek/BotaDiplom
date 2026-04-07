import 'package:career_guidance_app/app/router.dart';
import 'package:career_guidance_app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'app/app.dart';

void main() {
  MaterialApp(
    title: 'Bota Career',
    theme: AppTheme.lightTheme,
    routes: AppRouter.routes,
  );
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const CareerGuidanceApp());
}