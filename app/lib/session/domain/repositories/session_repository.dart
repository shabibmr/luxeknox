import 'package:fpdart/fpdart.dart';

import '../../../core/error/failures.dart';
import '../entities/capabilities.dart';
import '../entities/principal.dart';

/// Abstract repository for managing user authentication sessions.
///
/// This repository defines the contract for all session-related operations,
/// including login, logout, token refresh, and session restoration.
/// All methods return Either to handle failures without exceptions.
abstract class SessionRepository {
  /// Authenticates a user with email or phone and password.
  ///
  /// The [identifier] parameter accepts either an email address or phone number
  /// (per FR-AUTH-001 specification). On success, returns the user's [Principal]
  /// and their [Capabilities]. On failure, returns an appropriate [Failure].
  Future<Either<Failure, (Principal, Capabilities)>> login(
    String identifier,
    String password,
  );

  /// Signs out the current user and clears their session.
  ///
  /// Typically this clears stored tokens and removes authenticated state.
  /// Returns [Unit] (void equivalent in fpdart) on success.
  Future<Either<Failure, void>> logout();

  /// Refreshes the current authentication token.
  ///
  /// Typically uses a stored refresh token to obtain a new access token.
  /// Called when the current access token has expired.
  /// Returns [Unit] (void equivalent in fpdart) on success.
  Future<Either<Failure, void>> refresh();

  /// Retrieves the current authenticated user's details.
  ///
  /// Returns the [Principal] and [Capabilities] for the currently
  /// authenticated user. Typically calls a `/me` or similar endpoint.
  Future<Either<Failure, (Principal, Capabilities)>> getMe();

  /// Restores a previously authenticated session from stored credentials.
  ///
  /// Called on cold start to resume a session if tokens are stored locally.
  /// If no stored tokens exist or they are invalid, returns an [AuthFailure].
  /// Returns the [Principal] and [Capabilities] if restoration succeeds.
  Future<Either<Failure, (Principal, Capabilities)>> restore();

  /// Changes the authenticated user's password (current → new).
  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  /// Requests a password-reset token for [identifier] (email or phone).
  ///
  /// Always succeeds from the client's perspective on 2xx — the API must not
  /// reveal whether the account exists (same privacy rule as login).
  Future<Either<Failure, void>> forgotPassword(String identifier);

  /// Completes password reset with the emailed/SMS [token] and [newPassword].
  Future<Either<Failure, void>> resetPassword({
    required String token,
    required String newPassword,
  });
}
