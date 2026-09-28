import 'package:api_client/api_client.dart' as api;
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

abstract class ReportRemoteDataSource {
  Future<api.Report> getReport({
    required api.ReportType type,
    api.Date? from,
    api.Date? to,
    int? productId,
    int? trainerId,
  });

  Future<String> exportCsv({
    required String typeWire,
    api.Date? from,
    api.Date? to,
    int? productId,
    int? trainerId,
  });
}

@LazySingleton(as: ReportRemoteDataSource)
class ReportRemoteDataSourceImpl implements ReportRemoteDataSource {
  ReportRemoteDataSourceImpl(this._rptApi, this._dio);

  final api.RPTApi _rptApi;
  final Dio _dio;

  T _unwrap<T>(Response<T> response) {
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

  @override
  Future<api.Report> getReport({
    required api.ReportType type,
    api.Date? from,
    api.Date? to,
    int? productId,
    int? trainerId,
  }) async {
    return _unwrap(
      await _rptApi.getReport(
        type: type,
        from: from,
        to: to,
        productId: productId,
        trainerId: trainerId,
        format: 'json',
      ),
    );
  }

  @override
  Future<String> exportCsv({
    required String typeWire,
    api.Date? from,
    api.Date? to,
    int? productId,
    int? trainerId,
  }) async {
    // Forward-compatible: CSV may be text/csv rather than Report JSON.
    final response = await _dio.get<Object>(
      '/reports/$typeWire',
      queryParameters: <String, dynamic>{
        'from': ?from?.toString(),
        'to': ?to?.toString(),
        'product_id': ?productId,
        'trainer_id': ?trainerId,
        'format': 'csv',
      },
      options: Options(
        responseType: ResponseType.plain,
        validateStatus: (code) => code != null && code >= 200 && code < 300,
      ),
    );
    final data = response.data;
    if (data == null) {
      throw DioException(
        requestOptions: response.requestOptions,
        type: DioExceptionType.badResponse,
        response: response,
      );
    }
    return data.toString();
  }
}
