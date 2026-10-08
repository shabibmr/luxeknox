import 'dart:async';
import 'dart:convert';

import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/core/error/map_thrown.dart';
import 'package:luxeknox/core/network/error_interceptor.dart';
import 'package:luxeknox/core/network/refresh_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _RefreshCaller extends Mock {
  Future<Either<Failure, void>> call();
}

class _SignedOutCaller extends Mock {
  void call();
}

class _TestErrorHandler extends ErrorInterceptorHandler {
  final Completer<dynamic> _completer = Completer<dynamic>();

  Future<dynamic> get result => _completer.future;

  @override
  void next(DioException err) {
    if (!_completer.isCompleted) {
      _completer.completeError(err);
    }
  }

  @override
  void resolve(Response<dynamic> response) {
    if (!_completer.isCompleted) {
      _completer.complete(response);
    }
  }

  @override
  void reject(DioException err, [bool trueOnError = false]) {
    if (!_completer.isCompleted) {
      _completer.completeError(err);
    }
  }
}

/// Answers every request with 401 `unauthenticated`.
class _UnauthorizedAdapter implements HttpClientAdapter {
  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    return ResponseBody.fromString(
      jsonEncode({'code': 'unauthenticated'}),
      401,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }
}

DioException _unauthorizedError(Dio dio, String path) {
  final requestOptions = RequestOptions(path: path);
  final response = Response<dynamic>(
    requestOptions: requestOptions,
    statusCode: 401,
    data: {'code': 'unauthenticated', 'message': 'Token expired'},
  );
  final original = DioException(
    requestOptions: requestOptions,
    response: response,
    type: DioExceptionType.badResponse,
  );
  final failure = mapDioErrorToFailure(original);
  return original.copyWith(error: FailureDioException(failure, original));
}

