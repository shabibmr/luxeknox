import 'package:flutter/material.dart';

import '../../../../core/widgets/app_status_chip.dart';
import '../../domain/entities/goal_status.dart';
import '../../domain/helpers/goal_progress.dart';
import '../goals_strings.dart';

class AchievementChip extends StatelessWidget {
  const AchievementChip({super.key, required this.status});

  final GoalStatus status;

  @override
  Widget build(BuildContext context) {
    final achieved = isGoalAchievedStatus(status);
    final abandoned = status == GoalStatus.abandoned;
    final scheme = Theme.of(context).colorScheme;
    final chip = AppStatusChip(
      label: GoalsStrings.statusLabelFor(status),
      color: achieved
          ? scheme.primaryContainer
          : abandoned
              ? scheme.errorContainer
              : scheme.surfaceContainerHighest,
      foregroundColor: achieved
          ? scheme.onPrimaryContainer
          : abandoned
              ? scheme.onErrorContainer
              : scheme.onSurfaceVariant,
      icon: achieved
          ? Icons.emoji_events
          : abandoned
              ? Icons.block
              : Icons.flag_outlined,
      tinted: false,
    );
    if (!achieved) return chip;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        chip,
        const SizedBox(height: 4),
        Text(
          GoalsStrings.achievedServerCaption,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
