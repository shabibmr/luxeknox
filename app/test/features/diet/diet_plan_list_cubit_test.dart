import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/core/pagination/cursor_page.dart';
import 'package:luxeknox/core/presentation/load_status.dart';
import 'package:luxeknox/features/diet/domain/entities/diet_plan.dart';
import 'package:luxeknox/features/diet/domain/entities/diet_plan_status.dart';
import 'package:luxeknox/features/diet/domain/usecases/list_diet_plans_usecase.dart';
import 'package:luxeknox/features/diet/presentation/cubit/diet_plan_list_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockListDietPlans extends Mock implements ListDietPlansUseCase {}

void main() {
  late _MockListDietPlans listPlans;

  DietPlan plan({
    required String id,
    DietPlanStatus status = DietPlanStatus.draft,
  }) {
    return DietPlan(
      id: id,
      title: 'Plan $id',
      isTemplate: false,
      status: status,
      rowVersion: 1,
    );
  }

  setUp(() {
    listPlans = _MockListDietPlans();
    registerFallbackValue(const ListDietPlansParams());
  });

  blocTest<DietPlanListCubit, DietPlanListState>(
    'loads plans and applies client-side status filter',
    build: () {
      when(() => listPlans(any())).thenAnswer(
        (_) async => Right(
          CursorPage(
            items: [
              plan(id: '1', status: DietPlanStatus.draft),
              plan(id: '2', status: DietPlanStatus.active),
              plan(id: '3', status: DietPlanStatus.archived),
            ],
            nextCursor: null,
            hasMore: false,
          ),
        ),
      );
      return DietPlanListCubit(listPlans);
    },
    act: (cubit) async {
      await cubit.load();
      await cubit.setFilter(DietPlanListFilter.active);
    },
    expect: () => [
      isA<DietPlanListState>().having(
        (s) => s.status,
        'status',
        LoadStatus.loading,
      ),
      isA<DietPlanListState>()
          .having((s) => s.status, 'status', LoadStatus.success)
          .having(
            (s) => s.items.map((p) => p.id).toList(),
            'ids',
            ['1', '2', '3'],
          ),
      isA<DietPlanListState>()
          .having((s) => s.status, 'status', LoadStatus.success)
          .having((s) => s.filter, 'filter', DietPlanListFilter.active)
          .having((s) => s.items.map((p) => p.id).toList(), 'ids', ['2']),
    ],
  );

  blocTest<DietPlanListCubit, DietPlanListState>(
    'emits failure on repository error',
    build: () {
      when(() => listPlans(any())).thenAnswer(
        (_) async => const Left(NetworkFailure()),
      );
      return DietPlanListCubit(listPlans);
    },
    act: (cubit) => cubit.load(),
    expect: () => [
      isA<DietPlanListState>().having(
        (s) => s.status,
        'status',
        LoadStatus.loading,
      ),
      isA<DietPlanListState>()
          .having((s) => s.status, 'status', LoadStatus.failure)
          .having((s) => s.failure, 'failure', isA<NetworkFailure>())
          .having((s) => s.items, 'items', isEmpty),
    ],
  );
}
