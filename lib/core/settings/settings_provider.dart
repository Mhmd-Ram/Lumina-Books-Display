import 'package:flutter/material.dart';

import 'prefs_store.dart';

/// Global UI-settings state (Provider): the active theme (light "Parchment" /
/// dark "Midnight Library") and language (English / Arabic RTL). Both are
/// toggled from the header cluster on every screen and persisted via
/// [PrefsStore], so the app reopens in the same theme and language.
class SettingsProvider extends ChangeNotifier {
  SettingsProvider(PrefsStore prefs)
    : _prefs = prefs,
      _themeMode = prefs.themeMode,
      _locale = prefs.locale;

  final PrefsStore _prefs;
  ThemeMode _themeMode;
  Locale _locale;

  ThemeMode get themeMode => _themeMode;
  bool get isDark => _themeMode == ThemeMode.dark;

  Locale get locale => _locale;
  bool get isArabic => _locale.languageCode == 'ar';

  /// Label shown on the language pill — the script you'll switch *to*.
  String get languageButtonLabel => isArabic ? 'EN' : 'ع';

  void toggleTheme() {
    _themeMode = isDark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
    _prefs.setThemeMode(_themeMode);
  }

  void toggleLanguage() {
    _locale = isArabic ? const Locale('en') : const Locale('ar');
    notifyListeners();
    _prefs.setLocale(_locale);
  }
}
