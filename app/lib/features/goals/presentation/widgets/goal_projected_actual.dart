import 'package:flutter/material.dart';

import '../../domain/entities/member_goal.dart';
import '../../domain/helpers/goal_progress.dart';
import '../goals_strings.dart';

class GoalProjectedActual extends StatelessWidget {
  const GoalProjectedActual({
    super.key,
    required this.goal,
    this.asOf,
  });

  final MemberGoal goal;
  final DateTime? asOf;

  @override
  Widget build(BuildContext context) {
    final projected = projectedGoalValue(
      baseline: goal.baselineValue,
      target: goal.targetValue,
      startDate: goal.startDate,
      targetDate: goal.targetDate,
      asOf: asOf,
    );
    final unit = goal.metric?.unitOfMeasure;
    final projectedText = projected == null
        ? '—'
        : _format(projected, unit);
    final actualText = goal.currentValue == null
        ? '—'
        : _format(goal.currentValue!, unit);

    return Column(
      key: const Key('goal-view-projected-actual'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          GoalsStrings.projectedActualTitle,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Text('${GoalsStrings.projectedLabel}: $projectedText'),
        Text('${GoalsStrings.actualLabel}: $actualText'),
      ],
    );
  }

  String _format(num value, String? unit) {
    final raw = value is int || value == value.roundToDouble()
        ? '${value.round()}'
        : value.toStringAsFixed(1);
    if (unit == null || unit.isEmpty) return raw;
    return '$raw $unit';
  }
}
