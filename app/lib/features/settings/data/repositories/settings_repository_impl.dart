import 'package:api_client/api_client.dart' as api;
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/error/map_thrown.dart';
import '../../domain/entities/app_setting.dart';
import '../../domain/entities/setting_category.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_remote_datasource.dart';
import '../models/settings_mappers.dart';

@LazySingleton(as: SettingsRepository)
class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl(this._remote);

  final SettingsRemoteDataSource _remote;

  @override
  Future<Either<Failure, List<AppSetting>>> getSettings({
    SettingCategory? category,
  }) async {
    try {
      final list = await _remote.getSettings(
        category: category == null ? null : categoryToApi(category),
      );
      return Right(list.data.map(appSettingFromApi).toList());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<AppSetting>>> updateSettings(
    List<AppSetting> items,
  ) async {
    try {
      final write = api.SettingsWrite(
        (b) => b.items.replace(items.map(settingsWriteItemFromDomain)),
      );
      final list = await _remote.putSettings(write);
      return Right(list.data.map(appSettingFromApi).toList());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }
}
