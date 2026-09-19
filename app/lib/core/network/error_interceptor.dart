import 'package:dio/dio.dart';

import '../error/failures.dart';

/// Wraps a [DioException] with the [Failure] derived from it by
/// [ErrorInterceptor].
///
/// This is the mechanism by which downstream code (data sources,
/// repositories) recovers a typed [Failure] from a failed request:
///
/// ```dart
/// try {
///   final response = await dio.get('/exercises');
/// } on DioException catch (e) {
///   final failure = e.error is FailureDioException
///       ? (e.error! as FailureDioException).failure
///       : const UnknownFailure();
///   return Left(failure);
/// }
/// ```
///
/// [ErrorInterceptor] attaches this via `err.copyWith(error: ...)` and
/// forwards it with `handler.next(...)` (never `handler.reject` with a bare
/// exception) so later interceptors in the chain (e.g. the D4 refresh
/// interceptor and the D5 logging interceptor) still see a normal
/// [DioException] whose `error` field carries the mapped [Failure].
class FailureDioException implements Exception {
  const FailureDioException(this.failure, this.original);

  /// The mapped domain [Failure].
  final Failure failure;

  /// The original [DioException] this failure was derived from.
  final DioException original;

  @override
  String toString() => 'FailureDioException(failure: $failure)';
}

/// Translates transport/HTTP errors into domain [Failure]s per FRD §5.2.
///
/// The error response body is expected to be a JSON object shaped
/// `{ code, message, details[], request_id }` (FR-API-011). Mapping is by
/// `code` first, falling back to HTTP status when `code` is absent or
/// unrecognized. Connection/receive/send timeouts and connection errors
/// (e.g. socket failures) map to [NetworkFailure] regardless of body.
///
/// The resulting [Failure] is attached to the [DioException] via
/// [FailureDioException] (see its doc comment for how to consume it) and
/// forwarded with `handler.next`, so this interceptor never swallows the
/// error or changes control flow for other interceptors in the chain.
class ErrorInterceptor extends InterceptorsWrapper {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final failure = mapDioErrorToFailure(err);
    handler.next(err.copyWith(error: FailureDioException(failure, err)));
  }
}

/// Maps a [DioException] to a domain [Failure] per FRD §5.2.
///
/// Exposed as a top-level function (rather than kept private to
/// [ErrorInterceptor]) so it can be unit tested directly against fake
/// [DioException]/[Response] values without needing to drive the
/// interceptor handler pipeline.
Failure mapDioErrorToFailure(DioException err) {
  switch (err.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.connectionError:
    case DioExceptionType.transformTimeout:
      return const NetworkFailure();
    case DioExceptionType.badCertificate:
    case DioExceptionType.cancel:
    case DioExceptionType.unknown:
      // `unknown` also covers raw SocketException failures that Dio has
      // not classified as connectionError; treat as network failure only
      // when there is no HTTP response to map from.
      if (err.response == null) {
        return const NetworkFailure();
      }
    case DioExceptionType.badResponse:
      break;
  }

  final response = err.response;
  if (response == null) {
    return const UnknownFailure();
  }

  final status = response.statusCode;
  final body = response.data;
  String? code;
  List<String> details = const [];
  String? message;

  if (body is Map) {
    final rawCode = body['code'];
    if (rawCode is String) code = rawCode;
    final rawMessage = body['message'];
    if (rawMessage is String) message = rawMessage;
    final rawDetails = body['details'];
    if (rawDetails is List) {
      details = rawDetails.map((e) => e.toString()).toList();
    }
  }

  switch (code) {
    case 'validation_error':
      return ValidationFailure(details);
    case 'unauthenticated':
      return const AuthFailure();
    case 'forbidden':
      return const PermissionFailure();
    case 'not_found':
      return const NotFoundFailure();
    case 'conflict':
      return const ConflictFailure();
    case 'business_rule':
      return BusinessRuleFailure(message ?? '');
    case 'rate_limited':
      return const RateLimitFailure();
  }

  // No recognized code: fall back to HTTP status.
  switch (status) {
    case 400:
      return ValidationFailure(details);
    case 401:
      return const AuthFailure();
    case 403:
      return const PermissionFailure();
    case 404:
      return const NotFoundFailure();
    case 409:
      return const ConflictFailure();
    case 422:
      return BusinessRuleFailure(message ?? '');
    case 429:
      return const RateLimitFailure();
    default:
      return const UnknownFailure();
  }
}
