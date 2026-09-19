// Initializing formals (`this._refresh`) aren't usable in this constructor:
// the field names are private but the named parameters must stay public for
// callers outside this library (e.g. register_module.dart).
// ignore_for_file: prefer_initializing_formals

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

import '../error/failures.dart';
import 'error_interceptor.dart';

/// Handles token refresh on a 401 response, ensuring at most one refresh
/// call is ever in flight no matter how many requests fail with 401
/// concurrently.
///
/// Concurrency mechanism:
/// A single nullable `Future<Either<Failure, void>>` (`_inFlightRefresh`) is
/// stored on the interceptor. The first 401 to arrive finds it `null`,
/// creates it by invoking the injected [refresh] function, and stores it
/// before awaiting. Every subsequent 401 that arrives while it is non-null
/// simply awaits the *same* future instead of calling [refresh] again. Once
/// the future completes (success or failure) it is cleared (set back to
/// `null`) so a later, independent 401 can trigger a fresh refresh. Because
/// `_inFlightRefresh` is assigned synchronously (before any `await`), there
/// is no gap in which two overlapping 401s could each decide to start their
/// own refresh — the second 401's `onError` runs after the first has already
/// assigned the field, even though both are async callbacks, because the
/// assignment happens on the synchronous portion of the first call before it
/// hits its first `await`.
///
/// Retry mechanism:
/// This interceptor extends [Interceptor] (not [QueuedInterceptorsWrapper])
/// and retries the original failed request with `dio.fetch(err.requestOptions)`
/// using a [Dio] instance passed in via the constructor. `dio.fetch` re-runs
/// the *entire* interceptor chain (auth, refresh, error, logging), which is
/// desirable here: the retried request must pick up the freshly refreshed
/// access token via [AuthInterceptor] exactly as any other request would.
/// The alternative — a separate "raw" Dio/retry client with no interceptors
/// — would require this file to duplicate header-attachment logic and would
/// risk retrying with the stale token. The only risk with re-entering the
/// full chain is a second 401 causing infinite retry loops; that is guarded
/// against by only ever retrying once per original request (tracked via the
/// `_retried` extra flag on [RequestOptions]) and by clearing
/// `_inFlightRefresh` before the retry so a genuinely repeated 401 (e.g. the
/// refreshed token itself being rejected) triggers at most one further
/// refresh rather than looping silently.
class RefreshInterceptor extends Interceptor {
  RefreshInterceptor({
    required Future<Either<Failure, void>> Function() refresh,
    required Dio dio,
    required void Function() onSignedOut,
  }) : _refresh = refresh,
       _dio = dio,
       _onSignedOut = onSignedOut;

  final Future<Either<Failure, void>> Function() _refresh;
  final Dio _dio;
  final void Function() _onSignedOut;

  /// The shared in-flight refresh call, if one is currently running.
  /// `null` when no refresh is in progress.
  Future<Either<Failure, void>>? _inFlightRefresh;

  /// Guards [_onSignedOut] so it fires exactly once per failed refresh, even
  /// though every request queued on the same [_inFlightRefresh] future
  /// observes the same `Left` result. Reset to `false` whenever a new
  /// refresh is started. Checked-and-set synchronously (no `await` between
  /// the check and the set) so it is safe despite Dart's single-threaded,
  /// cooperative event loop.
  bool _signedOutNotifiedForCurrentRefresh = false;

  /// Key used on [RequestOptions.extra] to mark a request that has already
  /// been retried once after a refresh, so we never retry more than once
  /// per original request (prevents infinite retry loops).
  static const String _retriedFlag = 'refresh_interceptor_retried';

  bool _is401(DioException err) {
    if (err.response?.statusCode == 401) return true;
    final error = err.error;
    if (error is FailureDioException && error.failure is AuthFailure) {
      return true;
    }
    return false;
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (!_is401(err)) {
      handler.next(err);
      return;
    }

    final alreadyRetried = err.requestOptions.extra[_retriedFlag] == true;
    if (alreadyRetried) {
      // Already retried once after a refresh and failed again with 401:
      // do not loop. Forward the original error.
      handler.next(err);
      return;
    }

    // Reuse an in-flight refresh if one exists, otherwise start one. This
    // assignment happens synchronously relative to the caller, so
    // concurrent onError invocations for other failed requests will see the
    // already-assigned future rather than starting their own.
    final isNewRefresh = _inFlightRefresh == null;
    if (isNewRefresh) {
      _signedOutNotifiedForCurrentRefresh = false;
    }
    final refreshFuture = _inFlightRefresh ??= _refresh();

    final result = await refreshFuture;

    // Clear only if this call's future is still the current one (it always
    // will be here since we never reassign mid-flight), so the next
    // independent 401 can trigger a new refresh.
    if (identical(_inFlightRefresh, refreshFuture)) {
      _inFlightRefresh = null;
    }

    final signedOut = result.isLeft();
    if (signedOut) {
      if (!_signedOutNotifiedForCurrentRefresh) {
        _signedOutNotifiedForCurrentRefresh = true;
        _onSignedOut();
      }
      handler.next(err);
      return;
    }

    try {
      err.requestOptions.extra[_retriedFlag] = true;
      final response = await _dio.fetch<dynamic>(err.requestOptions);
      handler.resolve(response);
    } on DioException catch (retryError) {
      handler.next(retryError);
    }
  }
}
