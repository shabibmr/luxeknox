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
    this.primaryObjective12w,
    this.milestone4w,
    this.sessionsPerWeek,
    this.targetSessionDurationMinutes,
    this.splitType,
    this.cardioProtocol,
    this.mobilityProtocol,
    this.progressionMethods,
    this.mainSuccessMeasure,
    this.trainerProgrammingNotes,
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

  // Macrocycle Blueprint fields (PTF-12 / PTF-25)
  final String? primaryObjective12w;
  final String? milestone4w;
  final int? sessionsPerWeek;
  final int? targetSessionDurationMinutes;
  final String? splitType;
  final String? cardioProtocol;
  final String? mobilityProtocol;
  final List<String>? progressionMethods;
  final String? mainSuccessMeasure;
  final String? trainerProgrammingNotes;

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
    primaryObjective12w,
    milestone4w,
    sessionsPerWeek,
    targetSessionDurationMinutes,
    splitType,
    cardioProtocol,
    mobilityProtocol,
    progressionMethods,
    mainSuccessMeasure,
    trainerProgrammingNotes,
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
      primaryObjective12w: params.primaryObjective12w,
      milestone4w: params.milestone4w,
      sessionsPerWeek: params.sessionsPerWeek,
      targetSessionDurationMinutes: params.targetSessionDurationMinutes,
      splitType: params.splitType,
      cardioProtocol: params.cardioProtocol,
      mobilityProtocol: params.mobilityProtocol,
      progressionMethods: params.progressionMethods,
      mainSuccessMeasure: params.mainSuccessMeasure,
      trainerProgrammingNotes: params.trainerProgrammingNotes,
    );
  }
}
