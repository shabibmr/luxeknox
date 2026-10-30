import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/session_completion.dart';
import '../entities/workout_session.dart';
import '../repositories/workout_session_repository.dart';

class CompleteWorkoutSessionParams extends Equatable {
  const CompleteWorkoutSessionParams({
    required this.sessionId,
    this.completion = const SessionCompletion(),
  });

  factory CompleteWorkoutSessionParams.fromFields({
    required String sessionId,
    String? notes,
    int? clientFeedbackRating,
    int? effortRating,
    int? satisfactionRating,
    int? painDiscomfortScore,
    String? painNotes,
    String? trainerNotes,
    String? nextSessionPlan,
    String? sessionFocus,
    String? warmupProtocol,
    String? cooldownProtocol,
    bool? clientSigned,
    bool? trainerSigned,
  }) {
    return CompleteWorkoutSessionParams(
      sessionId: sessionId,
      completion: SessionCompletion(
        notes: notes,
        clientFeedbackRating: clientFeedbackRating,
        effortRating: effortRating,
        satisfactionRating: satisfactionRating,
        painDiscomfortScore: painDiscomfortScore,
        painNotes: painNotes,
        trainerNotes: trainerNotes,
        nextSessionPlan: nextSessionPlan,
        sessionFocus: sessionFocus,
        warmupProtocol: warmupProtocol,
        cooldownProtocol: cooldownProtocol,
        clientSigned: clientSigned,
        trainerSigned: trainerSigned,
      ),
    );
  }

  final String sessionId;
  final SessionCompletion completion;

  String? get notes => completion.notes;
  int? get clientFeedbackRating => completion.clientFeedbackRating;
  int? get effortRating => completion.effortRating;
  int? get satisfactionRating => completion.satisfactionRating;
  int? get painDiscomfortScore => completion.painDiscomfortScore;
  String? get painNotes => completion.painNotes;
  String? get trainerNotes => completion.trainerNotes;
  String? get nextSessionPlan => completion.nextSessionPlan;
  String? get sessionFocus => completion.sessionFocus;
  String? get warmupProtocol => completion.warmupProtocol;
  String? get cooldownProtocol => completion.cooldownProtocol;
  bool? get clientSigned => completion.clientSigned;
  bool? get trainerSigned => completion.trainerSigned;

  @override
  List<Object?> get props => [sessionId, completion];
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
      completion: params.completion,
    );
  }
}
