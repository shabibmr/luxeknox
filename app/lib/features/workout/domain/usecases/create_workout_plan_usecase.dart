import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/workout_plan.dart';
import '../repositories/workout_plan_repository.dart';

class CreateWorkoutPlanParams extends Equatable {
  const CreateWorkoutPlanParams({
    required this.title,
    this.description,
    this.memberId,
    this.trainerId,
    this.targetGoal,
    this.difficulty,
    this.durationWeeks,
    this.isTemplate,
  });

  final String title;
  final String? description;
  final String? memberId;
  final String? trainerId;
  final String? targetGoal;
  final String? difficulty;
  final int? durationWeeks;
  final bool? isTemplate;

  @override
  List<Object?> get props => [
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
class CreateWorkoutPlanUseCase
    implements UseCase<WorkoutPlan, CreateWorkoutPlanParams> {
  const CreateWorkoutPlanUseCase(this._repository);

  final WorkoutPlanRepository _repository;

  @override
  Future<Either<Failure, WorkoutPlan>> call(CreateWorkoutPlanParams params) {
    return _repository.createPlan(
      title: params.title,
      description: params.description,
      memberId: params.memberId,
      trainerId: params.trainerId,
      targetGoal: params.targetGoal,
      difficulty: params.difficulty,
      durationWeeks: params.durationWeeks,
      isTemplate: params.isTemplate,
    );
  }
}
