import 'package:flutter/material.dart';
import 'app/app.dart';
import 'core/services/locale_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await LocaleProvider.instance.loadLocale();

  runApp(
    CareerGuidanceApp(
      localeProvider: LocaleProvider.instance,
    ),
  );
}