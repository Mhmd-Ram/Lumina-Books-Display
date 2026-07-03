import 'package:flutter/material.dart';

import 'login_page.dart';
import 'signup_page.dart';

/// The signed-out step of the app: shows either Login or Sign-up and lets the
/// two cross-link into each other. The parent gate only cares whether the user
/// is authenticated, so this owns the local login⇄signup toggle.
class AuthFlow extends StatefulWidget {
  const AuthFlow({super.key});

  @override
  State<AuthFlow> createState() => _AuthFlowState();
}

class _AuthFlowState extends State<AuthFlow> {
  bool _showLogin = true;

  void _toggle(bool showLogin) => setState(() => _showLogin = showLogin);

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: _showLogin
          ? LoginPage(
              key: const ValueKey('login'),
              onGoSignup: () => _toggle(false),
            )
          : SignupPage(
              key: const ValueKey('signup'),
              onGoLogin: () => _toggle(true),
            ),
    );
  }
}
