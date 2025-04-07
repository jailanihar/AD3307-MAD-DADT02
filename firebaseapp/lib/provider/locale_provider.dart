// lib/locale_provider.dart
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  LocaleProvider() {
    _loadLocale();
  }

  void _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final String? languageCode = prefs.getString('language_code');
    if(languageCode != null) {
      _locale = Locale(languageCode);
    }
    notifyListeners();
  }

  void setLocale(Locale locale) async {
    if (!AppLocalizations.supportedLocales.contains(locale)) {
      return;
    }

    _locale = locale;
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('language_code', locale.languageCode);

    notifyListeners();
  }

}