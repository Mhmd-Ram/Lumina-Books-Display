import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/theme/lumina_context.dart';
import '../../../core/widgets/book_page_frame.dart';
import '../../../core/widgets/compass_medallion.dart';

/// Shared chrome for the Login and Sign-up screens: the gold book-page frame,
/// a scrollable padded column (so fields stay reachable with the keyboard up),
/// and a consistent content inset. Screens supply their own [children].
class AuthScaffold extends StatelessWidget {
  final List<Widget> children;
  const AuthScaffold({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    final tokens = context.lumina;
    return Scaffold(
      backgroundColor: tokens.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: BookPageFrame(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(30, 40, 30, 34),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: children,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The floating compass mark + serif title + soft subtitle shown at the top of
/// both auth screens.
class AuthHeader extends StatefulWidget {
  final String title;
  final String subtitle;
  const AuthHeader({super.key, required this.title, required this.subtitle});

  @override
  State<AuthHeader> createState() => _AuthHeaderState();
}

class _AuthHeaderState extends State<AuthHeader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _float = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 4400),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _float.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.lumina;
    return Column(
      children: [
        AnimatedBuilder(
          animation: _float,
          builder: (context, child) => Transform.translate(
            offset: Offset(0, -6 * math.sin(_float.value * math.pi)),
            child: child,
          ),
          child: const CompassMedallion(size: 66),
        ),
        const SizedBox(height: 22),
        Text(
          widget.title,
          textAlign: TextAlign.center,
          style: context.serif(
            fontSize: 32,
            fontWeight: FontWeight.w600,
            color: tokens.ink,
            height: context.isArabic ? 1.35 : 1.05,
            letterSpacing: context.isArabic ? null : -0.4,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          widget.subtitle,
          textAlign: TextAlign.center,
          style: context.sans(
            fontSize: 14.5,
            fontWeight: FontWeight.w500,
            color: tokens.soft,
          ),
        ),
      ],
    );
  }
}

/// A horizontal rule with a centered "or" label.
class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.lumina;
    final line = Expanded(child: Container(height: 1, color: tokens.line));
    return Row(
      children: [
        line,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Text(
            context.strings.orDivider.toUpperCase(),
            style: context.sans(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: tokens.faint,
              letterSpacing: context.eyebrowTracking(12) * 0.5,
            ),
          ),
        ),
        line,
      ],
    );
  }
}

/// Footer prompt: soft text followed by an accent-colored action link.
class AuthFooterLink extends StatelessWidget {
  final String prompt;
  final String action;
  final VoidCallback onTap;

  const AuthFooterLink({
    super.key,
    required this.prompt,
    required this.action,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.lumina;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          prompt,
          style: context.sans(
            fontSize: 14.5,
            fontWeight: FontWeight.w500,
            color: tokens.soft,
          ),
        ),
        const SizedBox(width: 5),
        GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: Text(
            action,
            style: context.sans(
              fontSize: 14.5,
              fontWeight: FontWeight.w800,
              color: tokens.accent,
            ),
          ),
        ),
      ],
    );
  }
}
