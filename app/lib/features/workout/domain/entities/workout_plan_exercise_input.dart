import 'package:equatable/equatable.dart';

/// Builder / replace-write line item. [exerciseName] is UI-only.
class WorkoutPlanExerciseInput extends Equatable {
  const WorkoutPlanExerciseInput({
    required this.exerciseId,
    required this.dayNumber,
    required this.orderIndex,
    this.targetSets,
    this.targetReps,
    this.targetWeightKg,
    this.restSeconds,
    this.notes,
    this.exerciseName,
  });

  final String exerciseId;
  final int dayNumber;
  final int orderIndex;
  final int? targetSets;
  final String? targetReps;
  final num? targetWeightKg;
  final int? restSeconds;
  final String? notes;
  final String? exerciseName;

  WorkoutPlanExerciseInput copyWith({
    String? exerciseId,
    int? dayNumber,
    int? orderIndex,
    int? targetSets,
    String? targetReps,
    num? targetWeightKg,
    int? restSeconds,
    String? notes,
    String? exerciseName,
  }) {
    return WorkoutPlanExerciseInput(
      exerciseId: exerciseId ?? this.exerciseId,
      dayNumber: dayNumber ?? this.dayNumber,
      orderIndex: orderIndex ?? this.orderIndex,
      targetSets: targetSets ?? this.targetSets,
      targetReps: targetReps ?? this.targetReps,
      targetWeightKg: targetWeightKg ?? this.targetWeightKg,
      restSeconds: restSeconds ?? this.restSeconds,
      notes: notes ?? this.notes,
      exerciseName: exerciseName ?? this.exerciseName,
    );
  }

  @override
  List<Object?> get props => [
    exerciseId,
    dayNumber,
    orderIndex,
    targetSets,
    targetReps,
    targetWeightKg,
    restSeconds,
    notes,
    exerciseName,
  ];
}
