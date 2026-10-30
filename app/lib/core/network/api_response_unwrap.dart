import 'package:dio/dio.dart';

/// Unwraps the payload from a [Response], throwing a [DioException]
/// with type [DioExceptionType.badResponse] if [Response.data] is null.
T unwrapApiResponse<T>(Response<T> response) {
  final data = response.data;
  if (data == null) {
    throw DioException(
      requestOptions: response.requestOptions,
      type: DioExceptionType.badResponse,
      response: response,
    );
  }
  return data;
}

