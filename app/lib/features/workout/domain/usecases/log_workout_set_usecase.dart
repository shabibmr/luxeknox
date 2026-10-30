import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/workout_session_set.dart';
import '../repositories/workout_session_repository.dart';

class LogWorkoutSetParams extends Equatable {
  const LogWorkoutSetParams({
    required this.sessionId,
    required this.exerciseId,
    required this.setNumber,
    this.repsCompleted,
    this.weightLiftedKg,
    this.rpeScore,
    this.targetRir,
    this.actualRir,
    this.targetDurationSeconds,
    this.actualDurationSeconds,
    this.isCompleted = true,
    this.notes,
  });

  final String sessionId;
  final String exerciseId;
  final int setNumber;
  final int? repsCompleted;
  final num? weightLiftedKg;
  final num? rpeScore;
  final num? targetRir;
  final num? actualRir;
  final int? targetDurationSeconds;
  final int? actualDurationSeconds;
  final bool? isCompleted;
  final String? notes;

  @override
  List<Object?> get props => [
    sessionId,
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

@lazySingleton
class LogWorkoutSetUseCase
    implements UseCase<WorkoutSessionSet, LogWorkoutSetParams> {
  const LogWorkoutSetUseCase(this._repository);

  final WorkoutSessionRepository _repository;

  @override
  Future<Either<Failure, WorkoutSessionSet>> call(LogWorkoutSetParams params) {
    return _repository.logSet(
      params.sessionId,
      exerciseId: params.exerciseId,
      setNumber: params.setNumber,
      repsCompleted: params.repsCompleted,
      weightLiftedKg: params.weightLiftedKg,
      rpeScore: params.rpeScore,
      targetRir: params.targetRir,
      actualRir: params.actualRir,
      targetDurationSeconds: params.targetDurationSeconds,
      actualDurationSeconds: params.actualDurationSeconds,
      isCompleted: params.isCompleted,
      notes: params.notes,
    );
  }
}
