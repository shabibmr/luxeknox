import 'package:equatable/equatable.dart';

/// Base sealed class for all failures in the application.
/// Each subtype represents a specific kind of failure that can occur
/// when executing domain operations.
sealed class Failure extends Equatable {
  const Failure();

  @override
  List<Object?> get props => [];
}

/// Failure indicating one or more validation errors occurred.
/// Used when input validation fails at the domain or data layer.
final class ValidationFailure extends Failure {
  /// List of validation error details (e.g., field names or error messages).
  final List<String> details;

  const ValidationFailure(this.details);

  @override
  List<Object?> get props => [details];
}

/// Failure indicating authentication is required or has failed.
/// Used when a user is not authenticated or credentials are invalid.
final class AuthFailure extends Failure {
  const AuthFailure();
}

/// Failure indicating the user lacks permission for the requested operation.
/// Used when a user is authenticated but lacks the necessary capability.
final class PermissionFailure extends Failure {
  const PermissionFailure();
}

/// Failure indicating the requested resource was not found.
/// Used when a GET or other operation targets a non-existent resource.
final class NotFoundFailure extends Failure {
  const NotFoundFailure();
}

/// Failure indicating a conflict prevented the operation.
/// Used when a resource creation or update conflicts with existing data.
final class ConflictFailure extends Failure {
  const ConflictFailure();
}

/// Failure indicating a business rule violation.
/// Used when a domain constraint or business logic check fails.
/// The server message is passed through verbatim per ADR-0006 §3.
final class BusinessRuleFailure extends Failure {
  /// The server-provided or generated business rule violation message.
  final String message;

  const BusinessRuleFailure(this.message);

  @override
  List<Object?> get props => [message];
}

/// Failure indicating the client is rate-limited.
/// Used when the server responds with a 429 (Too Many Requests) status.
final class RateLimitFailure extends Failure {
  const RateLimitFailure();
}

/// Failure indicating a network or connectivity error.
/// Used for socket errors, timeouts, connection refused, etc.
final class NetworkFailure extends Failure {
  const NetworkFailure();
}

/// Failure indicating an unknown or unexpected error occurred.
/// Used as a catch-all for errors that do not fit other categories.
final class UnknownFailure extends Failure {
  const UnknownFailure();
}
