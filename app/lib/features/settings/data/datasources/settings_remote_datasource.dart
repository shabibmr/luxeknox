import 'package:api_client/api_client.dart' as api;
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

abstract class SettingsRemoteDataSource {
  Future<api.SettingsList> getSettings({api.SettingCategory? category});

  Future<api.SettingsList> putSettings(api.SettingsWrite write);

  Future<api.PublicSettings> getPublicSettings();
}

@LazySingleton(as: SettingsRemoteDataSource)
class SettingsRemoteDataSourceImpl implements SettingsRemoteDataSource {
  SettingsRemoteDataSourceImpl(this._sysApi);

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
  Future<api.SettingsList> getSettings({api.SettingCategory? category}) async {
    return _unwrap(await _sysApi.getSettings(category: category));
  }

  @override
  Future<api.SettingsList> putSettings(api.SettingsWrite write) async {
    return _unwrap(await _sysApi.putSettings(settingsWrite: write));
  }

  @override
  Future<api.PublicSettings> getPublicSettings() async {
    return _unwrap(await _sysApi.getPublicSettings());
  }
}
