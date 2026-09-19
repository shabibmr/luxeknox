import 'package:dio/dio.dart';

import '../storage/token_storage.dart';

/// Attaches `Authorization: Bearer <token>` to outgoing requests using the
/// access token from [TokenStorage], except for requests to the login and
/// refresh endpoints which must not carry a (possibly stale) token.
class AuthInterceptor extends InterceptorsWrapper {
  AuthInterceptor(this._tokenStorage);

  final TokenStorage _tokenStorage;

  static const List<String> _excludedPaths = ['/auth/login', '/auth/refresh'];

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (_excludedPaths.contains(options.path)) {
      handler.next(options);
      return;
    }

    final token = await _tokenStorage.readAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }
}
