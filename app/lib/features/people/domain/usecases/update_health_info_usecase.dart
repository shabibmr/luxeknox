import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/health_info.dart';
import '../repositories/profile_repository.dart';

@lazySingleton
class UpdateHealthInfoUseCase implements UseCase<HealthInfo, HealthInfo> {
  const UpdateHealthInfoUseCase(this._repository);

  final ProfileRepository _repository;

  @override
  Future<Either<Failure, HealthInfo>> call(HealthInfo info) {
    return _repository.updateHealthInfo(info);
  }
}
