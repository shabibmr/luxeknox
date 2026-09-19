import 'package:equatable/equatable.dart';

/// Sentinel object for copyWith to distinguish null from not-provided
class _Sentinel {
  const _Sentinel();
}

const _sentinel = _Sentinel();

class ExerciseFilter extends Equatable {
  final String? searchText;
  final String? muscleGroup;
  final String? equipment;
  final String? difficulty;

  const ExerciseFilter({
    this.searchText,
    this.muscleGroup,
    this.equipment,
    this.difficulty,
  });

  /// Returns true when all filter fields are null
  bool get isEmpty =>
      searchText == null &&
      muscleGroup == null &&
      equipment == null &&
      difficulty == null;

  /// Returns a copy with optionally overridden fields.
  /// Passing null to a field explicitly sets it to null (vs. leaving it unchanged).
  ExerciseFilter copyWith({
    Object? searchText = _sentinel,
    Object? muscleGroup = _sentinel,
    Object? equipment = _sentinel,
    Object? difficulty = _sentinel,
  }) {
    return ExerciseFilter(
      searchText: searchText is _Sentinel
          ? this.searchText
          : searchText as String?,
      muscleGroup: muscleGroup is _Sentinel
          ? this.muscleGroup
          : muscleGroup as String?,
      equipment: equipment is _Sentinel ? this.equipment : equipment as String?,
      difficulty: difficulty is _Sentinel
          ? this.difficulty
          : difficulty as String?,
    );
  }

  @override
  List<Object?> get props => [searchText, muscleGroup, equipment, difficulty];
}
