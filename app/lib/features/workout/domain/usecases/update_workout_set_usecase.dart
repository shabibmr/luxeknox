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
    this.isCompleted,
  });

  final String sessionId;
  final String setId;
  final int? reps;
  final num? weightKg;
  final num? rpe;
  final bool? isCompleted;

  @override
  List<Object?> get props => [
    sessionId,
    setId,
    reps,
    weightKg,
    rpe,
    isCompleted,
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
      isCompleted: params.isCompleted,
    );
  }
}
