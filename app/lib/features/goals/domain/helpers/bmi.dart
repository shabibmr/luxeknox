/// Converts a recorded weight to kilograms when the unit is known.
double? weightToKg(num value, String unitOfMeasure) {
  final unit = unitOfMeasure.trim().toLowerCase();
  if (unit == 'kg' || unit == 'kilogram' || unit == 'kilograms') {
    return value.toDouble();
  }
  if (unit == 'lb' || unit == 'lbs' || unit == 'pound' || unit == 'pounds') {
    return value.toDouble() * 0.45359237;
  }
  return null;
}

/// BMI from weight (kg) and height (cm). Null when either input is unusable.
double? computeBmi({required double? weightKg, required double? heightCm}) {
  if (weightKg == null || heightCm == null) return null;
  if (weightKg <= 0 || heightCm <= 0) return null;
  final meters = heightCm / 100.0;
  return weightKg / (meters * meters);
}
