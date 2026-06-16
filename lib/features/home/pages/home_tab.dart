import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/lumina_context.dart';
import '../../../core/widgets/gradient_cover.dart';
import '../../../core/widgets/lumina_header.dart';
import '../../../core/widgets/lumina_states.dart';
import '../../catalog/models/book.dart';
import '../../catalog/providers/books_provider.dart';
import '../widgets/book_tile.dart';
import '../widgets/featured_carousel.dart';
import '../widgets/section_header.dart';

/// Home — a celestial-library landing page: a time-of-day greeting header, a
/// parallax "Featured" carousel, and "Trending now" / "New arrivals" rows. All
/// three sections are sliced from the single Open Library catalog the
/// [BooksProvider] loads.
class HomeTab extends StatelessWidget {
  /// "See all" → jump to the Search tab.
  final VoidCallback onSeeAll;

  const HomeTab({super.key, required this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BooksProvider>();

    if (provider.isLoading && provider.books.isEmpty) {
      return const LuminaLoading();
    }
    if (provider.error != null && provider.books.isEmpty) {
      return LuminaError(
        message: provider.error!,
        onRetry: () => context.read<BooksProvider>().refresh(),
      );
    }

    final books = provider.books;
    // Slice the catalog into the three sections (with graceful fallbacks).
    final featured = books.take(5).toList();
    final trending = _slice(books, 5, 11);
    final arrivals = _slice(books, 11, 17);

    final s = context.strings;

    return SafeArea(
      bottom: false,
      child: RefreshIndicator(
        color: context.lumina.accent,
        onRefresh: () => context.read<BooksProvider>().refresh(),
        child: ListView(
          padding: const EdgeInsets.only(bottom: 104),
          children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 6, 24, 0),
            child: LuminaHeader(
              eyebrowIcon: Icons.auto_awesome,
              eyebrow: s.greeting(DateTime.now().hour),
              title: s.hello,
              titleSize: 31,
            ),
          ),

          if (featured.isNotEmpty) ...[
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 6),
              child: SectionHeader(
                title: s.featured,
                actionLabel: s.seeAll,
                onAction: onSeeAll,
              ),
            ),
            FeaturedCarousel(books: featured),
          ],

          if (trending.isNotEmpty)
            _Row(
              title: s.trending,
              seeAll: s.seeAll,
              onSeeAll: onSeeAll,
              books: trending,
              decor: CoverDecor.topRight,
            ),

          if (arrivals.isNotEmpty)
            _Row(
              title: s.arrivals,
              seeAll: s.seeAll,
              onSeeAll: onSeeAll,
              books: arrivals,
              decor: CoverDecor.bottomLeft,
            ),
          ],
        ),
      ),
    );
  }

  /// Returns `books[start..end]`, falling back to a wrap-around slice when there
  /// aren't enough results to fill every section distinctly.
  List<Book> _slice(List<Book> books, int start, int end) {
    if (books.length > start) {
      return books.sublist(start, end.clamp(0, books.length));
    }
    if (books.length <= 5) return books; // small catalog: reuse what we have
    return books.sublist(books.length - 5);
  }
}

class _Row extends StatelessWidget {
  final String title;
  final String seeAll;
  final VoidCallback onSeeAll;
  final List<Book> books;
  final CoverDecor decor;

  const _Row({
    required this.title,
    required this.seeAll,
    required this.onSeeAll,
    required this.books,
    required this.decor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 14, 24, 6),
          child: SectionHeader(
            title: title,
            actionLabel: seeAll,
            onAction: onSeeAll,
          ),
        ),
        SizedBox(
          height: 290,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 14),
            itemCount: books.length,
            separatorBuilder: (_, _) => const SizedBox(width: 16),
            itemBuilder: (_, i) => BookTile(book: books[i], decor: decor),
          ),
        ),
      ],
    );
  }
}
