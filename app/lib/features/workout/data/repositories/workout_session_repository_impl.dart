import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/error/map_thrown.dart';
import '../../../../core/pagination/cursor_page.dart';
import '../../domain/entities/exercise_history_session.dart';
import '../../domain/entities/performed_set_metrics.dart';
import '../../domain/entities/session_completion.dart';
import '../../domain/entities/workout_session.dart';
import '../../domain/entities/workout_session_set.dart';
import '../../domain/entities/workout_validators.dart';
import '../../domain/repositories/workout_session_repository.dart';
import '../datasources/workout_session_remote_datasource.dart';
import '../models/workout_plan_mappers.dart';

@LazySingleton(as: WorkoutSessionRepository)
class WorkoutSessionRepositoryImpl implements WorkoutSessionRepository {
  WorkoutSessionRepositoryImpl(this._remoteDataSource);

  final WorkoutSessionRemoteDataSource _remoteDataSource;

  int? _parseId(String id) => int.tryParse(id);

  ValidationFailure? _validateSetMetrics(PerformedSetMetrics metrics) {
    return WorkoutValidators.firstFailure([
      WorkoutValidators.validateRir(metrics.actualRir),
      WorkoutValidators.validateDurationSeconds(metrics.actualDurationSeconds),
    ]);
  }

  ValidationFailure? _validateSessionRatings(SessionCompletion completion) {
    return WorkoutValidators.firstFailure([
      WorkoutValidators.validateClientFeedbackRating(
        completion.clientFeedbackRating,
      ),
      WorkoutValidators.validateEffortRating(completion.effortRating),
      WorkoutValidators.validateSatisfactionRating(
        completion.satisfactionRating,
      ),
      WorkoutValidators.validatePainDiscomfortScore(
        completion.painDiscomfortScore,
      ),
    ]);
  }

  @override
  Future<Either<Failure, CursorPage<WorkoutSession>>> listSessions({
    String? memberId,
    int? limit,
    String? cursor,
  }) async {
    if (memberId != null && int.tryParse(memberId) == null) {
      return const Left(ValidationFailure(['Invalid member id']));
    }
    try {
      final page = await _remoteDataSource.listSessions(
        memberId: memberId == null ? null : int.tryParse(memberId),
        limit: limit,
        cursor: cursor,
      );
      return Right(
        CursorPage<WorkoutSession>(
          items: page.data.map((s) => s.toDomain()).toList(),
          nextCursor: page.meta.nextCursor,
          hasMore: page.meta.hasMore,
        ),
      );
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, WorkoutSession>> startSession({
    required String memberId,
    String? workoutPlanId,
    String? workoutPlanVersionId,
  }) async {
    if (int.tryParse(memberId) == null) {
      return const Left(ValidationFailure(['Invalid member id']));
    }
    try {
      final session = await _remoteDataSource.startSession(
        toWorkoutSessionCreate(
          memberId: memberId,
          workoutPlanId: workoutPlanId,
          workoutPlanVersionId: workoutPlanVersionId,
        ),
      );
      return Right(session.toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, WorkoutSessionSet>> logSet(
    String sessionId, {
    required String exerciseId,
    required int setNumber,
    PerformedSetMetrics metrics = const PerformedSetMetrics(),
    int? repsCompleted,
    num? weightLiftedKg,
    num? rpeScore,
    num? actualRir,
    int? actualDurationSeconds,
    bool? isCompleted,
    String? notes,
    num? targetRir,
    int? targetDurationSeconds,
  }) async {
    final intId = _parseId(sessionId);
    if (intId == null || int.tryParse(exerciseId) == null) {
      return const Left(ValidationFailure(['Invalid session or exercise id']));
    }
    final resolvedMetrics = metrics != const PerformedSetMetrics()
        ? metrics
        : PerformedSetMetrics(
            repsCompleted: repsCompleted,
            weightLiftedKg: weightLiftedKg,
            rpeScore: rpeScore,
            actualRir: actualRir,
            actualDurationSeconds: actualDurationSeconds,
            isCompleted: isCompleted,
            notes: notes,
          );

    final validationError = _validateSetMetrics(resolvedMetrics);
    if (validationError != null) return Left(validationError);
    try {
      final logged = await _remoteDataSource.logSet(
        intId,
        toWorkoutSetWrite(
          exerciseId: exerciseId,
          setNumber: setNumber,
          metrics: resolvedMetrics,
        ),
      );
      return Right(logged.toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, WorkoutSession>> completeSession(
    String sessionId, {
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
    final intId = _parseId(sessionId);
    if (intId == null) return const Left(NotFoundFailure());

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

    final ratingError = _validateSessionRatings(resolved);
    if (ratingError != null) return Left(ratingError);
    try {
      final completed = await _remoteDataSource.completeSession(
        intId,
        completion: resolved,
      );
      return Right(completed.toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, WorkoutSession?>> getActiveSession(
    String memberId,
  ) async {
    final intId = _parseId(memberId);
    if (intId == null) {
      return const Left(ValidationFailure(['Invalid member id']));
    }
    try {
      final session = await _remoteDataSource.getActiveSession(memberId: intId);
      return Right(session.toDomain());
    } catch (e) {
      final failure = mapThrownToFailure(e);
      if (failure is NotFoundFailure) {
        return const Right(null);
      }
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, WorkoutSessionSet>> updateSet(
    String sessionId,
    String setId, {
    PerformedSetMetrics metrics = const PerformedSetMetrics(),
    int? reps,
    num? weightKg,
    num? rpe,
    num? actualRir,
    int? actualDurationSeconds,
    bool? isCompleted,
    String? notes,
    num? targetRir,
    int? targetDurationSeconds,
  }) async {
    final sid = _parseId(sessionId);
    final stid = _parseId(setId);
    if (sid == null || stid == null) {
      return const Left(ValidationFailure(['Invalid session or set id']));
    }
    final resolvedMetrics = metrics != const PerformedSetMetrics()
        ? metrics
        : PerformedSetMetrics(
            repsCompleted: reps,
            weightLiftedKg: weightKg,
            rpeScore: rpe,
            actualRir: actualRir,
            actualDurationSeconds: actualDurationSeconds,
            isCompleted: isCompleted,
            notes: notes,
          );

    final validationError = _validateSetMetrics(resolvedMetrics);
    if (validationError != null) return Left(validationError);
    try {
      final updated = await _remoteDataSource.updateSet(
        sid,
        stid,
        toWorkoutSetUpdate(resolvedMetrics),
      );
      return Right(updated.toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteSet(
    String sessionId,
    String setId,
  ) async {
    final sid = _parseId(sessionId);
    final stid = _parseId(setId);
    if (sid == null || stid == null) {
      return const Left(ValidationFailure(['Invalid session or set id']));
    }
    try {
      await _remoteDataSource.deleteSet(sid, stid);
      return const Right(unit);
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<ExerciseHistorySession>>> getExerciseHistory({
    String? memberId,
    required String exerciseId,
  }) async {
    final eid = _parseId(exerciseId);
    if (eid == null) {
      return const Left(ValidationFailure(['Invalid exercise id']));
    }
    final mid = memberId == null ? null : _parseId(memberId);
    try {
      final list = await _remoteDataSource.getExerciseHistory(
        memberId: mid,
        exerciseId: eid,
      );
      final domainList = list.map((item) {
        return ExerciseHistorySession(
          sessionId: item.sessionId.toString(),
          startedAt: item.startedAt.toLocal(),
          completedAt: item.completedAt?.toLocal(),
          sets: (item.sets.toList()).map((s) => s.toDomain()).toList(),
        );
      }).toList();
      return Right(domainList);
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }
}
