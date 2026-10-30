import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:luxeknox/features/workout/domain/entities/performed_set_metrics.dart';
import 'package:luxeknox/features/workout/domain/entities/session_completion.dart';
import 'package:luxeknox/features/workout/domain/entities/workout_plan.dart';
import 'package:luxeknox/features/workout/domain/entities/workout_plan_exercise_input.dart';
import 'package:luxeknox/features/workout/domain/entities/workout_plan_status.dart';
import 'package:luxeknox/features/workout/domain/entities/workout_session.dart';
import 'package:luxeknox/features/workout/domain/entities/workout_session_set.dart';
import 'package:luxeknox/features/workout/domain/repositories/workout_plan_repository.dart';
import 'package:luxeknox/features/workout/domain/repositories/workout_session_repository.dart';
import 'package:luxeknox/features/workout/domain/usecases/complete_workout_session_usecase.dart';
import 'package:luxeknox/features/workout/domain/usecases/create_workout_plan_usecase.dart';
import 'package:luxeknox/features/workout/domain/usecases/log_workout_set_usecase.dart';
import 'package:luxeknox/features/workout/domain/usecases/replace_workout_plan_exercises_usecase.dart';
import 'package:luxeknox/features/workout/domain/usecases/update_workout_plan_usecase.dart';
import 'package:luxeknox/features/workout/domain/usecases/update_workout_set_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockPlanRepository extends Mock implements WorkoutPlanRepository {}

class MockSessionRepository extends Mock implements WorkoutSessionRepository {}

const _samplePlan = WorkoutPlan(
  id: '1',
  title: 'Test Plan',
  isTemplate: false,
  status: WorkoutPlanStatus.draft,
  rowVersion: 1,
  primaryObjective12w: 'Reach milestone',
  sessionsPerWeek: 3,
);

const _sampleSet = WorkoutSessionSet(
  id: '1',
  workoutSessionId: '10',
  exerciseId: '5',
  setNumber: 1,
  actualRir: '1.5',
  actualDurationSeconds: 30,
);

final _sampleSession = WorkoutSession(
  id: '10',
  memberId: '42',
  startedAt: DateTime(2026, 1, 1),
  effortRating: 8,
  satisfactionRating: 9,
  painDiscomfortScore: 0,
);

