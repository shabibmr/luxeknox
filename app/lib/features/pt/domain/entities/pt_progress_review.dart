import 'package:equatable/equatable.dart';

/// Tri-party sign-off lifecycle for a PT progress review.
enum PtProgressReviewStatus {
  draft,
  pendingClientSign,
  pendingManagerApproval,
  approved,
  archived,
}

/// One body-metric row on the measures comparison table
/// (start / current / change / target).
class BodyMetricSnapshot extends Equatable {
  final String metric;
  final double? startValue;
  final double? currentValue;

  /// Always `current − start` when both sides are present on the server.
  final double? changeValue;
  final double? targetValue;

  const BodyMetricSnapshot({
    required this.metric,
    this.startValue,
    this.currentValue,
    this.changeValue,
    this.targetValue,
  });

  @override
  List<Object?> get props => [
    metric,
    startValue,
    currentValue,
    changeValue,
    targetValue,
  ];
}

/// One performance-marker row; values stay as strings (e.g. "80kg x 5").
class PerformanceMarkerSnapshot extends Equatable {
  final String marker;
  final String? startValue;
  final String? currentValue;
  final String? changeValue;
  final String? targetValue;

  const PerformanceMarkerSnapshot({
    required this.marker,
    this.startValue,
    this.currentValue,
    this.changeValue,
    this.targetValue,
  });

  @override
  List<Object?> get props => [
    marker,
    startValue,
    currentValue,
    changeValue,
    targetValue,
  ];
}

/// Six-item review checklist from the presentation card.
class PtReviewChecklist extends Equatable {
  final bool goalsReviewed;
  final bool measurementsReviewed;
  final bool performanceReviewed;
  final bool attendanceReviewed;
  final bool programUpdated;
  final bool nextGoalsAgreed;

  const PtReviewChecklist({
    this.goalsReviewed = false,
    this.measurementsReviewed = false,
    this.performanceReviewed = false,
    this.attendanceReviewed = false,
    this.programUpdated = false,
    this.nextGoalsAgreed = false,
  });

  PtReviewChecklist copyWith({
    bool? goalsReviewed,
    bool? measurementsReviewed,
    bool? performanceReviewed,
    bool? attendanceReviewed,
    bool? programUpdated,
    bool? nextGoalsAgreed,
  }) {
    return PtReviewChecklist(
      goalsReviewed: goalsReviewed ?? this.goalsReviewed,
      measurementsReviewed: measurementsReviewed ?? this.measurementsReviewed,
      performanceReviewed: performanceReviewed ?? this.performanceReviewed,
      attendanceReviewed: attendanceReviewed ?? this.attendanceReviewed,
      programUpdated: programUpdated ?? this.programUpdated,
      nextGoalsAgreed: nextGoalsAgreed ?? this.nextGoalsAgreed,
    );
  }

  @override
  List<Object?> get props => [
    goalsReviewed,
    measurementsReviewed,
    performanceReviewed,
    attendanceReviewed,
    programUpdated,
    nextGoalsAgreed,
  ];
}

/// Mirrors API `PtProgressReview` (Screen 45 domain model).
class PtProgressReview extends Equatable {
  final int id;
  final int memberId;
  final int trainerId;

  /// Calendar date (time-of-day discarded).
  final DateTime reviewPeriodStart;
  final DateTime reviewPeriodEnd;
  final List<BodyMetricSnapshot> bodyMetricsSnapshot;
  final List<PerformanceMarkerSnapshot> performanceMarkersSnapshot;
  final List<String> progressHighlights;
  final String? highlightsOtherText;
  final String? trainerSummary;
  final String? clientFeedback;
  final String? nextPhaseGoal;
  final String? nextPhaseTrainingFocus;
  final DateTime? nextReviewDate;
  final PtReviewChecklist? reviewChecklist;
  final String? finalReviewNotes;
  final DateTime? clientSignedAt;
  final DateTime? trainerSignedAt;
  final int? managerUserId;
  final DateTime? managerSignedAt;
  final PtProgressReviewStatus status;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const PtProgressReview({
    required this.id,
    required this.memberId,
    required this.trainerId,
    required this.reviewPeriodStart,
    required this.reviewPeriodEnd,
    required this.status,
    required this.createdAt,
    this.bodyMetricsSnapshot = const [],
    this.performanceMarkersSnapshot = const [],
    this.progressHighlights = const [],
    this.highlightsOtherText,
    this.trainerSummary,
    this.clientFeedback,
    this.nextPhaseGoal,
    this.nextPhaseTrainingFocus,
    this.nextReviewDate,
    this.reviewChecklist,
    this.finalReviewNotes,
    this.clientSignedAt,
    this.trainerSignedAt,
    this.managerUserId,
    this.managerSignedAt,
    this.updatedAt,
  });

  /// Highlights and checklist can only change while the review is a draft.
  bool get isCardEditable => status == PtProgressReviewStatus.draft;

  /// The PDF is offered once trainer, client and manager have all signed.
  /// This is the single rule to change if export should open up earlier.
  bool get canExportPdf =>
      trainerSignedAt != null &&
      clientSignedAt != null &&
      managerSignedAt != null;

  @override
  List<Object?> get props => [
    id,
    memberId,
    trainerId,
    reviewPeriodStart,
    reviewPeriodEnd,
    bodyMetricsSnapshot,
    performanceMarkersSnapshot,
    progressHighlights,
    highlightsOtherText,
    trainerSummary,
    clientFeedback,
    nextPhaseGoal,
    nextPhaseTrainingFocus,
    nextReviewDate,
    reviewChecklist,
    finalReviewNotes,
    clientSignedAt,
    trainerSignedAt,
    managerUserId,
    managerSignedAt,
    status,
    createdAt,
    updatedAt,
  ];
}

/// Create-draft payload for [memberId]'s PT progress review.
class PtProgressReviewDraftInput extends Equatable {
  final int memberId;
  final DateTime reviewPeriodStart;
  final DateTime reviewPeriodEnd;
  final String? trainerSummary;
  final String? clientFeedback;
  final String? nextPhaseGoal;
  final String? nextPhaseTrainingFocus;
  final DateTime? nextReviewDate;

  const PtProgressReviewDraftInput({
    required this.memberId,
    required this.reviewPeriodStart,
    required this.reviewPeriodEnd,
    this.trainerSummary,
    this.clientFeedback,
    this.nextPhaseGoal,
    this.nextPhaseTrainingFocus,
    this.nextReviewDate,
  });

  @override
  List<Object?> get props => [
    memberId,
    reviewPeriodStart,
    reviewPeriodEnd,
    trainerSummary,
    clientFeedback,
    nextPhaseGoal,
    nextPhaseTrainingFocus,
    nextReviewDate,
  ];
}

/// Edit payload for a draft's presentation card: celebration highlights and
/// the six-item checklist. Highlights are the stored wire keys
/// (e.g. `improved_technique`, `other`).
class PtProgressReviewCardEdit extends Equatable {
  final List<String> progressHighlights;
  final String? highlightsOtherText;
  final PtReviewChecklist reviewChecklist;

  const PtProgressReviewCardEdit({
    required this.progressHighlights,
    this.highlightsOtherText,
    required this.reviewChecklist,
  });

  @override
  List<Object?> get props => [
    progressHighlights,
    highlightsOtherText,
    reviewChecklist,
  ];
}
