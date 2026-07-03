import 'package:flutter/material.dart';

import '../theme/lumina_context.dart';

/// The Lumina primary call-to-action: a gold-gradient pill with white bold text
/// and a soft warm shadow, that scales down slightly while pressed. Used by the
/// onboarding CTA and the Login / Sign-up submit buttons (matches the comp's
/// `primaryBtn`: `linear-gradient(135deg,#E7C56B 0%,#A97C2E 100%)`).
class LuminaPrimaryButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;

  /// When true, the button shows a spinner instead of the label and ignores
  /// taps — used while an async submit (login / sign-up) is in flight.
  final bool loading;

  const LuminaPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
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
    // The button looks solid (full opacity) whenever it has an action; the
    // spinner alone signals the in-flight state. Taps are ignored while loading.
    final hasAction = widget.onPressed != null;
    final enabled = hasAction && !widget.loading;

    return GestureDetector(
      onTapDown: enabled ? (_) => _setPressed(true) : null,
      onTapCancel: enabled ? () => _setPressed(false) : null,
      onTapUp: enabled ? (_) => _setPressed(false) : null,
      onTap: enabled ? widget.onPressed : null,
      child: AnimatedScale(
        scale: _pressed ? 0.98 : 1,
        duration: const Duration(milliseconds: 120),
        child: Opacity(
          opacity: hasAction ? 1 : 0.6,
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
            child: widget.loading
                ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.4,
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                  )
                : Text(
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
