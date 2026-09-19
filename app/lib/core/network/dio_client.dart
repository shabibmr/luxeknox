import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

import '../config/app_config.dart';
import '../error/failures.dart';
import '../storage/token_storage.dart';
import 'auth_interceptor.dart';
import 'error_interceptor.dart';
import 'logging_interceptor.dart';
import 'refresh_interceptor.dart';

/// Builds a [Dio] client configured with the app's base URL and timeouts.
Dio createDioClient(AppConfig config) {
  return Dio(
    BaseOptions(
      baseUrl: config.apiBaseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 20),
      contentType: 'application/json',
    ),
  );
}

/// Assembles the interceptor chain in the required order:
/// auth -> refresh -> error -> logging.
Dio configureDioClient({
  required AppConfig config,
  required TokenStorage tokenStorage,
  required Future<Either<Failure, void>> Function() onRefreshToken,
  required void Function() onSignedOut,
  void Function(String message, {Object? error})? logFunction,
}) {
  final dio = createDioClient(config);

  dio.interceptors.addAll([
    AuthInterceptor(tokenStorage),
    RefreshInterceptor(
      refresh: onRefreshToken,
      dio: dio,
      onSignedOut: onSignedOut,
    ),
    ErrorInterceptor(),
    LoggingInterceptor(
      logFunction:
          (
            msg, {
            error,
            level = 0,
            name = '',
            sequenceNumber,
            stackTrace,
            time,
          }) {
            if (logFunction != null) {
              logFunction(msg);
            }
          },
    ),
  ]);

  return dio;
}
