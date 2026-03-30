import 'package:flutter/material.dart';
import 'package:career_guidance_app/app/router.dart';
import 'package:career_guidance_app/core/theme/app_theme.dart';

class CareerGuidanceApp extends StatelessWidget {
  const CareerGuidanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Career Guidance App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRouter.auth,
      routes: AppRouter.routes,
    );
  }
}