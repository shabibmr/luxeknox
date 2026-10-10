import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luxeknox/features/goals/domain/entities/goal_history.dart';
import 'package:luxeknox/features/goals/domain/entities/goal_metric.dart';
import 'package:luxeknox/features/goals/domain/entities/goal_metric_category.dart';
import 'package:luxeknox/features/goals/domain/entities/goal_status.dart';
import 'package:luxeknox/features/goals/domain/entities/member_goal.dart';
import 'package:luxeknox/features/goals/presentation/goals_strings.dart';
import 'package:luxeknox/features/goals/presentation/widgets/goal_history_section.dart';
import 'package:luxeknox/features/goals/presentation/widgets/goal_identity_facts.dart';

void main() {
  const goal = MemberGoal(
    id: '1',
    memberId: '9',
    metricId: '4',
    baselineValue: 80,
    targetValue: 70,
    currentValue: 76,
    startDate: null,
    targetDate: null,
    status: GoalStatus.inProgress,
    metric: GoalMetric(
      id: '4',
      name: 'Weight',
      unitOfMeasure: 'kg',
      category: GoalMetricCategory.bodyComposition,
      isActive: true,
    ),
  );

  testWidgets('identity facts show direction and unit without repeating progress', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: GoalIdentityFacts(goal: goal))),
    );

    expect(find.byKey(const Key('goal-view-identity')), findsOneWidget);
    expect(find.textContaining(GoalsStrings.directionDecrease), findsOneWidget);
    expect(find.textContaining('kg'), findsOneWidget);
    expect(find.textContaining('Progress:'), findsNothing);
  });

  testWidgets('empty history shows one empty line and no latest card', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: GoalHistorySection(history: [])),
      ),
    );

    expect(find.byKey(const Key('goal-view-chart')), findsOneWidget);
    expect(find.text(GoalsStrings.noCheckInsYet), findsOneWidget);
    expect(find.byKey(const Key('goal-view-latest')), findsNothing);
    expect(find.byKey(const Key('goal-view-history')), findsNothing);
  });

  testWidgets('earlier rows skip the newest reading', (tester) async {
    final history = [
      GoalHistoryEntry(
        id: '2',
        goalId: '1',
        recordedValue: 76,
        recordedDate: DateTime(2026, 10, 2),
        notes: 'latest',
      ),
      GoalHistoryEntry(
        id: '10',
        goalId: '1',
        recordedValue: 78,
        recordedDate: DateTime(2026, 10, 1),
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: GoalHistorySection(history: history, showEarlier: true),
        ),
      ),
    );

    expect(find.byKey(const Key('goal-view-history')), findsOneWidget);
    expect(find.textContaining('2026-10-01 · 78'), findsOneWidget);
    expect(find.textContaining('latest'), findsNothing);
  });
}
