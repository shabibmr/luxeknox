import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/error/map_thrown.dart';
import '../../../../core/pagination/cursor_page.dart';
import '../../domain/entities/workout_session.dart';
import '../../domain/entities/workout_session_set.dart';
import '../../domain/repositories/workout_session_repository.dart';
import '../datasources/workout_session_remote_datasource.dart';
import '../models/workout_plan_mappers.dart';

@LazySingleton(as: WorkoutSessionRepository)
class WorkoutSessionRepositoryImpl implements WorkoutSessionRepository {
  WorkoutSessionRepositoryImpl(this._remoteDataSource);

  final WorkoutSessionRemoteDataSource _remoteDataSource;

  int? _parseId(String id) => int.tryParse(id);

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
    bool? isCompleted,
  }) async {
    final intId = _parseId(sessionId);
    if (intId == null || int.tryParse(exerciseId) == null) {
      return const Left(ValidationFailure(['Invalid session or exercise id']));
    }
    try {
      final logged = await _remoteDataSource.logSet(
        intId,
        toWorkoutSetWrite(
          exerciseId: exerciseId,
          setNumber: setNumber,
          repsCompleted: repsCompleted,
          weightLiftedKg: weightLiftedKg,
          rpeScore: rpeScore,
          isCompleted: isCompleted,
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
  }) async {
    final intId = _parseId(sessionId);
    if (intId == null) return const Left(NotFoundFailure());
    if (clientFeedbackRating != null &&
        (clientFeedbackRating < 1 || clientFeedbackRating > 5)) {
      return const Left(ValidationFailure(['Rating must be 1–5']));
    }
    try {
      final completed = await _remoteDataSource.completeSession(
        intId,
        notes: notes,
        clientFeedbackRating: clientFeedbackRating,
      );
      return Right(completed.toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }
}
