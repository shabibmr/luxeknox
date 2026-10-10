import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/core/pagination/cursor_page.dart';
import 'package:luxeknox/core/presentation/load_status.dart';
import 'package:luxeknox/features/workout/domain/entities/workout_plan.dart';
import 'package:luxeknox/features/workout/domain/entities/workout_plan_exercise.dart';
import 'package:luxeknox/features/workout/domain/entities/workout_plan_status.dart';
import 'package:luxeknox/features/workout/domain/usecases/get_workout_plan_usecase.dart';
import 'package:luxeknox/features/workout/domain/usecases/list_workout_plans_usecase.dart';
import 'package:luxeknox/features/workout/presentation/cubit/todays_workout_cubit.dart';
import 'package:mocktail/mocktail.dart';

class _MockListPlans extends Mock implements ListWorkoutPlansUseCase {}

class _MockGetPlan extends Mock implements GetWorkoutPlanUseCase {}

void main() {
  late _MockListPlans listPlans;
  late _MockGetPlan getPlan;

  setUpAll(() {
    registerFallbackValue(const ListWorkoutPlansParams());
  });

  setUp(() {
    listPlans = _MockListPlans();
    getPlan = _MockGetPlan();
  });

  const testExercises = [
    WorkoutPlanExercise(
      id: 'e1',
      exerciseId: '10',
      exerciseName: 'Bench Press',
      dayNumber: 1,
      orderIndex: 1,
      targetSets: 4,
      targetReps: '8-10',
      targetWeightKg: 80,
      restSeconds: 90,
    ),
    WorkoutPlanExercise(
      id: 'e2',
      exerciseId: '11',
      exerciseName: 'Incline Dumbbell Press',
      dayNumber: 1,
      orderIndex: 2,
      targetSets: 3,
      targetReps: '10-12',
      targetWeightKg: 28,
      restSeconds: 60,
    ),
    WorkoutPlanExercise(
      id: 'e3',
      exerciseId: '12',
      exerciseName: 'Barbell Row',
      dayNumber: 2,
      orderIndex: 1,
      targetSets: 4,
      targetReps: '8-10',
      targetWeightKg: 70,
      restSeconds: 90,
    ),
  ];

  const testPlan = WorkoutPlan(
    id: '1',
    title: '4-Week Hypertrophy Split',
    isTemplate: false,
    status: WorkoutPlanStatus.active,
    rowVersion: 1,
    memberId: '42',
    exercises: testExercises,
  );

  TodaysWorkoutCubit buildCubit() => TodaysWorkoutCubit(listPlans, getPlan);

  group('TodaysWorkoutCubit', () {
    test('initial state has initial status', () {
      final cubit = buildCubit();
      expect(cubit.state.status, LoadStatus.initial);
      expect(cubit.state.hasActivePlan, isFalse);
    });

    blocTest<TodaysWorkoutCubit, TodaysWorkoutState>(
      'loads active plan and defaults to Day 1',
      build: () {
        when(
          () => listPlans(any()),
        ).thenAnswer(
          (_) async => const Right(
            CursorPage(items: [testPlan], hasMore: false, nextCursor: null),
          ),
        );
        when(() => getPlan('1')).thenAnswer((_) async => const Right(testPlan));
        return buildCubit();
      },
      act: (cubit) => cubit.load(memberId: '42'),
      expect: () => [
        const TodaysWorkoutState(status: LoadStatus.loading),
        isA<TodaysWorkoutState>()
            .having((s) => s.status, 'status', LoadStatus.success)
            .having((s) => s.hasActivePlan, 'hasActivePlan', true)
            .having((s) => s.activePlan?.id, 'planId', '1')
            .having((s) => s.selectedDay, 'selectedDay', 1)
            .having((s) => s.availableDays, 'availableDays', [1, 2])
            .having((s) => s.exercisesForDay.length, 'exercisesForDay', 2),
      ],
    );

    blocTest<TodaysWorkoutCubit, TodaysWorkoutState>(
      'selects a different day and filters exercises correctly',
      build: () {
        when(
          () => listPlans(any()),
        ).thenAnswer(
          (_) async => const Right(
            CursorPage(items: [testPlan], hasMore: false, nextCursor: null),
          ),
        );
        when(() => getPlan('1')).thenAnswer((_) async => const Right(testPlan));
        return buildCubit();
      },
      act: (cubit) async {
        await cubit.load(memberId: '42');
        cubit.selectDay(2);
      },
      skip: 1, // Skip loading state
      expect: () => [
        isA<TodaysWorkoutState>()
            .having((s) => s.status, 'status', LoadStatus.success)
            .having((s) => s.selectedDay, 'selectedDay', 1)
            .having((s) => s.exercisesForDay.length, 'exercises length', 2),
        isA<TodaysWorkoutState>()
            .having((s) => s.selectedDay, 'selectedDay', 2)
            .having((s) => s.exercisesForDay.length, 'exercises length', 1)
            .having(
              (s) => s.exercisesForDay.first.exerciseName,
              'name',
              'Barbell Row',
            ),
      ],
    );

    blocTest<TodaysWorkoutCubit, TodaysWorkoutState>(
      'emits success with no active plan when member has no plans',
      build: () {
        when(
          () => listPlans(any()),
        ).thenAnswer(
          (_) async => const Right(
            CursorPage(items: [], hasMore: false, nextCursor: null),
          ),
        );
        return buildCubit();
      },
      act: (cubit) => cubit.load(memberId: '42'),
      expect: () => [
        const TodaysWorkoutState(status: LoadStatus.loading),
        const TodaysWorkoutState(
          status: LoadStatus.success,
          activePlan: null,
          availableDays: [],
          exercisesForDay: [],
          selectedDay: 1,
        ),
      ],
    );

    blocTest<TodaysWorkoutCubit, TodaysWorkoutState>(
      'emits failure when listPlans fails',
      build: () {
        when(
          () => listPlans(any()),
        ).thenAnswer((_) async => const Left(UnknownFailure()));
        return buildCubit();
      },
      act: (cubit) => cubit.load(memberId: '42'),
      expect: () => [
        const TodaysWorkoutState(status: LoadStatus.loading),
        isA<TodaysWorkoutState>()
            .having((s) => s.status, 'status', LoadStatus.failure)
            .having((s) => s.failure, 'failure', isA<UnknownFailure>()),
      ],
    );
  });
}
