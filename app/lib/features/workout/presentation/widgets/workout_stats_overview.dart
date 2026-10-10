import 'package:flutter/material.dart';

import '../../domain/entities/workout_plan_exercise.dart';
import '../workout_strings.dart';

/// Modular widget displaying high-level workout plan statistics.
class WorkoutStatsOverview extends StatelessWidget {
  const WorkoutStatsOverview({super.key, required this.exercises});

  final List<WorkoutPlanExercise> exercises;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final daysCount = exercises.map((e) => e.dayNumber).toSet().length;
    final totalExercises = exercises.length;
    final totalSets = exercises.fold<int>(
      0,
      (sum, e) => sum + (e.targetSets ?? 0),
    );

    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _StatColumn(
              icon: Icons.calendar_month_outlined,
              value: '$daysCount',
              label: WorkoutStrings.totalDaysLabel,
            ),
            Container(
              width: 1,
              height: 32,
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
            ),
            _StatColumn(
              icon: Icons.fitness_center_outlined,
              value: '$totalExercises',
              label: WorkoutStrings.totalExercisesLabel,
            ),
            Container(
              width: 1,
              height: 32,
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
            ),
            _StatColumn(
              icon: Icons.repeat,
              value: totalSets > 0 ? '$totalSets' : '—',
              label: WorkoutStrings.totalSetsLabel,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  const _StatColumn({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: theme.colorScheme.primary),
            const SizedBox(width: 4),
            Text(
              value,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
