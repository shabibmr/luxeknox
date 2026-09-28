import 'package:flutter/material.dart';

import '../../domain/entities/workout_plan_exercise_input.dart';
import '../workout_strings.dart';

typedef PlanExerciseReorder = void Function(int oldIndex, int newIndex);
typedef PlanExerciseAction = void Function(int index);

/// Reorderable list for exercises within a single day group.
class PlanExerciseReorderList extends StatelessWidget {
  const PlanExerciseReorderList({
    super.key,
    required this.exercises,
    required this.onReorder,
    this.onRemove,
    this.onMoveDay,
    this.enabled = true,
  });

  final List<WorkoutPlanExerciseInput> exercises;
  final PlanExerciseReorder onReorder;
  final PlanExerciseAction? onRemove;
  final PlanExerciseAction? onMoveDay;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    if (exercises.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Text(WorkoutStrings.emptyDay),
      );
    }

    return ReorderableListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      buildDefaultDragHandles: enabled,
      itemCount: exercises.length,
      onReorderItem: enabled ? onReorder : (_, _) {},
      itemBuilder: (context, index) {
        final item = exercises[index];
        final subtitle = WorkoutStrings.exerciseSubtitle(
          sets: item.targetSets,
          reps: item.targetReps,
        );
        return ListTile(
          key: ValueKey('day-${item.dayNumber}-$index-${item.exerciseId}'),
          title: Text(item.exerciseName ?? 'Exercise #${item.exerciseId}'),
          subtitle: subtitle.isEmpty ? null : Text(subtitle),
          trailing: enabled
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (onMoveDay != null)
                      IconButton(
                        tooltip: WorkoutStrings.moveToDay,
                        icon: const Icon(Icons.swap_horiz),
                        onPressed: () => onMoveDay!(index),
                      ),
                    if (onRemove != null)
                      IconButton(
                        tooltip: WorkoutStrings.remove,
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => onRemove!(index),
                      ),
                    const Icon(Icons.drag_handle),
                  ],
                )
              : null,
        );
      },
    );
  }
}
