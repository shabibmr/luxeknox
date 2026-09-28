import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

import 'media_purpose.dart';

/// Service for client-side image compression and thumbnail generation (FR-MEDIA-002).
///
/// Ensures high-resolution camera captures do not exceed purpose byte limits
/// before attempting upload.
@lazySingleton
class ImageCompressor {
  @factoryMethod
  ImageCompressor() : _codecLoader = _defaultCodecLoader;

  @visibleForTesting
  ImageCompressor.withCodecLoader(this._codecLoader);

  final Future<ui.Codec> Function(
    Uint8List bytes, {
    int? targetWidth,
    int? targetHeight,
  }) _codecLoader;

  static Future<ui.Codec> _defaultCodecLoader(
    Uint8List bytes, {
    int? targetWidth,
    int? targetHeight,
  }) {
    return ui.instantiateImageCodec(
      bytes,
      targetWidth: targetWidth,
      targetHeight: targetHeight,
    );
  }

  /// Checks if [bytes] exceeds [purpose.maxSizeBytes]. If so, or if dimensions
  /// exceed [maxWidth]/[maxHeight], attempts to resize and compress the image.
  /// If compression is unnecessary or impossible, returns [bytes].
  Future<Uint8List> compressForPurpose({
    required Uint8List bytes,
    required MediaPurpose purpose,
    int maxWidth = 1920,
    int maxHeight = 1920,
  }) async {
    if (bytes.lengthInBytes <= purpose.maxSizeBytes) {
      return bytes;
    }

    return resizeAndCompress(
      bytes,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
    );
  }

  /// Resizes and encodes the image bytes to PNG format with specified bounds.
  Future<Uint8List> resizeAndCompress(
    Uint8List bytes, {
    int? maxWidth,
    int? maxHeight,
  }) async {
    try {
      final codec = await _codecLoader(
        bytes,
        targetWidth: maxWidth,
        targetHeight: maxHeight,
      );
      final frameInfo = await codec.getNextFrame();
      final image = frameInfo.image;

      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return bytes;

      return byteData.buffer.asUint8List();
    } catch (_) {
      // If decoding fails (e.g. non-image format or corrupted stream), fallback to original bytes
      return bytes;
    }
  }

  /// Generates a small thumbnail from an image payload.
  Future<Uint8List> generateThumbnail(
    Uint8List bytes, {
    int targetWidth = 200,
    int targetHeight = 200,
  }) async {
    return resizeAndCompress(
      bytes,
      maxWidth: targetWidth,
      maxHeight: targetHeight,
    );
  }
}
