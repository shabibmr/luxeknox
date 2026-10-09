import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/health_info.dart';
import '../repositories/profile_repository.dart';

@lazySingleton
class ListHealthHistoryUseCase implements UseCase<List<HealthInfo>, int> {
  const ListHealthHistoryUseCase(this._repository);

  final ProfileRepository _repository;

  @override
  Future<Either<Failure, List<HealthInfo>>> call(int memberId) {
    return _repository.listHealthHistory(memberId);
  }
}
