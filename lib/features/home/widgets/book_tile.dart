import 'package:flutter/material.dart';

import '../../../core/theme/lumina_context.dart';
import '../../../core/theme/lumina_tokens.dart';
import '../../../core/util/book_display.dart';
import '../../../core/util/book_palette.dart';
import '../../../core/widgets/gradient_cover.dart';
import '../../catalog/models/book.dart';
import '../../details/pages/book_details_sheet.dart';

/// A compact 150-wide book tile used by the Trending and New-arrivals rows:
/// a gradient cover with the title overlaid, then author + rating below.
class BookTile extends StatelessWidget {
  final Book book;
  final CoverDecor decor;

  const BookTile({super.key, required this.book, this.decor = CoverDecor.topRight});

  @override
  Widget build(BuildContext context) {
    final tokens = context.lumina;
    final palette = BookPalette.of(book);

    return GestureDetector(
      onTap: () => openBookDetails(context, book),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 150,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GradientCover(
              palette: palette,
              width: 150,
              height: 204,
              radius: 20,
              decor: decor,
              imageUrl: book.thumbnail,
              scrim: 0.46,
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 13),
              shadow: const [
                BoxShadow(
                  color: Color(0x80181E2E),
                  blurRadius: 34,
                  offset: Offset(0, 18),
                  spreadRadius: -18,
                ),
              ],
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  book.title,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: context.serif(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    height: 1.06,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              book.authorsText,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.sans(
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
                color: tokens.soft,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.star_rounded, size: 14, color: LuminaTokens.starList),
                const SizedBox(width: 5),
                Text(
                  book.ratingLabel ?? '—',
                  style: context.sans(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: tokens.ink,
                  ),
                ),
                if (book.ratingLabel != null) ...[
                  const SizedBox(width: 5),
                  Text(
                    '· ${book.countLabel}',
                    style: context.sans(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w500,
                      color: tokens.faint,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
