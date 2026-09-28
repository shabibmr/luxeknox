import 'package:api_client/api_client.dart' as api;
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

abstract class DashboardRemoteDataSource {
  Future<api.Dashboard> getDashboard();
}

@LazySingleton(as: DashboardRemoteDataSource)
class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  DashboardRemoteDataSourceImpl(this._dashApi);

  final api.DASHApi _dashApi;

  @override
  Future<api.Dashboard> getDashboard() async {
    final response = await _dashApi.getDashboard();
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
}
