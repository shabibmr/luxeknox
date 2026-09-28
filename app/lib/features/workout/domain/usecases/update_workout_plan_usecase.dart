import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/workout_plan.dart';
import '../repositories/workout_plan_repository.dart';

class UpdateWorkoutPlanParams extends Equatable {
  const UpdateWorkoutPlanParams({
    required this.id,
    required this.rowVersion,
    this.title,
    this.description,
    this.memberId,
    this.trainerId,
    this.targetGoal,
    this.difficulty,
    this.durationWeeks,
    this.isTemplate,
  });

  final String id;
  final int rowVersion;
  final String? title;
  final String? description;
  final String? memberId;
  final String? trainerId;
  final String? targetGoal;
  final String? difficulty;
  final int? durationWeeks;
  final bool? isTemplate;

  @override
  List<Object?> get props => [
    id,
    rowVersion,
    title,
    description,
    memberId,
    trainerId,
    targetGoal,
    difficulty,
    durationWeeks,
    isTemplate,
  ];
}

@lazySingleton
class UpdateWorkoutPlanUseCase
    implements UseCase<WorkoutPlan, UpdateWorkoutPlanParams> {
  const UpdateWorkoutPlanUseCase(this._repository);

  final WorkoutPlanRepository _repository;

  @override
  Future<Either<Failure, WorkoutPlan>> call(UpdateWorkoutPlanParams params) {
    return _repository.updatePlan(
      params.id,
      title: params.title,
      description: params.description,
      memberId: params.memberId,
      trainerId: params.trainerId,
      targetGoal: params.targetGoal,
      difficulty: params.difficulty,
      durationWeeks: params.durationWeeks,
      isTemplate: params.isTemplate,
      rowVersion: params.rowVersion,
    );
  }
}
