import 'package:luxeknox/core/pagination/cursor_page.dart';
import 'package:luxeknox/core/presentation/load_status.dart';
import 'package:luxeknox/features/goals/domain/entities/goal_metric.dart';
import 'package:luxeknox/features/goals/domain/entities/goal_metric_category.dart';
import 'package:luxeknox/features/goals/domain/entities/goal_status.dart';
import 'package:luxeknox/features/goals/domain/entities/member_goal.dart';
import 'package:luxeknox/features/goals/domain/usecases/goals_usecases.dart';
import 'package:luxeknox/features/goals/presentation/cubit/admin_member_goals_cubit.dart';
import 'package:luxeknox/features/goals/presentation/goals_strings.dart';
import 'package:luxeknox/features/goals/presentation/screens/admin_member_goals_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockListAllGoals extends Mock implements ListAllGoalsUseCase {}

void main() {
  late _MockListAllGoals listAllGoals;

  MemberGoal goal({
    required String id,
    String memberId = '42',
    String metricName = 'Weight',
  }) {
    return MemberGoal(
      id: id,
      memberId: memberId,
      metricId: 'm1',
      status: GoalStatus.inProgress,
      currentValue: 70,
      metric: GoalMetric(
        id: 'm1',
        name: metricName,
        unitOfMeasure: 'kg',
        category: GoalMetricCategory.bodyComposition,
        isActive: true,
      ),
    );
  }

  setUp(() {
    listAllGoals = _MockListAllGoals();
    registerFallbackValue(const ListAllGoalsParams());
  });

  Future<void> pumpScreen(
    WidgetTester tester, {
    required AdminMemberGoalsCubit cubit,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider.value(
          value: cubit,
          child: const AdminMemberGoalsScreen(),
        ),
      ),
    );
  }

  testWidgets('shows empty state when no goals', (tester) async {
    when(() => listAllGoals(any())).thenAnswer(
      (_) async => const Right(
        CursorPage(items: <MemberGoal>[], nextCursor: null, hasMore: false),
      ),
    );
    final cubit = AdminMemberGoalsCubit(listAllGoals);
    await pumpScreen(tester, cubit: cubit);
    await cubit.load(status: 'in_progress');
    await tester.pumpAndSettle();

    expect(find.text(GoalsStrings.adminMemberGoalsEmpty), findsOneWidget);
    expect(find.byType(ListTile), findsNothing);
  });

  testWidgets('shows one goal row', (tester) async {
    when(() => listAllGoals(any())).thenAnswer(
      (_) async => Right(
        CursorPage(
          items: [goal(id: 'g1')],
          nextCursor: null,
          hasMore: false,
        ),
      ),
    );
    final cubit = AdminMemberGoalsCubit(listAllGoals);
    await pumpScreen(tester, cubit: cubit);
    await cubit.load(status: 'in_progress');
    await tester.pumpAndSettle();

    expect(find.text('Weight'), findsOneWidget);
    expect(find.textContaining('Member #42'), findsOneWidget);
    expect(find.text('70'), findsOneWidget);
    expect(cubit.state.status, LoadStatus.success);
  });
}
