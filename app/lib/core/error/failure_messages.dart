import 'failures.dart';

/// Converts a [Failure] into a user-facing error message.
///
/// This function implements an exhaustive switch over all [Failure] subtypes,
/// ensuring every failure is handled. [BusinessRuleFailure] returns its
/// server message verbatim (per ADR-0006 §3); all others return static strings.
///
/// Returns: A non-empty user-facing error message string.
String failureMessage(Failure failure) {
  return switch (failure) {
    ValidationFailure(:final details) =>
      'Validation error${details.isNotEmpty ? ': ${details.join(", ")}' : ''}',
    AuthFailure() => 'Authentication failed. Please log in again.',
    PermissionFailure() => 'You do not have permission to perform this action.',
    NotFoundFailure() => 'The requested resource was not found.',
    ConflictFailure() => 'This operation conflicts with existing data.',
    BusinessRuleFailure(:final message) => message,
    RateLimitFailure() => 'Too many requests. Please try again later.',
    NetworkFailure() =>
      'Network error. Please check your connection and try again.',
    UnknownFailure() => 'An unexpected error occurred. Please try again.',
  };
}
