import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'lumina_tokens.dart';

/// Builds the Lumina [ThemeData] for a given [Brightness] and [Locale].
///
/// Colors come from [LuminaTokens] (registered as a theme extension); the base
/// body font switches with the language — Hanken Grotesk for English, IBM Plex
/// Sans Arabic for Arabic. Headings use a serif (Fraunces / Amiri) applied
/// per-widget via the `context.serif()` helper.
class AppTheme {
  AppTheme._();

  static ThemeData build({
    required Brightness brightness,
    required Locale locale,
  }) {
    final tokens =
        brightness == Brightness.dark ? LuminaTokens.dark : LuminaTokens.light;
    final isArabic = locale.languageCode == 'ar';

    final base = ThemeData(brightness: brightness, useMaterial3: true);
    final sansTextTheme = isArabic
        ? GoogleFonts.ibmPlexSansArabicTextTheme(base.textTheme)
        : GoogleFonts.hankenGroteskTextTheme(base.textTheme);

    return base.copyWith(
      scaffoldBackgroundColor: tokens.bg,
      colorScheme: ColorScheme.fromSeed(
        seedColor: tokens.accent,
        brightness: brightness,
      ).copyWith(surface: tokens.bg),
      textTheme:
          sansTextTheme.apply(bodyColor: tokens.ink, displayColor: tokens.ink),
      iconTheme: IconThemeData(color: tokens.ink),
      splashFactory: InkRipple.splashFactory,
      extensions: <ThemeExtension<dynamic>>[tokens],
    );
  }
}
