import 'package:flutter/material.dart';

import '../../../core/theme/lumina_context.dart';
import '../../../core/theme/lumina_tokens.dart';
import '../../../core/util/book_display.dart';
import '../../../core/util/book_palette.dart';
import '../../../core/widgets/gradient_cover.dart';
import '../../catalog/models/book.dart';
import '../../details/pages/book_details_sheet.dart';

/// A wide favourite card: a 72×100 gradient cover, the title/author, a
/// rating·genre chip, and a solid heart remove button at the trailing edge
/// (a flex item, so it never overlaps the title). Tapping the card opens
/// details; tapping the heart calls [onRemove].
class FavoriteCard extends StatelessWidget {
  final Book book;
  final VoidCallback onRemove;

  const FavoriteCard({super.key, required this.book, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    final tokens = context.lumina;
    final palette = BookPalette.of(book);
    final genre = book.firstCategory;

    return GestureDetector(
      onTap: () => openBookDetails(context, book),
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: BoxDecoration(
          color: tokens.card,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: tokens.line),
          boxShadow: const [
            BoxShadow(
              color: Color(0x66181E2E),
              blurRadius: 36,
              offset: Offset(0, 16),
              spreadRadius: -26,
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // Faint palette tint over the card.
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      palette.c1.withValues(alpha: tokens.isDark ? 0.17 : 0.12),
                      palette.c2.withValues(alpha: tokens.isDark ? 0.10 : 0.07),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  GradientCover(
                    palette: palette,
                    width: 72,
                    height: 100,
                    radius: 15,
                    imageUrl: book.thumbnail,
                    scrim: 0.4,
                    padding: const EdgeInsets.all(8),
                    child: book.thumbnail == null
                        ? Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              book.title,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: context.serif(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                height: 1.04,
                              ),
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          book.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: context.serif(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: tokens.ink,
                            height: 1.12,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          book.authorsText,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: context.sans(fontSize: 13, color: tokens.soft),
                        ),
                        const SizedBox(height: 10),
                        _RatingGenreChip(
                          rating: book.ratingLabel,
                          genre: genre.isEmpty ? null : context.strings.category(genre),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  _RemoveButton(onTap: onRemove),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RatingGenreChip extends StatelessWidget {
  final String? rating;
  final String? genre;
  const _RatingGenreChip({required this.rating, required this.genre});

  @override
  Widget build(BuildContext context) {
    final tokens = context.lumina;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
      decoration: BoxDecoration(
        color: tokens.chip,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, size: 12, color: LuminaTokens.starList),
          const SizedBox(width: 6),
          Text(
            rating ?? '—',
            style: context.sans(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: tokens.ink,
            ),
          ),
          if (genre != null) ...[
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                '· $genre',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.sans(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w500,
                  color: tokens.faint,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _RemoveButton extends StatelessWidget {
  final VoidCallback onTap;
  const _RemoveButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 46,
        height: 46,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: LuminaTokens.heartRemoveBg,
        ),
        child: const Icon(Icons.favorite, size: 23, color: LuminaTokens.heart),
      ),
    );
  }
}
