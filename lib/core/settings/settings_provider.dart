import 'package:flutter/material.dart';

/// Global UI-settings state (Provider): the active theme (light "Parchment" /
/// dark "Midnight Library") and language (English / Arabic RTL). Both are
/// toggled from the header cluster on every screen.
class SettingsProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  Locale _locale = const Locale('en');

  ThemeMode get themeMode => _themeMode;
  bool get isDark => _themeMode == ThemeMode.dark;

  Locale get locale => _locale;
  bool get isArabic => _locale.languageCode == 'ar';

  /// Label shown on the language pill — the script you'll switch *to*.
  String get languageButtonLabel => isArabic ? 'EN' : 'ع';

  void toggleTheme() {
    _themeMode = isDark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }

  void toggleLanguage() {
    _locale = isArabic ? const Locale('en') : const Locale('ar');
    notifyListeners();
  }
}
