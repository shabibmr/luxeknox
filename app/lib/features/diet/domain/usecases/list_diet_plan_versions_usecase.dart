import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/diet_plan_version.dart';
import '../repositories/diet_plan_repository.dart';

@lazySingleton
class ListDietPlanVersionsUseCase
    implements UseCase<List<DietPlanVersion>, String> {
  const ListDietPlanVersionsUseCase(this._repository);

  final DietPlanRepository _repository;

  @override
  Future<Either<Failure, List<DietPlanVersion>>> call(String planId) {
    return _repository.listVersions(planId);
  }
}
