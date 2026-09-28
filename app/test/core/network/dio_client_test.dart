import 'dart:convert';
import 'dart:typed_data';

import 'package:luxeknox/core/config/app_config.dart';
import 'package:luxeknox/core/network/auth_interceptor.dart';
import 'package:luxeknox/core/network/dio_client.dart';
import 'package:luxeknox/core/network/error_interceptor.dart';
import 'package:luxeknox/core/network/logging_interceptor.dart';
import 'package:luxeknox/core/network/refresh_interceptor.dart';
import 'package:luxeknox/core/storage/token_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockTokenStorage extends Mock implements TokenStorage {}

class _MockHttpAdapter implements HttpClientAdapter {
  _MockHttpAdapter(this.handler);

  final Future<ResponseBody> Function(RequestOptions options) handler;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) {
    return handler(options);
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  group('createDioClient', () {
    test('uses the base URL from AppConfig', () {
      const config = AppConfig(
        apiBaseUrl: 'https://stub.example.com',
        environment: AppEnvironment.dev,
      );

      final dio = createDioClient(config);

      expect(dio.options.baseUrl, 'https://stub.example.com');
    });

    test('configures the expected timeouts and content type', () {
      const config = AppConfig(
        apiBaseUrl: 'https://stub.example.com',
        environment: AppEnvironment.dev,
      );

      final dio = createDioClient(config);

      expect(dio.options.connectTimeout, const Duration(seconds: 15));
      expect(dio.options.receiveTimeout, const Duration(seconds: 20));
      expect(dio.options.contentType, 'application/json');
    });
  });

  group('configureDioClient (interceptor chain assembly)', () {
    test(
      'assembles interceptors in order: auth -> refresh -> error -> logging',
      () {
        final tokenStorage = MockTokenStorage();
        const config = AppConfig(
          apiBaseUrl: 'https://stub.example.com',
          environment: AppEnvironment.dev,
        );

        final dio = configureDioClient(
          config: config,
          tokenStorage: tokenStorage,
          onRefreshToken: () async => const Right(null),
          onSignedOut: () {},
        );

        final customInterceptors = dio.interceptors
            .where(
              (i) =>
                  i is AuthInterceptor ||
                  i is RefreshInterceptor ||
                  i is ErrorInterceptor ||
                  i is LoggingInterceptor,
            )
            .toList();

        expect(customInterceptors.length, 4);
        expect(customInterceptors[0], isA<AuthInterceptor>());
        expect(customInterceptors[1], isA<RefreshInterceptor>());
        expect(customInterceptors[2], isA<ErrorInterceptor>());
        expect(customInterceptors[3], isA<LoggingInterceptor>());
      },
    );

    test(
      'forced 401 triggers refresh, updates auth header, and retry succeeds',
      () async {
        final tokenStorage = MockTokenStorage();
        var accessToken = 'initial-stale-token';
        var refreshCount = 0;

        when(
          () => tokenStorage.readAccessToken(),
        ).thenAnswer((_) async => accessToken);

        const config = AppConfig(
          apiBaseUrl: 'https://stub.example.com',
          environment: AppEnvironment.dev,
        );

        final dio = configureDioClient(
          config: config,
          tokenStorage: tokenStorage,
          onRefreshToken: () async {
            refreshCount++;
            accessToken = 'fresh-refreshed-token';
            return const Right(null);
          },
          onSignedOut: () {},
        );

        dio.httpClientAdapter = _MockHttpAdapter((options) async {
          final authHeader = options.headers['Authorization'];
          if (authHeader == 'Bearer fresh-refreshed-token') {
            return ResponseBody.fromString(
              jsonEncode({'result': 'success_after_refresh'}),
              200,
              headers: {
                Headers.contentTypeHeader: [Headers.jsonContentType],
              },
            );
          } else {
            return ResponseBody.fromString(
              jsonEncode({
                'code': 'unauthenticated',
                'message': 'Token expired',
              }),
              401,
              headers: {
                Headers.contentTypeHeader: [Headers.jsonContentType],
              },
            );
          }
        });

        final response = await dio.get<Map<String, dynamic>>(
          '/protected-resource',
        );

        expect(refreshCount, 1);
        expect(response.statusCode, 200);
        expect(response.data?['result'], 'success_after_refresh');
      },
    );
  });
}
