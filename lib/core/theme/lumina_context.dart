import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../localization/app_strings.dart';
import 'lumina_tokens.dart';

/// Ergonomic accessors for the Lumina design system on [BuildContext]:
/// the color [LuminaTokens], localized [AppStrings], language direction, and the
/// two font families (serif headings / sans body) selected by language.
extension LuminaContext on BuildContext {
  LuminaTokens get lumina => Theme.of(this).extension<LuminaTokens>()!;

  AppStrings get strings => AppStrings.of(this);

  bool get isArabic => Localizations.localeOf(this).languageCode == 'ar';

  /// Literary serif used for headings and cover titles — Fraunces (EN) / Amiri (AR).
  TextStyle serif({
    double? fontSize,
    FontWeight fontWeight = FontWeight.w600,
    Color? color,
    double? height,
    double? letterSpacing,
    FontStyle? fontStyle,
    List<Shadow>? shadows,
  }) {
    final base = TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
      fontStyle: fontStyle,
      shadows: shadows,
    );
    return isArabic
        ? GoogleFonts.amiri(textStyle: base)
        : GoogleFonts.fraunces(textStyle: base);
  }

  /// Body / UI sans — Hanken Grotesk (EN) / IBM Plex Sans Arabic (AR).
  TextStyle sans({
    double? fontSize,
    FontWeight fontWeight = FontWeight.w500,
    Color? color,
    double? height,
    double? letterSpacing,
    List<Shadow>? shadows,
  }) {
    final base = TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
      shadows: shadows,
    );
    return isArabic
        ? GoogleFonts.ibmPlexSansArabic(textStyle: base)
        : GoogleFonts.hankenGrotesk(textStyle: base);
  }

  /// Eyebrow/label letter-spacing in logical px (≈ `.14em` EN, never AR).
  double eyebrowTracking(double fontSize) => isArabic ? 0.0 : fontSize * 0.14;

  /// Extra top room serif page titles need in Arabic (`--titlePt`).
  double get titleTopPad => isArabic ? 10.0 : 0.0;

  /// Serif page-title line height (`--titleLh`).
  double get titleLineHeight => isArabic ? 1.5 : 1.08;
}
