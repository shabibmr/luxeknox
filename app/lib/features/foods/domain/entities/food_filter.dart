import 'package:equatable/equatable.dart';

/// Sentinel object for copyWith to distinguish null from not-provided
class _Sentinel {
  const _Sentinel();
}

const _sentinel = _Sentinel();

/// Mirrors `ExerciseFilter`.
///
/// KNOWN CONTRACT MISMATCH: the task register calls for a `query` + `isActive`
/// filter, but the OpenAPI `Food`/`FoodWrite` schemas have no `is_active`
/// field — only `is_verified` — and `GET /foods` accepts no filter query
/// param beyond `q`. `isVerified` below is therefore client-side only for now
/// (not sent to the API by `FoodRemoteDataSource`) until the contract adds
/// server-side support.
class FoodFilter extends Equatable {
  final String? query;
  final bool? isVerified;

  const FoodFilter({this.query, this.isVerified});

  /// Returns true when all filter fields are null
  bool get isEmpty => query == null && isVerified == null;

  /// Returns a copy with optionally overridden fields.
  /// Passing null to a field explicitly sets it to null (vs. leaving it unchanged).
  FoodFilter copyWith({
    Object? query = _sentinel,
    Object? isVerified = _sentinel,
  }) {
    return FoodFilter(
      query: query is _Sentinel ? this.query : query as String?,
      isVerified: isVerified is _Sentinel
          ? this.isVerified
          : isVerified as bool?,
    );
  }

  @override
  List<Object?> get props => [query, isVerified];
}
