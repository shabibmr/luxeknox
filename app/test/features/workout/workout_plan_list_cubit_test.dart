import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/core/pagination/cursor_page.dart';
import 'package:luxeknox/core/presentation/load_status.dart';
import 'package:luxeknox/features/workout/domain/entities/workout_plan.dart';
import 'package:luxeknox/features/workout/domain/entities/workout_plan_status.dart';
import 'package:luxeknox/features/workout/domain/usecases/list_workout_plans_usecase.dart';
import 'package:luxeknox/features/workout/presentation/cubit/workout_plan_list_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockListWorkoutPlans extends Mock implements ListWorkoutPlansUseCase {}

void main() {
  late _MockListWorkoutPlans listPlans;

  WorkoutPlan plan({
    required String id,
    WorkoutPlanStatus status = WorkoutPlanStatus.draft,
  }) {
    return WorkoutPlan(
      id: id,
      title: 'Plan $id',
      isTemplate: false,
      status: status,
      rowVersion: 1,
    );
  }

  setUp(() {
    listPlans = _MockListWorkoutPlans();
    registerFallbackValue(const ListWorkoutPlansParams());
  });

  blocTest<WorkoutPlanListCubit, WorkoutPlanListState>(
    'loads plans and applies client-side status filter',
    build: () {
      when(() => listPlans(any())).thenAnswer(
        (_) async => Right(
          CursorPage(
            items: [
              plan(id: '1', status: WorkoutPlanStatus.draft),
              plan(id: '2', status: WorkoutPlanStatus.active),
              plan(id: '3', status: WorkoutPlanStatus.archived),
            ],
            nextCursor: null,
            hasMore: false,
          ),
        ),
      );
      return WorkoutPlanListCubit(listPlans);
    },
    act: (cubit) async {
      await cubit.load();
      await cubit.setFilter(WorkoutPlanListFilter.active);
    },
    expect: () => [
      isA<WorkoutPlanListState>().having(
        (s) => s.status,
        'status',
        LoadStatus.loading,
      ),
      isA<WorkoutPlanListState>()
          .having((s) => s.status, 'status', LoadStatus.success)
          .having(
            (s) => s.items.map((p) => p.id).toList(),
            'ids',
            ['1', '2', '3'],
          ),
      isA<WorkoutPlanListState>()
          .having((s) => s.status, 'status', LoadStatus.success)
          .having((s) => s.filter, 'filter', WorkoutPlanListFilter.active)
          .having((s) => s.items.map((p) => p.id).toList(), 'ids', ['2']),
    ],
  );

  blocTest<WorkoutPlanListCubit, WorkoutPlanListState>(
    'emits failure on repository error',
    build: () {
      when(() => listPlans(any())).thenAnswer(
        (_) async => const Left(NetworkFailure()),
      );
      return WorkoutPlanListCubit(listPlans);
    },
    act: (cubit) => cubit.load(),
    expect: () => [
      isA<WorkoutPlanListState>().having(
        (s) => s.status,
        'status',
        LoadStatus.loading,
      ),
      isA<WorkoutPlanListState>()
          .having((s) => s.status, 'status', LoadStatus.failure)
          .having((s) => s.failure, 'failure', isA<NetworkFailure>()),
    ],
  );
}
