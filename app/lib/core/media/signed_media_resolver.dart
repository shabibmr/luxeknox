import 'package:api_client/api_client.dart' as api;
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../error/failures.dart';
import '../error/map_thrown.dart';

/// Fetches a short-lived signed GET URL for an object key (FR-MEDIA-003).
///
/// Shared by [SignedMediaImage] and [SignedFileLink] so both widgets apply
/// the same 403-vs-other-failure distinction.
@lazySingleton
class SignedMediaResolver {
  SignedMediaResolver(this._mediaApi);

  final api.MEDIAApi _mediaApi;

  Future<Either<Failure, String>> resolve(String objectKey) async {
    try {
      final response = await _mediaApi.getMediaUrl(key: objectKey);
      final url = response.data?.url;
      if (url == null) return left(const UnknownFailure());
      return right(url);
    } catch (e) {
      return left(mapThrownToFailure(e));
    }
  }
}
