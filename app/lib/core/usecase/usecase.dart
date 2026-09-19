import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../error/failures.dart';

/// Abstract base class for all use cases in the application.
/// Use cases encapsulate domain logic and return an [Either] of [Failure] or result.
///
/// Type parameters:
/// - [Out]: The type of the successful result.
/// - [In]: The type of the input parameters (use [NoParams] for use cases with no input).
abstract class UseCase<Out, In> {
  /// Execute the use case with the given parameters.
  /// Returns an [Either] containing either a [Failure] or the successful result.
  Future<Either<Failure, Out>> call(In params);
}

/// Marker class for use cases that take no parameters.
/// Extends [Equatable] to provide value equality.
///
/// Example usage:
/// ```dart
/// class GetCurrentUserUseCase implements UseCase<User, NoParams> {
///   Future<Either<Failure, User>> call(NoParams params) async {
///     // Implementation
///   }
/// }
///
/// // Call the use case:
/// final result = await useCase(NoParams());
/// ```
final class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => [];
}
