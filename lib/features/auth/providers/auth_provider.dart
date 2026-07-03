import 'package:flutter/foundation.dart';

/// App auth + first-launch state (Provider).
///
/// Phase 1 is a **mock**: the methods just flip local flags so the whole flow
/// (onboarding → login/sign-up → home → log out) is navigable without a backend.
/// The public surface is shaped to match Firebase Auth, so Phase 2 can replace
/// the bodies with real `FirebaseAuth` calls (and `authStateChanges` for
/// auto-login) without changing any screen.
class AuthProvider extends ChangeNotifier {
  bool _onboardingSeen = false;
  bool _isAuthenticated = false;
  String? _displayName;
  String _email = '';

  /// Whether the onboarding slides have been completed/skipped this session.
  /// (Phase 2 persists this via `shared_preferences` so it is truly once-only.)
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

  void completeOnboarding() {
    if (_onboardingSeen) return;
    _onboardingSeen = true;
    notifyListeners();
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    _email = email.trim();
    _displayName = _nameFromEmail(_email);
    _isAuthenticated = true;
    notifyListeners();
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    _email = email.trim();
    _displayName = name.trim().isEmpty ? _nameFromEmail(_email) : name.trim();
    _isAuthenticated = true;
    notifyListeners();
  }

  Future<void> signInWithGoogle() async {
    _email = 'reader@gmail.com';
    _displayName = 'Amina Reader';
    _isAuthenticated = true;
    notifyListeners();
  }

  Future<void> signOut() async {
    // Keep [onboardingSeen] true — logging out returns to Login, not onboarding.
    _isAuthenticated = false;
    _displayName = null;
    _email = '';
    notifyListeners();
  }

  /// Turns "amina.reader@example.com" into a friendly "Amina Reader".
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
