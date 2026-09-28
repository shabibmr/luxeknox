import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/workout_plan.dart';
import '../repositories/workout_plan_repository.dart';

@lazySingleton
class GetWorkoutPlanUseCase implements UseCase<WorkoutPlan, String> {
  const GetWorkoutPlanUseCase(this._repository);

  final WorkoutPlanRepository _repository;

  @override
  Future<Either<Failure, WorkoutPlan>> call(String id) {
    return _repository.getPlan(id);
  }
}
