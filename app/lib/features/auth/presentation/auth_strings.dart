/// UI strings for splash, login, and sign-out.
abstract final class AuthStrings {
  static const signInTitle = 'Sign in';
  static const emailOrPhone = 'Email or phone';
  static const password = 'Password';
  static const signIn = 'Sign in';
  static const signOut = 'Sign out';
  static const signOutConfirm = 'Are you sure you want to sign out?';
  static const cancel = 'Cancel';

  static const enterEmailOrPhone = 'Enter your email or phone.';
  static const enterPassword = 'Enter your password.';
  static const enterCredentials =
      'Enter your email or phone and your password.';

  /// FR-AUTH-002 — identical for wrong password, unknown user, and suspended.
  static const incorrectCredentials = 'Incorrect email/phone or password.';
  static const rateLimited =
      'Too many attempts. Please wait a moment and try again.';
  static const networkError =
      'Network error. Please check your connection and try again.';
  static const genericError = 'Something went wrong. Please try again.';
}
