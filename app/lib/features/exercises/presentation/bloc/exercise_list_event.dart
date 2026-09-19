import 'package:equatable/equatable.dart';

import '../../domain/entities/exercise_filter.dart';

sealed class ExerciseListEvent extends Equatable {
  const ExerciseListEvent();

  @override
  List<Object?> get props => [];
}

final class ExerciseListStarted extends ExerciseListEvent {
  const ExerciseListStarted();
}

final class ExerciseListSearchChanged extends ExerciseListEvent {
  const ExerciseListSearchChanged(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

final class ExerciseListFilterChanged extends ExerciseListEvent {
  const ExerciseListFilterChanged(this.filter);

  final ExerciseFilter filter;

  @override
  List<Object?> get props => [filter];
}

final class ExerciseListNextPageRequested extends ExerciseListEvent {
  const ExerciseListNextPageRequested();
}

final class ExerciseListRefreshed extends ExerciseListEvent {
  const ExerciseListRefreshed();
}
