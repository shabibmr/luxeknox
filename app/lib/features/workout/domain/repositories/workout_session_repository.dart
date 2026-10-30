import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/pagination/cursor_page.dart';
import '../entities/exercise_history_session.dart';
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
    num? targetRir,
    num? actualRir,
    int? targetDurationSeconds,
    int? actualDurationSeconds,
    bool? isCompleted,
    String? notes,
  });

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
  });

  Future<Either<Failure, WorkoutSession?>> getActiveSession(String memberId);

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
  });

  Future<Either<Failure, Unit>> deleteSet(String sessionId, String setId);

  Future<Either<Failure, List<ExerciseHistorySession>>> getExerciseHistory({
    String? memberId,
    required String exerciseId,
  });
}
