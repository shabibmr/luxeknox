import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:luxeknox/core/media/image_compressor.dart';
import 'package:luxeknox/core/media/media_purpose.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCodec extends Mock implements ui.Codec {}
class MockFrameInfo extends Mock implements ui.FrameInfo {}
class MockImage extends Mock implements ui.Image {}

void main() {
  group('ImageCompressor (FR-MEDIA-002)', () {
    test('returns original bytes unmodified when within purpose size limit', () async {
      final compressor = ImageCompressor();
      final smallBytes = Uint8List.fromList([1, 2, 3, 4, 5]);

      final result = await compressor.compressForPurpose(
        bytes: smallBytes,
        purpose: MediaPurpose.avatar, // 5MB limit
      );

      expect(result, equals(smallBytes));
    });

    test('falls back gracefully to input bytes if codec decoding fails', () async {
      Future<ui.Codec> mockCodecLoader(Uint8List bytes, {int? targetWidth, int? targetHeight}) async {
        throw Exception('Codec decoding error');
      }

      final compressor = ImageCompressor.withCodecLoader(mockCodecLoader);
      final rawBytes = Uint8List(6 * 1024 * 1024); // Exceeds avatar 5MB

      final result = await compressor.compressForPurpose(
        bytes: rawBytes,
        purpose: MediaPurpose.avatar,
      );

      expect(result, equals(rawBytes));
    });

    test('resizes and re-encodes image when codec succeeds', () async {
      final mockCodec = MockCodec();
      final mockFrameInfo = MockFrameInfo();
      final mockImage = MockImage();

      when(() => mockCodec.getNextFrame()).thenAnswer((_) async => mockFrameInfo);
      when(() => mockFrameInfo.image).thenReturn(mockImage);

      final dummyPngBytes = Uint8List.fromList([0x89, 0x50, 0x4E, 0x47, 10, 20]);
      final byteData = ByteData.sublistView(dummyPngBytes);
      when(() => mockImage.toByteData(format: ui.ImageByteFormat.png))
          .thenAnswer((_) async => byteData);

      Future<ui.Codec> mockCodecLoader(Uint8List bytes, {int? targetWidth, int? targetHeight}) async {
        return mockCodec;
      }

      final compressor = ImageCompressor.withCodecLoader(mockCodecLoader);
      final largeBytes = Uint8List(9 * 1024 * 1024); // Exceeds progressPhoto 8MB

      final result = await compressor.compressForPurpose(
        bytes: largeBytes,
        purpose: MediaPurpose.progressPhoto,
      );

      expect(result, equals(dummyPngBytes));
      verify(() => mockCodec.getNextFrame()).called(1);
    });

    test('generateThumbnail calls resize with thumbnail dimensions', () async {
      int? requestedWidth;
      int? requestedHeight;

      final mockCodec = MockCodec();
      final mockFrameInfo = MockFrameInfo();
      final mockImage = MockImage();

      when(() => mockCodec.getNextFrame()).thenAnswer((_) async => mockFrameInfo);
      when(() => mockFrameInfo.image).thenReturn(mockImage);

      final thumbnailBytes = Uint8List.fromList([1, 2, 3]);
      when(() => mockImage.toByteData(format: ui.ImageByteFormat.png))
          .thenAnswer((_) async => ByteData.sublistView(thumbnailBytes));

      Future<ui.Codec> mockCodecLoader(Uint8List bytes, {int? targetWidth, int? targetHeight}) async {
        requestedWidth = targetWidth;
        requestedHeight = targetHeight;
        return mockCodec;
      }

      final compressor = ImageCompressor.withCodecLoader(mockCodecLoader);
      final result = await compressor.generateThumbnail(
        Uint8List.fromList([10, 20, 30]),
        targetWidth: 150,
        targetHeight: 150,
      );

      expect(result, equals(thumbnailBytes));
      expect(requestedWidth, equals(150));
      expect(requestedHeight, equals(150));
    });
  });
}
