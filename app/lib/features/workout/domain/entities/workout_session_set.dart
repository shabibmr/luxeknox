import 'package:equatable/equatable.dart';

class WorkoutSessionSet extends Equatable {
  const WorkoutSessionSet({
    required this.id,
    required this.workoutSessionId,
    required this.exerciseId,
    required this.setNumber,
    this.repsCompleted,
    this.weightLiftedKg,
    this.rpeScore,
    this.targetRir,
    this.actualRir,
    this.targetDurationSeconds,
    this.actualDurationSeconds,
    this.isCompleted,
    this.notes,
  });

  final String id;
  final String workoutSessionId;
  final String exerciseId;
  final int setNumber;
  final int? repsCompleted;
  final num? weightLiftedKg;
  final num? rpeScore;
  final String? targetRir;
  final String? actualRir;
  final int? targetDurationSeconds;
  final int? actualDurationSeconds;
  final bool? isCompleted;
  final String? notes;

  num? get targetRirNum => targetRir != null ? num.tryParse(targetRir!) : null;
  num? get actualRirNum => actualRir != null ? num.tryParse(actualRir!) : null;

  WorkoutSessionSet copyWith({
    String? id,
    String? workoutSessionId,
    String? exerciseId,
    int? setNumber,
    int? repsCompleted,
    num? weightLiftedKg,
    num? rpeScore,
    String? targetRir,
    String? actualRir,
    int? targetDurationSeconds,
    int? actualDurationSeconds,
    bool? isCompleted,
    String? notes,
  }) {
    return WorkoutSessionSet(
      id: id ?? this.id,
      workoutSessionId: workoutSessionId ?? this.workoutSessionId,
      exerciseId: exerciseId ?? this.exerciseId,
      setNumber: setNumber ?? this.setNumber,
      repsCompleted: repsCompleted ?? this.repsCompleted,
      weightLiftedKg: weightLiftedKg ?? this.weightLiftedKg,
      rpeScore: rpeScore ?? this.rpeScore,
      targetRir: targetRir ?? this.targetRir,
      actualRir: actualRir ?? this.actualRir,
      targetDurationSeconds:
          targetDurationSeconds ?? this.targetDurationSeconds,
      actualDurationSeconds:
          actualDurationSeconds ?? this.actualDurationSeconds,
      isCompleted: isCompleted ?? this.isCompleted,
      notes: notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props => [
    id,
    workoutSessionId,
    exerciseId,
    setNumber,
    repsCompleted,
    weightLiftedKg,
    rpeScore,
    targetRir,
    actualRir,
    targetDurationSeconds,
    actualDurationSeconds,
    isCompleted,
    notes,
  ];
}
