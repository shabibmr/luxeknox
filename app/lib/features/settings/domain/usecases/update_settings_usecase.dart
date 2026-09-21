import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/app_setting.dart';
import '../repositories/settings_repository.dart';

@lazySingleton
class UpdateSettingsUseCase
    implements UseCase<List<AppSetting>, List<AppSetting>> {
  const UpdateSettingsUseCase(this._repository);

  final SettingsRepository _repository;

  @override
  Future<Either<Failure, List<AppSetting>>> call(List<AppSetting> params) {
    return _repository.updateSettings(params);
  }
}
