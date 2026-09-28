import 'package:api_client/api_client.dart' as api;
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

abstract class AlertsRemoteDataSource {
  Future<api.AuditLogPage> listAuditLogs({String? cursor, int? limit});
}

@LazySingleton(as: AlertsRemoteDataSource)
class AlertsRemoteDataSourceImpl implements AlertsRemoteDataSource {
  AlertsRemoteDataSourceImpl(this._sysApi);

  final api.SYSApi _sysApi;

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
  Future<api.AuditLogPage> listAuditLogs({String? cursor, int? limit}) async {
    return _unwrap(await _sysApi.listAuditLogs(cursor: cursor, limit: limit));
  }
}
