import 'package:app/core/error/failures.dart';
import 'package:app/features/diet/domain/entities/diet_plan.dart';
import 'package:app/features/diet/domain/entities/diet_plan_status.dart';
import 'package:app/features/diet/domain/usecases/archive_diet_plan_usecase.dart';
import 'package:app/features/diet/domain/usecases/assign_diet_plan_usecase.dart';
import 'package:app/features/diet/domain/usecases/get_diet_plan_usecase.dart';
import 'package:app/features/diet/domain/usecases/publish_diet_plan_usecase.dart';
import 'package:app/features/diet/presentation/cubit/diet_plan_detail_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockGet extends Mock implements GetDietPlanUseCase {}
class _MockPublish extends Mock implements PublishDietPlanUseCase {}
class _MockArchive extends Mock implements ArchiveDietPlanUseCase {}
class _MockAssign extends Mock implements AssignDietPlanUseCase {}

void main() {
  late _MockGet getPlan;
  late _MockPublish publishPlan;
  late _MockArchive archivePlan;
  late _MockAssign assignPlan;

  DietPlan plan({
    required String id,
    DietPlanStatus status = DietPlanStatus.draft,
    int rowVersion = 1,
    bool isTemplate = false,
    String? memberId,
  }) {
    return DietPlan(
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
      const AssignDietPlanParams(planId: '1', memberId: '1'),
    );
  });

  setUp(() {
    getPlan = _MockGet();
    publishPlan = _MockPublish();
    archivePlan = _MockArchive();
    assignPlan = _MockAssign();
  });

  DietPlanDetailCubit buildCubit() =>
      DietPlanDetailCubit(getPlan, publishPlan, archivePlan, assignPlan);

  blocTest<DietPlanDetailCubit, DietPlanDetailState>(
    'loads plan',
    build: () {
      when(() => getPlan('1')).thenAnswer(
        (_) async => Right(plan(id: '1', status: DietPlanStatus.active, isTemplate: true)),
      );
      return buildCubit();
    },
    act: (cubit) => cubit.load('1'),
    expect: () => [
      isA<DietPlanDetailLoading>(),
      isA<DietPlanDetailLoaded>().having((s) => s.plan.title, 'title', 'Plan 1'),
    ],
  );

  blocTest<DietPlanDetailCubit, DietPlanDetailState>(
    'emits failure on getPlan error',
    build: () {
      when(() => getPlan('1')).thenAnswer(
        (_) async => const Left(NotFoundFailure()),
      );
      return buildCubit();
    },
    act: (cubit) => cubit.load('1'),
    expect: () => [
      isA<DietPlanDetailLoading>(),
      isA<DietPlanDetailFailure>(),
    ],
  );

  blocTest<DietPlanDetailCubit, DietPlanDetailState>(
    'publishes loaded draft plan',
    build: () {
      when(() => getPlan('1')).thenAnswer(
        (_) async => Right(plan(id: '1', status: DietPlanStatus.draft)),
      );
      when(() => publishPlan('1')).thenAnswer(
        (_) async => Right(plan(id: '1', status: DietPlanStatus.active, rowVersion: 2)),
      );
      return buildCubit();
    },
    act: (cubit) async {
      await cubit.load('1');
      await cubit.publish();
    },
    expect: () => [
      isA<DietPlanDetailLoading>(),
      isA<DietPlanDetailLoaded>().having((s) => s.plan.status, 'status', DietPlanStatus.draft),
      isA<DietPlanDetailActionInFlight>(),
      isA<DietPlanDetailLoaded>().having((s) => s.plan.status, 'status', DietPlanStatus.active),
    ],
  );

  blocTest<DietPlanDetailCubit, DietPlanDetailState>(
    'archives loaded plan',
    build: () {
      when(() => getPlan('2')).thenAnswer(
        (_) async => Right(plan(id: '2', status: DietPlanStatus.active)),
      );
      when(() => archivePlan('2')).thenAnswer(
        (_) async => Right(plan(id: '2', status: DietPlanStatus.archived, rowVersion: 3)),
      );
      return buildCubit();
    },
    act: (cubit) async {
      await cubit.load('2');
      await cubit.archive();
    },
    expect: () => [
      isA<DietPlanDetailLoading>(),
      isA<DietPlanDetailLoaded>().having((s) => s.plan.status, 'status', DietPlanStatus.active),
      isA<DietPlanDetailActionInFlight>(),
      isA<DietPlanDetailLoaded>().having((s) => s.plan.status, 'status', DietPlanStatus.archived),
    ],
  );

  blocTest<DietPlanDetailCubit, DietPlanDetailState>(
    'assigns template to member',
    build: () {
      when(() => getPlan('5')).thenAnswer(
        (_) async => Right(plan(id: '5', isTemplate: true)),
      );
      when(() => assignPlan(const AssignDietPlanParams(planId: '5', memberId: '42'))).thenAnswer(
        (_) async => Right(plan(id: '99', isTemplate: false, memberId: '42')),
      );
      return buildCubit();
    },
    act: (cubit) async {
      await cubit.load('5');
      await cubit.assignToMember('42');
    },
    expect: () => [
      isA<DietPlanDetailLoading>(),
      isA<DietPlanDetailLoaded>().having((s) => s.plan.id, 'id', '5'),
      isA<DietPlanDetailActionInFlight>(),
      isA<DietPlanDetailLoaded>().having(
        (s) => s.assignedPlan?.id,
        'assignedPlan.id',
        '99',
      ),
    ],
  );
}
