import 'package:flutter/material.dart';

/// The Lumina "celestial library" design tokens, exposed as a [ThemeExtension]
/// so every widget can read them via `Theme.of(context).extension<LuminaTokens>()`
/// (see the `context.lumina` helper in `lumina_context.dart`).
///
/// Two themed sets — light "Parchment" and dark "Midnight Library" — plus a few
/// fixed, non-themed brand colors (favourite heart, star glyphs) as static
/// constants.
@immutable
class LuminaTokens extends ThemeExtension<LuminaTokens> {
  final bool isDark;

  final Color bg; // screen background
  final Color ink; // primary text
  final Color soft; // secondary text
  final Color faint; // tertiary text / inactive nav
  final Color line; // borders / dividers
  final Color card; // solid cards / search field
  final Color nav; // bottom-nav bar (blurred)
  final Color navline; // nav border
  final Color chip; // chips / icon-button bg
  final Color hover; // row hover / pressed
  final Color accent; // antique gold — eyebrows, "See all", active nav
  final Color accentSoft; // active nav pill bg
  final Color frame; // gold book-page frame (outer)
  final Color frame2; // gold book-page frame (inner)

  const LuminaTokens({
    required this.isDark,
    required this.bg,
    required this.ink,
    required this.soft,
    required this.faint,
    required this.line,
    required this.card,
    required this.nav,
    required this.navline,
    required this.chip,
    required this.hover,
    required this.accent,
    required this.accentSoft,
    required this.frame,
    required this.frame2,
  });

  /// Light — "Parchment".
  static const LuminaTokens light = LuminaTokens(
    isDark: false,
    bg: Color(0xFFF4ECDA),
    ink: Color(0xFF3A2A1B),
    soft: Color(0xFF7E6C55),
    faint: Color(0xFFAD9C80),
    line: Color(0x2E705228),
    card: Color(0xFFFFFBF1),
    nav: Color(0xD9FFFBF2),
    navline: Color(0x29705228),
    chip: Color(0x14705228),
    hover: Color(0x0F705228),
    accent: Color(0xFFA97C2E),
    accentSoft: Color(0x29A97C2E),
    frame: Color(0x75967637),
    frame2: Color(0x47967637),
  );

  /// Dark — "Midnight Library".
  static const LuminaTokens dark = LuminaTokens(
    isDark: true,
    bg: Color(0xFF14152A),
    ink: Color(0xFFF1ECDC),
    soft: Color(0xFFA7A2BE),
    faint: Color(0xFF6E6A88),
    line: Color(0x1AFFFFFF),
    card: Color(0xFF1E2040),
    nav: Color(0xD9161830),
    navline: Color(0x17FFFFFF),
    chip: Color(0x12FFFFFF),
    hover: Color(0x0DFFFFFF),
    accent: Color(0xFFE3B23C),
    accentSoft: Color(0x29E3B23C),
    frame: Color(0x4DE3B23C),
    frame2: Color(0x29E3B23C),
  );

  // ---- Fixed / non-themed brand colors ----
  static const Color heart = Color(0xFFFF466F); // active favourite heart
  static const Color heartRemoveBg = Color(0x1FFF466F); // remove-button bg
  static const Color starList = Color(0xFFFFB020); // star glyphs in lists
  static const Color starDetails = Color(0xFFFFC83D); // star glyph in details

  @override
  LuminaTokens copyWith({
    bool? isDark,
    Color? bg,
    Color? ink,
    Color? soft,
    Color? faint,
    Color? line,
    Color? card,
    Color? nav,
    Color? navline,
    Color? chip,
    Color? hover,
    Color? accent,
    Color? accentSoft,
    Color? frame,
    Color? frame2,
  }) {
    return LuminaTokens(
      isDark: isDark ?? this.isDark,
      bg: bg ?? this.bg,
      ink: ink ?? this.ink,
      soft: soft ?? this.soft,
      faint: faint ?? this.faint,
      line: line ?? this.line,
      card: card ?? this.card,
      nav: nav ?? this.nav,
      navline: navline ?? this.navline,
      chip: chip ?? this.chip,
      hover: hover ?? this.hover,
      accent: accent ?? this.accent,
      accentSoft: accentSoft ?? this.accentSoft,
      frame: frame ?? this.frame,
      frame2: frame2 ?? this.frame2,
    );
  }

  @override
  LuminaTokens lerp(ThemeExtension<LuminaTokens>? other, double t) {
    if (other is! LuminaTokens) return this;
    return LuminaTokens(
      isDark: t < 0.5 ? isDark : other.isDark,
      bg: Color.lerp(bg, other.bg, t)!,
      ink: Color.lerp(ink, other.ink, t)!,
      soft: Color.lerp(soft, other.soft, t)!,
      faint: Color.lerp(faint, other.faint, t)!,
      line: Color.lerp(line, other.line, t)!,
      card: Color.lerp(card, other.card, t)!,
      nav: Color.lerp(nav, other.nav, t)!,
      navline: Color.lerp(navline, other.navline, t)!,
      chip: Color.lerp(chip, other.chip, t)!,
      hover: Color.lerp(hover, other.hover, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      accentSoft: Color.lerp(accentSoft, other.accentSoft, t)!,
      frame: Color.lerp(frame, other.frame, t)!,
      frame2: Color.lerp(frame2, other.frame2, t)!,
    );
  }
}
