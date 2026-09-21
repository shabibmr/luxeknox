import 'package:app/core/error/failures.dart';
import 'package:app/features/workout/domain/entities/workout_plan.dart';
import 'package:app/features/workout/domain/entities/workout_plan_status.dart';
import 'package:app/features/workout/domain/usecases/archive_workout_plan_usecase.dart';
import 'package:app/features/workout/domain/usecases/assign_workout_plan_usecase.dart';
import 'package:app/features/workout/domain/usecases/get_workout_plan_usecase.dart';
import 'package:app/features/workout/domain/usecases/publish_workout_plan_usecase.dart';
import 'package:app/features/workout/presentation/cubit/workout_plan_detail_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockGet extends Mock implements GetWorkoutPlanUseCase {}

class _MockPublish extends Mock implements PublishWorkoutPlanUseCase {}

class _MockArchive extends Mock implements ArchiveWorkoutPlanUseCase {}

class _MockAssign extends Mock implements AssignWorkoutPlanUseCase {}

void main() {
  late _MockGet getPlan;
  late _MockPublish publishPlan;
  late _MockArchive archivePlan;
  late _MockAssign assignPlan;

  WorkoutPlan plan({
    required String id,
    WorkoutPlanStatus status = WorkoutPlanStatus.draft,
    int rowVersion = 1,
    bool isTemplate = false,
    String? memberId,
  }) {
    return WorkoutPlan(
      id: id,
      title: 'Plan $id',
      isTemplate: isTemplate,
      status: status,
      rowVersion: rowVersion,
      memberId: memberId,
    );
  }

  setUpAll(() {
    registerFallbackValue(
      const AssignWorkoutPlanParams(planId: '1', memberId: '1'),
    );
  });

  setUp(() {
    getPlan = _MockGet();
    publishPlan = _MockPublish();
    archivePlan = _MockArchive();
    assignPlan = _MockAssign();
  });

  WorkoutPlanDetailCubit buildCubit() =>
      WorkoutPlanDetailCubit(getPlan, publishPlan, archivePlan, assignPlan);

  blocTest<WorkoutPlanDetailCubit, WorkoutPlanDetailState>(
    'loads plan then publishes',
    build: () {
      when(() => getPlan('1')).thenAnswer(
        (_) async => Right(plan(id: '1')),
      );
      when(() => publishPlan('1')).thenAnswer(
        (_) async => Right(
          plan(id: '1', status: WorkoutPlanStatus.active, rowVersion: 2),
        ),
      );
      return buildCubit();
    },
    act: (cubit) async {
      await cubit.load('1');
      await cubit.publish();
    },
    expect: () => [
      isA<WorkoutPlanDetailLoading>(),
      isA<WorkoutPlanDetailLoaded>().having(
        (s) => s.plan.status,
        'status',
        WorkoutPlanStatus.draft,
      ),
      isA<WorkoutPlanDetailActionInFlight>(),
      isA<WorkoutPlanDetailLoaded>().having(
        (s) => s.plan.status,
        'status',
        WorkoutPlanStatus.active,
      ),
    ],
  );

  blocTest<WorkoutPlanDetailCubit, WorkoutPlanDetailState>(
    'archives loaded plan',
    build: () {
      when(() => getPlan('2')).thenAnswer(
        (_) async => Right(plan(id: '2', status: WorkoutPlanStatus.active)),
      );
      when(() => archivePlan('2')).thenAnswer(
        (_) async => Right(
          plan(id: '2', status: WorkoutPlanStatus.archived, rowVersion: 3),
        ),
      );
      return buildCubit();
    },
    act: (cubit) async {
      await cubit.load('2');
      await cubit.archive();
    },
    expect: () => [
      isA<WorkoutPlanDetailLoading>(),
      isA<WorkoutPlanDetailLoaded>(),
      isA<WorkoutPlanDetailActionInFlight>(),
      isA<WorkoutPlanDetailLoaded>().having(
        (s) => s.plan.status,
        'status',
        WorkoutPlanStatus.archived,
      ),
    ],
  );

  blocTest<WorkoutPlanDetailCubit, WorkoutPlanDetailState>(
    'publish failure emits failure state',
    build: () {
      when(() => getPlan('1')).thenAnswer(
        (_) async => Right(plan(id: '1')),
      );
      when(() => publishPlan('1')).thenAnswer(
        (_) async => const Left(NetworkFailure()),
      );
      return buildCubit();
    },
    act: (cubit) async {
      await cubit.load('1');
      await cubit.publish();
    },
    expect: () => [
      isA<WorkoutPlanDetailLoading>(),
      isA<WorkoutPlanDetailLoaded>(),
      isA<WorkoutPlanDetailActionInFlight>(),
      isA<WorkoutPlanDetailFailure>(),
    ],
  );

  blocTest<WorkoutPlanDetailCubit, WorkoutPlanDetailState>(
    'assigns template to member',
    build: () {
      when(() => getPlan('10')).thenAnswer(
        (_) async => Right(plan(id: '10', isTemplate: true)),
      );
      when(() => assignPlan(any())).thenAnswer(
        (_) async => Right(
          plan(id: '99', memberId: '5', isTemplate: false),
        ),
      );
      return buildCubit();
    },
    act: (cubit) async {
      await cubit.load('10');
      await cubit.assignToMember('5');
    },
    expect: () => [
      isA<WorkoutPlanDetailLoading>(),
      isA<WorkoutPlanDetailLoaded>(),
      isA<WorkoutPlanDetailActionInFlight>(),
      isA<WorkoutPlanDetailLoaded>()
          .having((s) => s.assignedPlan?.id, 'assignedPlan.id', '99')
          .having((s) => s.plan.id, 'plan.id', '10'),
    ],
  );
}
