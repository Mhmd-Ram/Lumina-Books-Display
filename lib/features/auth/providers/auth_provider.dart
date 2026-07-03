import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../../../core/settings/prefs_store.dart';
import '../services/auth_service.dart';

/// App auth + first-launch state (Provider), backed by Firebase Auth.
///
/// It subscribes to [AuthService.authState], so a returning user is auto-logged
/// in straight to the shell and a sign-out returns to Login. The public surface
/// is unchanged from the Phase 1 mock, so the auth screens did not change shape
/// — the method bodies just delegate to [AuthService] now, and failures surface
/// as [AuthFailure] for the pages to message.
class AuthProvider extends ChangeNotifier {
  AuthProvider(this._service, this._prefs) {
    _onboardingSeen = _prefs.onboardingSeen;
    _sub = _service.authState().listen(_onAuthChanged);
  }

  final AuthService _service;
  final PrefsStore _prefs;
  StreamSubscription<User?>? _sub;

  bool _onboardingSeen = false;
  bool _isAuthenticated = false;
  String? _displayName;
  String _email = '';

  /// Whether onboarding has ever been completed/skipped (persisted).
  bool get onboardingSeen => _onboardingSeen;

  /// Whether a user is signed in — drives the gate between Login and the shell.
  bool get isAuthenticated => _isAuthenticated;

  /// Display name for the Settings profile card (falls back to "Reader").
  String get displayName =>
      (_displayName != null && _displayName!.trim().isNotEmpty)
      ? _displayName!.trim()
      : 'Reader';

  /// The signed-in account's email (empty when signed out).
  String get email => _email;

  /// First letter for the profile avatar.
  String get initial => displayName[0].toUpperCase();

  void _onAuthChanged(User? user) {
    _isAuthenticated = user != null;
    _email = user?.email ?? '';
    final name = user?.displayName;
    _displayName = (name != null && name.trim().isNotEmpty)
        ? name
        : (user?.email != null ? _nameFromEmail(user!.email!) : null);
    notifyListeners();
  }

  Future<void> completeOnboarding() async {
    if (_onboardingSeen) return;
    _onboardingSeen = true;
    notifyListeners();
    await _prefs.setOnboardingSeen(true);
  }

  /// Sign in with email/password. Throws [AuthFailure] on error.
  Future<void> signIn({required String email, required String password}) =>
      _service.signIn(email: email.trim(), password: password);

  /// Register a new account. Throws [AuthFailure] on error.
  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) => _service.signUp(
    name: name.trim(),
    email: email.trim(),
    password: password,
  );

  /// Google Sign-In. Silently no-ops if the user dismisses the picker; throws
  /// [AuthFailure] on a real error.
  Future<void> signInWithGoogle() => _service.signInWithGoogle();

  /// Send a password-reset email. Throws [AuthFailure] on error.
  Future<void> sendPasswordReset(String email) =>
      _service.sendPasswordReset(email.trim());

  Future<void> signOut() => _service.signOut();

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  /// Turns "amina.reader@example.com" into a friendly "Amina Reader" when the
  /// account has no display name (e.g. an email/password signup we couldn't
  /// name yet).
  static String _nameFromEmail(String email) {
    final local = email.split('@').first;
    final words = local
        .split(RegExp(r'[._\-+]+'))
        .where((w) => w.isNotEmpty)
        .map((w) => '${w[0].toUpperCase()}${w.substring(1)}');
    final name = words.join(' ');
    return name.isEmpty ? 'Reader' : name;
  }
}
