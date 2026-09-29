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
    final scheme = Theme.of(context).colorScheme;
    return AppStatusChip(
      label: GoalsStrings.statusLabelFor(status),
      color: achieved ? scheme.primaryContainer : scheme.surfaceContainerHighest,
      foregroundColor: achieved ? scheme.onPrimaryContainer : scheme.onSurfaceVariant,
      icon: achieved ? Icons.emoji_events : Icons.flag_outlined,
      tinted: false,
    );
  }
}
