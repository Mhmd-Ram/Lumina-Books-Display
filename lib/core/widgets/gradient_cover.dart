import 'package:flutter/material.dart';

import '../util/book_palette.dart';

/// Where a cover's translucent décor disc sits.
enum CoverDecor { none, topRight, bottomLeft }

/// A generated, image-free book cover: the signature Lumina look. Paints the
/// per-book [BookPalette] gradient (base `c1→c2`, a `c3` radial tint, and a soft
/// white highlight), an optional décor disc and bottom scrim, and any [child]
/// overlay (title, monogram, favourite heart…).
///
/// If a real cover [imageUrl] is supplied it fades in over the gradient, so the
/// app shows actual Open Library covers when available and the gradient stands
/// in whenever one is missing or fails to load (the "≥2 images + fallback"
/// requirement) — while keeping the celestial-library aesthetic intact.
class GradientCover extends StatelessWidget {
  final BookPalette palette;
  final double width;
  final double height;
  final double radius;
  final String? imageUrl;
  final CoverDecor decor;
  final double scrim; // bottom dark scrim opacity (0 = none)
  final Widget? child;
  final EdgeInsetsGeometry? padding;
  final List<BoxShadow>? shadow;
  final FilterQuality filterQuality;

  const GradientCover({
    super.key,
    required this.palette,
    required this.width,
    required this.height,
    this.radius = 20,
    this.imageUrl,
    this.decor = CoverDecor.none,
    this.scrim = 0,
    this.child,
    this.padding,
    this.shadow,
    this.filterQuality = FilterQuality.medium,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(radius);
    final discSize = width * 0.74;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(borderRadius: borderRadius, boxShadow: shadow),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Layered gradient (base → c3 tint → white highlight).
            DecoratedBox(decoration: BoxDecoration(gradient: palette.baseGradient)),
            DecoratedBox(decoration: BoxDecoration(gradient: palette.accentGradient)),
            DecoratedBox(decoration: BoxDecoration(gradient: palette.highlightGradient)),

            // Real cover image, when present (gradient remains the fallback).
            if (imageUrl != null && imageUrl!.isNotEmpty)
              Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                filterQuality: filterQuality,
                errorBuilder: (_, _, _) => const SizedBox.shrink(),
                loadingBuilder: (_, child, progress) =>
                    progress == null ? child : const SizedBox.shrink(),
              ),

            // Translucent décor disc.
            if (decor == CoverDecor.topRight)
              Positioned(
                right: -width * 0.18,
                top: -width * 0.17,
                child: _disc(discSize, Colors.white.withValues(alpha: 0.16)),
              ),
            if (decor == CoverDecor.bottomLeft)
              Positioned(
                left: -width * 0.22,
                bottom: -width * 0.20,
                child: _disc(discSize, Colors.white.withValues(alpha: 0.14)),
              ),

            // Bottom scrim for title legibility.
            if (scrim > 0)
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xFF0A0810).withValues(alpha: 0),
                      Color(0xFF0A0810).withValues(alpha: scrim),
                    ],
                    stops: const [0.42, 1.0],
                  ),
                ),
              ),

            if (child != null)
              Padding(padding: padding ?? EdgeInsets.zero, child: child),
          ],
        ),
      ),
    );
  }

  Widget _disc(double size, Color color) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      );
}
