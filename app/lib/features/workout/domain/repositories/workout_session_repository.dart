import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/pagination/cursor_page.dart';
import '../entities/exercise_history_session.dart';
import '../entities/performed_set_metrics.dart';
import '../entities/session_completion.dart';
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
  });

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
  });

  Future<Either<Failure, WorkoutSession?>> getActiveSession(String memberId);

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
  });

  Future<Either<Failure, Unit>> deleteSet(String sessionId, String setId);

  Future<Either<Failure, List<ExerciseHistorySession>>> getExerciseHistory({
    String? memberId,
    required String exerciseId,
  });
}
