import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// The categories of auth error the UI knows how to message. Kept as an enum
/// (not a raw string) so the localized text lives in the UI layer
/// (`auth_error_l10n.dart`) and this data layer stays free of user strings.
enum AuthErrorType {
  wrongCredentials,
  emailInUse,
  weakPassword,
  invalidEmail,
  network,
  tooManyRequests,
  userDisabled,
  unknown,
}

/// A normalized, user-actionable auth error. Callers never see Firebase types —
/// they catch this and resolve [type] to a localized message.
class AuthFailure implements Exception {
  final AuthErrorType type;
  const AuthFailure(this.type);

  @override
  String toString() => 'AuthFailure($type)';
}

/// Thin wrapper over [FirebaseAuth] and Google Sign-In exposing just the surface
/// the app needs. Every failure is normalized to [AuthFailure].
class AuthService {
  AuthService({FirebaseAuth? auth, GoogleSignIn? googleSignIn})
    : _auth = auth ?? FirebaseAuth.instance,
      _googleSignIn = googleSignIn ?? GoogleSignIn();

  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  /// Emits the signed-in [User] (or null) on every auth change. Driving the app
  /// gate off this stream is what auto-logs a returning user into the shell.
  ///
  /// Uses [FirebaseAuth.userChanges] (not `authStateChanges`) so it also fires
  /// after `updateDisplayName` — otherwise a fresh sign-up would show the
  /// email-derived name until the next launch.
  Stream<User?> authState() => _auth.userChanges();

  User? get currentUser => _auth.currentUser;

  Future<void> signIn({required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw AuthFailure(_map(e.code));
    }
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await cred.user?.updateDisplayName(name);
      await cred.user?.reload();
    } on FirebaseAuthException catch (e) {
      throw AuthFailure(_map(e.code));
    }
  }

  /// Runs the Google account-picker flow and signs in with the credential.
  /// Returns `false` (not an error) if the user dismisses the picker.
  Future<bool> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return false; // cancelled by the user
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _auth.signInWithCredential(credential);
      return true;
    } on FirebaseAuthException catch (e) {
      throw AuthFailure(_map(e.code));
    }
  }

  Future<void> sendPasswordReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw AuthFailure(_map(e.code));
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  /// Maps a [FirebaseAuthException.code] to an [AuthErrorType]. Unknown-user,
  /// wrong-password and invalid-credential collapse to one generic "wrong
  /// credentials" so we never reveal which of the two was wrong.
  AuthErrorType _map(String code) {
    switch (code) {
      case 'invalid-email':
        return AuthErrorType.invalidEmail;
      case 'user-disabled':
        return AuthErrorType.userDisabled;
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return AuthErrorType.wrongCredentials;
      case 'email-already-in-use':
        return AuthErrorType.emailInUse;
      case 'weak-password':
        return AuthErrorType.weakPassword;
      case 'network-request-failed':
        return AuthErrorType.network;
      case 'too-many-requests':
        return AuthErrorType.tooManyRequests;
      default:
        return AuthErrorType.unknown;
    }
  }
}
