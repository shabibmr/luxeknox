import 'package:flutter/material.dart';

import '../../domain/entities/member_goal.dart';
import '../../domain/helpers/goal_progress.dart';
import '../goals_strings.dart';
import 'achievement_chip.dart';

class GoalProgressBar extends StatelessWidget {
  const GoalProgressBar({super.key, required this.goal});

  final MemberGoal goal;

  @override
  Widget build(BuildContext context) {
    final fraction = goalProgressFraction(
      baseline: goal.baselineValue,
      current: goal.currentValue,
      target: goal.targetValue,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                goal.metric?.name ?? GoalsStrings.metricLabel,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            AchievementChip(status: goal.status),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(value: fraction),
        const SizedBox(height: 4),
        Text(
          '${GoalsStrings.progressLabel}: ${GoalsStrings.percentLabel(fraction)}'
          ' · ${GoalsStrings.currentLabel}: ${goal.currentValue ?? '—'}'
          ' / ${GoalsStrings.targetLabel}: ${goal.targetValue ?? '—'}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
