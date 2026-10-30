/// Shared domain validators for workout entities and repository inputs.
class WorkoutValidators {
  const WorkoutValidators._();

  static String? validateSessionsPerWeek(int? value) {
    if (value != null && (value < 1 || value > 14)) {
      return 'Sessions per week must be 1–14';
    }
    return null;
  }

  static String? validateSessionDurationMinutes(int? value) {
    if (value != null && (value < 15 || value > 180)) {
      return 'Session duration must be 15–180 minutes';
    }
    return null;
  }

  static String? validateRir(num? value) {
    if (value != null && (value < 0 || value > 10)) {
      return 'RIR must be 0–10';
    }
    return null;
  }

  static String? validateDurationSeconds(int? value) {
    if (value != null && value < 0) {
      return 'Duration seconds must be non-negative';
    }
    return null;
  }

  static String? validateClientFeedbackRating(int? value) {
    if (value != null && (value < 1 || value > 5)) {
      return 'Rating must be 1–5';
    }
    return null;
  }

  static String? validateEffortRating(int? value) {
    if (value != null && (value < 1 || value > 10)) {
      return 'Effort rating must be 1–10';
    }
    return null;
  }

  static String? validateSatisfactionRating(int? value) {
    if (value != null && (value < 1 || value > 10)) {
      return 'Satisfaction rating must be 1–10';
    }
    return null;
  }

  static String? validatePainDiscomfortScore(int? value) {
    if (value != null && (value < 0 || value > 10)) {
      return 'Pain / discomfort score must be 0–10';
    }
    return null;
  }
}
