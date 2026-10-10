import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';

abstract class FirebaseAuthService {
  /// Initiates Google Sign-In across supported platforms (Web popup, native Android/iOS).
  ///
  /// Returns [UserCredential] on successful authentication, or `null` if the
  /// user dismissed or cancelled the sign-in prompt.
  Future<UserCredential?> signInWithGoogle();

  /// Signs the user out of both Firebase Auth and GoogleSignIn.
  Future<void> signOut();
}

/// Native Google Sign-In plugin. Web uses Firebase popup instead: constructing
/// [GoogleSignIn] on web starts an unawaited init that asserts when the OAuth
/// `client_id` meta tag is missing, which breaks password-admin staff flows
/// (including selling PT) that never use Google signup.
GoogleSignIn? googleSignInForPlatform({
  bool? isWeb,
  TargetPlatform? platform,
}) {
  final web = isWeb ?? kIsWeb;
  final target = platform ?? defaultTargetPlatform;
  if (web) return null;
  if (target != TargetPlatform.android && target != TargetPlatform.iOS) {
    return null;
  }
  return GoogleSignIn();
}

@LazySingleton(as: FirebaseAuthService)
class FirebaseAuthServiceImpl implements FirebaseAuthService {
  FirebaseAuthServiceImpl()
    : firebaseAuth = null,
      _googleSignIn = googleSignInForPlatform();

  @visibleForTesting
  FirebaseAuthServiceImpl.forTesting({
    this.firebaseAuth,
    GoogleSignIn? googleSignIn,
  }) : _googleSignIn = googleSignIn;

  final FirebaseAuth? firebaseAuth;

  // One instance for the service's lifetime. signIn and signOut must act on the
  // same GoogleSignIn, otherwise sign-out clears a different client's session.
  // Null when the plugin is skipped (web / desktop / missing client_id).
  final GoogleSignIn? _googleSignIn;

  FirebaseAuth get _auth => firebaseAuth ?? FirebaseAuth.instance;

  @override
  Future<UserCredential?> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        final googleProvider = GoogleAuthProvider();
        return await _auth.signInWithPopup(googleProvider);
      } else {
        final google = _googleSignIn;
        if (google == null) {
          // No native client_id / plugin — password login must still work.
          return null;
        }
        final googleUser = await google.signIn();
        if (googleUser == null) {
          // User cancelled the native sign-in dialog
          return null;
        }

        final googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        return await _auth.signInWithCredential(credential);
      }
    } on FirebaseAuthException catch (e) {
      // User closed popup or cancelled request
      if (e.code == 'popup-closed-by-user' ||
          e.code == 'cancelled-popup-request') {
        return null;
      }
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    final google = _googleSignIn;
    await Future.wait([
      if (firebaseAuth != null || Firebase.apps.isNotEmpty) _auth.signOut(),
      if (google != null) google.signOut(),
    ]);
  }
}
