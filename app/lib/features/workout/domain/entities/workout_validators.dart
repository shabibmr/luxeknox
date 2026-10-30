import '../../../../core/error/failures.dart';

/// Shared domain validators for workout entities and repository inputs.
class WorkoutValidators {
  const WorkoutValidators._();

  /// Validates that [value], if non-null, is within [min] and [max] inclusive.
  static String? validateRange<T extends num>(
    T? value, {
    required num min,
    required num max,
    required String label,
    String unit = '',
  }) {
    if (value != null && (value < min || value > max)) {
      final unitStr = unit.isNotEmpty ? ' $unit' : '';
      return '$label must be $min–$max$unitStr';
    }
    return null;
  }

  static String? validateSessionsPerWeek(int? value) {
    return validateRange(value, min: 1, max: 14, label: 'Sessions per week');
  }

  static String? validateSessionDurationMinutes(int? value) {
    return validateRange(
      value,
      min: 15,
      max: 180,
      label: 'Session duration',
      unit: 'minutes',
    );
  }

  static String? validateRir(num? value) {
    if (value == null) return null;
    final rangeError = validateRange(value, min: 0, max: 10, label: 'RIR');
    if (rangeError != null) return rangeError;
    if (((value * 10).round() - (value * 10)).abs() > 1e-6) {
      return 'RIR must have at most one decimal place';
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
    return validateRange(value, min: 1, max: 5, label: 'Rating');
  }

  static String? validateEffortRating(int? value) {
    return validateRange(value, min: 1, max: 10, label: 'Effort rating');
  }

  static String? validateSatisfactionRating(int? value) {
    return validateRange(value, min: 1, max: 10, label: 'Satisfaction rating');
  }

  static String? validatePainDiscomfortScore(int? value) {
    return validateRange(
      value,
      min: 0,
      max: 10,
      label: 'Pain / discomfort score',
    );
  }

  /// Evaluates an ordered list of validation error strings and returns the
  /// first non-null as a [ValidationFailure], collapsing validate-then-wrap ladders.
  static ValidationFailure? firstFailure(List<String?> errors) {
    for (final err in errors) {
      if (err != null) return ValidationFailure([err]);
    }
    return null;
  }

  /// Parses an RIR input (numeric or String) into a [num].
  /// Throws [FormatException] if the input cannot be parsed or is non-finite.
  static num? parseRir(dynamic value) {
    if (value == null) return null;
    if (value is num) {
      if (value.isNaN || value.isInfinite) {
        throw const FormatException('Malformed RIR: not a finite number');
      }
      return value;
    }
    if (value is String) {
      final trimmed = value.trim();
      if (trimmed.isEmpty) return null;
      final parsed = num.tryParse(trimmed);
      if (parsed == null) {
        throw FormatException('Malformed RIR: "$value"');
      }
      return parsed;
    }
    throw FormatException(
      'Malformed RIR: unsupported type ${value.runtimeType}',
    );
  }
}
