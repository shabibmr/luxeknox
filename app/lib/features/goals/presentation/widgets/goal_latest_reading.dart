import 'package:flutter/material.dart';

import '../../domain/entities/goal_history.dart';
import '../goals_strings.dart';

class GoalLatestReading extends StatelessWidget {
  const GoalLatestReading({super.key, required this.entry, this.unit});

  final GoalHistoryEntry entry;
  final String? unit;

  @override
  Widget build(BuildContext context) {
    final unitSuffix = unit == null || unit!.isEmpty ? '' : ' $unit';
    return Column(
      key: const Key('goal-view-latest'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${entry.recordedValue}$unitSuffix',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Text(GoalsStrings.calendarDate(entry.recordedDate)),
        if (entry.notes != null && entry.notes!.isNotEmpty)
          Text(entry.notes!),
      ],
    );
  }
}
