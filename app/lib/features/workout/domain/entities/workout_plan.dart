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
  ];
}
