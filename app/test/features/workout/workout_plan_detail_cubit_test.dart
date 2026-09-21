import 'package:app/core/error/failures.dart';
import 'package:app/features/workout/domain/entities/workout_plan.dart';
import 'package:app/features/workout/domain/entities/workout_plan_status.dart';
import 'package:app/features/workout/domain/usecases/archive_workout_plan_usecase.dart';
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

void main() {
  late _MockGet getPlan;
  late _MockPublish publishPlan;
  late _MockArchive archivePlan;

  WorkoutPlan plan({
    required String id,
    WorkoutPlanStatus status = WorkoutPlanStatus.draft,
    int rowVersion = 1,
  }) {
    return WorkoutPlan(
      id: id,
      title: 'Plan $id',
      isTemplate: false,
      status: status,
      rowVersion: rowVersion,
    );
  }

  setUp(() {
    getPlan = _MockGet();
    publishPlan = _MockPublish();
    archivePlan = _MockArchive();
  });

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
      return WorkoutPlanDetailCubit(getPlan, publishPlan, archivePlan);
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
      return WorkoutPlanDetailCubit(getPlan, publishPlan, archivePlan);
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
      return WorkoutPlanDetailCubit(getPlan, publishPlan, archivePlan);
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
}
