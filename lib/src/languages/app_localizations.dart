import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations {
  final Locale locale; // Idioma actual
  Map<String, String>?
      _localizedStrings; // Para las traducciones en el idioma actual
  Map<String, String>?
      _defaultLocalizedStrings; // Para las traducciones en inglés (por defecto)

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  Future<bool> load() async {
    String jsonString =
        await rootBundle.loadString('languages/${locale.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    _localizedStrings =
        jsonMap.map((key, value) => MapEntry(key, value.toString()));

    // Cargar las traducciones en inglés como respaldo
    String englishJsonString = await rootBundle.loadString('languages/en.json');
    Map<String, dynamic> englishJsonMap = json.decode(englishJsonString);
    _defaultLocalizedStrings =
        englishJsonMap.map((key, value) => MapEntry(key, value.toString()));

    return true;
  }

  String translate(String key) {
    // Primero busca la traducción en el idioma actual, sino en inglés
    return _localizedStrings?[key] ?? _defaultLocalizedStrings?[key] ?? key;
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'es', 'gl', 'vl'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) =>
      false;
}
