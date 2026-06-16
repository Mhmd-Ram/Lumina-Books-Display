import 'package:flutter/material.dart';

import '../../../core/theme/lumina_context.dart';

/// A section header row — a serif title with an optional gold "See all" action.
class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  const SectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.lumina;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Text(
            title,
            style: context.serif(
              fontSize: 21,
              fontWeight: FontWeight.w600,
              color: tokens.ink,
              letterSpacing: context.isArabic ? null : -0.2,
            ),
          ),
        ),
        if (actionLabel != null && onAction != null)
          GestureDetector(
            onTap: onAction,
            behavior: HitTestBehavior.opaque,
            child: Text(
              actionLabel!,
              style: context.sans(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: tokens.accent,
              ),
            ),
          ),
      ],
    );
  }
}
