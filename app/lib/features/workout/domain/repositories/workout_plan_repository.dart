import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/pagination/cursor_page.dart';
import '../entities/workout_plan.dart';
import '../entities/workout_plan_exercise_input.dart';

abstract class WorkoutPlanRepository {
  Future<Either<Failure, CursorPage<WorkoutPlan>>> listPlans({
    String? memberId,
    bool? isTemplate,
    int? limit,
    int? offset,
  });

  Future<Either<Failure, WorkoutPlan>> getPlan(String id);

  Future<Either<Failure, WorkoutPlan>> createPlan({
    required String title,
    String? description,
    String? memberId,
    String? trainerId,
    String? targetGoal,
    String? difficulty,
    int? durationWeeks,
    bool? isTemplate,
  });

  Future<Either<Failure, WorkoutPlan>> updatePlan(
    String id, {
    String? title,
    String? description,
    String? memberId,
    String? trainerId,
    String? targetGoal,
    String? difficulty,
    int? durationWeeks,
    bool? isTemplate,
    required int rowVersion,
  });

  Future<Either<Failure, WorkoutPlan>> replaceExercises(
    String id, {
    required int rowVersion,
    String? changelog,
    required List<WorkoutPlanExerciseInput> exercises,
  });

  Future<Either<Failure, WorkoutPlan>> publish(String id);

  Future<Either<Failure, WorkoutPlan>> archive(String id);
}
