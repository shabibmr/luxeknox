import 'package:api_client/api_client.dart' as api;
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

abstract class SessionRemoteDataSource {
  Future<api.SessionResponse> login(String identifier, String password);
  Future<void> logout(String refreshToken);
  Future<api.SessionResponse> refresh(String refreshToken);
  Future<api.MeResponse> getMe();
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });
  Future<void> forgotPassword(String identifier);
  Future<void> resetPassword({
    required String token,
    required String newPassword,
  });
}

@LazySingleton(as: SessionRemoteDataSource)
class SessionRemoteDataSourceImpl implements SessionRemoteDataSource {
  SessionRemoteDataSourceImpl(this._authApi);

  final api.AUTHApi _authApi;

  @override
  Future<api.SessionResponse> login(String identifier, String password) async {
    final request = api.LoginRequest((b) {
      b.password = password;
      if (identifier.contains('@')) {
        b.email = identifier;
      } else {
        b.phoneNumber = identifier;
      }
    });
    final response = await _authApi.login(loginRequest: request);
    final data = response.data;
    if (data == null) {
      throw DioException(
        requestOptions: response.requestOptions,
        type: DioExceptionType.badResponse,
        response: response,
      );
    }
    return data;
  }

  @override
  Future<void> logout(String _) async {
    // Session identified by bearer access token; body selects current vs all sessions.
    await _authApi.logout(
      logoutRequest: api.LogoutRequest((b) => b.all = false),
    );
  }

  @override
  Future<api.SessionResponse> refresh(String refreshToken) async {
    final request = api.RefreshRequest((b) {
      b.refreshToken = refreshToken;
    });
    final response = await _authApi.refreshSession(refreshRequest: request);
    final data = response.data;
    if (data == null) {
      throw DioException(
        requestOptions: response.requestOptions,
        type: DioExceptionType.badResponse,
        response: response,
      );
    }
    return data;
  }

  @override
  Future<api.MeResponse> getMe() async {
    final response = await _authApi.getMe();
    final data = response.data;
    if (data == null) {
      throw DioException(
        requestOptions: response.requestOptions,
        type: DioExceptionType.badResponse,
        response: response,
      );
    }
    return data;
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await _authApi.changePassword(
      changePasswordRequest: api.ChangePasswordRequest(
        (b) => b
          ..currentPassword = currentPassword
          ..newPassword = newPassword,
      ),
    );
  }

  @override
  Future<void> forgotPassword(String identifier) async {
    await _authApi.forgotPassword(
      forgotPasswordRequest: api.ForgotPasswordRequest((b) {
        if (identifier.contains('@')) {
          b.email = identifier;
        } else {
          b.phoneNumber = identifier;
        }
      }),
    );
  }

  @override
  Future<void> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    await _authApi.resetPassword(
      resetPasswordRequest: api.ResetPasswordRequest(
        (b) => b
          ..token = token
          ..newPassword = newPassword,
      ),
    );
  }
}
