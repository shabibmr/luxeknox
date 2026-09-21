import 'package:api_client/api_client.dart' as api;
import 'package:app/core/error/failures.dart';
import 'package:app/core/media/signed_media_resolver.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockMediaApi extends Mock implements api.MEDIAApi {}

void main() {
  late MockMediaApi mockApi;
  late SignedMediaResolver resolver;
  late DateTime fixedNow;

  setUp(() {
    mockApi = MockMediaApi();
    fixedNow = DateTime.utc(2026, 9, 21, 12, 0, 0);
    resolver = SignedMediaResolver.withClock(mockApi, () => fixedNow);
  });

  group('SignedMediaResolver & Expired URL Recovery (FR-MEDIA-003)', () {
    test('resolves and caches valid signed URL', () async {
      final download = api.MediaDownload(
        (b) => b
          ..url = 'https://media.example.com/avatar1.jpg'
          ..expiresAt = fixedNow.add(const Duration(minutes: 10)),
      );

      when(() => mockApi.getMediaUrl(key: 'avatar/1.jpg')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/media/avatar/1.jpg'),
          data: download,
        ),
      );

      final result1 = await resolver.resolve('avatar/1.jpg');
      expect(result1.isRight(), isTrue);
      expect(result1.getOrElse((_) => ''), equals('https://media.example.com/avatar1.jpg'));

      // Second call should return cached URL without calling API again
      final result2 = await resolver.resolve('avatar/1.jpg');
      expect(result2.isRight(), isTrue);
      expect(result2.getOrElse((_) => ''), equals('https://media.example.com/avatar1.jpg'));

      verify(() => mockApi.getMediaUrl(key: 'avatar/1.jpg')).called(1);
    });

    test('automatically re-fetches URL when cached entry has expired', () async {
      final firstDownload = api.MediaDownload(
        (b) => b
          ..url = 'https://media.example.com/avatar1_old.jpg'
          ..expiresAt = fixedNow.add(const Duration(seconds: 10)), // Will expire within 30s buffer
      );

      final secondDownload = api.MediaDownload(
        (b) => b
          ..url = 'https://media.example.com/avatar1_new.jpg'
          ..expiresAt = fixedNow.add(const Duration(minutes: 10)),
      );

      when(() => mockApi.getMediaUrl(key: 'avatar/1.jpg'))
          .thenAnswer((_) async => Response(
                requestOptions: RequestOptions(path: ''),
                data: firstDownload,
              ));

      await resolver.resolve('avatar/1.jpg');

      // Now time advances by 15 seconds, making the URL expired
      fixedNow = fixedNow.add(const Duration(seconds: 15));

      when(() => mockApi.getMediaUrl(key: 'avatar/1.jpg'))
          .thenAnswer((_) async => Response(
                requestOptions: RequestOptions(path: ''),
                data: secondDownload,
              ));

      final result = await resolver.resolve('avatar/1.jpg');
      expect(result.getOrElse((_) => ''), equals('https://media.example.com/avatar1_new.jpg'));
      verify(() => mockApi.getMediaUrl(key: 'avatar/1.jpg')).called(2);
    });

    test('recoverExpiredUrl explicitly forces refresh', () async {
      final firstDownload = api.MediaDownload(
        (b) => b
          ..url = 'https://media.example.com/doc_initial.pdf'
          ..expiresAt = fixedNow.add(const Duration(hours: 1)),
      );

      final recoveredDownload = api.MediaDownload(
        (b) => b
          ..url = 'https://media.example.com/doc_fresh.pdf'
          ..expiresAt = fixedNow.add(const Duration(hours: 1)),
      );

      when(() => mockApi.getMediaUrl(key: 'doc/sample.pdf')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ''),
          data: firstDownload,
        ),
      );

      await resolver.resolve('doc/sample.pdf');

      when(() => mockApi.getMediaUrl(key: 'doc/sample.pdf')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ''),
          data: recoveredDownload,
        ),
      );

      final result = await resolver.recoverExpiredUrl('doc/sample.pdf');
      expect(result.getOrElse((_) => ''), equals('https://media.example.com/doc_fresh.pdf'));
      verify(() => mockApi.getMediaUrl(key: 'doc/sample.pdf')).called(2);
    });

    test('returns failure on API error', () async {
      when(() => mockApi.getMediaUrl(key: 'missing.jpg')).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          response: Response(
            requestOptions: RequestOptions(path: ''),
            statusCode: 404,
          ),
        ),
      );

      final result = await resolver.resolve('missing.jpg');
      expect(result.isLeft(), isTrue);
      expect(result.fold((f) => f, (_) => null), isA<NotFoundFailure>());
    });
  });
}
