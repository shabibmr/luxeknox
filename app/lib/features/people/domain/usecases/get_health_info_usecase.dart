import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/health_info.dart';
import '../repositories/profile_repository.dart';

@lazySingleton
class GetHealthInfoUseCase implements UseCase<HealthInfo, int> {
  const GetHealthInfoUseCase(this._repository);

  final ProfileRepository _repository;

  @override
  Future<Either<Failure, HealthInfo>> call(int memberId) {
    return _repository.getHealthInfo(memberId);
  }
}
