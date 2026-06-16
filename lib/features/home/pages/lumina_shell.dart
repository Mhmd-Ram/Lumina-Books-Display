import 'package:flutter/material.dart';

import '../../../core/theme/lumina_context.dart';
import '../../../core/widgets/lumina_bottom_nav.dart';
import '../../favorites/pages/favorites_tab.dart';
import '../../search/pages/search_tab.dart';
import 'home_tab.dart';

/// The persistent app shell: Home / Search / Favorites tabs in an [IndexedStack]
/// (state preserved across switches) plus the bottom nav, all wrapped in the
/// gold book-page frame. Everything — header, scrolling lists, and the nav —
/// lives *inside* the frame: the content is clipped to the frame's rounded
/// rectangle so nothing bleeds past the border while scrolling. The Book
/// Details sheet is pushed over this shell.
class LuminaShell extends StatefulWidget {
  const LuminaShell({super.key});

  @override
  State<LuminaShell> createState() => _LuminaShellState();
}

class _LuminaShellState extends State<LuminaShell> {
  int _index = 0;

  void _go(int i) => setState(() => _index = i);

  @override
  Widget build(BuildContext context) {
    final s = context.strings;
    final items = [
      LuminaNavItem(Icons.home_outlined, s.navHome),
      LuminaNavItem(Icons.search, s.navSearch),
      LuminaNavItem(Icons.favorite_border, s.navFav),
    ];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: _BookPageFrame(
            child: Stack(
              children: [
                Positioned.fill(
                  child: IndexedStack(
                    index: _index,
                    children: [
                      HomeTab(onSeeAll: () => _go(1)),
                      const SearchTab(),
                      const FavoritesTab(),
                    ],
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: LuminaBottomNav(
                    currentIndex: _index,
                    onTap: _go,
                    items: items,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Clips [child] to the rounded book-page rectangle and draws the gold double
/// border on top, so all content stays neatly inside the frame.
class _BookPageFrame extends StatelessWidget {
  final Widget child;
  const _BookPageFrame({required this.child});

  @override
  Widget build(BuildContext context) {
    final tokens = context.lumina;
    return Stack(
      children: [
        // Content, clipped to the frame and bordered on top.
        Positioned.fill(
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
            foregroundDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: tokens.frame, width: 1.4),
            ),
            child: child,
          ),
        ),
        // Inner hairline border.
        Positioned.fill(
          child: IgnorePointer(
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(26),
                  border: Border.all(color: tokens.frame2, width: 1),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
