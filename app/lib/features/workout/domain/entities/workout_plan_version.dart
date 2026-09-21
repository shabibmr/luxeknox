import 'package:equatable/equatable.dart';

import 'workout_plan_exercise.dart';

class WorkoutPlanVersion extends Equatable {
  const WorkoutPlanVersion({
    required this.id,
    required this.planId,
    required this.versionNumber,
    this.changelog,
    this.createdAt,
    this.exercises = const [],
  });

  final String id;
  final String planId;
  final int versionNumber;
  final String? changelog;
  final DateTime? createdAt;
  final List<WorkoutPlanExercise> exercises;

  @override
  List<Object?> get props => [
    id,
    planId,
    versionNumber,
    changelog,
    createdAt,
    exercises,
  ];
}
