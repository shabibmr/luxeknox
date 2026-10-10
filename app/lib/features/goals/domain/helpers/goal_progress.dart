import '../entities/goal_status.dart';

/// Display-only progress fraction from baseline → current → target.
/// Direction follows whether target is above or below baseline.
/// Does NOT decide achievement — that is server-derived ([isGoalAchievedStatus]).
double goalProgressFraction({
  required num? baseline,
  required num? current,
  required num? target,
}) {
  if (baseline == null || current == null || target == null) return 0;
  final b = baseline.toDouble();
  final c = current.toDouble();
  final t = target.toDouble();
  final span = t - b;
  if (span == 0) {
    return c == t ? 1 : 0;
  }
  final raw = (c - b) / span;
  if (raw.isNaN || raw.isInfinite) return 0;
  return raw.clamp(0.0, 1.0);
}

/// True only when the server status is `achieved` (FR-GOAL-004).
bool isGoalAchievedStatus(GoalStatus status) => status == GoalStatus.achieved;

/// Display direction from baseline to target. Does not decide achievement.
enum GoalDirection { increase, decrease, hold }

/// Null when either endpoint is missing. Equal values are [GoalDirection.hold].
GoalDirection? goalDirection({required num? baseline, required num? target}) {
  if (baseline == null || target == null) return null;
  if (target > baseline) return GoalDirection.increase;
  if (target < baseline) return GoalDirection.decrease;
  return GoalDirection.hold;
}

/// Linear expected value from [baseline]→[target] across [startDate]→[targetDate].
/// Null when any endpoint is missing or the date span is empty/inverted.
num? projectedGoalValue({
  required num? baseline,
  required num? target,
  required DateTime? startDate,
  required DateTime? targetDate,
  DateTime? asOf,
}) {
  if (baseline == null ||
      target == null ||
      startDate == null ||
      targetDate == null) {
    return null;
  }
  final start = DateTime(startDate.year, startDate.month, startDate.day);
  final end = DateTime(targetDate.year, targetDate.month, targetDate.day);
  final spanMs = end.difference(start).inMilliseconds;
  if (spanMs <= 0) return null;

  final now = asOf ?? DateTime.now();
  final day = DateTime(now.year, now.month, now.day);
  if (day.isBefore(start)) return baseline;
  if (!day.isBefore(end)) return target;

  final elapsed = day.difference(start).inMilliseconds / spanMs;
  return baseline + (target - baseline) * elapsed;
}
