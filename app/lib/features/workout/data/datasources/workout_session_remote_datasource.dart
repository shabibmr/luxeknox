import 'package:api_client/api_client.dart' as api;
import 'package:built_value/serializer.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

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
  });

  Future<api.WorkoutSession> getActiveSession({int? memberId});

  Future<api.WorkoutSessionExercise> updateSet(
    int sessionId,
    int setId,
    api.WorkoutSetUpdate update,
  );

  Future<void> deleteSet(int sessionId, int setId);
}

@LazySingleton(as: WorkoutSessionRemoteDataSource)
class WorkoutSessionRemoteDataSourceImpl
    implements WorkoutSessionRemoteDataSource {
  WorkoutSessionRemoteDataSourceImpl(this._workApi, this._dio);

  final api.WORKApi _workApi;
  final Dio _dio;

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
  }) async {
    final trimmedNotes = notes?.trim();
    final hasBody =
        (trimmedNotes != null && trimmedNotes.isNotEmpty) ||
        clientFeedbackRating != null;

    // OpenAPI complete has no body; FR-WORK-013 notes/rating use forward-compat POST.
    if (!hasBody) {
      return _unwrap(await _workApi.completeWorkoutSession(id: sessionId));
    }

    final body = <String, dynamic>{
      if (trimmedNotes != null && trimmedNotes.isNotEmpty)
        'notes': trimmedNotes,
      'client_feedback_rating': ?clientFeedbackRating,
    };
    final response = await _dio.post<Object>(
      '/workout-sessions/$sessionId/complete',
      data: body,
    );
    try {
      final raw = response.data;
      if (raw == null) {
        throw DioException(
          requestOptions: response.requestOptions,
          type: DioExceptionType.badResponse,
          response: response,
        );
      }
      return api.standardSerializers.deserialize(
            raw,
            specifiedType: const FullType(api.WorkoutSession),
          )
          as api.WorkoutSession;
    } catch (error, stackTrace) {
      if (error is DioException) rethrow;
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }
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
}
