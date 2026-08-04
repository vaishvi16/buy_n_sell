import 'package:flutter/material.dart';
import '../shared_pref/shared_pref.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  LanguageProvider() {
    loadLanguage();
  }

  Future<void> loadLanguage() async {
    String languageCode = await SharedPref.getLanguage();
    _locale = Locale(languageCode);
    notifyListeners();
  }

  Future<void> changeLanguage(String languageCode) async {
    _locale = Locale(languageCode);

    await SharedPref.saveLanguage(languageCode);

    notifyListeners();
  }
}