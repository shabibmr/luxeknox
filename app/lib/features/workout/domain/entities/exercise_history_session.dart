import 'package:equatable/equatable.dart';

import 'workout_session_set.dart';

class ExerciseHistorySession extends Equatable {
  const ExerciseHistorySession({
    required this.sessionId,
    required this.startedAt,
    this.completedAt,
    required this.sets,
  });

  final String sessionId;
  final DateTime startedAt;
  final DateTime? completedAt;
  final List<WorkoutSessionSet> sets;

  @override
  List<Object?> get props => [sessionId, startedAt, completedAt, sets];
}
