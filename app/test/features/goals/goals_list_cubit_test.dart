import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/core/presentation/load_status.dart';
import 'package:luxeknox/core/pagination/cursor_page.dart';
import 'package:luxeknox/features/goals/domain/entities/goal_status.dart';
import 'package:luxeknox/features/goals/domain/entities/member_goal.dart';
import 'package:luxeknox/features/goals/domain/usecases/goals_usecases.dart';
import 'package:luxeknox/features/goals/presentation/cubit/goals_list_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockListMemberGoals extends Mock implements ListMemberGoalsUseCase {}

void main() {
  late _MockListMemberGoals listGoals;

  MemberGoal goal(String id) {
    return MemberGoal(
      id: id,
      memberId: '10',
      metricId: '1',
      status: GoalStatus.inProgress,
      currentValue: 50,
      baselineValue: 0,
      targetValue: 100,
    );
  }

  setUp(() {
    listGoals = _MockListMemberGoals();
    registerFallbackValue(const MemberIdParams('0'));
  });

  blocTest<GoalsListCubit, GoalsListState>(
    'loads member goals',
    build: () {
      when(() => listGoals(any())).thenAnswer(
        (_) async => Right(
          CursorPage(
            items: [goal('1'), goal('2')],
            nextCursor: null,
            hasMore: false,
          ),
        ),
      );
      return GoalsListCubit(listGoals);
    },
    act: (cubit) => cubit.load('10'),
    expect: () => [
      isA<GoalsListState>().having(
        (s) => s.status,
        'status',
        LoadStatus.loading,
      ),
      isA<GoalsListState>()
          .having((s) => s.status, 'status', LoadStatus.success)
          .having(
            (s) => s.items.map((g) => g.id).toList(),
            'ids',
            ['1', '2'],
          ),
    ],
  );

  blocTest<GoalsListCubit, GoalsListState>(
    'emits failure on error',
    build: () {
      when(() => listGoals(any())).thenAnswer(
        (_) async => const Left(NetworkFailure()),
      );
      return GoalsListCubit(listGoals);
    },
    act: (cubit) => cubit.load('10'),
    expect: () => [
      isA<GoalsListState>().having(
        (s) => s.status,
        'status',
        LoadStatus.loading,
      ),
      isA<GoalsListState>()
          .having((s) => s.status, 'status', LoadStatus.failure)
          .having((s) => s.failure, 'failure', isA<NetworkFailure>())
          .having((s) => s.items, 'items', isEmpty),
    ],
  );
}
