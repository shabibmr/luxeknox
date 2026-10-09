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

@LazySingleton(as: FirebaseAuthService)
class FirebaseAuthServiceImpl implements FirebaseAuthService {
  FirebaseAuthServiceImpl()
    : firebaseAuth = null,
      _googleSignIn = GoogleSignIn();

  @visibleForTesting
  FirebaseAuthServiceImpl.forTesting({
    this.firebaseAuth,
    GoogleSignIn? googleSignIn,
  }) : _googleSignIn = googleSignIn ?? GoogleSignIn();

  final FirebaseAuth? firebaseAuth;

  // One instance for the service's lifetime. signIn and signOut must act on the
  // same GoogleSignIn, otherwise sign-out clears a different client's session.
  final GoogleSignIn _googleSignIn;

  FirebaseAuth get _auth => firebaseAuth ?? FirebaseAuth.instance;

  @override
  Future<UserCredential?> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        final googleProvider = GoogleAuthProvider();
        return await _auth.signInWithPopup(googleProvider);
      } else {
        final googleUser = await _googleSignIn.signIn();
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
    await Future.wait([
      if (firebaseAuth != null || Firebase.apps.isNotEmpty) _auth.signOut(),
      if (!kIsWeb) _googleSignIn.signOut(),
    ]);
  }
}
