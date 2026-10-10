import 'package:flutter/material.dart';

import '../../domain/entities/member_goal.dart';
import '../../domain/helpers/goal_progress.dart';
import '../goals_strings.dart';

class GoalIdentityFacts extends StatelessWidget {
  const GoalIdentityFacts({super.key, required this.goal});

  final MemberGoal goal;

  @override
  Widget build(BuildContext context) {
    final metric = goal.metric;
    final rows = <(String, String)>[
      if (metric != null) (GoalsStrings.metricUnitLabel, metric.unitOfMeasure),
      if (metric != null)
        (
          GoalsStrings.metricCategoryLabel,
          GoalsStrings.categoryLabelFor(metric.category),
        ),
      (GoalsStrings.baselineLabel, '${goal.baselineValue ?? '—'}'),
      (
        'Direction',
        GoalsStrings.directionLabel(
          goalDirection(
            baseline: goal.baselineValue,
            target: goal.targetValue,
          ),
        ),
      ),
      (GoalsStrings.startDateLabel, GoalsStrings.calendarDate(goal.startDate)),
      (
        GoalsStrings.targetDateLabel,
        GoalsStrings.calendarDate(goal.targetDate),
      ),
      (
        GoalsStrings.statusLabel,
        GoalsStrings.statusLabelFor(goal.status),
      ),
    ];
    return Column(
      key: const Key('goal-view-identity'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final row in rows)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text('${row.$1}: ${row.$2}'),
          ),
      ],
    );
  }
}
