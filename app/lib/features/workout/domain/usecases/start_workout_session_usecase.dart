import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/workout_session.dart';
import '../repositories/workout_session_repository.dart';

class StartWorkoutSessionParams extends Equatable {
  const StartWorkoutSessionParams({
    required this.memberId,
    this.workoutPlanId,
    this.workoutPlanVersionId,
  });

  final String memberId;
  final String? workoutPlanId;
  final String? workoutPlanVersionId;

  @override
  List<Object?> get props => [memberId, workoutPlanId, workoutPlanVersionId];
}

@lazySingleton
class StartWorkoutSessionUseCase
    implements UseCase<WorkoutSession, StartWorkoutSessionParams> {
  const StartWorkoutSessionUseCase(this._repository);

  final WorkoutSessionRepository _repository;

  @override
  Future<Either<Failure, WorkoutSession>> call(
    StartWorkoutSessionParams params,
  ) {
    return _repository.startSession(
      memberId: params.memberId,
      workoutPlanId: params.workoutPlanId,
      workoutPlanVersionId: params.workoutPlanVersionId,
    );
  }
}
