import 'dart:typed_data';

import 'package:api_client/api_client.dart' as api;
import 'package:app/core/error/failures.dart';
import 'package:app/core/media/media_purpose.dart';
import 'package:app/core/media/media_uploader.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockMediaApi extends Mock implements api.MEDIAApi {}
class MockDio extends Mock implements Dio {}

void main() {
  late MockMediaApi mockApi;
  late MockDio mockUploadDio;
  late MediaUploader uploader;

  setUpAll(() {
    registerFallbackValue(RequestOptions(path: ''));
    registerFallbackValue(
      api.MediaUploadRequest(
        (b) => b
          ..purpose = api.MediaUploadRequestPurposeEnum.avatar
          ..contentType = 'image/jpeg'
          ..sizeBytes = 100,
      ),
    );
    registerFallbackValue(Uri.parse('https://example.com'));
  });

  setUp(() {
    mockApi = MockMediaApi();
    mockUploadDio = MockDio();
    uploader = MediaUploader.withUploadDio(mockApi, mockUploadDio);
  });

  group('MediaUploader (FR-MEDIA-001 & FR-MEDIA-002)', () {
    test('rejects disallowed MIME type without invoking API', () async {
      final bytes = Uint8List.fromList([1, 2, 3]);
      final result = await uploader.upload(
        bytes: bytes,
        contentType: 'application/x-executable',
        purpose: MediaPurpose.avatar,
      );

      expect(result.isLeft(), isTrue);
      expect(result.fold((f) => f, (_) => null), isA<ValidationFailure>());
      verifyNever(() => mockApi.createMediaUpload(mediaUploadRequest: any(named: 'mediaUploadRequest')));
    });

    test('rejects payload exceeding purpose max size limit without invoking API', () async {
      // avatar limit is 5MB. Provide 5MB + 1 byte
      final largeBytes = Uint8List(5 * 1024 * 1024 + 1);
      final result = await uploader.upload(
        bytes: largeBytes,
        contentType: 'image/jpeg',
        purpose: MediaPurpose.avatar,
      );

      expect(result.isLeft(), isTrue);
      expect(result.fold((f) => f, (_) => null), isA<ValidationFailure>());
      verifyNever(() => mockApi.createMediaUpload(mediaUploadRequest: any(named: 'mediaUploadRequest')));
    });

    test('completes two-step signed upload successfully', () async {
      final bytes = Uint8List.fromList([10, 20, 30, 40]);
      final uploadSlot = api.MediaUpload(
        (b) => b
          ..objectKey = 'avatar/2026/09/user1.jpg'
          ..url = 'https://s3.example.com/put-slot-123'
          ..expiresAt = DateTime.utc(2026, 9, 21, 13, 0, 0),
      );

      when(() => mockApi.createMediaUpload(mediaUploadRequest: any(named: 'mediaUploadRequest')))
          .thenAnswer((_) async => Response(
                requestOptions: RequestOptions(path: ''),
                data: uploadSlot,
              ));

      when(() => mockUploadDio.putUri(
            any(),
            data: any(named: 'data'),
            cancelToken: any(named: 'cancelToken'),
            onSendProgress: any(named: 'onSendProgress'),
            options: any(named: 'options'),
          )).thenAnswer((_) async => Response(
            requestOptions: RequestOptions(path: ''),
            statusCode: 200,
          ));

      final result = await uploader.upload(
        bytes: bytes,
        contentType: 'image/jpeg',
        purpose: MediaPurpose.avatar,
      );

      expect(result.isRight(), isTrue);
      expect(result.getOrElse((_) => ''), equals('avatar/2026/09/user1.jpg'));

      verify(() => mockApi.createMediaUpload(mediaUploadRequest: any(named: 'mediaUploadRequest'))).called(1);
      verify(() => mockUploadDio.putUri(
            Uri.parse('https://s3.example.com/put-slot-123'),
            data: bytes,
            cancelToken: any(named: 'cancelToken'),
            onSendProgress: any(named: 'onSendProgress'),
            options: any(named: 'options'),
          )).called(1);
    });

    test('maps Dio cancellation to NetworkFailure', () async {
      final bytes = Uint8List.fromList([1, 2, 3]);
      final uploadSlot = api.MediaUpload(
        (b) => b
          ..objectKey = 'doc/1.pdf'
          ..url = 'https://s3.example.com/put'
          ..expiresAt = DateTime.utc(2026, 9, 21, 13, 0, 0),
      );

      when(() => mockApi.createMediaUpload(mediaUploadRequest: any(named: 'mediaUploadRequest')))
          .thenAnswer((_) async => Response(
                requestOptions: RequestOptions(path: ''),
                data: uploadSlot,
              ));

      final cancelToken = CancelToken();

      when(() => mockUploadDio.putUri(
            any(),
            data: any(named: 'data'),
            cancelToken: any(named: 'cancelToken'),
            onSendProgress: any(named: 'onSendProgress'),
            options: any(named: 'options'),
          )).thenAnswer((_) async {
        cancelToken.cancel('User canceled upload');
        throw DioException(
          requestOptions: RequestOptions(path: ''),
          type: DioExceptionType.cancel,
        );
      });

      final result = await uploader.upload(
        bytes: bytes,
        contentType: 'application/pdf',
        purpose: MediaPurpose.idProof,
        cancelToken: cancelToken,
      );

      expect(result.isLeft(), isTrue);
      expect(result.fold((f) => f, (_) => null), isA<NetworkFailure>());
    });
  });
}
