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
    this.effortRating,
    this.satisfactionRating,
    this.painDiscomfortScore,
    this.painNotes,
    this.trainerNotes,
    this.nextSessionPlan,
    this.sessionFocus,
    this.warmupProtocol,
    this.cooldownProtocol,
    this.clientSigned,
    this.trainerSigned,
    this.clientSignedAt,
    this.trainerSignedAt,
  });

  final String sessionId;
  final String? notes;
  final int? clientFeedbackRating;
  final int? effortRating;
  final int? satisfactionRating;
  final int? painDiscomfortScore;
  final String? painNotes;
  final String? trainerNotes;
  final String? nextSessionPlan;
  final String? sessionFocus;
  final String? warmupProtocol;
  final String? cooldownProtocol;
  final bool? clientSigned;
  final bool? trainerSigned;
  final DateTime? clientSignedAt;
  final DateTime? trainerSignedAt;

  @override
  List<Object?> get props => [
    sessionId,
    notes,
    clientFeedbackRating,
    effortRating,
    satisfactionRating,
    painDiscomfortScore,
    painNotes,
    trainerNotes,
    nextSessionPlan,
    sessionFocus,
    warmupProtocol,
    cooldownProtocol,
    clientSigned,
    trainerSigned,
    clientSignedAt,
    trainerSignedAt,
  ];
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
      effortRating: params.effortRating,
      satisfactionRating: params.satisfactionRating,
      painDiscomfortScore: params.painDiscomfortScore,
      painNotes: params.painNotes,
      trainerNotes: params.trainerNotes,
      nextSessionPlan: params.nextSessionPlan,
      sessionFocus: params.sessionFocus,
      warmupProtocol: params.warmupProtocol,
      cooldownProtocol: params.cooldownProtocol,
      clientSigned: params.clientSigned,
      trainerSigned: params.trainerSigned,
      clientSignedAt: params.clientSignedAt,
      trainerSignedAt: params.trainerSignedAt,
    );
  }
}
