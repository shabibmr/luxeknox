import 'package:flutter/material.dart';

import '../../domain/entities/exercise.dart';

/// Displays a single [Exercise] summary. Pure presentation — the caller
/// supplies the data and reacts to taps; this widget never fetches.
class ExerciseListItem extends StatelessWidget {
  const ExerciseListItem({super.key, required this.exercise, this.onTap});

  final Exercise exercise;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final equipmentLabel = exercise.equipmentNeeded.isEmpty
        ? 'No equipment'
        : exercise.equipmentNeeded.join(', ');

    return ListTile(
      onTap: onTap,
      title: Text(exercise.name),
      subtitle: Text('${exercise.primaryMuscleGroup} · $equipmentLabel'),
      trailing: Chip(
        label: Text(exercise.difficultyLevel),
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}
