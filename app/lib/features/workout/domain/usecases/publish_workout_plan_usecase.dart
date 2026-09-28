import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/workout_plan.dart';
import '../repositories/workout_plan_repository.dart';

@lazySingleton
class PublishWorkoutPlanUseCase implements UseCase<WorkoutPlan, String> {
  const PublishWorkoutPlanUseCase(this._repository);

  final WorkoutPlanRepository _repository;

  @override
  Future<Either<Failure, WorkoutPlan>> call(String id) {
    return _repository.publish(id);
  }
}
