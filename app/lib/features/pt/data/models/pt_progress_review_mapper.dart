import 'package:api_client/api_client.dart' as api;

import '../../../membership/data/models/membership_date.dart';
import '../../domain/entities/pt_progress_review.dart';

PtProgressReviewStatus _statusFromApi(api.PtProgressReviewStatusEnum status) {
  return switch (status) {
    api.PtProgressReviewStatusEnum.draft => PtProgressReviewStatus.draft,
    api.PtProgressReviewStatusEnum.pendingClientSign =>
      PtProgressReviewStatus.pendingClientSign,
    api.PtProgressReviewStatusEnum.pendingManagerApproval =>
      PtProgressReviewStatus.pendingManagerApproval,
    api.PtProgressReviewStatusEnum.approved => PtProgressReviewStatus.approved,
    api.PtProgressReviewStatusEnum.archived => PtProgressReviewStatus.archived,
    _ => PtProgressReviewStatus.draft,
  };
}

BodyMetricSnapshot _bodyMetricFromApi(api.BodyMetricSnapshot m) {
  return BodyMetricSnapshot(
    metric: m.metric,
    startVal: m.startVal?.toDouble(),
    currentVal: m.currentVal?.toDouble(),
    changeVal: m.changeVal?.toDouble(),
    targetVal: m.targetVal?.toDouble(),
  );
}

PerformanceMarkerSnapshot _performanceMarkerFromApi(
  api.PerformanceMarkerSnapshot m,
) {
  return PerformanceMarkerSnapshot(
    marker: m.marker,
    startVal: m.startVal,
    currentVal: m.currentVal,
    changeVal: m.changeVal,
    targetVal: m.targetVal,
  );
}

PtReviewChecklist _checklistFromApi(api.PtReviewChecklist c) {
  return PtReviewChecklist(
    goalsReviewed: c.goalsReviewed ?? false,
    measurementsReviewed: c.measurementsReviewed ?? false,
    performanceReviewed: c.performanceReviewed ?? false,
    attendanceReviewed: c.attendanceReviewed ?? false,
    programUpdated: c.programUpdated ?? false,
    nextGoalsAgreed: c.nextGoalsAgreed ?? false,
  );
}

PtProgressReview ptProgressReviewFromApi(api.PtProgressReview r) {
  return PtProgressReview(
    id: r.id,
    memberId: r.memberId,
    trainerId: r.trainerId,
    reviewPeriodStart: apiDateToDateTime(r.reviewPeriodStart),
    reviewPeriodEnd: apiDateToDateTime(r.reviewPeriodEnd),
    bodyMetricsSnapshot: [
      for (final m in r.bodyMetricsSnapshot ?? const <api.BodyMetricSnapshot>[])
        _bodyMetricFromApi(m),
    ],
    performanceMarkersSnapshot: [
      for (final m
          in r.performanceMarkersSnapshot ??
              const <api.PerformanceMarkerSnapshot>[])
        _performanceMarkerFromApi(m),
    ],
    progressHighlights: [
      for (final h in r.progressHighlights ?? const <String>[]) h,
    ],
    highlightsOtherText: r.highlightsOtherText,
    trainerSummary: r.trainerSummary,
    clientFeedback: r.clientFeedback,
    nextPhaseGoal: r.nextPhaseGoal,
    nextPhaseTrainingFocus: r.nextPhaseTrainingFocus,
    nextReviewDate: r.nextReviewDate == null
        ? null
        : apiDateToDateTime(r.nextReviewDate!),
    reviewChecklist: r.reviewChecklist == null
        ? null
        : _checklistFromApi(r.reviewChecklist!),
    finalReviewNotes: r.finalReviewNotes,
    clientSignedAt: r.clientSignedAt,
    trainerSignedAt: r.trainerSignedAt,
    managerUserId: r.managerUserId,
    managerSignedAt: r.managerSignedAt,
    status: _statusFromApi(r.status),
    createdAt: r.createdAt,
    updatedAt: r.updatedAt,
  );
}

api.PtProgressReviewDraft ptProgressReviewDraftToApi(
  PtProgressReviewDraftInput input,
) {
  return api.PtProgressReviewDraft(
    (b) => b
      ..reviewPeriodStart = dateTimeToApiDate(input.reviewPeriodStart)
      ..reviewPeriodEnd = dateTimeToApiDate(input.reviewPeriodEnd)
      ..trainerSummary = input.trainerSummary
      ..clientFeedback = input.clientFeedback
      ..nextPhaseGoal = input.nextPhaseGoal
      ..nextPhaseTrainingFocus = input.nextPhaseTrainingFocus
      ..nextReviewDate = input.nextReviewDate == null
          ? null
          : dateTimeToApiDate(input.nextReviewDate!),
  );
}
