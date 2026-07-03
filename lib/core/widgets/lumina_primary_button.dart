import 'package:flutter/material.dart';

import '../theme/lumina_context.dart';

/// The Lumina primary call-to-action: a gold-gradient pill with white bold text
/// and a soft warm shadow, that scales down slightly while pressed. Used by the
/// onboarding CTA and the Login / Sign-up submit buttons (matches the comp's
/// `primaryBtn`: `linear-gradient(135deg,#E7C56B 0%,#A97C2E 100%)`).
class LuminaPrimaryButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;

  const LuminaPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  State<LuminaPrimaryButton> createState() => _LuminaPrimaryButtonState();
}

class _LuminaPrimaryButtonState extends State<LuminaPrimaryButton> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed != value) setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null;

    return GestureDetector(
      onTapDown: enabled ? (_) => _setPressed(true) : null,
      onTapCancel: enabled ? () => _setPressed(false) : null,
      onTapUp: enabled ? (_) => _setPressed(false) : null,
      onTap: widget.onPressed,
      child: AnimatedScale(
        scale: _pressed ? 0.98 : 1,
        duration: const Duration(milliseconds: 120),
        child: Opacity(
          opacity: enabled ? 1 : 0.6,
          child: Container(
            height: 58,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(19),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFE7C56B), Color(0xFFA97C2E)],
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x99785620),
                  blurRadius: 34,
                  offset: Offset(0, 18),
                  spreadRadius: -14,
                ),
              ],
            ),
            child: Text(
              widget.label,
              style: context.sans(
                fontSize: 16.5,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
