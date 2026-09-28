/// UI strings for splash, login, and sign-out.
abstract final class AuthStrings {
  static const signInTitle = 'Sign in';
  static const emailOrPhone = 'Email or phone';
  static const password = 'Password';
  static const signIn = 'Sign in';
  static const signOut = 'Sign out';
  static const signOutConfirm = 'Are you sure you want to sign out?';
  static const cancel = 'Cancel';
  static const forgotPassword = 'Forgot password?';
  static const forgotPasswordTitle = 'Reset password';
  static const sendResetLink = 'Send reset link';
  static const resetLinkSent =
      'If an account exists for that email or phone, a reset link was sent.';
  static const resetPasswordTitle = 'Set new password';
  static const resetToken = 'Reset token';
  static const newPassword = 'New password';
  static const confirmPassword = 'Confirm password';
  static const saveNewPassword = 'Save new password';
  static const changePassword = 'Change password';
  static const changePasswordTitle = 'Change password';
  static const currentPassword = 'Current password';
  static const passwordChanged = 'Password updated.';
  static const passwordsDoNotMatch = 'Passwords do not match.';
  static const passwordTooShort = 'Password must be at least 8 characters.';

  static const enterEmailOrPhone = 'Enter your email or phone.';
  static const enterPassword = 'Enter your password.';
  static const enterCredentials =
      'Enter your email or phone and your password.';
  static const enterResetToken =
      'Enter the reset token from your email or SMS.';

  /// FR-AUTH-002 — identical for wrong password, unknown user, and suspended.
  static const incorrectCredentials = 'Incorrect email/phone or password.';
  static const rateLimited =
      'Too many attempts. Please wait a moment and try again.';
  static const networkError =
      'Network error. Please check your connection and try again.';
  static const genericError = 'Something went wrong. Please try again.';
}
