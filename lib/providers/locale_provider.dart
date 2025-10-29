// lib/providers/locale_provider.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  // Constantes (clés & valeurs techniques)
  static const String kPrefsKeyLanguageCode = 'language_code';
  static const String kDefaultLanguageCode = 'fr';

  Locale _locale = const Locale(kDefaultLanguageCode, '');

  Locale get locale => _locale;

  LocaleProvider() {
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode =
        prefs.getString(kPrefsKeyLanguageCode) ?? kDefaultLanguageCode;
    _locale = Locale(languageCode, '');
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    if (_locale == locale) return;

    _locale = locale;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(kPrefsKeyLanguageCode, locale.languageCode);
  }
}
