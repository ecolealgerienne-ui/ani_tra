import 'package:flutter/material.dart';
import 'strings_fr.dart';
import 'strings_ar.dart';
import 'strings_en.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  late Map<String, String> _localizedStrings;

  Future<void> load() async {
    switch (locale.languageCode) {
      case 'ar':
        _localizedStrings = stringsAr;
        break;
      case 'en':
        _localizedStrings = stringsEn;
        break;
      case 'fr':
      default:
        _localizedStrings = stringsFr;
    }
  }

  String translate(String key) {
    return _localizedStrings[key] ?? key;
  }

  // Shortcuts for common translations
  String get appName => translate('app_name');
  String get home => translate('home');
  String get scan => translate('scan');
  String get animals => translate('animals');
  String get campaigns => translate('campaigns');
  String get sync => translate('sync');
  String get settings => translate('settings');
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['fr', 'ar', 'en'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
