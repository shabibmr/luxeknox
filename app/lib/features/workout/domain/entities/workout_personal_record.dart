import 'package:equatable/equatable.dart';

import 'workout_session.dart';

/// Max weight lifted for a single exercise, derived from session sets.
class WorkoutPersonalRecord extends Equatable {
  const WorkoutPersonalRecord({
    required this.exerciseId,
    required this.maxWeightKg,
  });

  final String exerciseId;
  final num maxWeightKg;

  @override
  List<Object?> get props => [exerciseId, maxWeightKg];
}

/// Computes max `weightLiftedKg` per `exerciseId` across all sets in [sessions].
List<WorkoutPersonalRecord> computePersonalRecords(
  List<WorkoutSession> sessions,
) {
  final maxByExercise = <String, num>{};
  for (final session in sessions) {
    for (final set in session.sets) {
      final weight = set.weightLiftedKg;
      if (weight == null) continue;
      final prev = maxByExercise[set.exerciseId];
      if (prev == null || weight > prev) {
        maxByExercise[set.exerciseId] = weight;
      }
    }
  }
  final records = maxByExercise.entries
      .map(
        (e) => WorkoutPersonalRecord(
          exerciseId: e.key,
          maxWeightKg: e.value,
        ),
      )
      .toList();
  records.sort((a, b) => a.exerciseId.compareTo(b.exerciseId));
  return records;
}
