import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/workout_session.dart';
import '../repositories/workout_session_repository.dart';

class CompleteWorkoutSessionParams extends Equatable {
  const CompleteWorkoutSessionParams({
    required this.sessionId,
    this.notes,
    this.clientFeedbackRating,
  });

  final String sessionId;
  final String? notes;
  final int? clientFeedbackRating;

  @override
  List<Object?> get props => [sessionId, notes, clientFeedbackRating];
}

@lazySingleton
class CompleteWorkoutSessionUseCase
    implements UseCase<WorkoutSession, CompleteWorkoutSessionParams> {
  const CompleteWorkoutSessionUseCase(this._repository);

  final WorkoutSessionRepository _repository;

  @override
  Future<Either<Failure, WorkoutSession>> call(
    CompleteWorkoutSessionParams params,
  ) {
    return _repository.completeSession(
      params.sessionId,
      notes: params.notes,
      clientFeedbackRating: params.clientFeedbackRating,
    );
  }
}
