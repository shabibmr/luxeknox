import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luxeknox/features/goals/domain/entities/goal_history.dart';
import 'package:luxeknox/features/goals/domain/entities/goal_metric.dart';
import 'package:luxeknox/features/goals/domain/entities/goal_metric_category.dart';
import 'package:luxeknox/features/goals/domain/entities/goal_status.dart';
import 'package:luxeknox/features/goals/domain/entities/member_goal.dart';
import 'package:luxeknox/features/goals/domain/entities/progress_note.dart';
import 'package:luxeknox/features/goals/domain/entities/progress_note_type.dart';
import 'package:luxeknox/features/goals/presentation/goals_strings.dart';
import 'package:luxeknox/features/goals/presentation/widgets/goal_coach_notes_section.dart';
import 'package:luxeknox/features/goals/presentation/widgets/goal_history_section.dart';
import 'package:luxeknox/features/goals/presentation/widgets/goal_identity_facts.dart';
import 'package:luxeknox/features/goals/presentation/widgets/goal_projected_actual.dart';

void main() {
  final goal = MemberGoal(
    id: '1',
    memberId: '9',
    metricId: '4',
    baselineValue: 80,
    targetValue: 70,
    currentValue: 76,
    startDate: DateTime(2026, 1, 1),
    targetDate: DateTime(2026, 1, 11),
    status: GoalStatus.inProgress,
    metric: GoalMetric(
      id: '4',
      name: 'Weight',
      unitOfMeasure: 'kg',
      category: GoalMetricCategory.bodyComposition,
      isActive: true,
    ),
  );

  testWidgets('identity facts show dates status direction and unit', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(home: Scaffold(body: GoalIdentityFacts(goal: goal))),
    );

    expect(find.byKey(const Key('goal-view-identity')), findsOneWidget);
    expect(find.textContaining(GoalsStrings.directionDecrease), findsOneWidget);
    expect(find.textContaining('kg'), findsOneWidget);
    expect(find.textContaining('2026-01-01'), findsOneWidget);
    expect(find.textContaining('2026-01-11'), findsOneWidget);
    expect(find.textContaining(GoalsStrings.statusInProgress), findsOneWidget);
    expect(find.textContaining('Progress:'), findsNothing);
  });

  testWidgets('coach notes lists trainer assessments only content', (
    tester,
  ) async {
    final notes = [
      ProgressNote(
        id: '1',
        memberId: '9',
        authorUserId: '2',
        noteText: 'Keep cutting slowly',
        noteType: ProgressNoteType.trainerAssessment,
        createdAt: DateTime(2026, 1, 5),
      ),
    ];
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: GoalCoachNotesSection(notes: notes)),
      ),
    );

    expect(find.byKey(const Key('goal-view-coach-notes')), findsOneWidget);
    expect(find.text(GoalsStrings.coachNotesTitle), findsOneWidget);
    expect(find.text('Keep cutting slowly'), findsOneWidget);
    expect(find.textContaining('2026-01-05'), findsOneWidget);
  });

  testWidgets('coach notes empty state', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: GoalCoachNotesSection(notes: [])),
      ),
    );
    expect(find.text(GoalsStrings.coachNotesEmpty), findsOneWidget);
  });

  testWidgets('projected vs actual shows linear midpoint and current', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: GoalProjectedActual(
            goal: goal,
            asOf: DateTime(2026, 1, 6),
          ),
        ),
      ),
    );

    expect(find.byKey(const Key('goal-view-projected-actual')), findsOneWidget);
    expect(find.textContaining('${GoalsStrings.projectedLabel}: 75'), findsOneWidget);
    expect(find.textContaining('${GoalsStrings.actualLabel}: 76'), findsOneWidget);
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

  testWidgets('history chart with close-then-long span finishes pumping', (
    tester,
  ) async {
    final history = [
      GoalHistoryEntry(
        id: '1',
        goalId: '1',
        recordedValue: 80,
        recordedDate: DateTime(2026, 9, 1),
      ),
      GoalHistoryEntry(
        id: '2',
        goalId: '1',
        recordedValue: 79,
        recordedDate: DateTime(2026, 9, 1).add(const Duration(seconds: 1)),
      ),
      GoalHistoryEntry(
        id: '3',
        goalId: '1',
        recordedValue: 76,
        recordedDate: DateTime(2026, 10, 1),
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: GoalHistorySection(history: history)),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('goal-view-chart')), findsOneWidget);
  });
}
