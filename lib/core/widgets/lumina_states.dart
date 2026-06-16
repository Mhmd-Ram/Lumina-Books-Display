import 'package:flutter/material.dart';

import '../theme/lumina_context.dart';

/// Centered gold progress indicator, themed to the parchment/midnight palette.
class LuminaLoading extends StatelessWidget {
  const LuminaLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 30,
        height: 30,
        child: CircularProgressIndicator(
          strokeWidth: 2.6,
          color: context.lumina.accent,
        ),
      ),
    );
  }
}

/// Friendly error state with a retry action, styled with the design tokens.
class LuminaError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const LuminaError({super.key, required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final tokens = context.lumina;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off_rounded, size: 46, color: tokens.faint),
            const SizedBox(height: 14),
            Text(
              message,
              textAlign: TextAlign.center,
              style: context.sans(fontSize: 14, color: tokens.soft),
            ),
            const SizedBox(height: 18),
            GestureDetector(
              onTap: onRetry,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                decoration: BoxDecoration(
                  color: tokens.accent,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  'Retry',
                  style: context.sans(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: tokens.isDark ? const Color(0xFF14152A) : Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Empty-state with a serif headline and a sub-line (no results / no favourites).
class LuminaEmpty extends StatelessWidget {
  final Widget? icon;
  final String title;
  final String subtitle;

  const LuminaEmpty({
    super.key,
    this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.lumina;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[icon!, const SizedBox(height: 18)],
            Text(
              title,
              textAlign: TextAlign.center,
              style: context.serif(fontSize: 22, color: tokens.ink),
            ),
            const SizedBox(height: 7),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: context.sans(fontSize: 14, color: tokens.soft),
            ),
          ],
        ),
      ),
    );
  }
}
