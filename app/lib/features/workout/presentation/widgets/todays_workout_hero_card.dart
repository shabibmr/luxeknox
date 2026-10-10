import 'package:flutter/material.dart';

import '../../domain/entities/workout_plan.dart';
import '../workout_strings.dart';

/// Hero summary card for Today's Workout highlighting routine metadata and start CTA.
class TodaysWorkoutHeroCard extends StatelessWidget {
  const TodaysWorkoutHeroCard({
    super.key,
    required this.plan,
    required this.dayNumber,
    required this.exerciseCount,
    required this.totalSets,
    required this.onStartWorkout,
    this.onViewPlan,
  });

  final WorkoutPlan plan;
  final int dayNumber;
  final int exerciseCount;
  final int totalSets;
  final VoidCallback onStartWorkout;
  final VoidCallback? onViewPlan;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 0,
      color: colorScheme.primaryContainer.withValues(alpha: 0.4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: colorScheme.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.fitness_center,
                  size: 20,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  WorkoutStrings.todayWorkoutTitle.toUpperCase(),
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
                    color: colorScheme.primary,
                  ),
                ),
                const Spacer(),
                if (onViewPlan != null)
                  TextButton(
                    onPressed: onViewPlan,
                    style: TextButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.zero,
                    ),
                    child: const Text(WorkoutStrings.viewDetails),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              plan.title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${WorkoutStrings.dayHeader(dayNumber)} · $exerciseCount ${WorkoutStrings.totalExercisesLabel.toLowerCase()}'
              '${totalSets > 0 ? ' · $totalSets ${WorkoutStrings.totalSetsLabel.toLowerCase()}' : ''}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: onStartWorkout,
                icon: const Icon(Icons.play_arrow),
                label: const Text(WorkoutStrings.startSession),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
