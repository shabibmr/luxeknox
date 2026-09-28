import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/diet_plan.dart';
import '../repositories/diet_plan_repository.dart';

@lazySingleton
class PublishDietPlanUseCase implements UseCase<DietPlan, String> {
  const PublishDietPlanUseCase(this._repository);

  final DietPlanRepository _repository;

  @override
  Future<Either<Failure, DietPlan>> call(String planId) {
    return _repository.publish(planId);
  }
}
