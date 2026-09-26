import 'package:equatable/equatable.dart';

/// Sentinel object for copyWith to distinguish null from not-provided
class _Sentinel {
  const _Sentinel();
}

const _sentinel = _Sentinel();

/// Optional criteria for the food catalogue list.
class FoodFilter extends Equatable {
  final String? query;
  final bool? isVerified;
  final bool? isActive;

  const FoodFilter({this.query, this.isVerified, this.isActive});

  /// Returns true when all filter fields are null
  bool get isEmpty => query == null && isVerified == null && isActive == null;

  /// Returns a copy with optionally overridden fields.
  /// Passing null to a field explicitly sets it to null (vs. leaving it unchanged).
  FoodFilter copyWith({
    Object? query = _sentinel,
    Object? isVerified = _sentinel,
    Object? isActive = _sentinel,
  }) {
    return FoodFilter(
      query: query is _Sentinel ? this.query : query as String?,
      isVerified: isVerified is _Sentinel
          ? this.isVerified
          : isVerified as bool?,
      isActive: isActive is _Sentinel ? this.isActive : isActive as bool?,
    );
  }

  @override
  List<Object?> get props => [query, isVerified, isActive];
}
