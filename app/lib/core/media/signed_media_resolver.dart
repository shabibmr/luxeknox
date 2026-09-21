import 'package:api_client/api_client.dart' as api;
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

import '../error/failures.dart';
import '../error/map_thrown.dart';

/// Fetches a short-lived signed GET URL for an object key (FR-MEDIA-003).
///
/// Shared by [SignedMediaImage] and [SignedFileLink] so both widgets apply
/// the same 403-vs-other-failure distinction.
/// Represents a cached signed GET URL with its expiration timestamp.
class CachedSignedUrl {
  const CachedSignedUrl({required this.url, required this.expiresAt});

  final String url;
  final DateTime expiresAt;

  /// Returns true if the URL has expired or will expire within [buffer].
  bool isExpired({
    Duration buffer = const Duration(seconds: 30),
    DateTime Function()? now,
  }) {
    final currentTime = (now != null ? now() : DateTime.now()).toUtc();
    return currentTime.isAfter(expiresAt.toUtc().subtract(buffer));
  }
}

/// Fetches and caches short-lived signed GET URLs for object keys (FR-MEDIA-003).
///
/// Automatically handles expired URL recovery by refreshing near-expiry or
/// stale URLs, and provides [invalidate] for recovery when an image or download
/// fails due to URL expiry.
@lazySingleton
class SignedMediaResolver {
  @factoryMethod
  SignedMediaResolver(this._mediaApi) : _clock = DateTime.now;

  @visibleForTesting
  SignedMediaResolver.withClock(this._mediaApi, this._clock);

  final api.MEDIAApi _mediaApi;
  final DateTime Function() _clock;
  final Map<String, CachedSignedUrl> _cache = {};

  /// Returns cached URL if still valid; otherwise fetches a fresh signed URL.
  /// Set [forceRefresh] to true for explicit expired-URL recovery.
  Future<Either<Failure, String>> resolve(
    String objectKey, {
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh) {
      final cached = _cache[objectKey];
      if (cached != null && !cached.isExpired(now: _clock)) {
        return right(cached.url);
      }
    }

    try {
      final response = await _mediaApi.getMediaUrl(key: objectKey);
      final download = response.data;
      if (download == null) return left(const UnknownFailure());

      _cache[objectKey] = CachedSignedUrl(
        url: download.url,
        expiresAt: download.expiresAt,
      );
      return right(download.url);
    } catch (e) {
      return left(mapThrownToFailure(e));
    }
  }

  /// Forces invalidation of a cached signed URL so the next call to [resolve]
  /// retrieves a fresh URL.
  void invalidate(String objectKey) {
    _cache.remove(objectKey);
  }

  /// Clears the entire signed URL cache.
  void clearCache() {
    _cache.clear();
  }

  /// Recover from an expired URL by invalidating the cache and fetching a new one.
  Future<Either<Failure, String>> recoverExpiredUrl(String objectKey) {
    invalidate(objectKey);
    return resolve(objectKey, forceRefresh: true);
  }
}
