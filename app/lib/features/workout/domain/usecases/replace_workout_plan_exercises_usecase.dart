import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/workout_plan.dart';
import '../entities/workout_plan_exercise_input.dart';
import '../repositories/workout_plan_repository.dart';

class ReplaceWorkoutPlanExercisesParams extends Equatable {
  const ReplaceWorkoutPlanExercisesParams({
    required this.id,
    required this.rowVersion,
    this.changelog,
    required this.exercises,
  });

  final String id;
  final int rowVersion;
  final String? changelog;
  final List<WorkoutPlanExerciseInput> exercises;

  @override
  List<Object?> get props => [id, rowVersion, changelog, exercises];
}

@lazySingleton
class ReplaceWorkoutPlanExercisesUseCase
    implements UseCase<WorkoutPlan, ReplaceWorkoutPlanExercisesParams> {
  const ReplaceWorkoutPlanExercisesUseCase(this._repository);

  final WorkoutPlanRepository _repository;

  @override
  Future<Either<Failure, WorkoutPlan>> call(
    ReplaceWorkoutPlanExercisesParams params,
  ) {
    return _repository.replaceExercises(
      params.id,
      rowVersion: params.rowVersion,
      changelog: params.changelog,
      exercises: params.exercises,
    );
  }
}
