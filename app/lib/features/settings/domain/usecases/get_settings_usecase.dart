import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/app_setting.dart';
import '../entities/setting_category.dart';
import '../repositories/settings_repository.dart';

class GetSettingsParams extends Equatable {
  const GetSettingsParams({this.category});

  final SettingCategory? category;

  @override
  List<Object?> get props => [category];
}

@lazySingleton
class GetSettingsUseCase
    implements UseCase<List<AppSetting>, GetSettingsParams> {
  const GetSettingsUseCase(this._repository);

  final SettingsRepository _repository;

  @override
  Future<Either<Failure, List<AppSetting>>> call(GetSettingsParams params) {
    return _repository.getSettings(category: params.category);
  }
}
