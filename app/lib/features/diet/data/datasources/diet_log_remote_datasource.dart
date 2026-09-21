import 'package:api_client/api_client.dart' as api;
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

abstract class DietLogRemoteDataSource {
  Future<api.DietLog> recordDietLog({
    required int memberId,
    required api.Date date,
    required api.DietLogWrite write,
  });

  Future<api.DietLogPage> listDietLogs({
    required int memberId,
    int? limit,
    String? cursor,
  });
}

@LazySingleton(as: DietLogRemoteDataSource)
class DietLogRemoteDataSourceImpl implements DietLogRemoteDataSource {
  DietLogRemoteDataSourceImpl(this._dietApi);

  final api.DIETApi _dietApi;

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
  Future<api.DietLog> recordDietLog({
    required int memberId,
    required api.Date date,
    required api.DietLogWrite write,
  }) async {
    return _unwrap(
      await _dietApi.putDietLog(
        id: memberId,
        date: date,
        dietLogWrite: write,
      ),
    );
  }

  @override
  Future<api.DietLogPage> listDietLogs({
    required int memberId,
    int? limit,
    String? cursor,
  }) async {
    return _unwrap(
      await _dietApi.listDietLogs(
        id: memberId,
        limit: limit,
        cursor: cursor,
      ),
    );
  }
}
