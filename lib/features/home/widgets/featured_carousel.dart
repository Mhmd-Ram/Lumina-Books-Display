import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../core/theme/lumina_context.dart';
import '../../../core/util/book_display.dart';
import '../../../core/util/book_palette.dart';
import '../../../core/widgets/gradient_cover.dart';
import '../../catalog/models/book.dart';
import '../../details/pages/book_details_sheet.dart';
import '../../favorites/widgets/favorite_heart.dart';

/// The Home "Featured" snap carousel: large cards with parallax cover art, a
/// frosted rating chip, a favourite heart, and a soft color glow that recolors
/// to the centered card's palette.
class FeaturedCarousel extends StatefulWidget {
  final List<Book> books;
  const FeaturedCarousel({super.key, required this.books});

  @override
  State<FeaturedCarousel> createState() => _FeaturedCarouselState();
}

class _FeaturedCarouselState extends State<FeaturedCarousel> {
  final PageController _controller = PageController(viewportFraction: 0.76);
  double _page = 0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() => _page = _controller.page ?? 0);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final centered = _page.round().clamp(0, widget.books.length - 1);
    final glow = BookPalette.of(widget.books[centered]);

    return SizedBox(
      height: 384,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Soft color glow behind the centered card.
          IgnorePointer(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              child: Container(
                key: ValueKey(centered),
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      glow.c1.withValues(alpha: 0.55),
                      glow.c2.withValues(alpha: 0.3),
                      glow.c2.withValues(alpha: 0),
                    ],
                    stops: const [0, 0.5, 0.8],
                  ),
                ),
              ),
            ),
          ),
          PageView.builder(
            controller: _controller,
            itemCount: widget.books.length,
            itemBuilder: (context, i) {
              return _FeaturedCard(
                book: widget.books[i],
                delta: _page - i,
                onTap: () => openBookDetails(context, widget.books[i]),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _FeaturedCard extends StatelessWidget {
  final Book book;
  final double delta;
  final VoidCallback onTap;

  const _FeaturedCard({
    required this.book,
    required this.delta,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final palette = BookPalette.of(book);
    final scale = (1 - delta.abs() * 0.06).clamp(0.92, 1.0);
    final dx = (delta * 28).clamp(-28.0, 28.0);

    return Center(
      child: Transform.scale(
        scale: scale,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 16),
          child: GestureDetector(
            onTap: onTap,
            child: SizedBox(
              height: 344,
              child: LayoutBuilder(
                builder: (context, c) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Parallax cover art (oversized so it can slide).
                        OverflowBox(
                          maxWidth: double.infinity,
                          alignment: Alignment.center,
                          child: Transform.translate(
                            offset: Offset(dx, 0),
                            child: GradientCover(
                              palette: palette,
                              width: c.maxWidth + 60,
                              height: 344,
                              radius: 0,
                              decor: CoverDecor.topRight,
                              imageUrl: book.largeThumbnail,
                              filterQuality: FilterQuality.high,
                            ),
                          ),
                        ),
                        // Static scrim for legibility.
                        const DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Color(0x000A0810), Color(0x800A0810)],
                              stops: [0.38, 1],
                            ),
                          ),
                        ),
                        // Favourite heart (top-right).
                        Positioned(
                          top: 15,
                          right: 15,
                          child: FavoriteHeart(
                            book: book,
                            size: 38,
                            iconSize: 19,
                            background: Colors.white.withValues(alpha: 0.22),
                            blurBackground: true,
                            outlineColor: Colors.white,
                          ),
                        ),
                        // Rating chip + title + author (bottom).
                        Positioned(
                          left: 22,
                          right: 22,
                          bottom: 20,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (book.ratingLabel != null) ...[
                                _RatingChip(label: book.ratingLabel!),
                                const SizedBox(height: 10),
                              ],
                              Text(
                                book.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: context.serif(
                                  fontSize: 27,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  height: 1.03,
                                  shadows: const [
                                    Shadow(
                                      color: Color(0x52000000),
                                      blurRadius: 18,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 7),
                              Text(
                                book.authorsText.toUpperCase(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: context.sans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white.withValues(alpha: 0.88),
                                  letterSpacing: context.isArabic ? null : 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RatingChip extends StatelessWidget {
  final String label;
  const _RatingChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.star_rounded, size: 13, color: Color(0xFFFFD15C)),
              const SizedBox(width: 5),
              Text(
                label,
                style: context.sans(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 0.6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
