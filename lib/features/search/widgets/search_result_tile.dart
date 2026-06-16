import 'package:flutter/material.dart';

import '../../../core/theme/lumina_context.dart';
import '../../../core/theme/lumina_tokens.dart';
import '../../../core/util/book_display.dart';
import '../../../core/util/book_palette.dart';
import '../../../core/widgets/gradient_cover.dart';
import '../../catalog/models/book.dart';
import '../../details/pages/book_details_sheet.dart';
import '../../favorites/widgets/favorite_heart.dart';

/// One row in the search results: a small gradient thumb with a serif monogram,
/// the title/author, a meta row (year · LANG · ★rating), and a favourite heart.
class SearchResultTile extends StatelessWidget {
  final Book book;
  const SearchResultTile({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    final tokens = context.lumina;
    final palette = BookPalette.of(book);

    return InkWell(
      onTap: () => openBookDetails(context, book),
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            GradientCover(
              palette: palette,
              width: 60,
              height: 84,
              radius: 13,
              imageUrl: book.thumbnail,
              shadow: const [
                BoxShadow(
                  color: Color(0x80181E2E),
                  blurRadius: 20,
                  offset: Offset(0, 10),
                  spreadRadius: -12,
                ),
              ],
              child: book.thumbnail == null
                  ? Center(
                      child: Text(
                        book.initial,
                        style: context.serif(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withValues(alpha: 0.92),
                          shadows: const [
                            Shadow(color: Color(0x4D000000), blurRadius: 10),
                          ],
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: context.serif(
                      fontSize: 16.5,
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
                  const SizedBox(height: 6),
                  _MetaRow(book: book),
                ],
              ),
            ),
            const SizedBox(width: 8),
            FavoriteHeart(
              book: book,
              size: 42,
              iconSize: 21,
              background: tokens.chip,
              outlineColor: tokens.faint,
            ),
          ],
        ),
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  final Book book;
  const _MetaRow({required this.book});

  @override
  Widget build(BuildContext context) {
    final tokens = context.lumina;
    final dotStyle = context.sans(
      fontSize: 11.5,
      fontWeight: FontWeight.w600,
      color: tokens.faint,
    );

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 8,
      children: [
        Text(book.year, style: dotStyle),
        Text('·', style: dotStyle),
        Text(book.languageLabel, style: dotStyle),
        Text('·', style: dotStyle),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.star_rounded, size: 12, color: LuminaTokens.starList),
            const SizedBox(width: 3),
            Text(
              book.ratingLabel ?? '—',
              style: context.sans(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: tokens.ink,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
