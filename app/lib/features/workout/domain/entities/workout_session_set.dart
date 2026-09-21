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
    this.isCompleted,
  });

  final String id;
  final String workoutSessionId;
  final String exerciseId;
  final int setNumber;
  final int? repsCompleted;
  final num? weightLiftedKg;
  final num? rpeScore;
  final bool? isCompleted;

  @override
  List<Object?> get props => [
    id,
    workoutSessionId,
    exerciseId,
    setNumber,
    repsCompleted,
    weightLiftedKg,
    rpeScore,
    isCompleted,
  ];
}
