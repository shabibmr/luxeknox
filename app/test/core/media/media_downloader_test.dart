import 'dart:typed_data';

import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/core/media/media_downloader.dart';
import 'package:luxeknox/core/media/signed_media_resolver.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockSignedMediaResolver extends Mock implements SignedMediaResolver {}
class MockDio extends Mock implements Dio {}

void main() {
  late MockSignedMediaResolver mockResolver;
  late MockDio mockDio;
  late MediaDownloader downloader;

  setUpAll(() {
    registerFallbackValue(RequestOptions(path: ''));
  });

  setUp(() {
    mockResolver = MockSignedMediaResolver();
    mockDio = MockDio();
    downloader = MediaDownloader.withDownloadDio(mockResolver, mockDio);
  });

  group('MediaDownloader (FR-MEDIA-003)', () {
    test('downloads bytes from objectKey by resolving URL first', () async {
      when(() => mockResolver.resolve('docs/123.pdf'))
          .thenAnswer((_) async => const Right('https://s3.example.com/docs/123.pdf'));

      final expectedBytes = [1, 2, 3, 4, 5];
      when(() => mockDio.get<List<int>>(
            'https://s3.example.com/docs/123.pdf',
            cancelToken: any(named: 'cancelToken'),
            onReceiveProgress: any(named: 'onReceiveProgress'),
            options: any(named: 'options'),
          )).thenAnswer((_) async => Response(
            requestOptions: RequestOptions(path: ''),
            data: expectedBytes,
            statusCode: 200,
          ));

      final result = await downloader.downloadBytes(objectKey: 'docs/123.pdf');
      expect(result.isRight(), isTrue);
      expect(result.getOrElse((_) => Uint8List(0)), equals(Uint8List.fromList(expectedBytes)));

      verify(() => mockResolver.resolve('docs/123.pdf')).called(1);
    });

    test('returns failure if resolver fails', () async {
      when(() => mockResolver.resolve('docs/missing.pdf'))
          .thenAnswer((_) async => const Left(NotFoundFailure()));

      final result = await downloader.downloadBytes(objectKey: 'docs/missing.pdf');
      expect(result.isLeft(), isTrue);
      expect(result.fold((f) => f, (_) => null), isA<NotFoundFailure>());
      verifyNever(() => mockDio.get<List<int>>(any(), options: any(named: 'options')));
    });

    test('maps download cancelation to NetworkFailure', () async {
      when(() => mockResolver.resolve('docs/big.pdf'))
          .thenAnswer((_) async => const Right('https://s3.example.com/big.pdf'));

      final cancelToken = CancelToken();

      when(() => mockDio.get<List<int>>(
            'https://s3.example.com/big.pdf',
            cancelToken: any(named: 'cancelToken'),
            onReceiveProgress: any(named: 'onReceiveProgress'),
            options: any(named: 'options'),
          )).thenAnswer((_) async {
        cancelToken.cancel('User cancelled download');
        throw DioException(
          requestOptions: RequestOptions(path: ''),
          type: DioExceptionType.cancel,
        );
      });

      final result = await downloader.downloadBytes(
        objectKey: 'docs/big.pdf',
        cancelToken: cancelToken,
      );

      expect(result.isLeft(), isTrue);
      expect(result.fold((f) => f, (_) => null), isA<NetworkFailure>());
    });
  });
}
