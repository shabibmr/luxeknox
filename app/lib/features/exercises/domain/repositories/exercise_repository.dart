import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/pagination/cursor_page.dart';
import '../entities/exercise.dart';
import '../entities/exercise_filter.dart';

/// Abstract repository for exercise operations.
///
/// Defines the contract for accessing and managing exercises in the domain layer.
/// Implementations handle data source communication and error translation.
abstract class ExerciseRepository {
  /// Retrieves a paginated list of exercises matching the given filter.
  ///
  /// Supports cursor-based pagination for efficient data retrieval.
  ///
  /// Parameters:
  ///   - [filter]: The filtering criteria (search text, muscle group, equipment, difficulty).
  ///   - [cursor]: Optional pagination cursor. If null, retrieves the first page.
  ///
  /// Returns:
  ///   - A Future resolving to `Either<Failure, CursorPage<Exercise>>`:
  ///     - Right: A page of exercises with pagination metadata.
  ///     - Left: A Failure indicating what went wrong.
  Future<Either<Failure, CursorPage<Exercise>>> getExercises(
    ExerciseFilter filter,
    String? cursor,
  );

  /// Retrieves a single exercise by its ID.
  ///
  /// Parameters:
  ///   - [id]: The unique identifier of the exercise.
  ///
  /// Returns:
  ///   - A Future resolving to `Either<Failure, Exercise>`:
  ///     - Right: The requested exercise.
  ///     - Left: A Failure (e.g., NotFoundFailure if the exercise doesn't exist).
  Future<Either<Failure, Exercise>> getExercise(String id);

  /// Creates a new exercise.
  ///
  /// Parameters:
  ///   - [exercise]: The exercise to create (typically without an ID, as the server assigns it).
  ///
  /// Returns:
  ///   - A Future resolving to `Either<Failure, Exercise>`:
  ///     - Right: The created exercise with the server-assigned ID.
  ///     - Left: A Failure (e.g., ValidationFailure, PermissionFailure, BusinessRuleFailure).
  Future<Either<Failure, Exercise>> create(Exercise exercise);

  /// Updates an existing exercise.
  ///
  /// Parameters:
  ///   - [exercise]: The exercise with updated fields (must include the ID).
  ///
  /// Returns:
  ///   - A Future resolving to `Either<Failure, Exercise>`:
  ///     - Right: The updated exercise.
  ///     - Left: A Failure (e.g., NotFoundFailure, PermissionFailure, BusinessRuleFailure).
  Future<Either<Failure, Exercise>> update(Exercise exercise);

  /// Deactivates an exercise by its ID.
  ///
  /// Deactivation marks an exercise as inactive without deleting it.
  ///
  /// Parameters:
  ///   - [id]: The unique identifier of the exercise to deactivate.
  ///
  /// Returns:
  ///   - A Future resolving to `Either<Failure, void>`:
  ///     - Right: Unit (void), indicating successful deactivation.
  ///     - Left: A Failure (e.g., NotFoundFailure, PermissionFailure).
  Future<Either<Failure, void>> deactivate(String id);
}
