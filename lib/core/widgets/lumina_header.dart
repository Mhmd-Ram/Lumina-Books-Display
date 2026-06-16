import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../settings/settings_provider.dart';
import '../theme/lumina_context.dart';

/// The shared screen header used on Home, Search and Favorites: a gold eyebrow
/// (icon + tracked uppercase label), a serif page title with an optional
/// trailing widget (e.g. a count), and the language/theme control cluster.
class LuminaHeader extends StatelessWidget {
  final IconData eyebrowIcon;
  final String eyebrow;
  final String title;
  final double titleSize;
  final Widget? titleTrailing;

  const LuminaHeader({
    super.key,
    required this.eyebrowIcon,
    required this.eyebrow,
    required this.title,
    this.titleSize = 30,
    this.titleTrailing,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.lumina;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(eyebrowIcon, size: 14, color: tokens.accent),
                  const SizedBox(width: 7),
                  Flexible(
                    child: Text(
                      eyebrow.toUpperCase(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.sans(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: tokens.accent,
                        letterSpacing: context.eyebrowTracking(12),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 3 + context.titleTopPad),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Flexible(
                    child: Text(
                      title,
                      style: context.serif(
                        fontSize: titleSize,
                        fontWeight: FontWeight.w600,
                        color: tokens.ink,
                        height: context.titleLineHeight,
                        letterSpacing:
                            context.isArabic ? null : -titleSize * 0.013,
                      ),
                    ),
                  ),
                  if (titleTrailing != null) ...[
                    const SizedBox(width: 10),
                    titleTrailing!,
                  ],
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        const _LuminaControls(),
      ],
    );
  }
}

/// Language pill + circular theme toggle (top-right of every main screen).
class _LuminaControls extends StatelessWidget {
  const _LuminaControls();

  @override
  Widget build(BuildContext context) {
    final tokens = context.lumina;
    final settings = context.watch<SettingsProvider>();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Language toggle pill (shows the script you'd switch to: ع / EN).
        Material(
          color: tokens.card,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(19),
            side: BorderSide(color: tokens.line),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(19),
            onTap: () => context.read<SettingsProvider>().toggleLanguage(),
            child: Container(
              height: 38,
              constraints: const BoxConstraints(minWidth: 40),
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                settings.languageButtonLabel,
                style: GoogleFonts.ibmPlexSansArabic(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: tokens.ink,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        // Theme toggle (sun in dark mode, moon in light mode).
        Material(
          color: tokens.card,
          shape: CircleBorder(side: BorderSide(color: tokens.line)),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () => context.read<SettingsProvider>().toggleTheme(),
            child: SizedBox(
              width: 38,
              height: 38,
              child: Icon(
                settings.isDark ? Icons.light_mode_outlined : Icons.dark_mode,
                size: 19,
                color: tokens.ink,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
