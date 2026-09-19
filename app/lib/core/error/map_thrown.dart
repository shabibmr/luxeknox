import 'package:dio/dio.dart';

import '../network/error_interceptor.dart';
import 'failures.dart';

Failure mapThrownToFailure(Object e) {
  if (e is DioException) {
    if (e.error is FailureDioException) {
      return (e.error! as FailureDioException).failure;
    }
    return mapDioErrorToFailure(e);
  }
  return const UnknownFailure();
}
