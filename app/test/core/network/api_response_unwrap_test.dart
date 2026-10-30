import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luxeknox/core/network/api_response_unwrap.dart';

void main() {
  group('unwrapApiResponse', () {
    test('returns data when response.data is non-null', () {
      final requestOptions = RequestOptions(path: '/test');
      final response = Response<String>(
        requestOptions: requestOptions,
        data: 'payload',
        statusCode: 200,
      );

      final result = unwrapApiResponse(response);

      expect(result, 'payload');
    });

    test('throws DioException with badResponse when response.data is null', () {
      final requestOptions = RequestOptions(path: '/test');
      final response = Response<String>(
        requestOptions: requestOptions,
        data: null,
        statusCode: 200,
      );

      expect(
        () => unwrapApiResponse(response),
        throwsA(
          isA<DioException>()
              .having((e) => e.type, 'type', DioExceptionType.badResponse)
              .having((e) => e.requestOptions, 'requestOptions', requestOptions)
              .having((e) => e.response, 'response', response),
        ),
      );
    });

  });
}
