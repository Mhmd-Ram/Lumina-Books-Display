import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/lumina_context.dart';
import '../../../core/widgets/lumina_primary_button.dart';
import '../auth_error_l10n.dart';
import '../providers/auth_provider.dart';
import '../services/auth_service.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/google_button.dart';

/// Basic email shape check for client-side validation before hitting Firebase.
final _emailRe = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

/// Sign-in screen, wired to Firebase Auth via [AuthProvider]: validates input,
/// shows a spinner while signing in, and surfaces localized errors. The app
/// gate switches to the shell automatically on the auth-state change.
class LoginPage extends StatefulWidget {
  /// Switches the auth flow to the Sign-up screen.
  final VoidCallback onGoSignup;
  const LoginPage({super.key, required this.onGoSignup});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;
  bool _busy = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _snack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  Future<void> _submit() async {
    if (_busy) return;
    FocusScope.of(context).unfocus();
    final s = context.strings;
    final email = _email.text.trim();
    final password = _password.text;

    final error = email.isEmpty
        ? s.enterEmail
        : !_emailRe.hasMatch(email)
        ? s.invalidEmail
        : password.isEmpty
        ? s.enterPassword
        : null;
    if (error != null) {
      _snack(error);
      return;
    }

    final auth = context.read<AuthProvider>();
    setState(() => _busy = true);
    try {
      await auth.signIn(email: email, password: password);
      // The app gate switches to the shell on the auth-state change.
    } on AuthFailure catch (f) {
      if (mounted) _snack(f.type.message(s));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _google() async {
    if (_busy) return;
    final s = context.strings;
    final auth = context.read<AuthProvider>();
    setState(() => _busy = true);
    try {
      await auth.signInWithGoogle();
    } on AuthFailure catch (f) {
      if (mounted) _snack(f.type.message(s));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _forgot() async {
    final s = context.strings;
    final email = _email.text.trim();
    if (email.isEmpty || !_emailRe.hasMatch(email)) {
      _snack(s.invalidEmail);
      return;
    }
    final auth = context.read<AuthProvider>();
    try {
      await auth.sendPasswordReset(email);
      if (mounted) _snack(s.resetSent);
    } on AuthFailure catch (f) {
      if (mounted) _snack(f.type.message(s));
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = context.strings;
    final tokens = context.lumina;

    return AuthScaffold(
      children: [
        AuthHeader(title: s.welcomeBack, subtitle: s.loginSub),
        const SizedBox(height: 30),
        AuthTextField(
          label: s.email,
          hint: s.emailHint,
          icon: Icons.mail_outline,
          controller: _email,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 14),
        AuthTextField(
          label: s.password,
          hint: s.passwordHintLogin,
          icon: Icons.lock_outline,
          controller: _password,
          isPassword: true,
          obscure: _obscure,
          textInputAction: TextInputAction.done,
          onToggleObscure: () => setState(() => _obscure = !_obscure),
          onSubmitted: (_) => _submit(),
        ),
        const SizedBox(height: 10),
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: GestureDetector(
            onTap: _forgot,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Text(
                s.forgotPassword,
                style: context.sans(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: tokens.accent,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        LuminaPrimaryButton(label: s.logIn, loading: _busy, onPressed: _submit),
        const SizedBox(height: 22),
        const OrDivider(),
        const SizedBox(height: 22),
        GoogleButton(label: s.continueGoogle, onPressed: _google),
        const SizedBox(height: 26),
        AuthFooterLink(
          prompt: s.newToLumina,
          action: s.createAccount,
          onTap: widget.onGoSignup,
        ),
      ],
    );
  }
}
