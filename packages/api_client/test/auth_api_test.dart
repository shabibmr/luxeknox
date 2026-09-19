import 'package:test/test.dart';
import 'package:api_client/api_client.dart';


/// tests for AUTHApi
void main() {
  final instance = ApiClient().getAUTHApi();

  group(AUTHApi, () {
    // Change password; invalidates other sessions
    //
    //Future changePassword(ChangePasswordRequest changePasswordRequest) async
    test('test changePassword', () async {
      // TODO
    });

    // Request a password-reset token
    //
    //Future forgotPassword(ForgotPasswordRequest forgotPasswordRequest) async
    test('test forgotPassword', () async {
      // TODO
    });

    // Current user, role, permission slugs, profile summary
    //
    //Future<MeResponse> getMe() async
    test('test getMe', () async {
      // TODO
    });

    // Login with email or phone + password
    //
    //Future<SessionResponse> login(LoginRequest loginRequest) async
    test('test login', () async {
      // TODO
    });

    // Revoke current session
    //
    //Future logout(LogoutRequest logoutRequest) async
    test('test logout', () async {
      // TODO
    });

    // Rotate refresh token; reuse revokes the family
    //
    //Future<SessionResponse> refreshSession(RefreshRequest refreshRequest) async
    test('test refreshSession', () async {
      // TODO
    });

    // Consume a one-time reset token
    //
    //Future resetPassword(ResetPasswordRequest resetPasswordRequest) async
    test('test resetPassword', () async {
      // TODO
    });

  });
}
