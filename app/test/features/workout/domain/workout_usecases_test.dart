import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:luxeknox/features/workout/domain/entities/workout_plan.dart';
import 'package:luxeknox/features/workout/domain/entities/workout_plan_status.dart';
import 'package:luxeknox/features/workout/domain/entities/workout_session.dart';
import 'package:luxeknox/features/workout/domain/entities/workout_session_set.dart';
import 'package:luxeknox/features/workout/domain/repositories/workout_plan_repository.dart';
import 'package:luxeknox/features/workout/domain/repositories/workout_session_repository.dart';
import 'package:luxeknox/features/workout/domain/usecases/complete_workout_session_usecase.dart';
import 'package:luxeknox/features/workout/domain/usecases/create_workout_plan_usecase.dart';
import 'package:luxeknox/features/workout/domain/usecases/log_workout_set_usecase.dart';
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
  targetRir: '2',
  actualRir: '1.5',
  targetDurationSeconds: 30,
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
        ),
      );

      expect(result.isRight(), isTrue);
      verify(
        () => planRepo.createPlan(
          title: 'Macro Plan',
          primaryObjective12w: 'Reach milestone',
          sessionsPerWeek: 3,
          progressionMethods: ['load', 'volume'],
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
          ),
        );

        expect(result.isRight(), isTrue);
        verify(
          () => planRepo.updatePlan(
            '1',
            rowVersion: 2,
            title: 'Updated Plan',
            primaryObjective12w: 'New goal',
          ),
        ).called(1);
      },
    );

    test(
      'LogWorkoutSetUseCase forwards targetRir, actualRir, target/actual duration',
      () async {
        when(
          () => sessionRepo.logSet(
            any(),
            exerciseId: any(named: 'exerciseId'),
            setNumber: any(named: 'setNumber'),
            repsCompleted: any(named: 'repsCompleted'),
            weightLiftedKg: any(named: 'weightLiftedKg'),
            rpeScore: any(named: 'rpeScore'),
            targetRir: any(named: 'targetRir'),
            actualRir: any(named: 'actualRir'),
            targetDurationSeconds: any(named: 'targetDurationSeconds'),
            actualDurationSeconds: any(named: 'actualDurationSeconds'),
            isCompleted: any(named: 'isCompleted'),
            notes: any(named: 'notes'),
          ),
        ).thenAnswer((_) async => const Right(_sampleSet));

        final useCase = LogWorkoutSetUseCase(sessionRepo);
        final result = await useCase(
          const LogWorkoutSetParams(
            sessionId: '10',
            exerciseId: '5',
            setNumber: 1,
            targetRir: 2,
            actualRir: 1.5,
            targetDurationSeconds: 30,
            actualDurationSeconds: 30,
            notes: 'Isometric plank',
          ),
        );

        expect(result.isRight(), isTrue);
        verify(
          () => sessionRepo.logSet(
            '10',
            exerciseId: '5',
            setNumber: 1,
            targetRir: 2,
            actualRir: 1.5,
            targetDurationSeconds: 30,
            actualDurationSeconds: 30,
            isCompleted: true,
            notes: 'Isometric plank',
          ),
        ).called(1);
      },
    );

    test(
      'UpdateWorkoutSetUseCase forwards targetRir, actualRir, duration',
      () async {
        when(
          () => sessionRepo.updateSet(
            any(),
            any(),
            reps: any(named: 'reps'),
            weightKg: any(named: 'weightKg'),
            rpe: any(named: 'rpe'),
            targetRir: any(named: 'targetRir'),
            actualRir: any(named: 'actualRir'),
            targetDurationSeconds: any(named: 'targetDurationSeconds'),
            actualDurationSeconds: any(named: 'actualDurationSeconds'),
            isCompleted: any(named: 'isCompleted'),
            notes: any(named: 'notes'),
          ),
        ).thenAnswer((_) async => const Right(_sampleSet));

        final useCase = UpdateWorkoutSetUseCase(sessionRepo);
        final result = await useCase(
          const UpdateWorkoutSetParams(
            sessionId: '10',
            setId: '1',
            targetRir: 1,
            actualRir: 0.5,
            targetDurationSeconds: 45,
            actualDurationSeconds: 50,
          ),
        );

        expect(result.isRight(), isTrue);
        verify(
          () => sessionRepo.updateSet(
            '10',
            '1',
            targetRir: 1,
            actualRir: 0.5,
            targetDurationSeconds: 45,
            actualDurationSeconds: 50,
          ),
        ).called(1);
      },
    );

    test(
      'CompleteWorkoutSessionUseCase forwards multi-metric ratings and pain data',
      () async {
        when(
          () => sessionRepo.completeSession(
            any(),
            notes: any(named: 'notes'),
            clientFeedbackRating: any(named: 'clientFeedbackRating'),
            effortRating: any(named: 'effortRating'),
            satisfactionRating: any(named: 'satisfactionRating'),
            painDiscomfortScore: any(named: 'painDiscomfortScore'),
            painNotes: any(named: 'painNotes'),
            trainerNotes: any(named: 'trainerNotes'),
            nextSessionPlan: any(named: 'nextSessionPlan'),
            sessionFocus: any(named: 'sessionFocus'),
            warmupProtocol: any(named: 'warmupProtocol'),
            cooldownProtocol: any(named: 'cooldownProtocol'),
            clientSigned: any(named: 'clientSigned'),
            trainerSigned: any(named: 'trainerSigned'),
            clientSignedAt: any(named: 'clientSignedAt'),
            trainerSignedAt: any(named: 'trainerSignedAt'),
          ),
        ).thenAnswer((_) async => Right(_sampleSession));

        final useCase = CompleteWorkoutSessionUseCase(sessionRepo);
        final result = await useCase(
          const CompleteWorkoutSessionParams(
            sessionId: '10',
            effortRating: 8,
            satisfactionRating: 9,
            painDiscomfortScore: 0,
            painNotes: null,
            nextSessionPlan: 'Deload next week',
          ),
        );

        expect(result.isRight(), isTrue);
        verify(
          () => sessionRepo.completeSession(
            '10',
            effortRating: 8,
            satisfactionRating: 9,
            painDiscomfortScore: 0,
            painNotes: null,
            nextSessionPlan: 'Deload next week',
          ),
        ).called(1);
      },
    );
  });
}
