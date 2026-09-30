import 'package:flutter/material.dart';

import '../../domain/entities/exercise.dart';
import '../exercise_strings.dart';

/// Displays a single [Exercise] summary. Pure presentation — the caller
/// supplies the data and reacts to taps; this widget never fetches.
class ExerciseListItem extends StatelessWidget {
  const ExerciseListItem({super.key, required this.exercise, this.onTap});

  final Exercise exercise;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final equipmentLabel = exercise.equipmentNeeded.isEmpty
        ? ExerciseStrings.noEquipmentShort
        : exercise.equipmentNeeded.join(', ');

    return ListTile(
      onTap: onTap,
      title: Text(
        exercise.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        '${exercise.primaryMuscleGroup} · $equipmentLabel',
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 110),
        child: Chip(
          label: Text(
            exercise.difficultyLevel,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          visualDensity: VisualDensity.compact,
        ),
      ),
    );
  }
}
