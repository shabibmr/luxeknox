import 'package:flutter/material.dart';

import '../../../../core/widgets/app_status_chip.dart';
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
    return AppStatusChip(label: label, color: color);
  }
}
