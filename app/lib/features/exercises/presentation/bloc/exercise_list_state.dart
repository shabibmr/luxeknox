import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../domain/entities/exercise.dart';
import '../../domain/entities/exercise_filter.dart';

part 'exercise_list_state.freezed.dart';

@freezed
abstract class ExerciseListState with _$ExerciseListState {
  const factory ExerciseListState({
    @Default(LoadStatus.initial) LoadStatus status,
    @Default(<Exercise>[]) List<Exercise> items,
    @Default(ExerciseFilter()) ExerciseFilter filter,
    String? cursor,
    @Default(false) bool hasMore,
    Failure? failure,
  }) = _ExerciseListState;
}
