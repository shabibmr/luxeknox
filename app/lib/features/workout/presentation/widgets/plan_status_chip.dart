import 'package:flutter/material.dart';

import '../../domain/entities/workout_plan_status.dart';
import '../workout_strings.dart';

class PlanStatusChip extends StatelessWidget {
  const PlanStatusChip({super.key, required this.status});

  final WorkoutPlanStatus status;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final (label, color) = switch (status) {
      WorkoutPlanStatus.draft => (WorkoutStrings.statusDraft, Colors.orange),
      WorkoutPlanStatus.active => (WorkoutStrings.statusActive, Colors.green),
      WorkoutPlanStatus.archived => (
        WorkoutStrings.statusArchived,
        scheme.outline,
      ),
    };
    return Chip(
      label: Text(label),
      backgroundColor: color.withValues(alpha: 0.15),
      labelStyle: TextStyle(color: color, fontWeight: FontWeight.w600),
      side: BorderSide.none,
    );
  }
}
