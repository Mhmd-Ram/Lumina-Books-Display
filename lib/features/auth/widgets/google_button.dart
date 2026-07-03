import 'package:flutter/material.dart';

import '../../../core/theme/lumina_context.dart';
import '../../../core/widgets/google_g.dart';

/// "Continue with Google" button — a card-colored pill with the Google mark and
/// a `line` border, matching the auth comp. Press scales it down slightly.
class GoogleButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;

  const GoogleButton({super.key, required this.label, required this.onPressed});

  @override
  State<GoogleButton> createState() => _GoogleButtonState();
}

class _GoogleButtonState extends State<GoogleButton> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed != value) setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.lumina;

    return GestureDetector(
      onTapDown: (_) => _setPressed(true),
      onTapCancel: () => _setPressed(false),
      onTapUp: (_) => _setPressed(false),
      onTap: widget.onPressed,
      child: AnimatedScale(
        scale: _pressed ? 0.98 : 1,
        duration: const Duration(milliseconds: 120),
        child: Container(
          height: 56,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: tokens.card,
            borderRadius: BorderRadius.circular(19),
            border: Border.all(color: tokens.line, width: 1.5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const GoogleG(size: 20),
              const SizedBox(width: 12),
              Text(
                widget.label,
                style: context.sans(
                  fontSize: 15.5,
                  fontWeight: FontWeight.w700,
                  color: tokens.ink,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
