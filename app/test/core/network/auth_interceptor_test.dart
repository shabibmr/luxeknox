import 'dart:typed_data';

import 'package:app/core/network/auth_interceptor.dart';
import 'package:app/core/storage/token_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTokenStorage extends Mock implements TokenStorage {}

/// A fake adapter that records the last [RequestOptions] it received and
/// returns an empty 200 response without performing any real I/O.
class _RecordingAdapter implements HttpClientAdapter {
  RequestOptions? lastOptions;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    lastOptions = options;
    return ResponseBody.fromString(
      '{}',
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  late MockTokenStorage tokenStorage;
  late Dio dio;
  late _RecordingAdapter adapter;

  setUp(() {
    tokenStorage = MockTokenStorage();
    adapter = _RecordingAdapter();
    dio = Dio(BaseOptions(baseUrl: 'https://stub.example.com'))
      ..httpClientAdapter = adapter
      ..interceptors.add(AuthInterceptor(tokenStorage));
  });

  test('attaches Authorization header on a normal request path', () async {
    when(
      () => tokenStorage.readAccessToken(),
    ).thenAnswer((_) async => 'token-123');

    await dio.get<void>('/exercises');

    expect(adapter.lastOptions?.headers['Authorization'], 'Bearer token-123');
  });

  test('does not attach Authorization header for /auth/login', () async {
    when(
      () => tokenStorage.readAccessToken(),
    ).thenAnswer((_) async => 'token-123');

    await dio.post<void>('/auth/login');

    expect(adapter.lastOptions?.headers.containsKey('Authorization'), isFalse);
    verifyNever(() => tokenStorage.readAccessToken());
  });

  test('does not attach Authorization header for /auth/refresh', () async {
    when(
      () => tokenStorage.readAccessToken(),
    ).thenAnswer((_) async => 'token-123');

    await dio.post<void>('/auth/refresh');

    expect(adapter.lastOptions?.headers.containsKey('Authorization'), isFalse);
    verifyNever(() => tokenStorage.readAccessToken());
  });

  test('does not attach header when no token is stored', () async {
    when(() => tokenStorage.readAccessToken()).thenAnswer((_) async => null);

    await dio.get<void>('/exercises');

    expect(adapter.lastOptions?.headers.containsKey('Authorization'), isFalse);
  });
}
