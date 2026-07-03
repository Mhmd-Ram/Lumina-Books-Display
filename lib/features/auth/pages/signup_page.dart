import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/lumina_context.dart';
import '../../../core/widgets/lumina_primary_button.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/google_button.dart';

/// Registration screen. Phase 1 wires the buttons to the mock [AuthProvider];
/// Phase 2 swaps those calls for real Firebase Auth (plus validation + errors).
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

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    context.read<AuthProvider>().signUp(
      name: _name.text,
      email: _email.text,
      password: _password.text,
    );
  }

  void _google() => context.read<AuthProvider>().signInWithGoogle();

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
        LuminaPrimaryButton(label: s.signUp, onPressed: _submit),
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
