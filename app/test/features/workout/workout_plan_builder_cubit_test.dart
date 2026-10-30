import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/core/presentation/load_status.dart';
import 'package:luxeknox/features/exercises/domain/entities/exercise.dart';
import 'package:luxeknox/features/workout/domain/entities/workout_plan.dart';
import 'package:luxeknox/features/workout/domain/entities/workout_plan_exercise.dart';
import 'package:luxeknox/features/workout/domain/entities/workout_plan_status.dart';
import 'package:luxeknox/features/workout/domain/usecases/create_workout_plan_usecase.dart';
import 'package:luxeknox/features/workout/domain/usecases/get_workout_plan_usecase.dart';
import 'package:luxeknox/features/workout/domain/usecases/publish_workout_plan_usecase.dart';
import 'package:luxeknox/features/workout/domain/usecases/replace_workout_plan_exercises_usecase.dart';
import 'package:luxeknox/features/workout/domain/usecases/update_workout_plan_usecase.dart';
import 'package:luxeknox/features/workout/presentation/cubit/workout_plan_builder_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockGet extends Mock implements GetWorkoutPlanUseCase {}

class _MockCreate extends Mock implements CreateWorkoutPlanUseCase {}

class _MockUpdate extends Mock implements UpdateWorkoutPlanUseCase {}

class _MockReplace extends Mock implements ReplaceWorkoutPlanExercisesUseCase {}

class _MockPublish extends Mock implements PublishWorkoutPlanUseCase {}

