import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageChangeController with ChangeNotifier {
  Locale? _appLocale;
  Locale? get appLocale => _appLocale;

  LanguageChangeController() {
    _loadLocale();
  }

  void _loadLocale() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String? languageCode = sp.getString('language_code');
    _appLocale = languageCode != null ? Locale(languageCode) : const Locale('en');
    print('Loaded locale: $_appLocale');  // Add this
    notifyListeners();
  }

  void changeLanguage(Locale type) async {
    if (_appLocale == type) return; // Avoid unnecessary updates
    SharedPreferences sp = await SharedPreferences.getInstance();
    _appLocale = type;
    await sp.setString('language_code', type.languageCode);
    notifyListeners();
  }
}