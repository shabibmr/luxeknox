import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/pagination/cursor_page.dart';
import '../entities/workout_session.dart';
import '../entities/workout_session_set.dart';

abstract class WorkoutSessionRepository {
  Future<Either<Failure, CursorPage<WorkoutSession>>> listSessions({
    String? memberId,
    int? limit,
    String? cursor,
  });

  Future<Either<Failure, WorkoutSession>> startSession({
    required String memberId,
    String? workoutPlanId,
    String? workoutPlanVersionId,
  });

  Future<Either<Failure, WorkoutSessionSet>> logSet(
    String sessionId, {
    required String exerciseId,
    required int setNumber,
    int? repsCompleted,
    num? weightLiftedKg,
    num? rpeScore,
    bool? isCompleted,
  });

  Future<Either<Failure, WorkoutSession>> completeSession(
    String sessionId, {
    String? notes,
    int? clientFeedbackRating,
  });

  Future<Either<Failure, WorkoutSession?>> getActiveSession(String memberId);

  Future<Either<Failure, WorkoutSessionSet>> updateSet(
    String sessionId,
    String setId, {
    int? reps,
    num? weightKg,
    num? rpe,
    bool? isCompleted,
  });

  Future<Either<Failure, Unit>> deleteSet(String sessionId, String setId);
}
