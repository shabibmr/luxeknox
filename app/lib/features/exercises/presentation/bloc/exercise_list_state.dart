import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/exercise.dart';
import '../../domain/entities/exercise_filter.dart';

enum ExerciseListStatus { initial, loading, success, failure }

class ExerciseListState extends Equatable {
  const ExerciseListState({
    this.status = ExerciseListStatus.initial,
    this.items = const <Exercise>[],
    this.filter = const ExerciseFilter(),
    this.cursor,
    this.hasMore = false,
    this.failure,
  });

  final ExerciseListStatus status;
  final List<Exercise> items;
  final ExerciseFilter filter;
  final String? cursor;
  final bool hasMore;
  final Failure? failure;

  ExerciseListState copyWith({
    ExerciseListStatus? status,
    List<Exercise>? items,
    ExerciseFilter? filter,
    String? cursor,
    bool clearCursor = false,
    bool? hasMore,
    Failure? failure,
  }) {
    return ExerciseListState(
      status: status ?? this.status,
      items: items ?? this.items,
      filter: filter ?? this.filter,
      cursor: clearCursor ? null : (cursor ?? this.cursor),
      hasMore: hasMore ?? this.hasMore,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [status, items, filter, cursor, hasMore, failure];
}