void main() {
  late _MockGet getPlan;
  late _MockCreate createPlan;
  late _MockUpdate updatePlan;
  late _MockReplace replaceExercises;
  late _MockPublish publishPlan;

  const exerciseA = Exercise(
    id: '10',
    name: 'Squat',
    primaryMuscleGroup: 'legs',
    secondaryMuscles: [],
    equipmentNeeded: [],
    instructions: '',
    difficultyLevel: 'beginner',
    isActive: true,
  );
  const exerciseB = Exercise(
    id: '11',
    name: 'Bench',
    primaryMuscleGroup: 'chest',
    secondaryMuscles: [],
    equipmentNeeded: [],
    instructions: '',
    difficultyLevel: 'beginner',
    isActive: true,
  );

  WorkoutPlan plan({
    required String id,
    int rowVersion = 1,
    String title = 'Push day',
  }) {
    return WorkoutPlan(
      id: id,
      title: title,
      isTemplate: false,
      status: WorkoutPlanStatus.draft,
      rowVersion: rowVersion,
    );
  }

  setUpAll(() {
    registerFallbackValue(const CreateWorkoutPlanParams(title: 'x'));
    registerFallbackValue(
      const UpdateWorkoutPlanParams(id: '1', rowVersion: 1),
    );
    registerFallbackValue(
      const ReplaceWorkoutPlanExercisesParams(
        id: '1',
        rowVersion: 1,
        exercises: [],
      ),
    );
  });

  setUp(() {
    getPlan = _MockGet();
    createPlan = _MockCreate();
    updatePlan = _MockUpdate();
    replaceExercises = _MockReplace();
    publishPlan = _MockPublish();
  });

  WorkoutPlanBuilderCubit buildCubit() => WorkoutPlanBuilderCubit(
    getPlan,
    createPlan,
    updatePlan,
    replaceExercises,
    publishPlan,
  );

  blocTest<WorkoutPlanBuilderCubit, WorkoutPlanBuilderState>(
    'add/reorder marks dirty and updates orderIndex',
    build: buildCubit,
    act: (cubit) async {
      await cubit.init();
      cubit.addExercise(exerciseA, dayNumber: 1);
      cubit.addExercise(exerciseB, dayNumber: 1);
      cubit.reorderWithinDay(dayNumber: 1, oldIndex: 0, newIndex: 1);
    },
    expect: () => [
      isA<WorkoutPlanBuilderState>()
          .having((s) => s.status, 'status', LoadStatus.success)
          .having((s) => s.dirty, 'dirty', false),
      isA<WorkoutPlanBuilderState>()
          .having((s) => s.status, 'status', LoadStatus.success)
          .having((s) => s.dirty, 'dirty', true)
          .having((s) => s.exercises.length, 'count', 1),
      isA<WorkoutPlanBuilderState>()
          .having((s) => s.status, 'status', LoadStatus.success)
          .having((s) => s.exercises.map((e) => e.exerciseId).toList(), 'ids', [
            '10',
            '11',
          ]),
      isA<WorkoutPlanBuilderState>()
          .having((s) => s.status, 'status', LoadStatus.success)
          .having(
            (s) => s.exercises.map((e) => e.exerciseId).toList(),
            'reordered',
            ['11', '10'],
          ),
    ],
    verify: (cubit) {
      expect(cubit.state.exercises.map((e) => e.orderIndex).toList(), [0, 1]);
      expect(cubit.state.dirty, isTrue);
    },
  );

  blocTest<WorkoutPlanBuilderCubit, WorkoutPlanBuilderState>(
    'setExerciseRestSeconds stores rest, ignores out of range, and can clear',
    build: buildCubit,
    act: (cubit) async {
      await cubit.init();
      cubit.addExercise(exerciseA, dayNumber: 1);
      cubit.addExercise(exerciseB, dayNumber: 1);
      cubit.setExerciseRestSeconds(
        dayNumber: 1,
        indexInDay: 0,
        restSeconds: 90,
      );
      cubit.setExerciseRestSeconds(
        dayNumber: 1,
        indexInDay: 0,
        restSeconds: 9000,
      );
      cubit.setExerciseRestSeconds(
        dayNumber: 1,
        indexInDay: 0,
        restSeconds: null,
      );
    },
    expect: () => [
      isA<WorkoutPlanBuilderState>().having((s) => s.dirty, 'dirty', false),
      isA<WorkoutPlanBuilderState>().having(
        (s) => s.exercises.length,
        'count',
        1,
      ),
      isA<WorkoutPlanBuilderState>().having(
        (s) => s.exercises.length,
        'count',
        2,
      ),
      isA<WorkoutPlanBuilderState>().having(
        (s) => s.exercises.first.restSeconds,
        'rest',
        90,
      ),
      isA<WorkoutPlanBuilderState>().having(
        (s) => s.exercises.first.restSeconds,
        'cleared',
        isNull,
      ),
    ],
  );

  blocTest<WorkoutPlanBuilderCubit, WorkoutPlanBuilderState>(
    'setExerciseRestBetweenExercises stores a separate rest value',
    build: buildCubit,
    act: (cubit) async {
      await cubit.init();
      cubit.addExercise(exerciseA, dayNumber: 1);
      cubit.setExerciseRestSeconds(
        dayNumber: 1,
        indexInDay: 0,
        restSeconds: 45,
      );
      cubit.setExerciseRestBetweenExercises(
        dayNumber: 1,
        indexInDay: 0,
        restBetweenExercisesSeconds: 120,
      );
    },
    verify: (cubit) {
      expect(cubit.state.exercises.single.restSeconds, 45);
      expect(cubit.state.exercises.single.restBetweenExercisesSeconds, 120);
    },
  );

  blocTest<WorkoutPlanBuilderCubit, WorkoutPlanBuilderState>(
    'save create then replaceExercises orchestration',
    build: () {
      when(
        () => createPlan(any()),
      ).thenAnswer((_) async => Right(plan(id: '99', rowVersion: 1)));
      when(
        () => replaceExercises(any()),
      ).thenAnswer((_) async => Right(plan(id: '99', rowVersion: 2)));
      return buildCubit();
    },
    act: (cubit) async {
      await cubit.init();
      cubit.setTitle('New plan');
      cubit.addExercise(exerciseA);
      await cubit.save();
    },
    verify: (cubit) {
      verify(() => createPlan(any())).called(1);
      final captured = verify(() => replaceExercises(captureAny())).captured;
      expect(captured, hasLength(1));
      final params = captured.single as ReplaceWorkoutPlanExercisesParams;
      expect(params.id, '99');
      expect(params.rowVersion, 1);
      expect(params.exercises, hasLength(1));
      expect(cubit.state.planId, '99');
      expect(cubit.state.dirty, isFalse);
      expect(cubit.state.savedPlan, isNotNull);
      expect(cubit.state.status, LoadStatus.success);
    },
  );

  blocTest<WorkoutPlanBuilderCubit, WorkoutPlanBuilderState>(
    'save edit updates metadata then replaces exercises',
    build: () {
      when(
        () => getPlan('5'),
      ).thenAnswer((_) async => Right(plan(id: '5', title: 'Old')));
      when(() => updatePlan(any())).thenAnswer(
        (_) async => Right(plan(id: '5', rowVersion: 4, title: 'Updated')),
      );
      when(() => replaceExercises(any())).thenAnswer(
        (_) async => Right(plan(id: '5', rowVersion: 5, title: 'Updated')),
      );
      return buildCubit();
    },
    act: (cubit) async {
      await cubit.init(planId: '5');
      cubit.setTitle('Updated');
      await cubit.save();
    },
    verify: (_) {
      final updateParams =
          verify(() => updatePlan(captureAny())).captured.single
              as UpdateWorkoutPlanParams;
      expect(updateParams.id, '5');
      expect(updateParams.rowVersion, 1);
      expect(updateParams.title, 'Updated');
      final replaceParams =
          verify(() => replaceExercises(captureAny())).captured.single
              as ReplaceWorkoutPlanExercisesParams;
      expect(replaceParams.rowVersion, 4);
    },
  );

  blocTest<WorkoutPlanBuilderCubit, WorkoutPlanBuilderState>(
    'save failure surfaces error without clearing dirty',
    build: () {
      when(
        () => createPlan(any()),
      ).thenAnswer((_) async => const Left(NetworkFailure()));
      return buildCubit();
    },
    act: (cubit) async {
      await cubit.init();
      cubit.setTitle('Broken');
      await cubit.save();
    },
    verify: (cubit) {
      expect(cubit.state.dirty, isTrue);
      expect(cubit.state.failure, isA<NetworkFailure>());
      expect(cubit.state.status, LoadStatus.failure);
      expect(cubit.state.saving, isFalse);
    },
  );

  group('program blueprint', () {
    Future<WorkoutPlanBuilderCubit> filled() async {
      final cubit = buildCubit();
      await cubit.init();
      cubit
        ..setPrimaryObjective12w('Lose 6 kg')
        ..setMilestone4w('Squat bodyweight')
        ..setSessionsPerWeek(4)
        ..setTargetSessionDurationMinutes(60)
        ..setSplitType('Upper / Lower');
      return cubit;
    }

    test('blueprintErrors flags every required field when empty', () async {
      final cubit = buildCubit();
      await cubit.init();
      expect(
        cubit.state.blueprintErrors.keys,
        containsAll([
          'objective',
          'milestone',
          'frequency',
          'duration',
          'split',
        ]),
      );
      expect(cubit.state.blueprintValid, isFalse);
    });

    test(
      'validateBlueprint fails and reveals errors when incomplete',
      () async {
        final cubit = buildCubit();
        await cubit.init();
        expect(cubit.validateBlueprint(), isFalse);
        expect(cubit.state.showBlueprintErrors, isTrue);
      },
    );

    test('validateBlueprint passes when complete', () async {
      final cubit = await filled();
      expect(cubit.state.blueprintErrors, isEmpty);
      expect(cubit.validateBlueprint(), isTrue);
    });

    test(
      'frequency outside 1-14 and duration outside 15-180 are errors',
      () async {
        final cubit = await filled();
        cubit
          ..setSessionsPerWeek(15)
          ..setTargetSessionDurationMinutes(10);
        expect(
          cubit.state.blueprintErrors.keys,
          containsAll(['frequency', 'duration']),
        );
      },
    );

    test('toggleProgressionMethod adds and removes tokens', () async {
      final cubit = buildCubit();
      await cubit.init();
      cubit
        ..toggleProgressionMethod('load')
        ..toggleProgressionMethod('reps');
      expect(cubit.state.progressionMethods, ['load', 'reps']);
      cubit.toggleProgressionMethod('load');
      expect(cubit.state.progressionMethods, ['reps']);
      expect(cubit.state.dirty, isTrue);
    });

    test('init hydrates blueprint from an existing plan', () async {
      when(() => getPlan('5')).thenAnswer(
        (_) async => Right(
          plan(id: '5').copyWith(
            primaryObjective12w: 'Build muscle',
            milestone4w: 'Add 5 kg',
            sessionsPerWeek: 3,
            targetSessionDurationMinutes: 45,
            splitType: 'Full body',
            progressionMethods: const ['volume'],
          ),
        ),
      );
      final cubit = buildCubit();
      await cubit.init(planId: '5');
      expect(cubit.state.primaryObjective12w, 'Build muscle');
      expect(cubit.state.sessionsPerWeek, 3);
      expect(cubit.state.targetSessionDurationMinutes, 45);
      expect(cubit.state.splitType, 'Full body');
      expect(cubit.state.progressionMethods, ['volume']);
    });

    test('save on create sends blueprint fields', () async {
      when(
        () => createPlan(any()),
      ).thenAnswer((_) async => Right(plan(id: '9')));
      when(
        () => replaceExercises(any()),
      ).thenAnswer((_) async => Right(plan(id: '9')));
      final cubit = await filled();
      cubit
        ..setTitle('Plan')
        ..toggleProgressionMethod('load');
      expect(await cubit.save(), isTrue);
      final params =
          verify(() => createPlan(captureAny())).captured.single
              as CreateWorkoutPlanParams;
      expect(params.primaryObjective12w, 'Lose 6 kg');
      expect(params.milestone4w, 'Squat bodyweight');
      expect(params.sessionsPerWeek, 4);
      expect(params.targetSessionDurationMinutes, 60);
      expect(params.splitType, 'Upper / Lower');
      expect(params.progressionMethods, ['load']);
    });

    test('save on update sends blueprint fields', () async {
      when(() => getPlan('5')).thenAnswer((_) async => Right(plan(id: '5')));
      when(
        () => updatePlan(any()),
      ).thenAnswer((_) async => Right(plan(id: '5')));
      when(
        () => replaceExercises(any()),
      ).thenAnswer((_) async => Right(plan(id: '5')));
      final cubit = buildCubit();
      await cubit.init(planId: '5');
      cubit
        ..setPrimaryObjective12w('Lose 6 kg')
        ..setSplitType('PPL');
      expect(await cubit.save(), isTrue);
      final params =
          verify(() => updatePlan(captureAny())).captured.single
              as UpdateWorkoutPlanParams;
      expect(params.primaryObjective12w, 'Lose 6 kg');
      expect(params.splitType, 'PPL');
    });
  });

  group('target RIR and timed duration on plan exercises (Issue #53)', () {
    test('setExerciseTargetRir sets RIR, ignores out-of-range, and can clear', () async {
      final cubit = buildCubit();
      await cubit.init();
      cubit.addExercise(exerciseA, dayNumber: 1);

      cubit.setExerciseTargetRir(dayNumber: 1, indexInDay: 0, targetRir: 2.5);
      expect(cubit.state.exercises.first.targetRir, 2.5);

      // Out of range ignored (> 10)
      cubit.setExerciseTargetRir(dayNumber: 1, indexInDay: 0, targetRir: 11);
      expect(cubit.state.exercises.first.targetRir, 2.5);

      // Out of range ignored (< 0)
      cubit.setExerciseTargetRir(dayNumber: 1, indexInDay: 0, targetRir: -1);
      expect(cubit.state.exercises.first.targetRir, 2.5);

      // Clear to null
      cubit.setExerciseTargetRir(dayNumber: 1, indexInDay: 0, targetRir: null);
      expect(cubit.state.exercises.first.targetRir, isNull);
    });

    test('setExerciseTargetDurationSeconds sets duration, ignores negative, and can clear', () async {
      final cubit = buildCubit();
      await cubit.init();
      cubit.addExercise(exerciseA, dayNumber: 1);

      cubit.setExerciseTargetDurationSeconds(dayNumber: 1, indexInDay: 0, targetDurationSeconds: 45);
      expect(cubit.state.exercises.first.targetDurationSeconds, 45);

      // Negative ignored
      cubit.setExerciseTargetDurationSeconds(dayNumber: 1, indexInDay: 0, targetDurationSeconds: -10);
      expect(cubit.state.exercises.first.targetDurationSeconds, 45);

      // Clear to null
      cubit.setExerciseTargetDurationSeconds(dayNumber: 1, indexInDay: 0, targetDurationSeconds: null);
      expect(cubit.state.exercises.first.targetDurationSeconds, isNull);
    });

    test('reopening plan restores saved target RIR and duration', () async {
      final existingPlan = const WorkoutPlan(
        id: '20',
        title: 'Saved Plan',
        isTemplate: false,
        status: WorkoutPlanStatus.draft,
        rowVersion: 1,
        exercises: [
          WorkoutPlanExercise(
            id: '1',
            exerciseId: '10',
            exerciseName: 'Squat',
            dayNumber: 1,
            orderIndex: 0,
            targetRir: 1.5,
            targetDurationSeconds: 60,
          ),
        ],
      );
      when(() => getPlan('20')).thenAnswer((_) async => Right(existingPlan));

      final cubit = buildCubit();
      await cubit.init(planId: '20');

      expect(cubit.state.exercises.length, 1);
      expect(cubit.state.exercises.first.targetRir, 1.5);
      expect(cubit.state.exercises.first.targetDurationSeconds, 60);
    });

    test('save forwards target RIR and duration to replaceExercises', () async {
      when(() => createPlan(any())).thenAnswer((_) async => Right(plan(id: '30')));
      when(() => replaceExercises(any())).thenAnswer((_) async => Right(plan(id: '30')));

      final cubit = buildCubit();
      await cubit.init();
      cubit
        ..setTitle('Test Plan')
        ..setPrimaryObjective12w('Goal')
        ..setMilestone4w('Milestone')
        ..setSessionsPerWeek(3)
        ..setTargetSessionDurationMinutes(60)
        ..setSplitType('Full Body')
        ..addExercise(exerciseA, dayNumber: 1)
        ..setExerciseTargetRir(dayNumber: 1, indexInDay: 0, targetRir: 2.0)
        ..setExerciseTargetDurationSeconds(dayNumber: 1, indexInDay: 0, targetDurationSeconds: 45);

      expect(await cubit.save(), isTrue);

      final replacedParams = verify(() => replaceExercises(captureAny())).captured.single
          as ReplaceWorkoutPlanExercisesParams;
      expect(replacedParams.exercises.length, 1);
      expect(replacedParams.exercises.first.targetRir, 2.0);
      expect(replacedParams.exercises.first.targetDurationSeconds, 45);
    });
  });
}
