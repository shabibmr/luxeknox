import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/workout_plan_version.dart';
import '../repositories/workout_plan_repository.dart';

@lazySingleton
class ListWorkoutPlanVersionsUseCase
    implements UseCase<List<WorkoutPlanVersion>, String> {
  const ListWorkoutPlanVersionsUseCase(this._repository);

  final WorkoutPlanRepository _repository;

  @override
  Future<Either<Failure, List<WorkoutPlanVersion>>> call(String planId) {
    return _repository.listVersions(planId);
  }
}
