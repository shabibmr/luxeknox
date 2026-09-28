import 'package:equatable/equatable.dart';

class WorkoutPlanExercise extends Equatable {
  const WorkoutPlanExercise({
    this.id,
    required this.exerciseId,
    this.exerciseName,
    required this.dayNumber,
    required this.orderIndex,
    this.targetSets,
    this.targetReps,
    this.targetWeightKg,
    this.restSeconds,
    this.notes,
  });

  final String? id;
  final String exerciseId;
  final String? exerciseName;
  final int dayNumber;
  final int orderIndex;
  final int? targetSets;
  final String? targetReps;
  final num? targetWeightKg;
  final int? restSeconds;
  final String? notes;

  @override
  List<Object?> get props => [
    id,
    exerciseId,
    exerciseName,
    dayNumber,
    orderIndex,
    targetSets,
    targetReps,
    targetWeightKg,
    restSeconds,
    notes,
  ];
}
