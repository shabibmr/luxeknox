import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/pagination/cursor_page.dart';
import '../entities/food.dart';
import '../entities/food_filter.dart';

/// Abstract repository for food operations.
///
/// Defines the contract for accessing and managing foods in the domain layer.
/// Implementations handle data source communication and error translation.
abstract class FoodRepository {
  /// Retrieves a paginated list of foods matching the given filter.
  ///
  /// Supports cursor-based pagination for efficient data retrieval.
  ///
  /// Parameters:
  ///   - [filter]: The filtering criteria (search query).
  ///   - [cursor]: Optional pagination cursor. If null, retrieves the first page.
  ///
  /// Returns:
  ///   - A Future resolving to `Either<Failure, CursorPage<Food>>`:
  ///     - Right: A page of foods with pagination metadata.
  ///     - Left: A Failure indicating what went wrong.
  Future<Either<Failure, CursorPage<Food>>> getFoods(
    FoodFilter filter,
    String? cursor,
  );

  /// Retrieves a single food by its ID.
  ///
  /// Parameters:
  ///   - [id]: The unique identifier of the food.
  ///
  /// Returns:
  ///   - A Future resolving to `Either<Failure, Food>`:
  ///     - Right: The requested food.
  ///     - Left: A Failure (e.g., NotFoundFailure if the food doesn't exist).
  Future<Either<Failure, Food>> getFood(String id);

  /// Creates a new food.
  ///
  /// Parameters:
  ///   - [food]: The food to create (typically without an ID, as the server assigns it).
  ///
  /// Returns:
  ///   - A Future resolving to `Either<Failure, Food>`:
  ///     - Right: The created food with the server-assigned ID.
  ///     - Left: A Failure (e.g., ValidationFailure, PermissionFailure, BusinessRuleFailure).
  Future<Either<Failure, Food>> create(Food food);

  /// Updates an existing food.
  ///
  /// Parameters:
  ///   - [food]: The food with updated fields (must include the ID).
  ///
  /// Returns:
  ///   - A Future resolving to `Either<Failure, Food>`:
  ///     - Right: The updated food.
  ///     - Left: A Failure (e.g., NotFoundFailure, PermissionFailure, BusinessRuleFailure).
  Future<Either<Failure, Food>> update(Food food);

  /// Deactivates a food by its ID.
  ///
  /// The contract has no dedicated `is_active`/deactivate concept for foods
  /// (see `FoodFilter` doc comment); this marks the food unverified
  /// (`is_verified: false`) via `PATCH /foods/{id}` as the closest available
  /// analogue, mirroring `ExerciseRepository.deactivate`.
  ///
  /// Parameters:
  ///   - [id]: The unique identifier of the food to deactivate.
  ///
  /// Returns:
  ///   - A Future resolving to `Either<Failure, void>`:
  ///     - Right: Unit (void), indicating successful deactivation.
  ///     - Left: A Failure (e.g., NotFoundFailure, PermissionFailure).
  Future<Either<Failure, void>> deactivate(String id);
}
