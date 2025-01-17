import 'package:flutter/material.dart';
import 'package:vila_tour_pmdm/src/prefs/user_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _locale = Locale('en'); // Idioma por defecto.

  Locale get locale => _locale;

  LanguageProvider() {
    loadLanguage();
  }

  void loadLanguage() async {
    String languageCode = await UserPreferences.instance.getLanguage() ?? 'en';
    _locale = Locale(languageCode);
    notifyListeners();
  }

  void setLanguage(String languageCode) async {
    _locale = Locale(languageCode);
    await UserPreferences.instance.saveLanguage(languageCode);
    notifyListeners();
  }
}