void main() {
  setUpAll(() {
    registerFallbackValue(const PerformedSetMetrics());
    registerFallbackValue(const SessionCompletion());
    registerFallbackValue(const <WorkoutPlanExerciseInput>[]);
  });

  group('Workout UseCases with blueprint and RIR/pain support', () {
    late MockPlanRepository planRepo;
    late MockSessionRepository sessionRepo;

    setUp(() {
      planRepo = MockPlanRepository();
      sessionRepo = MockSessionRepository();
    });

    test('CreateWorkoutPlanUseCase forwards blueprint params', () async {
      when(
        () => planRepo.createPlan(
          title: any(named: 'title'),
          description: any(named: 'description'),
          memberId: any(named: 'memberId'),
          trainerId: any(named: 'trainerId'),
          targetGoal: any(named: 'targetGoal'),
          difficulty: any(named: 'difficulty'),
          durationWeeks: any(named: 'durationWeeks'),
          isTemplate: any(named: 'isTemplate'),
          primaryObjective12w: any(named: 'primaryObjective12w'),
          milestone4w: any(named: 'milestone4w'),
          sessionsPerWeek: any(named: 'sessionsPerWeek'),
          targetSessionDurationMinutes: any(
            named: 'targetSessionDurationMinutes',
          ),
          splitType: any(named: 'splitType'),
          cardioProtocol: any(named: 'cardioProtocol'),
          mobilityProtocol: any(named: 'mobilityProtocol'),
          progressionMethods: any(named: 'progressionMethods'),
          mainSuccessMeasure: any(named: 'mainSuccessMeasure'),
          trainerProgrammingNotes: any(named: 'trainerProgrammingNotes'),
        ),
      ).thenAnswer((_) async => const Right(_samplePlan));

      final useCase = CreateWorkoutPlanUseCase(planRepo);
      final result = await useCase(
        const CreateWorkoutPlanParams(
          title: 'Macro Plan',
          primaryObjective12w: 'Reach milestone',
          sessionsPerWeek: 3,
          progressionMethods: ['load', 'volume'],
          splitType: 'Upper / Lower',
          mainSuccessMeasure: '1RM Bench',
        ),
      );

      expect(result.isRight(), isTrue);
      verify(
        () => planRepo.createPlan(
          title: 'Macro Plan',
          primaryObjective12w: 'Reach milestone',
          sessionsPerWeek: 3,
          progressionMethods: ['load', 'volume'],
          splitType: 'Upper / Lower',
          mainSuccessMeasure: '1RM Bench',
        ),
      ).called(1);
    });

    test(
      'UpdateWorkoutPlanUseCase forwards blueprint params and rowVersion',
      () async {
        when(
          () => planRepo.updatePlan(
            any(),
            rowVersion: any(named: 'rowVersion'),
            title: any(named: 'title'),
            description: any(named: 'description'),
            memberId: any(named: 'memberId'),
            trainerId: any(named: 'trainerId'),
            targetGoal: any(named: 'targetGoal'),
            difficulty: any(named: 'difficulty'),
            durationWeeks: any(named: 'durationWeeks'),
            isTemplate: any(named: 'isTemplate'),
            primaryObjective12w: any(named: 'primaryObjective12w'),
            milestone4w: any(named: 'milestone4w'),
            sessionsPerWeek: any(named: 'sessionsPerWeek'),
            targetSessionDurationMinutes: any(
              named: 'targetSessionDurationMinutes',
            ),
            splitType: any(named: 'splitType'),
            cardioProtocol: any(named: 'cardioProtocol'),
            mobilityProtocol: any(named: 'mobilityProtocol'),
            progressionMethods: any(named: 'progressionMethods'),
            mainSuccessMeasure: any(named: 'mainSuccessMeasure'),
            trainerProgrammingNotes: any(named: 'trainerProgrammingNotes'),
          ),
        ).thenAnswer((_) async => const Right(_samplePlan));

        final useCase = UpdateWorkoutPlanUseCase(planRepo);
        final result = await useCase(
          const UpdateWorkoutPlanParams(
            id: '1',
            rowVersion: 2,
            title: 'Updated Plan',
            primaryObjective12w: 'New goal',
            splitType: 'PPL',
            mainSuccessMeasure: '3RM Squat',
          ),
        );

        expect(result.isRight(), isTrue);
        verify(
          () => planRepo.updatePlan(
            '1',
            rowVersion: 2,
            title: 'Updated Plan',
            primaryObjective12w: 'New goal',
            splitType: 'PPL',
            mainSuccessMeasure: '3RM Squat',
          ),
        ).called(1);
      },
    );

    test('ReplaceWorkoutPlanExercisesUseCase roundtrips target RIR and duration', () async {
      when(
        () => planRepo.replaceExercises(
          any(),
          rowVersion: any(named: 'rowVersion'),
          changelog: any(named: 'changelog'),
          exercises: any(named: 'exercises'),
        ),
      ).thenAnswer((_) async => const Right(_samplePlan));

      final useCase = ReplaceWorkoutPlanExercisesUseCase(planRepo);
      final exercises = [
        const WorkoutPlanExerciseInput(
          exerciseId: '55',
          dayNumber: 1,
          orderIndex: 0,
          targetSets: 3,
          targetRir: 2.5,
          targetDurationSeconds: 45,
        ),
      ];
      final result = await useCase(
        ReplaceWorkoutPlanExercisesParams(
          id: '1',
          rowVersion: 2,
          exercises: exercises,
        ),
      );

      expect(result.isRight(), isTrue);
      verify(
        () => planRepo.replaceExercises(
          '1',
          rowVersion: 2,
          exercises: exercises,
        ),
      ).called(1);
    });

    test(
      'LogWorkoutSetUseCase forwards PerformedSetMetrics and never a target',
      () async {
        when(
          () => sessionRepo.logSet(
            any(),
            exerciseId: any(named: 'exerciseId'),
            setNumber: any(named: 'setNumber'),
            metrics: any(named: 'metrics'),
          ),
        ).thenAnswer((_) async => const Right(_sampleSet));

        final useCase = LogWorkoutSetUseCase(sessionRepo);
        final result = await useCase(
          const LogWorkoutSetParams(
            sessionId: '10',
            exerciseId: '5',
            setNumber: 1,
            metrics: PerformedSetMetrics(
              actualRir: 1.5,
              actualDurationSeconds: 30,
              notes: 'Isometric plank',
            ),
          ),
        );

        expect(result.isRight(), isTrue);
        verify(
          () => sessionRepo.logSet(
            '10',
            exerciseId: '5',
            setNumber: 1,
            metrics: const PerformedSetMetrics(
              actualRir: 1.5,
              actualDurationSeconds: 30,
              notes: 'Isometric plank',
            ),
          ),
        ).called(1);
      },
    );

    test(
      'UpdateWorkoutSetUseCase forwards PerformedSetMetrics and never a target',
      () async {
        when(
          () => sessionRepo.updateSet(
            any(),
            any(),
            metrics: any(named: 'metrics'),
          ),
        ).thenAnswer((_) async => const Right(_sampleSet));

        final useCase = UpdateWorkoutSetUseCase(sessionRepo);
        final result = await useCase(
          const UpdateWorkoutSetParams(
            sessionId: '10',
            setId: '1',
            metrics: PerformedSetMetrics(
              actualRir: 0.5,
              actualDurationSeconds: 50,
            ),
          ),
        );

        expect(result.isRight(), isTrue);
        verify(
          () => sessionRepo.updateSet(
            '10',
            '1',
            metrics: const PerformedSetMetrics(
              actualRir: 0.5,
              actualDurationSeconds: 50,
            ),
          ),
        ).called(1);
      },
    );

    test(
      'CompleteWorkoutSessionUseCase forwards SessionCompletion value object with no client timestamps',
      () async {
        when(
          () => sessionRepo.completeSession(
            any(),
            completion: any(named: 'completion'),
          ),
        ).thenAnswer((_) async => Right(_sampleSession));

        final useCase = CompleteWorkoutSessionUseCase(sessionRepo);
        const completion = SessionCompletion(
          effortRating: 8,
          satisfactionRating: 9,
          painDiscomfortScore: 0,
          painNotes: null,
          nextSessionPlan: 'Deload next week',
        );

        final result = await useCase(
          const CompleteWorkoutSessionParams(
            sessionId: '10',
            completion: completion,
          ),
        );

        expect(result.isRight(), isTrue);
        verify(
          () => sessionRepo.completeSession(
            '10',
            completion: completion,
          ),
        ).called(1);
      },
    );
  });
}
