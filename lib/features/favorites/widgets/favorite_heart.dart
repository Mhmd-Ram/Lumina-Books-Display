import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../catalog/models/book.dart';
import '../providers/favorites_provider.dart';

/// A heart toggle bound to the global [FavoritesProvider]. Presentation is fully
/// configurable so the same widget serves every surface — the featured card,
/// search rows, and the details hero — each with its own size and colors. The
/// glyph animates with a "pop" scale whenever it turns filled.
class FavoriteHeart extends StatelessWidget {
  final Book book;
  final double size;
  final double iconSize;

  /// Circle background; null = transparent.
  final Color? background;

  /// Gradient circle background (takes precedence over [background]).
  final Gradient? backgroundGradient;

  /// Drop shadow under the circle.
  final List<BoxShadow>? shadow;

  /// Blur whatever is behind the circle (used over cover art).
  final bool blurBackground;

  /// Color of the filled heart, and of the outline heart.
  final Color filledColor;
  final Color outlineColor;

  const FavoriteHeart({
    super.key,
    required this.book,
    this.size = 42,
    this.iconSize = 21,
    this.background,
    this.backgroundGradient,
    this.shadow,
    this.blurBackground = false,
    this.filledColor = const Color(0xFFFF466F),
    required this.outlineColor,
  });

  @override
  Widget build(BuildContext context) {
    final isFav = context.select<FavoritesProvider, bool>(
      (p) => p.isFavorite(book.id),
    );

    return _PopHeart(
      filled: isFav,
      size: size,
      iconSize: iconSize,
      background: background,
      backgroundGradient: backgroundGradient,
      shadow: shadow,
      blurBackground: blurBackground,
      filledColor: filledColor,
      outlineColor: outlineColor,
      onTap: () => context.read<FavoritesProvider>().toggle(book),
    );
  }
}

class _PopHeart extends StatefulWidget {
  final bool filled;
  final double size;
  final double iconSize;
  final Color? background;
  final Gradient? backgroundGradient;
  final List<BoxShadow>? shadow;
  final bool blurBackground;
  final Color filledColor;
  final Color outlineColor;
  final VoidCallback onTap;

  const _PopHeart({
    required this.filled,
    required this.size,
    required this.iconSize,
    required this.background,
    required this.backgroundGradient,
    required this.shadow,
    required this.blurBackground,
    required this.filledColor,
    required this.outlineColor,
    required this.onTap,
  });

  @override
  State<_PopHeart> createState() => _PopHeartState();
}

class _PopHeartState extends State<_PopHeart>
    with SingleTickerProviderStateMixin {
  // Initialized in initState (not a lazy `late final`): a heart that never
  // morphs still gets disposed, and a lazy init would then run during dispose()
  // — which is unsafe (it looks up an inherited widget on a dead element).
  late final AnimationController _morph;
  late final Animation<double> _heartScale;
  late final Animation<double> _bookScale;

  @override
  void initState() {
    super.initState();
    // 0 = outline open-book (not saved), 1 = filled heart (saved).
    _morph = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 540),
      value: widget.filled ? 1 : 0,
    );
    // Heart blooms in with a springy overshoot; book eases out, and back.
    _heartScale = Tween(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _morph,
        curve: Curves.easeOutBack,
        reverseCurve: Curves.easeIn,
      ),
    );
    _bookScale = Tween(begin: 1.0, end: 0.5).animate(
      CurvedAnimation(
        parent: _morph,
        curve: Curves.easeIn,
        reverseCurve: Curves.easeOutBack,
      ),
    );
  }

  @override
  void didUpdateWidget(_PopHeart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.filled != oldWidget.filled) {
      widget.filled ? _morph.forward() : _morph.reverse();
    }
  }

  @override
  void dispose() {
    _morph.dispose();
    super.dispose();
  }

  /// The outline open-book ⇄ filled-heart crossfade-and-bloom.
  Widget _buildIcon() {
    return AnimatedBuilder(
      animation: _morph,
      builder: (context, _) {
        final v = _morph.value;
        return SizedBox(
          width: widget.iconSize,
          height: widget.iconSize,
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              Opacity(
                opacity: (1 - v).clamp(0.0, 1.0),
                child: Transform.scale(
                  scale: _bookScale.value,
                  child: Icon(
                    Icons.menu_book_outlined,
                    size: widget.iconSize,
                    color: widget.outlineColor,
                  ),
                ),
              ),
              Opacity(
                opacity: v.clamp(0.0, 1.0),
                child: Transform.scale(
                  scale: _heartScale.value,
                  child: Icon(
                    Icons.favorite,
                    size: widget.iconSize,
                    color: widget.filledColor,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final icon = Center(child: _buildIcon());
    Widget circle;

    if (widget.backgroundGradient != null) {
      circle = Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: widget.backgroundGradient,
          boxShadow: widget.shadow,
        ),
        child: icon,
      );
    } else if (widget.background != null || widget.blurBackground) {
      circle = ClipOval(
        child: BackdropFilter(
          filter: widget.blurBackground
              ? ImageFilter.blur(sigmaX: 6, sigmaY: 6)
              : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
          child: Container(
            width: widget.size,
            height: widget.size,
            color: widget.background,
            child: icon,
          ),
        ),
      );
    } else {
      circle = SizedBox(width: widget.size, height: widget.size, child: icon);
    }

    return GestureDetector(
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: circle,
    );
  }
}