void main() {
  late Dio dio;
  late _RefreshCaller refreshCaller;
  late _SignedOutCaller signedOutCaller;
  late RefreshInterceptor interceptor;

  setUp(() {
    dio = Dio(BaseOptions());
    refreshCaller = _RefreshCaller();
    signedOutCaller = _SignedOutCaller();

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          handler.resolve(
            Response<dynamic>(
              requestOptions: options,
              statusCode: 200,
              data: {'ok': true},
            ),
          );
        },
      ),
    );

    interceptor = RefreshInterceptor(
      refresh: refreshCaller.call,
      dio: dio,
      onSignedOut: signedOutCaller.call,
    );
  });

  test('three concurrent 401s trigger exactly one refresh call and all '
      'three original requests are retried and resolved', () async {
    final completer = Completer<Either<Failure, void>>();
    when(() => refreshCaller.call()).thenAnswer((_) => completer.future);

    final results = <Response<dynamic>?>[null, null, null];
    final errors = <DioException?>[null, null, null];

    Future<void> fireOne(int index, String path) async {
      final err = _unauthorizedError(dio, path);
      final handler = _TestErrorHandler();
      unawaited(
        handler.result.then(
          (value) {
            if (value is Response) {
              results[index] = value;
            }
          },
          onError: (Object e) {
            if (e is DioException) errors[index] = e;
          },
        ),
      );
      await interceptor.onError(err, handler);
    }

    // Fire all three overlapping while refresh is pending
    final f0 = fireOne(0, '/exercises');
    final f1 = fireOne(1, '/exercises/1');
    final f2 = fireOne(2, '/exercises/2');

    // Refresh hasn't resolved yet: exactly one call should have been made.
    verify(() => refreshCaller.call()).called(1);

    completer.complete(const Right(null));

    await Future.wait([f0, f1, f2]);
    await Future<void>.delayed(const Duration(milliseconds: 50));

    verifyNever(() => refreshCaller.call());
    verifyNever(() => signedOutCaller.call());

    expect(results[0]?.statusCode, 200);
    expect(results[1]?.statusCode, 200);
    expect(results[2]?.statusCode, 200);
  });

  test(
    'refresh failure triggers onSignedOut exactly once and does not retry',
    () async {
      when(
        () => refreshCaller.call(),
      ).thenAnswer((_) async => const Left(AuthFailure()));

      final err = _unauthorizedError(dio, '/exercises');
      final handler = _TestErrorHandler();

      DioException? forwardedError;
      unawaited(
        handler.result.then(
          (_) {},
          onError: (Object e) {
            if (e is DioException) forwardedError = e;
          },
        ),
      );

      await interceptor.onError(err, handler);
      await Future<void>.delayed(Duration.zero);

      verify(() => refreshCaller.call()).called(1);
      verify(() => signedOutCaller.call()).called(1);
      expect(forwardedError, isNotNull);
      expect(forwardedError!.response?.statusCode, 401);
    },
  );

  test('a 401 from /auth/refresh is forwarded without refreshing', () async {
    final err = _unauthorizedError(dio, '/auth/refresh');
    final handler = _TestErrorHandler();
    DioException? forwardedError;
    unawaited(
      handler.result.then(
        (_) {},
        onError: (Object e) {
          if (e is DioException) forwardedError = e;
        },
      ),
    );

    await interceptor.onError(err, handler);
    await Future<void>.delayed(Duration.zero);

    verifyNever(() => refreshCaller.call());
    verifyNever(() => signedOutCaller.call());
    expect(forwardedError?.response?.statusCode, 401);
  });

  test('refresh rejected with 401 through the real chain signs out instead '
      'of deadlocking', () async {
    final chainDio = Dio(BaseOptions(baseUrl: 'https://api.test'))
      ..httpClientAdapter = _UnauthorizedAdapter();
    var signedOutCount = 0;
    chainDio.interceptors.addAll([
      RefreshInterceptor(
        refresh: () async {
          try {
            await chainDio.post<dynamic>('/auth/refresh');
            return const Right(null);
          } on DioException catch (e) {
            return Left(mapThrownToFailure(e));
          }
        },
        dio: chainDio,
        onSignedOut: () => signedOutCount++,
      ),
      ErrorInterceptor(),
    ]);

    final error = await chainDio
        .get<dynamic>('/auth/me')
        .then<Object?>((_) => null, onError: (Object e) => e)
        .timeout(const Duration(seconds: 2));

    expect(error, isA<DioException>());
    expect(mapThrownToFailure(error!), const AuthFailure());
    expect(signedOutCount, 1);
  });

  test('refresh NetworkFailure does not sign out and surfaces NetworkFailure '
      'instead of the 401', () async {
    when(
      () => refreshCaller.call(),
    ).thenAnswer((_) async => const Left(NetworkFailure()));

    final err = _unauthorizedError(dio, '/exercises');
    final handler = _TestErrorHandler();
    DioException? forwardedError;
    unawaited(
      handler.result.then(
        (_) {},
        onError: (Object e) {
          if (e is DioException) forwardedError = e;
        },
      ),
    );

    await interceptor.onError(err, handler);
    await Future<void>.delayed(Duration.zero);

    verify(() => refreshCaller.call()).called(1);
    verifyNever(() => signedOutCaller.call());
    expect(forwardedError, isNotNull);
    expect(mapThrownToFailure(forwardedError!), const NetworkFailure());
  });

  test(
    'a non-401 error is forwarded untouched without calling refresh',
    () async {
      final requestOptions = RequestOptions(path: '/exercises');
      final response = Response<dynamic>(
        requestOptions: requestOptions,
        statusCode: 500,
        data: {'code': 'unknown_error'},
      );
      final original = DioException(
        requestOptions: requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
      );
      final failure = mapDioErrorToFailure(original);
      final err = original.copyWith(
        error: FailureDioException(failure, original),
      );

      final handler = _TestErrorHandler();
      DioException? forwardedError;
      unawaited(
        handler.result.then(
          (_) {},
          onError: (Object e) {
            if (e is DioException) forwardedError = e;
          },
        ),
      );

      await interceptor.onError(err, handler);

      verifyNever(() => refreshCaller.call());
      verifyNever(() => signedOutCaller.call());
      expect(forwardedError?.response?.statusCode, 500);
    },
  );
}
