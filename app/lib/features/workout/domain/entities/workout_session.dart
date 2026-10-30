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
    this.effortRating,
    this.satisfactionRating,
    this.painDiscomfortScore,
    this.painNotes,
    this.sessionFocus,
    this.warmupProtocol,
    this.cooldownProtocol,
    this.trainerNotes,
    this.nextSessionPlan,
    this.clientSignedAt,
    this.trainerSignedAt,
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

  // Multi-metric completion, safety & protocols (PTF-14 / PTF-25)
  final int? effortRating;
  final int? satisfactionRating;
  final int? painDiscomfortScore;
  final String? painNotes;
  final String? sessionFocus;
  final String? warmupProtocol;
  final String? cooldownProtocol;
  final String? trainerNotes;
  final String? nextSessionPlan;
  final DateTime? clientSignedAt;
  final DateTime? trainerSignedAt;

  bool get isCompleted => completedAt != null;

  WorkoutSession copyWith({
    String? id,
    String? memberId,
    String? workoutPlanId,
    String? workoutPlanVersionId,
    String? trainerId,
    DateTime? startedAt,
    DateTime? completedAt,
    num? totalVolumeKg,
    int? durationMinutes,
    int? clientFeedbackRating,
    String? notes,
    List<WorkoutSessionSet>? sets,
    int? effortRating,
    int? satisfactionRating,
    int? painDiscomfortScore,
    String? painNotes,
    String? sessionFocus,
    String? warmupProtocol,
    String? cooldownProtocol,
    String? trainerNotes,
    String? nextSessionPlan,
    DateTime? clientSignedAt,
    DateTime? trainerSignedAt,
  }) {
    return WorkoutSession(
      id: id ?? this.id,
      memberId: memberId ?? this.memberId,
      workoutPlanId: workoutPlanId ?? this.workoutPlanId,
      workoutPlanVersionId: workoutPlanVersionId ?? this.workoutPlanVersionId,
      trainerId: trainerId ?? this.trainerId,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      totalVolumeKg: totalVolumeKg ?? this.totalVolumeKg,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      clientFeedbackRating: clientFeedbackRating ?? this.clientFeedbackRating,
      notes: notes ?? this.notes,
      sets: sets ?? this.sets,
      effortRating: effortRating ?? this.effortRating,
      satisfactionRating: satisfactionRating ?? this.satisfactionRating,
      painDiscomfortScore: painDiscomfortScore ?? this.painDiscomfortScore,
      painNotes: painNotes ?? this.painNotes,
      sessionFocus: sessionFocus ?? this.sessionFocus,
      warmupProtocol: warmupProtocol ?? this.warmupProtocol,
      cooldownProtocol: cooldownProtocol ?? this.cooldownProtocol,
      trainerNotes: trainerNotes ?? this.trainerNotes,
      nextSessionPlan: nextSessionPlan ?? this.nextSessionPlan,
      clientSignedAt: clientSignedAt ?? this.clientSignedAt,
      trainerSignedAt: trainerSignedAt ?? this.trainerSignedAt,
    );
  }

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
    effortRating,
    satisfactionRating,
    painDiscomfortScore,
    painNotes,
    sessionFocus,
    warmupProtocol,
    cooldownProtocol,
    trainerNotes,
    nextSessionPlan,
    clientSignedAt,
    trainerSignedAt,
  ];
}
