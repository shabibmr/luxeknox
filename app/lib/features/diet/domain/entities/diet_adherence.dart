enum DietAdherenceRating {
  onTarget,
  moderate,
  offTarget;

  static DietAdherenceRating fromScore(num score) {
    if (score >= 85) return DietAdherenceRating.onTarget;
    if (score >= 70) return DietAdherenceRating.moderate;
    return DietAdherenceRating.offTarget;
  }
}

/// Computes an adherence score (0–100) based on calories consumed vs daily target.
/// Uses the formula: max(0, (1 - |consumed - target| / target) * 100).
num computeDietAdherence({
  required num caloriesConsumed,
  required num targetCalories,
}) {
  if (targetCalories <= 0) return 100.0;
  final diffRatio = (caloriesConsumed - targetCalories).abs() / targetCalories;
  final score = (1.0 - diffRatio) * 100.0;
  return score.clamp(0.0, 100.0);
}
