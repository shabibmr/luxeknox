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
    this.isCompleted = true,
  });

  final String sessionId;
  final String exerciseId;
  final int setNumber;
  final int? repsCompleted;
  final num? weightLiftedKg;
  final num? rpeScore;
  final bool? isCompleted;

  @override
  List<Object?> get props => [
    sessionId,
    exerciseId,
    setNumber,
    repsCompleted,
    weightLiftedKg,
    rpeScore,
    isCompleted,
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
      isCompleted: params.isCompleted,
    );
  }
}
