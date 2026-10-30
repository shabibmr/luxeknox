import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/error/map_thrown.dart';
import '../../../../core/pagination/cursor_page.dart';
import '../../domain/entities/exercise_history_session.dart';
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

  ValidationFailure? _validateSetMetrics({
    num? targetRir,
    num? actualRir,
    int? targetDurationSeconds,
    int? actualDurationSeconds,
  }) {
    final targetRirError = WorkoutValidators.validateRir(targetRir);
    if (targetRirError != null) return ValidationFailure([targetRirError]);

    final actualRirError = WorkoutValidators.validateRir(actualRir);
    if (actualRirError != null) return ValidationFailure([actualRirError]);

    final targetDurError =
        WorkoutValidators.validateDurationSeconds(targetDurationSeconds);
    if (targetDurError != null) return ValidationFailure([targetDurError]);

    final actualDurError =
        WorkoutValidators.validateDurationSeconds(actualDurationSeconds);
    if (actualDurError != null) return ValidationFailure([actualDurError]);

    return null;
  }

  ValidationFailure? _validateSessionRatings({
    int? clientFeedbackRating,
    int? effortRating,
    int? satisfactionRating,
    int? painDiscomfortScore,
  }) {
    final feedbackError =
        WorkoutValidators.validateClientFeedbackRating(clientFeedbackRating);
    if (feedbackError != null) return ValidationFailure([feedbackError]);

    final effortError = WorkoutValidators.validateEffortRating(effortRating);
    if (effortError != null) return ValidationFailure([effortError]);

    final satisfactionError =
        WorkoutValidators.validateSatisfactionRating(satisfactionRating);
    if (satisfactionError != null) {
      return ValidationFailure([satisfactionError]);
    }

    final painError =
        WorkoutValidators.validatePainDiscomfortScore(painDiscomfortScore);
    if (painError != null) return ValidationFailure([painError]);

    return null;
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
    int? repsCompleted,
    num? weightLiftedKg,
    num? rpeScore,
    num? targetRir,
    num? actualRir,
    int? targetDurationSeconds,
    int? actualDurationSeconds,
    bool? isCompleted,
    String? notes,
  }) async {
    final intId = _parseId(sessionId);
    if (intId == null || int.tryParse(exerciseId) == null) {
      return const Left(ValidationFailure(['Invalid session or exercise id']));
    }
    final validationError = _validateSetMetrics(
      targetRir: targetRir,
      actualRir: actualRir,
      targetDurationSeconds: targetDurationSeconds,
      actualDurationSeconds: actualDurationSeconds,
    );
    if (validationError != null) return Left(validationError);
    try {
      final logged = await _remoteDataSource.logSet(
        intId,
        toWorkoutSetWrite(
          exerciseId: exerciseId,
          setNumber: setNumber,
          repsCompleted: repsCompleted,
          weightLiftedKg: weightLiftedKg,
          rpeScore: rpeScore,
          targetRir: targetRir,
          actualRir: actualRir,
          targetDurationSeconds: targetDurationSeconds,
          actualDurationSeconds: actualDurationSeconds,
          isCompleted: isCompleted,
          notes: notes,
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
    final intId = _parseId(sessionId);
    if (intId == null) return const Left(NotFoundFailure());
    final ratingError = _validateSessionRatings(
      clientFeedbackRating: clientFeedbackRating,
      effortRating: effortRating,
      satisfactionRating: satisfactionRating,
      painDiscomfortScore: painDiscomfortScore,
    );
    if (ratingError != null) return Left(ratingError);
    try {
      final completed = await _remoteDataSource.completeSession(
        intId,
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
        clientSignedAt: clientSignedAt,
        trainerSignedAt: trainerSignedAt,
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
    int? reps,
    num? weightKg,
    num? rpe,
    num? targetRir,
    num? actualRir,
    int? targetDurationSeconds,
    int? actualDurationSeconds,
    bool? isCompleted,
    String? notes,
  }) async {
    final sid = _parseId(sessionId);
    final stid = _parseId(setId);
    if (sid == null || stid == null) {
      return const Left(ValidationFailure(['Invalid session or set id']));
    }
    final validationError = _validateSetMetrics(
      targetRir: targetRir,
      actualRir: actualRir,
      targetDurationSeconds: targetDurationSeconds,
      actualDurationSeconds: actualDurationSeconds,
    );
    if (validationError != null) return Left(validationError);
    try {
      final updated = await _remoteDataSource.updateSet(
        sid,
        stid,
        toWorkoutSetUpdate(
          repsCompleted: reps,
          weightLiftedKg: weightKg,
          rpeScore: rpe,
          targetRir: targetRir,
          actualRir: actualRir,
          targetDurationSeconds: targetDurationSeconds,
          actualDurationSeconds: actualDurationSeconds,
          isCompleted: isCompleted,
          notes: notes,
        ),
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
