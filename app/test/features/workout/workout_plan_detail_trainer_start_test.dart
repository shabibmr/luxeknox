import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:go_router/go_router.dart';
import 'package:luxeknox/core/di/injector.dart';
import 'package:luxeknox/features/workout/domain/entities/workout_plan.dart';
import 'package:luxeknox/features/workout/domain/entities/workout_plan_status.dart';
import 'package:luxeknox/features/workout/domain/usecases/archive_workout_plan_usecase.dart';
import 'package:luxeknox/features/workout/domain/usecases/assign_workout_plan_usecase.dart';
import 'package:luxeknox/features/workout/domain/usecases/get_workout_plan_usecase.dart';
import 'package:luxeknox/features/workout/domain/usecases/publish_workout_plan_usecase.dart';
import 'package:luxeknox/features/workout/presentation/cubit/workout_plan_detail_cubit.dart';
import 'package:luxeknox/features/workout/presentation/screens/workout_plan_detail_screen.dart';
import 'package:luxeknox/features/workout/presentation/workout_strings.dart';
import 'package:mocktail/mocktail.dart';

class MockGetWorkoutPlanUseCase extends Mock implements GetWorkoutPlanUseCase {}

class MockPublishWorkoutPlanUseCase extends Mock
    implements PublishWorkoutPlanUseCase {}

class MockArchiveWorkoutPlanUseCase extends Mock
    implements ArchiveWorkoutPlanUseCase {}

class MockAssignWorkoutPlanUseCase extends Mock
    implements AssignWorkoutPlanUseCase {}

/// Covers the Task 6 "Start session with member" trainer action on the
/// workout plan detail screen: shown only for a member-owned plan (not a
/// template) when the screen isn't in member read-only mode, and it
/// navigates to the trainer's active-session route for that member.
void main() {
  late MockGetWorkoutPlanUseCase getPlan;
  late MockPublishWorkoutPlanUseCase publishPlan;
  late MockArchiveWorkoutPlanUseCase archivePlan;
  late MockAssignWorkoutPlanUseCase assignPlan;

  WorkoutPlan memberPlan({String id = 'plan-1', String? memberId = '42'}) =>
      WorkoutPlan(
        id: id,
        title: 'Strength block',
        memberId: memberId,
        isTemplate: memberId == null,
        status: WorkoutPlanStatus.active,
        rowVersion: 1,
      );

  setUp(() {
    getPlan = MockGetWorkoutPlanUseCase();
    publishPlan = MockPublishWorkoutPlanUseCase();
    archivePlan = MockArchiveWorkoutPlanUseCase();
    assignPlan = MockAssignWorkoutPlanUseCase();

    getIt.registerFactory<WorkoutPlanDetailCubit>(
      () => WorkoutPlanDetailCubit(getPlan, publishPlan, archivePlan, assignPlan),
    );
  });

  tearDown(() => getIt.reset());

  testWidgets(
    'shows "Start session with member" for a member-owned plan and '
    'navigates to that member\'s active-session route',
    (tester) async {
      final plan = memberPlan();
      when(() => getPlan(plan.id)).thenAnswer((_) async => Right(plan));

      final router = GoRouter(
        initialLocation: '/trainer/plans/workouts/${plan.id}',
        routes: [
          GoRoute(
            path: '/trainer/plans/workouts/:id',
            builder: (context, state) =>
                WorkoutPlanDetailScreen(planId: state.pathParameters['id']!),
          ),
          GoRoute(
            path: '/trainer/members/:id/workout/active',
            builder: (context, state) => Text(
              'ACTIVE:${state.pathParameters['id']}:'
              '${state.uri.queryParameters['workoutPlanId']}',
            ),
          ),
        ],
      );

      await tester.pumpWidget(MaterialApp.router(routerConfig: router));
      await tester.pumpAndSettle();

      expect(find.text(WorkoutStrings.startSessionWithMember), findsOneWidget);

      await tester.tap(find.text(WorkoutStrings.startSessionWithMember));
      await tester.pumpAndSettle();

      expect(find.text('ACTIVE:42:plan-1'), findsOneWidget);
    },
  );

  testWidgets('hidden for a template plan (no memberId)', (tester) async {
    final plan = memberPlan(memberId: null);
    when(() => getPlan(plan.id)).thenAnswer((_) async => Right(plan));

    final router = GoRouter(
      initialLocation: '/trainer/plans/workouts/${plan.id}',
      routes: [
        GoRoute(
          path: '/trainer/plans/workouts/:id',
          builder: (context, state) =>
              WorkoutPlanDetailScreen(planId: state.pathParameters['id']!),
        ),
      ],
    );

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();

    expect(find.text(WorkoutStrings.startSessionWithMember), findsNothing);
  });

  testWidgets('hidden when the screen is in member view-only mode', (
    tester,
  ) async {
    final plan = memberPlan();
    when(() => getPlan(plan.id)).thenAnswer((_) async => Right(plan));

    final router = GoRouter(
      initialLocation: '/trainer/plans/workouts/${plan.id}',
      routes: [
        GoRoute(
          path: '/trainer/plans/workouts/:id',
          builder: (context, state) => WorkoutPlanDetailScreen(
            planId: state.pathParameters['id']!,
            isViewOnly: true,
          ),
        ),
      ],
    );

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();

    expect(find.text(WorkoutStrings.startSessionWithMember), findsNothing);
    expect(find.text(WorkoutStrings.startSession), findsOneWidget);
  });
}
