/// Returns metric ids required by [mandatoryIds] that are missing from
/// [submittedMetricIds] (FR-GOAL-008 client-side guard).
List<String> missingMandatoryMetrics({
  required Iterable<String> mandatoryIds,
  required Iterable<String> submittedMetricIds,
}) {
  final submitted = submittedMetricIds.toSet();
  return mandatoryIds.where((id) => !submitted.contains(id)).toList();
}
