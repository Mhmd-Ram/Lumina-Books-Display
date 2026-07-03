import 'package:flutter/material.dart';

import '../theme/lumina_context.dart';

/// The Lumina "book page" frame: clips [child] to a rounded rectangle and draws
/// the gold double border on top, so all content stays neatly inside the frame.
///
/// Used by the main [LuminaShell] and by the standalone onboarding / login /
/// sign-up screens, so every full-screen surface shares the same gold-edged
/// parchment page (matching the design comp, which frames every screen).
class BookPageFrame extends StatelessWidget {
  final Widget child;
  const BookPageFrame({super.key, required this.child});

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
