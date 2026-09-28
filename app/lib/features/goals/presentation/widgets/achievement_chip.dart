import 'package:flutter/material.dart';

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
    return Chip(
      avatar: Icon(
        achieved ? Icons.emoji_events : Icons.flag_outlined,
        size: 16,
        color: achieved ? scheme.onPrimaryContainer : scheme.onSurfaceVariant,
      ),
      label: Text(GoalsStrings.statusLabelFor(status)),
      backgroundColor: achieved
          ? scheme.primaryContainer
          : scheme.surfaceContainerHighest,
    );
  }
}
