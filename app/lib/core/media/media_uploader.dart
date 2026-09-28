import 'dart:typed_data';

import 'package:api_client/api_client.dart' as api;
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

import '../error/failures.dart';
import '../error/map_thrown.dart';
import 'media_purpose.dart';

/// Requests a signed PUT slot (FR-MEDIA-001), validates the payload
/// client-side against [MediaPurpose] limits (FR-MEDIA-002), uploads the
/// bytes, and returns the resulting object key.
@lazySingleton
class MediaUploader {
  MediaUploader(this._mediaApi) : _uploadDio = Dio();

  /// Test-only seam for injecting a fake upload [Dio] — not resolved by DI.
  @visibleForTesting
  MediaUploader.withUploadDio(this._mediaApi, this._uploadDio);

  final api.MEDIAApi _mediaApi;

  /// Plain [Dio] instance (no auth/refresh interceptors) used for the raw
  /// PUT against the signed URL — that URL is already authorized and must
  /// not carry the app's bearer token.
  final Dio _uploadDio;

  CancelToken? _activeToken;

  /// Cancels the in-flight signed PUT, if any.
  void cancel() {
    _activeToken?.cancel('upload cancelled');
    _activeToken = null;
  }

  Future<Either<Failure, String>> upload({
    required Uint8List bytes,
    required String contentType,
    required MediaPurpose purpose,
    void Function(int sent, int total)? onProgress,
    CancelToken? cancelToken,
  }) async {
    if (!purpose.allowedMimeTypes.contains(contentType)) {
      return left(
        ValidationFailure(['Unsupported file type for $contentType']),
      );
    }
    if (bytes.lengthInBytes > purpose.maxSizeBytes) {
      return left(
        ValidationFailure([
          'File exceeds the ${purpose.maxSizeBytesFormatted} limit',
        ]),
      );
    }

    final token = cancelToken ?? CancelToken();
    _activeToken = token;

    try {
      final slot = await _mediaApi.createMediaUpload(
        mediaUploadRequest: api.MediaUploadRequest(
          (b) => b
            ..purpose = _mapPurposeToApi(purpose)
            ..contentType = contentType
            ..sizeBytes = bytes.lengthInBytes,
        ),
      );
      final upload = slot.data;
      if (upload == null) return left(const UnknownFailure());

      await _uploadDio.putUri(
        Uri.parse(upload.url),
        data: bytes,
        cancelToken: token,
        onSendProgress: onProgress,
        options: Options(
          headers: {
            Headers.contentTypeHeader: contentType,
            Headers.contentLengthHeader: bytes.lengthInBytes,
          },
        ),
      );

      return right(upload.objectKey);
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) {
        return left(const NetworkFailure());
      }
      return left(mapThrownToFailure(e));
    } catch (e) {
      return left(mapThrownToFailure(e));
    } finally {
      if (identical(_activeToken, token)) {
        _activeToken = null;
      }
    }
  }
}

api.MediaUploadRequestPurposeEnum _mapPurposeToApi(MediaPurpose purpose) {
  return switch (purpose) {
    MediaPurpose.exerciseMedia => api.MediaUploadRequestPurposeEnum.exerciseMedia,
    MediaPurpose.avatar => api.MediaUploadRequestPurposeEnum.avatar,
    MediaPurpose.progressPhoto => api.MediaUploadRequestPurposeEnum.progressPhoto,
    MediaPurpose.idProof => api.MediaUploadRequestPurposeEnum.idProof,
    MediaPurpose.waiver => api.MediaUploadRequestPurposeEnum.waiver,
    MediaPurpose.medicalCert => api.MediaUploadRequestPurposeEnum.medicalCert,
    MediaPurpose.receiptPdf => api.MediaUploadRequestPurposeEnum.receiptPdf,
  };
}
