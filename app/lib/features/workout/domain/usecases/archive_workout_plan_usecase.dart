import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/workout_plan.dart';
import '../repositories/workout_plan_repository.dart';

@lazySingleton
class ArchiveWorkoutPlanUseCase implements UseCase<WorkoutPlan, String> {
  const ArchiveWorkoutPlanUseCase(this._repository);

  final WorkoutPlanRepository _repository;

  @override
  Future<Either<Failure, WorkoutPlan>> call(String id) {
    return _repository.archive(id);
  }
}
