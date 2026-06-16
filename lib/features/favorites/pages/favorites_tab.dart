import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/lumina_context.dart';
import '../../../core/theme/lumina_tokens.dart';
import '../../../core/widgets/constellation_glyph.dart';
import '../../../core/widgets/lumina_header.dart';
import '../../../core/widgets/lumina_states.dart';
import '../../catalog/models/book.dart';
import '../providers/favorites_provider.dart';
import '../widgets/favorite_card.dart';

/// Favorites — a "YOUR LIBRARY" header with a live count, then the saved books.
/// Removing a card animates it out (fade + slide + collapse) before it is
/// actually dropped from the global [FavoritesProvider].
class FavoritesTab extends StatefulWidget {
  const FavoritesTab({super.key});

  @override
  State<FavoritesTab> createState() => _FavoritesTabState();
}

class _FavoritesTabState extends State<FavoritesTab> {
  static const Duration _removeDuration = Duration(milliseconds: 360);

  /// Ids currently animating out (before the provider removes them).
  final Set<String> _removing = {};

  void _remove(Book book) {
    if (_removing.contains(book.id)) return;
    setState(() => _removing.add(book.id));
    Future.delayed(_removeDuration, () {
      if (!mounted) return;
      context.read<FavoritesProvider>().toggle(book);
      setState(() => _removing.remove(book.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    final s = context.strings;
    final items = context.watch<FavoritesProvider>().items;

    return SafeArea(
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
            child: LuminaHeader(
              eyebrowIcon: Icons.favorite,
              eyebrow: s.library,
              title: s.favorites,
              titleSize: 30,
              titleTrailing: Text(
                '${items.length}',
                style: context.sans(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: context.lumina.faint,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: items.isEmpty
                ? _EmptyFavorites(title: s.noFavs, subtitle: s.noFavsSub)
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 104),
                    itemCount: items.length,
                    itemBuilder: (_, i) {
                      final book = items[i];
                      return _RemovableCard(
                        removing: _removing.contains(book.id),
                        child: FavoriteCard(
                          book: book,
                          onRemove: () => _remove(book),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

/// Wraps a card with the remove-out animation (fade + slide + collapse).
class _RemovableCard extends StatelessWidget {
  final bool removing;
  final Widget child;

  const _RemovableCard({required this.removing, required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: AnimatedAlign(
        alignment: Alignment.topCenter,
        heightFactor: removing ? 0 : 1,
        duration: const Duration(milliseconds: 360),
        curve: Curves.easeInOut,
        child: AnimatedOpacity(
          opacity: removing ? 0 : 1,
          duration: const Duration(milliseconds: 360),
          child: AnimatedSlide(
            offset: removing ? const Offset(0.12, 0) : Offset.zero,
            duration: const Duration(milliseconds: 360),
            curve: Curves.easeIn,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyFavorites extends StatelessWidget {
  final String title;
  final String subtitle;

  const _EmptyFavorites({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return LuminaEmpty(
      title: title,
      subtitle: subtitle,
      icon: ConstellationGlyph.heart(size: 104, color: LuminaTokens.heart),
    );
  }
}
