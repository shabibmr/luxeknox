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
    this.restBetweenExercisesSeconds,
    this.notes,
    this.targetRir,
    this.targetDurationSeconds,
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
  final int? restBetweenExercisesSeconds;
  final String? notes;

  // Micro-execution / Timed holds / RIR (PTF-13 / PTF-25)
  final String? targetRir;
  final int? targetDurationSeconds;

  num? get targetRirNum => targetRir != null ? num.tryParse(targetRir!) : null;

  WorkoutPlanExercise copyWith({
    String? id,
    String? exerciseId,
    String? exerciseName,
    int? dayNumber,
    int? orderIndex,
    int? targetSets,
    String? targetReps,
    num? targetWeightKg,
    int? restSeconds,
    int? restBetweenExercisesSeconds,
    String? notes,
    String? targetRir,
    int? targetDurationSeconds,
  }) {
    return WorkoutPlanExercise(
      id: id ?? this.id,
      exerciseId: exerciseId ?? this.exerciseId,
      exerciseName: exerciseName ?? this.exerciseName,
      dayNumber: dayNumber ?? this.dayNumber,
      orderIndex: orderIndex ?? this.orderIndex,
      targetSets: targetSets ?? this.targetSets,
      targetReps: targetReps ?? this.targetReps,
      targetWeightKg: targetWeightKg ?? this.targetWeightKg,
      restSeconds: restSeconds ?? this.restSeconds,
      restBetweenExercisesSeconds:
          restBetweenExercisesSeconds ?? this.restBetweenExercisesSeconds,
      notes: notes ?? this.notes,
      targetRir: targetRir ?? this.targetRir,
      targetDurationSeconds:
          targetDurationSeconds ?? this.targetDurationSeconds,
    );
  }

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
    restBetweenExercisesSeconds,
    notes,
    targetRir,
    targetDurationSeconds,
  ];
}
