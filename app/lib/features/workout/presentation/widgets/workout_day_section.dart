import 'package:flutter/material.dart';

import '../../domain/entities/workout_plan_exercise.dart';
import '../workout_strings.dart';
import 'workout_exercise_card.dart';

/// Modular section container displaying exercises for a specific day in the workout split.
class WorkoutDaySection extends StatelessWidget {
  const WorkoutDaySection({
    super.key,
    required this.dayNumber,
    required this.exercises,
    this.onExerciseTap,
    this.onStartDay,
  });

  final int dayNumber;
  final List<WorkoutPlanExercise> exercises;
  final void Function(WorkoutPlanExercise exercise)? onExerciseTap;
  final VoidCallback? onStartDay;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final totalSets = exercises.fold<int>(
      0,
      (sum, e) => sum + (e.targetSets ?? 0),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      WorkoutStrings.dayHeader(dayNumber),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${exercises.length} ${WorkoutStrings.totalExercisesLabel.toLowerCase()}'
                      '${totalSets > 0 ? ' · $totalSets ${WorkoutStrings.totalSetsLabel.toLowerCase()}' : ''}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (onStartDay != null && exercises.isNotEmpty)
                FilledButton.tonalIcon(
                  onPressed: onStartDay,
                  icon: const Icon(Icons.play_arrow, size: 18),
                  label: const Text(WorkoutStrings.startDayWorkout),
                  style: FilledButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                  ),
                ),
            ],
          ),
        ),
        if (exercises.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              WorkoutStrings.emptyDay,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.outline,
                fontStyle: FontStyle.italic,
              ),
            ),
          )
        else
          ...exercises.map(
            (e) => WorkoutExerciseCard(
              exercise: e,
              onTap: onExerciseTap != null ? () => onExerciseTap!(e) : null,
            ),
          ),
        const SizedBox(height: 12),
      ],
    );
  }
}
