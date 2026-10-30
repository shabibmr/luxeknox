import 'package:equatable/equatable.dart';

import 'workout_plan_exercise.dart';
import 'workout_plan_status.dart';

class WorkoutPlan extends Equatable {
  const WorkoutPlan({
    required this.id,
    required this.title,
    this.description,
    this.memberId,
    this.trainerId,
    this.targetGoal,
    this.difficulty,
    this.durationWeeks,
    required this.isTemplate,
    required this.status,
    this.createdAt,
    required this.rowVersion,
    this.exercises = const [],
    this.primaryObjective12w,
    this.milestone4w,
    this.sessionsPerWeek,
    this.targetSessionDurationMinutes,
    this.splitType,
    this.cardioProtocol,
    this.mobilityProtocol,
    this.progressionMethods = const [],
    this.mainSuccessMeasure,
    this.trainerProgrammingNotes,
  });

  final String id;
  final String title;
  final String? description;
  final String? memberId;
  final String? trainerId;
  final String? targetGoal;
  final String? difficulty;
  final int? durationWeeks;
  final bool isTemplate;
  final WorkoutPlanStatus status;
  final DateTime? createdAt;
  final int rowVersion;
  final List<WorkoutPlanExercise> exercises;

  // Macrocycle Blueprint fields (PTF-12 / PTF-25)
  final String? primaryObjective12w;
  final String? milestone4w;
  final int? sessionsPerWeek;
  final int? targetSessionDurationMinutes;
  final String? splitType;
  final String? cardioProtocol;
  final String? mobilityProtocol;
  final List<String> progressionMethods;
  final String? mainSuccessMeasure;
  final String? trainerProgrammingNotes;

  WorkoutPlan copyWith({
    String? id,
    String? title,
    String? description,
    String? memberId,
    String? trainerId,
    String? targetGoal,
    String? difficulty,
    int? durationWeeks,
    bool? isTemplate,
    WorkoutPlanStatus? status,
    DateTime? createdAt,
    int? rowVersion,
    List<WorkoutPlanExercise>? exercises,
    String? primaryObjective12w,
    String? milestone4w,
    int? sessionsPerWeek,
    int? targetSessionDurationMinutes,
    String? splitType,
    String? cardioProtocol,
    String? mobilityProtocol,
    List<String>? progressionMethods,
    String? mainSuccessMeasure,
    String? trainerProgrammingNotes,
  }) {
    return WorkoutPlan(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      memberId: memberId ?? this.memberId,
      trainerId: trainerId ?? this.trainerId,
      targetGoal: targetGoal ?? this.targetGoal,
      difficulty: difficulty ?? this.difficulty,
      durationWeeks: durationWeeks ?? this.durationWeeks,
      isTemplate: isTemplate ?? this.isTemplate,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      rowVersion: rowVersion ?? this.rowVersion,
      exercises: exercises ?? this.exercises,
      primaryObjective12w: primaryObjective12w ?? this.primaryObjective12w,
      milestone4w: milestone4w ?? this.milestone4w,
      sessionsPerWeek: sessionsPerWeek ?? this.sessionsPerWeek,
      targetSessionDurationMinutes:
          targetSessionDurationMinutes ?? this.targetSessionDurationMinutes,
      splitType: splitType ?? this.splitType,
      cardioProtocol: cardioProtocol ?? this.cardioProtocol,
      mobilityProtocol: mobilityProtocol ?? this.mobilityProtocol,
      progressionMethods: progressionMethods ?? this.progressionMethods,
      mainSuccessMeasure: mainSuccessMeasure ?? this.mainSuccessMeasure,
      trainerProgrammingNotes:
          trainerProgrammingNotes ?? this.trainerProgrammingNotes,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    memberId,
    trainerId,
    targetGoal,
    difficulty,
    durationWeeks,
    isTemplate,
    status,
    createdAt,
    rowVersion,
    exercises,
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
