import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

import '../error/failures.dart';
import '../error/map_thrown.dart';
import 'signed_media_resolver.dart';

/// Downloads media files using short-lived signed GET URLs (FR-MEDIA-003).
///
/// Plain [Dio] instance (no auth interceptor) is used since signed GET URLs
/// are pre-authorized via HMAC/S3 credentials.
@lazySingleton
class MediaDownloader {
  @factoryMethod
  MediaDownloader(this._resolver) : _downloadDio = Dio();

  @visibleForTesting
  MediaDownloader.withDownloadDio(this._resolver, this._downloadDio);

  final SignedMediaResolver _resolver;
  final Dio _downloadDio;

  CancelToken? _activeToken;

  /// Cancels in-flight download, if any.
  void cancel() {
    _activeToken?.cancel('download cancelled');
    _activeToken = null;
  }

  /// Resolves the signed GET URL for [objectKey] and downloads the raw bytes.
  Future<Either<Failure, Uint8List>> downloadBytes({
    required String objectKey,
    void Function(int received, int total)? onProgress,
    CancelToken? cancelToken,
  }) async {
    final urlResult = await _resolver.resolve(objectKey);
    return urlResult.fold(
      left,
      (url) => downloadFromUrl(
        url: url,
        onProgress: onProgress,
        cancelToken: cancelToken,
      ),
    );
  }

  /// Downloads raw bytes directly from an authorized signed [url].
  Future<Either<Failure, Uint8List>> downloadFromUrl({
    required String url,
    void Function(int received, int total)? onProgress,
    CancelToken? cancelToken,
  }) async {
    final token = cancelToken ?? CancelToken();
    _activeToken = token;

    try {
      final response = await _downloadDio.get<List<int>>(
        url,
        cancelToken: token,
        onReceiveProgress: onProgress,
        options: Options(responseType: ResponseType.bytes),
      );

      final data = response.data;
      if (data == null) return left(const UnknownFailure());

      return right(Uint8List.fromList(data));
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
