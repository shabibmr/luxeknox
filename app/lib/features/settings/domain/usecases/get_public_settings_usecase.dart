import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/gym_public_settings.dart';
import '../repositories/settings_repository.dart';

@lazySingleton
class GetPublicSettingsUseCase
    implements UseCase<GymPublicSettings, NoParams> {
  const GetPublicSettingsUseCase(this._repository);

  final SettingsRepository _repository;

  @override
  Future<Either<Failure, GymPublicSettings>> call(NoParams params) {
    return _repository.getPublicSettings();
  }
}
