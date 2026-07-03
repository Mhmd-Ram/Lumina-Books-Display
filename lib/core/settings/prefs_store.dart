import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Typed, synchronous access to the handful of persisted UI/session flags
/// (onboarding-seen, theme, language). Load it once at startup with [create] so
/// reads are synchronous — that way the app opens straight into the saved theme
/// and language with no first-frame flash of the wrong one.
class PrefsStore {
  PrefsStore(this._prefs);

  static Future<PrefsStore> create() async =>
      PrefsStore(await SharedPreferences.getInstance());

  final SharedPreferences _prefs;

  static const _kOnboardingSeen = 'onboardingSeen';
  static const _kThemeMode = 'themeMode';
  static const _kLocale = 'locale';

  bool get onboardingSeen => _prefs.getBool(_kOnboardingSeen) ?? false;
  Future<void> setOnboardingSeen(bool value) =>
      _prefs.setBool(_kOnboardingSeen, value);

  ThemeMode get themeMode => _prefs.getString(_kThemeMode) == 'dark'
      ? ThemeMode.dark
      : ThemeMode.light;
  Future<void> setThemeMode(ThemeMode mode) =>
      _prefs.setString(_kThemeMode, mode == ThemeMode.dark ? 'dark' : 'light');

  Locale get locale => Locale(_prefs.getString(_kLocale) ?? 'en');
  Future<void> setLocale(Locale value) =>
      _prefs.setString(_kLocale, value.languageCode);
}
