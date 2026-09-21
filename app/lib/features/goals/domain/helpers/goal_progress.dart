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
