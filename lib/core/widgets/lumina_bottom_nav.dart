import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/lumina_context.dart';

/// One destination in the bottom nav.
class LuminaNavItem {
  final IconData icon;
  final String label;
  const LuminaNavItem(this.icon, this.label);
}

/// The persistent, floating, blurred bottom navigation bar (Home / Search /
/// Favorites). The active tab shows a gold icon + label over a rounded
/// `accentSoft` pill; inactive tabs are `faint`.
class LuminaBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<LuminaNavItem> items;

  const LuminaBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.lumina;

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            height: 66,
            decoration: BoxDecoration(
              color: tokens.nav,
              borderRadius: BorderRadius.circular(26),
              border: Border.all(color: tokens.navline),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x4D181018),
                  blurRadius: 40,
                  offset: Offset(0, 18),
                  spreadRadius: -18,
                ),
              ],
            ),
            child: Row(
              children: [
                for (var i = 0; i < items.length; i++)
                  Expanded(
                    child: _NavButton(
                      item: items[i],
                      active: i == currentIndex,
                      onTap: () => onTap(i),
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

class _NavButton extends StatelessWidget {
  final LuminaNavItem item;
  final bool active;
  final VoidCallback onTap;

  const _NavButton({
    required this.item,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.lumina;
    final color = active ? tokens.accent : tokens.faint;

    return InkResponse(
      onTap: onTap,
      radius: 40,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            width: 46,
            height: 30,
            decoration: BoxDecoration(
              color: active ? tokens.accentSoft : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Icon(item.icon, size: 22, color: color),
          ),
          const SizedBox(height: 3),
          Text(
            item.label,
            style: context.sans(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
