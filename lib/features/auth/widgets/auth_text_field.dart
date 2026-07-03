import 'package:flutter/material.dart';

import '../../../core/theme/lumina_context.dart';

/// A Lumina-styled labeled input: an uppercase soft label above a rounded card
/// field with a leading icon; the border warms to the gold accent while focused.
/// Password fields get a show/hide eye toggle. Matches the auth design comp.
class AuthTextField extends StatefulWidget {
  final String label;
  final String hint;
  final IconData icon;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;

  /// Password mode: obscures text and shows the eye toggle.
  final bool isPassword;
  final bool obscure;
  final VoidCallback? onToggleObscure;
  final ValueChanged<String>? onSubmitted;

  const AuthTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.icon,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.isPassword = false,
    this.obscure = false,
    this.onToggleObscure,
    this.onSubmitted,
  });

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  final _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocusChange);
  }

  void _onFocusChange() => setState(() {});

  @override
  void dispose() {
    _focus.removeListener(_onFocusChange);
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.lumina;
    final focused = _focus.hasFocus;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label.toUpperCase(),
          style: context.sans(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: tokens.soft,
            letterSpacing: context.eyebrowTracking(12) * 0.3,
          ),
        ),
        const SizedBox(height: 8),
        AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: 56,
          padding: const EdgeInsetsDirectional.only(start: 16, end: 12),
          decoration: BoxDecoration(
            color: tokens.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: focused ? tokens.accent : tokens.line,
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Icon(widget.icon, size: 19, color: tokens.faint),
              const SizedBox(width: 11),
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  focusNode: _focus,
                  keyboardType: widget.keyboardType,
                  textInputAction: widget.textInputAction,
                  obscureText: widget.isPassword && widget.obscure,
                  onSubmitted: widget.onSubmitted,
                  cursorColor: tokens.accent,
                  style: context.sans(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: tokens.ink,
                  ),
                  decoration: InputDecoration(
                    isCollapsed: true,
                    border: InputBorder.none,
                    hintText: widget.hint,
                    hintStyle: context.sans(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: tokens.faint,
                    ),
                  ),
                ),
              ),
              if (widget.isPassword)
                GestureDetector(
                  onTap: widget.onToggleObscure,
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      widget.obscure
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      size: 19,
                      color: tokens.faint,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
