import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/lumina_context.dart';
import '../../../core/widgets/lumina_primary_button.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/google_button.dart';

/// Sign-in screen. Phase 1 wires the buttons to the mock [AuthProvider]; Phase 2
/// swaps those calls for real Firebase Auth (plus validation + error messages).
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

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    context.read<AuthProvider>().signIn(
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
            onTap: () {}, // Static in Phase 1.
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
        LuminaPrimaryButton(label: s.logIn, onPressed: _submit),
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
