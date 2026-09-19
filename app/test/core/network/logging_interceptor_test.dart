import 'package:app/core/network/logging_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

class _CapturingErrorHandler extends ErrorInterceptorHandler {
  DioException? error;

  @override
  void next(DioException err) {
    error = err;
  }

  @override
  void resolve(Response<dynamic> response) {}

  @override
  void reject(DioException err, [bool trueOnError = false]) {
    error = err;
  }
}

void main() {
  group('LoggingInterceptor', () {
    test('logs method, path, status, and request_id on failure', () {
      final logs = <String>[];
      Object? capturedError;
      final interceptor = LoggingInterceptor(
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
              logs.add(msg);
              capturedError = error;
            },
      );

      final requestOptions = RequestOptions(
        path: '/exercises/42',
        method: 'GET',
        headers: {'Authorization': 'Bearer secret-access-token-12345'},
      );

      final dioException = DioException(
        requestOptions: requestOptions,
        response: Response(
          requestOptions: requestOptions,
          statusCode: 404,
          data: {
            'code': 'not_found',
            'message': 'Exercise not found',
            'request_id': 'req_xyz987',
          },
        ),
      );

      final handler = _CapturingErrorHandler();
      interceptor.onError(dioException, handler);

      expect(logs.length, 1);
      final logLine = logs.first;
      expect(logLine, contains('GET'));
      expect(logLine, contains('/exercises/42'));
      expect(logLine, contains('404'));
      expect(logLine, contains('req_xyz987'));
      expect(logLine.contains('secret-access-token-12345'), isFalse);
      expect(capturedError, isNull);
      expect(handler.error, equals(dioException));
    });

    test(
      'never logs tokens even if present in headers or query parameters',
      () {
        final logs = <String>[];
        Object? capturedError;
        final interceptor = LoggingInterceptor(
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
                logs.add(msg);
                capturedError = error;
              },
        );

        final requestOptions = RequestOptions(
          path: '/auth/login',
          method: 'POST',
          headers: {'Authorization': 'Bearer super-secret-token'},
        );

        final dioException = DioException(
          requestOptions: requestOptions,
          response: Response(
            requestOptions: requestOptions,
            statusCode: 400,
            data: {
              'code': 'validation_error',
              'message': 'Invalid credentials',
            },
          ),
        );

        final handler = _CapturingErrorHandler();
        interceptor.onError(dioException, handler);

        expect(logs.length, 1);
        final logLine = logs.first;
        expect(logLine.contains('super-secret-token'), isFalse);
        expect(capturedError, isNull);
        expect(handler.error, equals(dioException));
      },
    );
  });
}
