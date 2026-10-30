import 'package:api_client/api_client.dart' as api;
import 'package:flutter_test/flutter_test.dart';
import 'package:luxeknox/features/workout/data/models/workout_plan_mappers.dart';
import 'package:luxeknox/features/workout/domain/entities/performed_set_metrics.dart';
import 'package:luxeknox/features/workout/domain/entities/session_completion.dart';
import 'package:luxeknox/features/workout/domain/entities/workout_plan.dart';
import 'package:luxeknox/features/workout/domain/entities/workout_plan_exercise.dart';
import 'package:luxeknox/features/workout/domain/entities/workout_plan_exercise_input.dart';
import 'package:luxeknox/features/workout/domain/entities/workout_plan_status.dart';
import 'package:luxeknox/features/workout/domain/entities/workout_session.dart';
import 'package:luxeknox/features/workout/domain/entities/workout_session_set.dart';

void main() {
  group('WorkoutPlan entity & mappers with blueprint support', () {
    test(
      'WorkoutPlan contains all macrocycle blueprint fields (PTF-12 / PTF-25)',
      () {
        const plan = WorkoutPlan(
          id: '1',
          title: 'Hypertrophy Block A',
          isTemplate: false,
          status: WorkoutPlanStatus.active,
          rowVersion: 1,
          primaryObjective12w: 'Add 5kg lean mass',
          milestone4w: 'Baseline hypertrophy assessment',
          sessionsPerWeek: 4,
          targetSessionDurationMinutes: 60,
          splitType: 'Upper / Lower',
          cardioProtocol: 'Zone 2 20m 2x/wk',
          mobilityProtocol: 'Thoracic & hip openers',
          progressionMethods: ['volume', 'density'],
          mainSuccessMeasure: 'Chest & arm circumference',
          trainerProgrammingNotes: 'Emphasize mind-muscle connection',
        );

        expect(plan.primaryObjective12w, 'Add 5kg lean mass');
        expect(plan.milestone4w, 'Baseline hypertrophy assessment');
        expect(plan.sessionsPerWeek, 4);
        expect(plan.targetSessionDurationMinutes, 60);
        expect(plan.splitType, 'Upper / Lower');
        expect(plan.cardioProtocol, 'Zone 2 20m 2x/wk');
        expect(plan.mobilityProtocol, 'Thoracic & hip openers');
        expect(plan.progressionMethods, ['volume', 'density']);
        expect(plan.mainSuccessMeasure, 'Chest & arm circumference');
        expect(
          plan.trainerProgrammingNotes,
          'Emphasize mind-muscle connection',
        );
      },
    );

    test(
      'maps api.WorkoutPlan with blueprint fields to domain WorkoutPlan',
      () {
        final apiPlan = api.WorkoutPlan(
          (b) => b
            ..id = 42
            ..title = 'Strength 101'
            ..isTemplate = true
            ..status = api.WorkoutPlanStatusEnum.draft
            ..rowVersion = 2
            ..primaryObjective12w = 'Squat 180kg'
            ..milestone4w = 'Deadlift 140kg x 3'
            ..sessionsPerWeek = 3
            ..targetSessionDurationMinutes = 75
            ..splitType = 'Full Body'
            ..cardioProtocol = 'None'
            ..mobilityProtocol = 'Ankle mobility'
            ..progressionMethods.replace([
              api.WorkoutPlanProgressionMethodsEnum.load,
              api.WorkoutPlanProgressionMethodsEnum.technique,
            ])
            ..mainSuccessMeasure = '1RM Deadlift'
            ..trainerProgrammingNotes = 'Deload on week 4',
        );

        final domain = apiPlan.toDomain();

        expect(domain.id, '42');
        expect(domain.primaryObjective12w, 'Squat 180kg');
        expect(domain.milestone4w, 'Deadlift 140kg x 3');
        expect(domain.sessionsPerWeek, 3);
        expect(domain.targetSessionDurationMinutes, 75);
        expect(domain.splitType, 'Full Body');
        expect(domain.cardioProtocol, 'None');
        expect(domain.mobilityProtocol, 'Ankle mobility');
        expect(domain.progressionMethods, ['load', 'technique']);
        expect(domain.mainSuccessMeasure, '1RM Deadlift');
        expect(domain.trainerProgrammingNotes, 'Deload on week 4');
      },
    );

    test('toWorkoutPlanWrite serializes blueprint fields', () {
      final write = toWorkoutPlanWrite(
        title: 'Powerbuilding',
        primaryObjective12w: 'Reach 500kg total',
        milestone4w: 'Technique lock-in',
        sessionsPerWeek: 5,
        targetSessionDurationMinutes: 90,
        splitType: 'Push Pull Legs',
        cardioProtocol: 'Incline treadmill 15m',
        mobilityProtocol: 'Shoulder dislocates',
        progressionMethods: ['load', 'density'],
        mainSuccessMeasure: 'Total S/B/D',
        trainerProgrammingNotes: 'Watch right knee tracking',
      );

      expect(write.title, 'Powerbuilding');
      expect(write.primaryObjective12w, 'Reach 500kg total');
      expect(write.milestone4w, 'Technique lock-in');
      expect(write.sessionsPerWeek, 5);
      expect(write.targetSessionDurationMinutes, 90);
      expect(write.splitType, 'Push Pull Legs');
      expect(write.cardioProtocol, 'Incline treadmill 15m');
      expect(write.mobilityProtocol, 'Shoulder dislocates');
      expect(write.progressionMethods?.map((e) => e.name).toList(), [
        'load',
        'density',
      ]);
      expect(write.mainSuccessMeasure, 'Total S/B/D');
      expect(write.trainerProgrammingNotes, 'Watch right knee tracking');
    });

    test('toWorkoutPlanWrite sends blank or whitespace split and measure as null (Issue #53)', () {
      final write = toWorkoutPlanWrite(
        title: 'Whitespace Test',
        splitType: '   ',
        mainSuccessMeasure: '\t \n ',
      );

      expect(write.splitType, isNull);
      expect(write.mainSuccessMeasure, isNull);
    });
  });

  group('WorkoutPlanExercise & WorkoutPlanExerciseInput', () {
    test(
      'WorkoutPlanExercise supports numeric targetRir, targetDurationSeconds, notes (Issue #53)',
      () {
        const exercise = WorkoutPlanExercise(
          id: '1',
          exerciseId: '55',
          exerciseName: 'Plank Hold',
          dayNumber: 1,
          orderIndex: 0,
          targetSets: 3,
          targetReps: '1',
          targetRir: 2,
          targetDurationSeconds: 45,
          notes: 'Keep pelvis tucked',
        );

        expect(exercise.targetRir, 2);
        expect(exercise.targetRirNum, 2);
        expect(exercise.targetDurationSeconds, 45);
        expect(exercise.notes, 'Keep pelvis tucked');
      },
    );

    test('maps api.WorkoutPlanExercise to domain WorkoutPlanExercise with parsed numeric RIR', () {
      final apiExercise = api.WorkoutPlanExercise(
        (b) => b
          ..id = 12
          ..workoutPlanVersionId = 3
          ..exerciseId = 99
          ..dayNumber = 2
          ..orderIndex = 1
          ..targetSets = 4
          ..targetReps = '8-10'
          ..targetRir = '1.5'
          ..targetDurationSeconds = 30
          ..notes = 'Pause at bottom',
      );

      final domain = apiExercise.toDomain();

      expect(domain.id, '12');
      expect(domain.targetRir, 1.5);
      expect(domain.targetDurationSeconds, 30);
      expect(domain.notes, 'Pause at bottom');
    });

    test('WorkoutPlanExerciseInput supports targetRir and targetDurationSeconds', () {
      const input = WorkoutPlanExerciseInput(
        exerciseId: '55',
        dayNumber: 1,
        orderIndex: 0,
        targetSets: 3,
        targetRir: 2.5,
        targetDurationSeconds: 45,
        notes: 'Hold strict',
      );

      expect(input.targetRir, 2.5);
      expect(input.targetDurationSeconds, 45);

      final updated = input.copyWith(targetSets: 4, targetRir: 1.0);
      expect(updated.targetSets, 4);
      expect(updated.targetRir, 1.0);
      expect(updated.targetDurationSeconds, 45);
      expect(updated.notes, 'Hold strict');
    });

    test('toWorkoutPlanExercisesWrite serializes targetRir and targetDurationSeconds (Issue #53)', () {
      final write = toWorkoutPlanExercisesWrite(
        rowVersion: 1,
        exercises: const [
          WorkoutPlanExerciseInput(
            exerciseId: '55',
            dayNumber: 1,
            orderIndex: 0,
            targetRir: 2.5,
            targetDurationSeconds: 45,
          ),
        ],
      );

      expect(write.exercises.first.targetRir, 2.5);
      expect(write.exercises.first.targetDurationSeconds, 45);
    });
  });

  group('WorkoutSessionSet entity & mappers', () {
    test(
      'WorkoutSessionSet supports targetRir, actualRir, target/actual duration',
      () {
        const set = WorkoutSessionSet(
          id: '201',
          workoutSessionId: '10',
          exerciseId: '5',
          setNumber: 1,
          repsCompleted: 8,
          weightLiftedKg: 100,
          rpeScore: 8.5,
          targetRir: '2',
          actualRir: '1.5',
          targetDurationSeconds: 0,
          actualDurationSeconds: 30,
          isCompleted: true,
          notes: 'Solid effort',
        );

        expect(set.targetRir, '2');
        expect(set.actualRir, '1.5');
        expect(set.targetDurationSeconds, 0);
        expect(set.actualDurationSeconds, 30);
        expect(set.rpeScore, 8.5);
      },
    );

    test('maps api.WorkoutSessionExercise to domain WorkoutSessionSet', () {
      final apiSet = api.WorkoutSessionExercise(
        (b) => b
          ..id = 300
          ..workoutSessionId = 44
          ..exerciseId = 88
          ..setNumber = 2
          ..repsCompleted = 5
          ..weightLiftedKg = 120
          ..rpeScore = 9
          ..targetRir = '1'
          ..actualRir = '0.5'
          ..targetDurationSeconds = 0
          ..actualDurationSeconds = 25
          ..isCompleted = true
          ..notes = 'Near failure',
      );

      final domain = apiSet.toDomain();

      expect(domain.id, '300');
      expect(domain.targetRir, '1');
      expect(domain.actualRir, '0.5');
      expect(domain.targetDurationSeconds, 0);
      expect(domain.actualDurationSeconds, 25);
      expect(domain.notes, 'Near failure');
    });

    test(
      'toWorkoutSetWrite and toWorkoutSetUpdate serialize performed metrics and NEVER targets (Issue #54)',
      () {
        final write = toWorkoutSetWrite(
          exerciseId: '12',
          setNumber: 1,
          metrics: const PerformedSetMetrics(
            repsCompleted: 10,
            weightLiftedKg: 60,
            rpeScore: 8,
            actualRir: 1.5,
            actualDurationSeconds: 32,
            isCompleted: true,
            notes: 'First set',
          ),
        );

        expect(write.exerciseId, 12);
        expect(write.targetRir, isNull, reason: 'Target RIR must never be sent in set writes');
        expect(write.targetDurationSeconds, isNull, reason: 'Target duration must never be sent in set writes');
        expect(write.actualRir, 1.5);
        expect(write.actualDurationSeconds, 32);
        expect(write.notes, 'First set');

        final update = toWorkoutSetUpdate(
          const PerformedSetMetrics(
            repsCompleted: 12,
            actualRir: 0.5,
            actualDurationSeconds: 45,
            notes: 'Updated note',
          ),
        );

        expect(update.repsCompleted, 12);
        expect(update.targetRir, isNull, reason: 'Target RIR must never be sent in set updates');
        expect(update.targetDurationSeconds, isNull, reason: 'Target duration must never be sent in set updates');
        expect(update.actualRir, 0.5);
        expect(update.actualDurationSeconds, 45);
        expect(update.notes, 'Updated note');
      },
    );
  });

  group('WorkoutSession entity & mappers', () {
    test(
      'WorkoutSession supports multi-dimensional feedback ratings and pain alert',
      () {
        final now = DateTime.now();
        final session = WorkoutSession(
          id: '500',
          memberId: '42',
          startedAt: now,
          completedAt: now.add(const Duration(minutes: 55)),
          durationMinutes: 55,
          clientFeedbackRating: 5,
          effortRating: 9,
          satisfactionRating: 8,
          painDiscomfortScore: 4,
          painNotes: 'Left patellar tendon irritation',
          sessionFocus: 'Heavy Lower',
          warmupProtocol: 'Leg swings + dynamic lunge',
          cooldownProtocol: 'Foam rolling quads',
          trainerNotes: 'Scale back squat volume next week',
          nextSessionPlan: 'Focus on hamstring curls & lunges',
          clientSignedAt: now.add(const Duration(minutes: 58)),
          trainerSignedAt: now.add(const Duration(minutes: 57)),
        );

        expect(session.effortRating, 9);
        expect(session.satisfactionRating, 8);
        expect(session.painDiscomfortScore, 4);
        expect(session.painNotes, 'Left patellar tendon irritation');
        expect(session.sessionFocus, 'Heavy Lower');
        expect(session.warmupProtocol, 'Leg swings + dynamic lunge');
        expect(session.cooldownProtocol, 'Foam rolling quads');
        expect(session.trainerNotes, 'Scale back squat volume next week');
        expect(session.nextSessionPlan, 'Focus on hamstring curls & lunges');
        expect(session.clientSignedAt, isNotNull);
        expect(session.trainerSignedAt, isNotNull);
      },
    );

    test(
      'maps api.WorkoutSession to domain WorkoutSession with ratings & protocols',
      () {
        final started = DateTime(2026, 3, 1, 10, 0);
        final completed = DateTime(2026, 3, 1, 11, 0);
        final apiSession = api.WorkoutSession(
          (b) => b
            ..id = 90
            ..memberId = 15
            ..startedAt = started
            ..completedAt = completed
            ..effortRating = 8
            ..satisfactionRating = 9
            ..painDiscomfortScore = 0
            ..painNotes = null
            ..sessionFocus = 'Upper Push'
            ..warmupProtocol = 'Band pull-aparts'
            ..cooldownProtocol = 'Triceps stretch'
            ..trainerNotes = 'Solid PR on bench'
            ..nextSessionPlan = 'Overhead press focus'
            ..clientSignedAt = completed
            ..trainerSignedAt = completed
            ..notes = 'Good session',
        );

        final domain = apiSession.toDomain();

        expect(domain.id, '90');
        expect(domain.effortRating, 8);
        expect(domain.satisfactionRating, 9);
        expect(domain.painDiscomfortScore, 0);
        expect(domain.sessionFocus, 'Upper Push');
        expect(domain.warmupProtocol, 'Band pull-aparts');
        expect(domain.cooldownProtocol, 'Triceps stretch');
        expect(domain.trainerNotes, 'Solid PR on bench');
        expect(domain.nextSessionPlan, 'Overhead press focus');
        expect(domain.clientSignedAt, completed);
        expect(domain.trainerSignedAt, completed);
      },
    );

    test(
      'toWorkoutSessionComplete packages SessionCompletion with NO client-supplied timestamps (Issue #54)',
      () {
        final complete = toWorkoutSessionComplete(
          const SessionCompletion(
            clientFeedbackRating: 5,
            effortRating: 8,
            satisfactionRating: 9,
            painDiscomfortScore: 5,
            painNotes: 'Hamstring tweak on last set',
            notes: 'Session finished early',
            trainerNotes: 'Referral sent to physio',
            nextSessionPlan: 'Upper body only',
            sessionFocus: 'Lower Posterior',
            warmupProtocol: 'RDL warmups',
            cooldownProtocol: 'Static stretch',
            clientSigned: true,
            trainerSigned: true,
          ),
        );

        expect(complete.clientFeedbackRating, 5);
        expect(complete.effortRating, 8);
        expect(complete.satisfactionRating, 9);
        expect(complete.painDiscomfortScore, 5);
        expect(complete.painNotes, 'Hamstring tweak on last set');
        expect(complete.notes, 'Session finished early');
        expect(complete.trainerNotes, 'Referral sent to physio');
        expect(complete.nextSessionPlan, 'Upper body only');
        expect(complete.sessionFocus, 'Lower Posterior');
        expect(complete.warmupProtocol, 'RDL warmups');
        expect(complete.cooldownProtocol, 'Static stretch');
        expect(complete.clientSigned, isTrue);
        expect(complete.trainerSigned, isTrue);
        expect(complete.clientSignedAt, isNull, reason: 'Signed-at timestamps are server-stamped');
        expect(complete.trainerSignedAt, isNull, reason: 'Signed-at timestamps are server-stamped');
      },
    );
  });
}
