import 'package:api_client/api_client.dart' as api;
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

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
    DateTime? clientSignedAt,
    DateTime? trainerSignedAt,
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
  WorkoutSessionRemoteDataSourceImpl(this._workApi, [Dio? dio]) : _dio = dio;

  final api.WORKApi _workApi;
  // ignore: unused_field
  final Dio? _dio;

  T _unwrap<T>(Response<T> response) {
    final data = response.data;
    if (data == null) {
      throw DioException(
        requestOptions: response.requestOptions,
        type: DioExceptionType.badResponse,
        response: response,
      );
    }
    return data;
  }

  @override
  Future<api.WorkoutSessionPage> listSessions({
    int? memberId,
    int? limit,
    String? cursor,
  }) async {
    return _unwrap(
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
    return _unwrap(
      await _workApi.startWorkoutSession(workoutSessionCreate: create),
    );
  }

  @override
  Future<api.WorkoutSessionExercise> logSet(
    int sessionId,
    api.WorkoutSetWrite write,
  ) async {
    return _unwrap(
      await _workApi.logWorkoutSet(id: sessionId, workoutSetWrite: write),
    );
  }

  @override
  Future<api.WorkoutSession> completeSession(
    int sessionId, {
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
    DateTime? clientSignedAt,
    DateTime? trainerSignedAt,
  }) async {
    final trimmedNotes = notes?.trim();
    final trimmedPainNotes = painNotes?.trim();
    final trimmedTrainerNotes = trainerNotes?.trim();
    final trimmedNextPlan = nextSessionPlan?.trim();
    final trimmedFocus = sessionFocus?.trim();
    final trimmedWarmup = warmupProtocol?.trim();
    final trimmedCooldown = cooldownProtocol?.trim();

    final hasBody =
        (trimmedNotes != null && trimmedNotes.isNotEmpty) ||
        clientFeedbackRating != null ||
        effortRating != null ||
        satisfactionRating != null ||
        painDiscomfortScore != null ||
        (trimmedPainNotes != null && trimmedPainNotes.isNotEmpty) ||
        (trimmedTrainerNotes != null && trimmedTrainerNotes.isNotEmpty) ||
        (trimmedNextPlan != null && trimmedNextPlan.isNotEmpty) ||
        (trimmedFocus != null && trimmedFocus.isNotEmpty) ||
        (trimmedWarmup != null && trimmedWarmup.isNotEmpty) ||
        (trimmedCooldown != null && trimmedCooldown.isNotEmpty) ||
        clientSigned != null ||
        trainerSigned != null ||
        clientSignedAt != null ||
        trainerSignedAt != null;

    final completeBody = hasBody
        ? toWorkoutSessionComplete(
            notes: trimmedNotes,
            clientFeedbackRating: clientFeedbackRating,
            effortRating: effortRating,
            satisfactionRating: satisfactionRating,
            painDiscomfortScore: painDiscomfortScore,
            painNotes: trimmedPainNotes,
            trainerNotes: trimmedTrainerNotes,
            nextSessionPlan: trimmedNextPlan,
            sessionFocus: trimmedFocus,
            warmupProtocol: trimmedWarmup,
            cooldownProtocol: trimmedCooldown,
            clientSigned: clientSigned,
            trainerSigned: trainerSigned,
            clientSignedAt: clientSignedAt,
            trainerSignedAt: trainerSignedAt,
          )
        : null;

    return _unwrap(
      await _workApi.completeWorkoutSession(
        id: sessionId,
        workoutSessionComplete: completeBody,
      ),
    );
  }

  @override
  Future<api.WorkoutSession> getActiveSession({int? memberId}) async {
    return _unwrap(await _workApi.getActiveWorkoutSession(memberId: memberId));
  }

  @override
  Future<api.WorkoutSessionExercise> updateSet(
    int sessionId,
    int setId,
    api.WorkoutSetUpdate update,
  ) async {
    return _unwrap(
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
    final list = _unwrap(response);
    return list.toList();
  }
}
