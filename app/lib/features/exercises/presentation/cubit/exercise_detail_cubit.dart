import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/exercise.dart';
import '../../domain/usecases/get_exercise_usecase.dart';

enum ExerciseDetailStatus { initial, loading, success, failure }

class ExerciseDetailState extends Equatable {
  const ExerciseDetailState({
    this.status = ExerciseDetailStatus.initial,
    this.exercise,
    this.failure,
  });

  final ExerciseDetailStatus status;
  final Exercise? exercise;
  final Failure? failure;

  ExerciseDetailState copyWith({
    ExerciseDetailStatus? status,
    Exercise? exercise,
    Failure? failure,
  }) {
    return ExerciseDetailState(
      status: status ?? this.status,
      exercise: exercise ?? this.exercise,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [status, exercise, failure];
}

@injectable
class ExerciseDetailCubit extends Cubit<ExerciseDetailState> {
  ExerciseDetailCubit(this._getExerciseUseCase)
    : super(const ExerciseDetailState());

  final GetExerciseUseCase _getExerciseUseCase;

  Future<void> loadExercise(String id) async {
    emit(state.copyWith(status: ExerciseDetailStatus.loading, failure: null));

    final result = await _getExerciseUseCase(id);

    result.fold(
      (failure) => emit(
        state.copyWith(status: ExerciseDetailStatus.failure, failure: failure),
      ),
      (exercise) => emit(
        state.copyWith(
          status: ExerciseDetailStatus.success,
          exercise: exercise,
        ),
      ),
    );
  }
}
