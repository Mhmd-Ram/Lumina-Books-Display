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

/// Registration screen, wired to Firebase Auth via [AuthProvider]: validates
/// input, shows a spinner while creating the account, and surfaces localized
/// errors. The app gate switches to the shell on the auth-state change.
class SignupPage extends StatefulWidget {
  /// Switches the auth flow to the Login screen.
  final VoidCallback onGoLogin;
  const SignupPage({super.key, required this.onGoLogin});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;
  bool _busy = false;

  @override
  void dispose() {
    _name.dispose();
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
    final name = _name.text.trim();
    final email = _email.text.trim();
    final password = _password.text;

    final error = name.isEmpty
        ? s.enterName
        : email.isEmpty
        ? s.enterEmail
        : !_emailRe.hasMatch(email)
        ? s.invalidEmail
        : password.length < 6
        ? s.passwordTooShort
        : null;
    if (error != null) {
      _snack(error);
      return;
    }

    final auth = context.read<AuthProvider>();
    setState(() => _busy = true);
    try {
      await auth.signUp(name: name, email: email, password: password);
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

  @override
  Widget build(BuildContext context) {
    final s = context.strings;
    final tokens = context.lumina;

    return AuthScaffold(
      children: [
        AuthHeader(title: s.createYourAccount, subtitle: s.signupSub),
        const SizedBox(height: 30),
        AuthTextField(
          label: s.fullName,
          hint: s.fullNameHint,
          icon: Icons.person_outline,
          controller: _name,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 14),
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
          hint: s.passwordHintSignup,
          icon: Icons.lock_outline,
          controller: _password,
          isPassword: true,
          obscure: _obscure,
          textInputAction: TextInputAction.done,
          onToggleObscure: () => setState(() => _obscure = !_obscure),
          onSubmitted: (_) => _submit(),
        ),
        const SizedBox(height: 22),
        LuminaPrimaryButton(label: s.signUp, loading: _busy, onPressed: _submit),
        const SizedBox(height: 22),
        const OrDivider(),
        const SizedBox(height: 22),
        GoogleButton(label: s.continueGoogle, onPressed: _google),
        const SizedBox(height: 26),
        AuthFooterLink(
          prompt: s.alreadyHaveAccount,
          action: s.logIn,
          onTap: widget.onGoLogin,
        ),
        const SizedBox(height: 18),
        Text(
          s.tos,
          textAlign: TextAlign.center,
          style: context.sans(
            fontSize: 11.5,
            fontWeight: FontWeight.w500,
            color: tokens.faint,
            height: 1.55,
          ),
        ),
      ],
    );
  }
}
