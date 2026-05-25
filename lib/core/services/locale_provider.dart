import 'package:flutter/material.dart';
import 'locale_service.dart';

class LocaleProvider extends ChangeNotifier {
  static final LocaleProvider instance = LocaleProvider();
  
  final LocaleService _localeService = LocaleService();

  Locale _locale = const Locale('ru');

  Locale get locale => _locale;

  Future<void> loadLocale() async {
    _locale = await _localeService.loadLocale();
    notifyListeners();
  }

  Future<void> changeLocale(Locale locale) async {
    _locale = locale;

    await _localeService.saveLocale(locale);

    notifyListeners();
  }
}