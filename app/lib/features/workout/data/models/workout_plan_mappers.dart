import 'package:api_client/api_client.dart' as api;
import 'package:built_collection/built_collection.dart';

import '../../domain/entities/workout_plan.dart';
import '../../domain/entities/workout_plan_exercise.dart';
import '../../domain/entities/workout_plan_exercise_input.dart';
import '../../domain/entities/workout_plan_status.dart';
import '../../domain/entities/workout_plan_version.dart';
import '../../domain/entities/workout_session.dart';
import '../../domain/entities/workout_session_set.dart';

WorkoutPlanStatus workoutPlanStatusToDomain(api.WorkoutPlanStatusEnum status) {
  return switch (status.name) {
    'active' => WorkoutPlanStatus.active,
    'archived' => WorkoutPlanStatus.archived,
    'draft' => WorkoutPlanStatus.draft,
    _ => WorkoutPlanStatus.draft,
  };
}

extension WorkoutPlanModelMapper on api.WorkoutPlan {
  WorkoutPlan toDomain() {
    final versionExercises = currentVersion?.exercises ?? BuiltList();
    return WorkoutPlan(
      id: id.toString(),
      title: title,
      description: description,
      memberId: memberId?.toString(),
      trainerId: trainerId?.toString(),
      targetGoal: targetGoal,
      difficulty: difficulty,
      durationWeeks: durationWeeks,
      isTemplate: isTemplate,
      status: workoutPlanStatusToDomain(status),
      createdAt: createdAt,
      rowVersion: rowVersion,
      exercises: versionExercises.map((e) => e.toDomain()).toList(),
    );
  }
}

extension WorkoutPlanExerciseModelMapper on api.WorkoutPlanExercise {
  WorkoutPlanExercise toDomain() {
    return WorkoutPlanExercise(
      id: id.toString(),
      exerciseId: exerciseId.toString(),
      exerciseName: exercise?.name,
      dayNumber: dayNumber,
      orderIndex: orderIndex,
      targetSets: targetSets,
      targetReps: targetReps,
      targetWeightKg: targetWeightKg,
      restSeconds: restSeconds,
      notes: notes,
    );
  }
}

api.WorkoutPlanWrite toWorkoutPlanWrite({
  String? title,
  String? description,
  String? memberId,
  String? trainerId,
  String? targetGoal,
  String? difficulty,
  int? durationWeeks,
  bool? isTemplate,
  int? rowVersion,
}) {
  return api.WorkoutPlanWrite(
    (b) => b
      ..title = title
      ..description = description
      ..memberId = memberId == null ? null : int.tryParse(memberId)
      ..trainerId = trainerId == null ? null : int.tryParse(trainerId)
      ..targetGoal = targetGoal
      ..difficulty = difficulty
      ..durationWeeks = durationWeeks
      ..isTemplate = isTemplate
      ..rowVersion = rowVersion,
  );
}

api.WorkoutPlanExercisesWrite toWorkoutPlanExercisesWrite({
  required int rowVersion,
  String? changelog,
  required List<WorkoutPlanExerciseInput> exercises,
}) {
  return api.WorkoutPlanExercisesWrite(
    (b) => b
      ..changelog = changelog
      ..rowVersion = rowVersion
      ..exercises.replace(
        exercises.map(
          (e) => api.WorkoutPlanExercisesWriteExercisesInner(
            (ib) => ib
              ..exerciseId = int.parse(e.exerciseId)
              ..dayNumber = e.dayNumber
              ..orderIndex = e.orderIndex
              ..targetSets = e.targetSets
              ..targetReps = e.targetReps
              ..targetWeightKg = e.targetWeightKg
              ..restSeconds = e.restSeconds
              ..notes = e.notes,
          ),
        ),
      ),
  );
}

extension WorkoutPlanVersionModelMapper on api.WorkoutPlanVersion {
  WorkoutPlanVersion toDomain() {
    return WorkoutPlanVersion(
      id: id.toString(),
      planId: workoutPlanId.toString(),
      versionNumber: versionNumber,
      changelog: changelog,
      createdAt: createdAt,
      exercises: (exercises ?? BuiltList()).map((e) => e.toDomain()).toList(),
    );
  }
}

extension WorkoutSessionModelMapper on api.WorkoutSession {
  WorkoutSession toDomain() {
    return WorkoutSession(
      id: id.toString(),
      memberId: memberId.toString(),
      workoutPlanId: workoutPlanId?.toString(),
      workoutPlanVersionId: workoutPlanVersionId?.toString(),
      trainerId: trainerId?.toString(),
      startedAt: startedAt,
      completedAt: completedAt,
      totalVolumeKg: totalVolumeKg,
      durationMinutes: durationMinutes,
      clientFeedbackRating: clientFeedbackRating,
      notes: notes,
      sets: (sets ?? BuiltList()).map((e) => e.toDomain()).toList(),
    );
  }
}

extension WorkoutSessionExerciseModelMapper on api.WorkoutSessionExercise {
  WorkoutSessionSet toDomain() {
    return WorkoutSessionSet(
      id: id.toString(),
      workoutSessionId: workoutSessionId.toString(),
      exerciseId: exerciseId.toString(),
      setNumber: setNumber,
      repsCompleted: repsCompleted,
      weightLiftedKg: weightLiftedKg,
      rpeScore: rpeScore,
      isCompleted: isCompleted,
    );
  }
}

api.AssignPlanRequest toAssignPlanRequest(String memberId) {
  return api.AssignPlanRequest(
    (b) => b..memberId = int.parse(memberId),
  );
}

api.WorkoutSessionCreate toWorkoutSessionCreate({
  required String memberId,
  String? workoutPlanId,
  String? workoutPlanVersionId,
}) {
  return api.WorkoutSessionCreate(
    (b) => b
      ..memberId = int.parse(memberId)
      ..workoutPlanId =
          workoutPlanId == null ? null : int.tryParse(workoutPlanId)
      ..workoutPlanVersionId = workoutPlanVersionId == null
          ? null
          : int.tryParse(workoutPlanVersionId),
  );
}

api.WorkoutSetWrite toWorkoutSetWrite({
  required String exerciseId,
  required int setNumber,
  int? repsCompleted,
  num? weightLiftedKg,
  num? rpeScore,
  bool? isCompleted,
}) {
  return api.WorkoutSetWrite(
    (b) => b
      ..exerciseId = int.parse(exerciseId)
      ..setNumber = setNumber
      ..repsCompleted = repsCompleted
      ..weightLiftedKg = weightLiftedKg
      ..rpeScore = rpeScore
      ..isCompleted = isCompleted,
  );
}
