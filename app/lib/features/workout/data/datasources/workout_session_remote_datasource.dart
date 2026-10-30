import 'package:api_client/api_client.dart' as api;
import '../../../../core/network/api_response_unwrap.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/session_completion.dart';
import '../models/workout_plan_mappers.dart';

abstract class WorkoutSessionRemoteDataSource {
  Future<api.WorkoutSessionPage> listSessions({
    int? memberId,
    int? limit,
    String? cursor,
  });

  Future<api.WorkoutSession> startSession(api.WorkoutSessionCreate create);

  Future<api.WorkoutSessionExercise> logSet(
    int sessionId,
    api.WorkoutSetWrite write,
  );

  Future<api.WorkoutSession> completeSession(
    int sessionId, {
    SessionCompletion completion = const SessionCompletion(),
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
  });

  Future<api.WorkoutSession> getActiveSession({int? memberId});

  Future<api.WorkoutSessionExercise> updateSet(
    int sessionId,
    int setId,
    api.WorkoutSetUpdate update,
  );

  Future<void> deleteSet(int sessionId, int setId);

  Future<List<api.ExerciseHistorySession>> getExerciseHistory({
    int? memberId,
    required int exerciseId,
  });
}

@LazySingleton(as: WorkoutSessionRemoteDataSource)
class WorkoutSessionRemoteDataSourceImpl
    implements WorkoutSessionRemoteDataSource {
  WorkoutSessionRemoteDataSourceImpl(this._workApi);

  final api.WORKApi _workApi;

  @override
  Future<api.WorkoutSessionPage> listSessions({
    int? memberId,
    int? limit,
    String? cursor,
  }) async {
    return unwrapApiResponse(
      await _workApi.listWorkoutSessions(
        memberId: memberId,
        limit: limit,
        cursor: cursor,
      ),
    );
  }

  @override
  Future<api.WorkoutSession> startSession(
    api.WorkoutSessionCreate create,
  ) async {
    return unwrapApiResponse(
      await _workApi.startWorkoutSession(workoutSessionCreate: create),
    );
  }

  @override
  Future<api.WorkoutSessionExercise> logSet(
    int sessionId,
    api.WorkoutSetWrite write,
  ) async {
    return unwrapApiResponse(
      await _workApi.logWorkoutSet(id: sessionId, workoutSetWrite: write),
    );
  }

  @override
  Future<api.WorkoutSession> completeSession(
    int sessionId, {
    SessionCompletion completion = const SessionCompletion(),
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
  }) async {
    final resolved = completion != const SessionCompletion()
        ? completion
        : SessionCompletion(
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
          );

    final trimmedNotes = resolved.notes?.trim();
    final trimmedPainNotes = resolved.painNotes?.trim();
    final trimmedTrainerNotes = resolved.trainerNotes?.trim();
    final trimmedNextPlan = resolved.nextSessionPlan?.trim();
    final trimmedFocus = resolved.sessionFocus?.trim();
    final trimmedWarmup = resolved.warmupProtocol?.trim();
    final trimmedCooldown = resolved.cooldownProtocol?.trim();

    final hasBody =
        (trimmedNotes != null && trimmedNotes.isNotEmpty) ||
        resolved.clientFeedbackRating != null ||
        resolved.effortRating != null ||
        resolved.satisfactionRating != null ||
        resolved.painDiscomfortScore != null ||
        (trimmedPainNotes != null && trimmedPainNotes.isNotEmpty) ||
        (trimmedTrainerNotes != null && trimmedTrainerNotes.isNotEmpty) ||
        (trimmedNextPlan != null && trimmedNextPlan.isNotEmpty) ||
        (trimmedFocus != null && trimmedFocus.isNotEmpty) ||
        (trimmedWarmup != null && trimmedWarmup.isNotEmpty) ||
        (trimmedCooldown != null && trimmedCooldown.isNotEmpty) ||
        resolved.clientSigned != null ||
        resolved.trainerSigned != null;

    final completeBody = hasBody
        ? toWorkoutSessionComplete(
            SessionCompletion(
              notes: trimmedNotes,
              clientFeedbackRating: resolved.clientFeedbackRating,
              effortRating: resolved.effortRating,
              satisfactionRating: resolved.satisfactionRating,
              painDiscomfortScore: resolved.painDiscomfortScore,
              painNotes: trimmedPainNotes,
              trainerNotes: trimmedTrainerNotes,
              nextSessionPlan: trimmedNextPlan,
              sessionFocus: trimmedFocus,
              warmupProtocol: trimmedWarmup,
              cooldownProtocol: trimmedCooldown,
              clientSigned: resolved.clientSigned,
              trainerSigned: resolved.trainerSigned,
            ),
          )
        : null;

    return unwrapApiResponse(
      await _workApi.completeWorkoutSession(
        id: sessionId,
        workoutSessionComplete: completeBody,
      ),
    );
  }

  @override
  Future<api.WorkoutSession> getActiveSession({int? memberId}) async {
    return unwrapApiResponse(
      await _workApi.getActiveWorkoutSession(memberId: memberId),
    );
  }

  @override
  Future<api.WorkoutSessionExercise> updateSet(
    int sessionId,
    int setId,
    api.WorkoutSetUpdate update,
  ) async {
    return unwrapApiResponse(
      await _workApi.updateWorkoutSet(
        id: sessionId,
        setId: setId,
        workoutSetUpdate: update,
      ),
    );
  }

  @override
  Future<void> deleteSet(int sessionId, int setId) async {
    await _workApi.deleteWorkoutSet(id: sessionId, setId: setId);
  }

  @override
  Future<List<api.ExerciseHistorySession>> getExerciseHistory({
    int? memberId,
    required int exerciseId,
  }) async {
    final response = await _workApi.getExerciseHistory(
      memberId: memberId,
      exerciseId: exerciseId,
    );
    final list = unwrapApiResponse(response);
    return list.toList();
  }
}
