import 'dart:developer' as developer;

import 'package:dio/dio.dart';

/// Logs failed HTTP requests only (method, path, status, and request_id).
///
/// Under no circumstances are tokens or request/response bodies logged.
class LoggingInterceptor extends Interceptor {
  const LoggingInterceptor({this.logFunction = developer.log});

  final void Function(
    String message, {
    DateTime? time,
    int? sequenceNumber,
    int level,
    String name,
    Object? error,
    StackTrace? stackTrace,
  })
  logFunction;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final method = err.requestOptions.method.toUpperCase();
    final path = err.requestOptions.path;
    final status = err.response?.statusCode;

    String? requestId;
    final responseData = err.response?.data;
    if (responseData is Map) {
      final id = responseData['request_id'];
      if (id is String) {
        requestId = id;
      }
    }

    final statusStr = status != null ? status.toString() : 'NO_RESPONSE';
    final requestIdStr = requestId != null ? ' [request_id: $requestId]' : '';

    logFunction(
      'HTTP ERROR: $method $path -> $statusStr$requestIdStr',
      name: 'network',
    );

    handler.next(err);
  }
}
