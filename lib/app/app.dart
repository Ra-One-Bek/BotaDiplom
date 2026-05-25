import 'package:flutter/material.dart';
import 'package:career_guidance_app/app/router.dart';
import 'package:career_guidance_app/core/theme/app_theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../core/services/locale_provider.dart';
import '../l10n/generated/app_localizations.dart';

class CareerGuidanceApp extends StatelessWidget {
  final LocaleProvider localeProvider;

  const CareerGuidanceApp({
    super.key,
    required this.localeProvider,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: localeProvider,
      builder: (context, _) {
        return MaterialApp(
          title: 'Proffy',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          locale: localeProvider.locale,
          initialRoute: AppRouter.splash,
          routes: AppRouter.routes,
          supportedLocales: const [
            Locale('ru'),
            Locale('en'),
            Locale('kk'),
          ],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
        );
      },
    );
  }
}