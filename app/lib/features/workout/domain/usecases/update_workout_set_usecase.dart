import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/workout_session_set.dart';
import '../repositories/workout_session_repository.dart';

class UpdateWorkoutSetParams extends Equatable {
  const UpdateWorkoutSetParams({
    required this.sessionId,
    required this.setId,
    this.reps,
    this.weightKg,
    this.rpe,
    this.targetRir,
    this.actualRir,
    this.targetDurationSeconds,
    this.actualDurationSeconds,
    this.isCompleted,
    this.notes,
  });

  final String sessionId;
  final String setId;
  final int? reps;
  final num? weightKg;
  final num? rpe;
  final num? targetRir;
  final num? actualRir;
  final int? targetDurationSeconds;
  final int? actualDurationSeconds;
  final bool? isCompleted;
  final String? notes;

  @override
  List<Object?> get props => [
    sessionId,
    setId,
    reps,
    weightKg,
    rpe,
    targetRir,
    actualRir,
    targetDurationSeconds,
    actualDurationSeconds,
    isCompleted,
    notes,
  ];
}

@lazySingleton
class UpdateWorkoutSetUseCase
    implements UseCase<WorkoutSessionSet, UpdateWorkoutSetParams> {
  const UpdateWorkoutSetUseCase(this._repository);

  final WorkoutSessionRepository _repository;

  @override
  Future<Either<Failure, WorkoutSessionSet>> call(
    UpdateWorkoutSetParams params,
  ) {
    return _repository.updateSet(
      params.sessionId,
      params.setId,
      reps: params.reps,
      weightKg: params.weightKg,
      rpe: params.rpe,
      targetRir: params.targetRir,
      actualRir: params.actualRir,
      targetDurationSeconds: params.targetDurationSeconds,
      actualDurationSeconds: params.actualDurationSeconds,
      isCompleted: params.isCompleted,
      notes: params.notes,
    );
  }
}
