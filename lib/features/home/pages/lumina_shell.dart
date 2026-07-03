import 'package:flutter/material.dart';

import '../../../core/theme/lumina_context.dart';
import '../../../core/widgets/book_page_frame.dart';
import '../../../core/widgets/lumina_bottom_nav.dart';
import '../../favorites/pages/favorites_tab.dart';
import '../../search/pages/search_tab.dart';
import '../../settings/pages/settings_tab.dart';
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
      LuminaNavItem(Icons.settings_outlined, s.navSettings),
    ];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: BookPageFrame(
            child: Stack(
              children: [
                Positioned.fill(
                  child: IndexedStack(
                    index: _index,
                    children: [
                      HomeTab(onSeeAll: () => _go(1)),
                      const SearchTab(),
                      const FavoritesTab(),
                      const SettingsTab(),
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

