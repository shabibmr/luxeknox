import 'package:equatable/equatable.dart';

import 'workout_session_set.dart';

class WorkoutSession extends Equatable {
  const WorkoutSession({
    required this.id,
    required this.memberId,
    this.workoutPlanId,
    this.workoutPlanVersionId,
    this.trainerId,
    required this.startedAt,
    this.completedAt,
    this.totalVolumeKg,
    this.durationMinutes,
    this.clientFeedbackRating,
    this.notes,
    this.sets = const [],
  });

  final String id;
  final String memberId;
  final String? workoutPlanId;
  final String? workoutPlanVersionId;
  final String? trainerId;
  final DateTime startedAt;
  final DateTime? completedAt;
  final num? totalVolumeKg;
  final int? durationMinutes;
  final int? clientFeedbackRating;
  final String? notes;
  final List<WorkoutSessionSet> sets;

  bool get isCompleted => completedAt != null;

  @override
  List<Object?> get props => [
    id,
    memberId,
    workoutPlanId,
    workoutPlanVersionId,
    trainerId,
    startedAt,
    completedAt,
    totalVolumeKg,
    durationMinutes,
    clientFeedbackRating,
    notes,
    sets,
  ];
}
