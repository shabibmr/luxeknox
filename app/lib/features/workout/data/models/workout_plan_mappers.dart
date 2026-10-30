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
      primaryObjective12w: primaryObjective12w,
      milestone4w: milestone4w,
      sessionsPerWeek: sessionsPerWeek,
      targetSessionDurationMinutes: targetSessionDurationMinutes,
      splitType: splitType,
      cardioProtocol: cardioProtocol,
      mobilityProtocol: mobilityProtocol,
      progressionMethods:
          progressionMethods?.map((e) => e.name).toList() ?? const [],
      mainSuccessMeasure: mainSuccessMeasure,
      trainerProgrammingNotes: trainerProgrammingNotes,
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
      restBetweenExercisesSeconds: restBetweenExercisesSeconds,
      notes: notes,
      targetRir: targetRir,
      targetDurationSeconds: targetDurationSeconds,
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
  String? primaryObjective12w,
  String? milestone4w,
  int? sessionsPerWeek,
  int? targetSessionDurationMinutes,
  String? splitType,
  String? cardioProtocol,
  String? mobilityProtocol,
  List<String>? progressionMethods,
  String? mainSuccessMeasure,
  String? trainerProgrammingNotes,
}) {
  return api.WorkoutPlanWrite((b) {
    b
      ..title = title
      ..description = description
      ..memberId = memberId == null ? null : int.tryParse(memberId)
      ..trainerId = trainerId == null ? null : int.tryParse(trainerId)
      ..targetGoal = targetGoal
      ..difficulty = difficulty
      ..durationWeeks = durationWeeks
      ..isTemplate = isTemplate
      ..rowVersion = rowVersion
      ..primaryObjective12w = primaryObjective12w
      ..milestone4w = milestone4w
      ..sessionsPerWeek = sessionsPerWeek
      ..targetSessionDurationMinutes = targetSessionDurationMinutes
      ..splitType = splitType
      ..cardioProtocol = cardioProtocol
      ..mobilityProtocol = mobilityProtocol
      ..mainSuccessMeasure = mainSuccessMeasure
      ..trainerProgrammingNotes = trainerProgrammingNotes;

    if (progressionMethods != null) {
      b.progressionMethods.replace(
        progressionMethods.map(
          (m) => api.WorkoutPlanWriteProgressionMethodsEnum.valueOf(m),
        ),
      );
    }
  });
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
              ..restBetweenExercisesSeconds = e.restBetweenExercisesSeconds
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
      effortRating: effortRating,
      satisfactionRating: satisfactionRating,
      painDiscomfortScore: painDiscomfortScore,
      painNotes: painNotes,
      sessionFocus: sessionFocus,
      warmupProtocol: warmupProtocol,
      cooldownProtocol: cooldownProtocol,
      trainerNotes: trainerNotes,
      nextSessionPlan: nextSessionPlan,
      clientSignedAt: clientSignedAt,
      trainerSignedAt: trainerSignedAt,
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
      actualRir: actualRir,
      actualDurationSeconds: actualDurationSeconds,
      isCompleted: isCompleted,
      notes: notes,
    );
  }
}

api.AssignPlanRequest toAssignPlanRequest(String memberId) {
  return api.AssignPlanRequest((b) => b..memberId = int.parse(memberId));
}

api.WorkoutSessionCreate toWorkoutSessionCreate({
  required String memberId,
  String? workoutPlanId,
  String? workoutPlanVersionId,
}) {
  return api.WorkoutSessionCreate(
    (b) => b
      ..memberId = int.parse(memberId)
      ..workoutPlanId = workoutPlanId == null
          ? null
          : int.tryParse(workoutPlanId)
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
  num? targetRir,
  num? actualRir,
  int? targetDurationSeconds,
  int? actualDurationSeconds,
  bool? isCompleted,
  String? notes,
}) {
  return api.WorkoutSetWrite(
    (b) => b
      ..exerciseId = int.parse(exerciseId)
      ..setNumber = setNumber
      ..repsCompleted = repsCompleted
      ..weightLiftedKg = weightLiftedKg
      ..rpeScore = rpeScore
      ..targetRir = targetRir
      ..actualRir = actualRir
      ..targetDurationSeconds = targetDurationSeconds
      ..actualDurationSeconds = actualDurationSeconds
      ..isCompleted = isCompleted
      ..notes = notes,
  );
}

api.WorkoutSetUpdate toWorkoutSetUpdate({
  int? repsCompleted,
  num? weightLiftedKg,
  num? rpeScore,
  num? targetRir,
  num? actualRir,
  int? targetDurationSeconds,
  int? actualDurationSeconds,
  bool? isCompleted,
  String? notes,
}) {
  return api.WorkoutSetUpdate(
    (b) => b
      ..repsCompleted = repsCompleted
      ..weightLiftedKg = weightLiftedKg
      ..rpeScore = rpeScore
      ..targetRir = targetRir
      ..actualRir = actualRir
      ..targetDurationSeconds = targetDurationSeconds
      ..actualDurationSeconds = actualDurationSeconds
      ..isCompleted = isCompleted
      ..notes = notes,
  );
}

api.WorkoutSessionComplete toWorkoutSessionComplete({
  int? clientFeedbackRating,
  int? effortRating,
  int? satisfactionRating,
  int? painDiscomfortScore,
  String? painNotes,
  String? notes,
  String? trainerNotes,
  String? nextSessionPlan,
  String? sessionFocus,
  String? warmupProtocol,
  String? cooldownProtocol,
  bool? clientSigned,
  bool? trainerSigned,
  DateTime? clientSignedAt,
  DateTime? trainerSignedAt,
}) {
  return api.WorkoutSessionComplete(
    (b) => b
      ..clientFeedbackRating = clientFeedbackRating
      ..effortRating = effortRating
      ..satisfactionRating = satisfactionRating
      ..painDiscomfortScore = painDiscomfortScore
      ..painNotes = painNotes
      ..notes = notes
      ..trainerNotes = trainerNotes
      ..nextSessionPlan = nextSessionPlan
      ..sessionFocus = sessionFocus
      ..warmupProtocol = warmupProtocol
      ..cooldownProtocol = cooldownProtocol
      ..clientSigned = clientSigned
      ..trainerSigned = trainerSigned
      ..clientSignedAt = clientSignedAt
      ..trainerSignedAt = trainerSignedAt,
  );
}
