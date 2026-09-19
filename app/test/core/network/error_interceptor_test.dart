import 'dart:convert';

import 'package:app/core/error/failures.dart';
import 'package:app/core/network/error_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

/// A fake [HttpClientAdapter] that always returns the given status/body,
/// so [Dio] surfaces a real [DioException] of type [DioExceptionType.badResponse]
/// through its normal error-handling path (running interceptors, unlike
/// constructing a [DioException] by hand).
class _ThrowingAdapter implements HttpClientAdapter {
  _ThrowingAdapter({required this.statusCode, required this.body});

  final int statusCode;
  final Map<String, Object?> body;

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final bytes = utf8.encode(jsonEncode(body));
    return ResponseBody.fromBytes(
      bytes,
      statusCode,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }
}

DioException _httpError({required int status, Map<String, Object?>? body}) {
  final requestOptions = RequestOptions(path: '/exercises');
  return DioException(
    requestOptions: requestOptions,
    type: DioExceptionType.badResponse,
    response: Response(
      requestOptions: requestOptions,
      statusCode: status,
      data: body,
    ),
  );
}

DioException _connectionError(DioExceptionType type) {
  return DioException(
    requestOptions: RequestOptions(path: '/exercises'),
    type: type,
  );
}

void main() {
  group('mapDioErrorToFailure — FRD §5.2 codes', () {
    test('validation_error -> ValidationFailure with details', () {
      final failure = mapDioErrorToFailure(
        _httpError(
          status: 400,
          body: {
            'code': 'validation_error',
            'message': 'Invalid',
            'details': ['name is required'],
          },
        ),
      );
      expect(failure, isA<ValidationFailure>());
      expect((failure as ValidationFailure).details, ['name is required']);
    });

    test('unauthenticated -> AuthFailure', () {
      final failure = mapDioErrorToFailure(
        _httpError(status: 401, body: {'code': 'unauthenticated'}),
      );
      expect(failure, isA<AuthFailure>());
    });

    test('forbidden -> PermissionFailure', () {
      final failure = mapDioErrorToFailure(
        _httpError(status: 403, body: {'code': 'forbidden'}),
      );
      expect(failure, isA<PermissionFailure>());
    });

    test('not_found -> NotFoundFailure', () {
      final failure = mapDioErrorToFailure(
        _httpError(status: 404, body: {'code': 'not_found'}),
      );
      expect(failure, isA<NotFoundFailure>());
    });

    test('conflict -> ConflictFailure', () {
      final failure = mapDioErrorToFailure(
        _httpError(status: 409, body: {'code': 'conflict'}),
      );
      expect(failure, isA<ConflictFailure>());
    });

    test('business_rule -> BusinessRuleFailure with verbatim message', () {
      final failure = mapDioErrorToFailure(
        _httpError(
          status: 422,
          body: {'code': 'business_rule', 'message': 'Cannot deactivate'},
        ),
      );
      expect(failure, isA<BusinessRuleFailure>());
      expect((failure as BusinessRuleFailure).message, 'Cannot deactivate');
    });

    test('rate_limited -> RateLimitFailure', () {
      final failure = mapDioErrorToFailure(
        _httpError(status: 429, body: {'code': 'rate_limited'}),
      );
      expect(failure, isA<RateLimitFailure>());
    });

    test('unrecognized code falls back to HTTP status', () {
      final failure = mapDioErrorToFailure(
        _httpError(status: 404, body: {'code': 'something_unmapped'}),
      );
      expect(failure, isA<NotFoundFailure>());
    });
  });

  group('mapDioErrorToFailure — timeouts and connection errors', () {
    test('connectionTimeout -> NetworkFailure', () {
      final failure = mapDioErrorToFailure(
        _connectionError(DioExceptionType.connectionTimeout),
      );
      expect(failure, isA<NetworkFailure>());
    });

    test('receiveTimeout -> NetworkFailure', () {
      final failure = mapDioErrorToFailure(
        _connectionError(DioExceptionType.receiveTimeout),
      );
      expect(failure, isA<NetworkFailure>());
    });

    test('sendTimeout -> NetworkFailure', () {
      final failure = mapDioErrorToFailure(
        _connectionError(DioExceptionType.sendTimeout),
      );
      expect(failure, isA<NetworkFailure>());
    });

    test('connectionError (socket failure) -> NetworkFailure', () {
      final failure = mapDioErrorToFailure(
        _connectionError(DioExceptionType.connectionError),
      );
      expect(failure, isA<NetworkFailure>());
    });
  });

  group('ErrorInterceptor', () {
    test('attaches FailureDioException and forwards the error', () async {
      final dio = Dio(BaseOptions())
        ..httpClientAdapter = _ThrowingAdapter(
          statusCode: 404,
          body: {'code': 'not_found'},
        )
        ..interceptors.add(ErrorInterceptor());

      DioException? caught;
      try {
        await dio.get<void>('/exercises');
      } on DioException catch (e) {
        caught = e;
      }

      expect(caught?.error, isA<FailureDioException>());
      expect(
        (caught!.error! as FailureDioException).failure,
        isA<NotFoundFailure>(),
      );
    });
  });
}
