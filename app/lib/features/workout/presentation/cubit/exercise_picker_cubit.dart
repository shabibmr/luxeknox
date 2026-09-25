import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../exercises/domain/entities/exercise.dart';
import '../../../exercises/domain/entities/exercise_filter.dart';
import '../../../exercises/domain/usecases/get_exercises_usecase.dart';

part 'exercise_picker_cubit.freezed.dart';

@freezed
abstract class ExercisePickerState with _$ExercisePickerState {
  const factory ExercisePickerState({
    @Default(LoadStatus.initial) LoadStatus status,
    @Default(<Exercise>[]) List<Exercise> items,
    Failure? failure,
  }) = _ExercisePickerState;
}

@injectable
class ExercisePickerCubit extends Cubit<ExercisePickerState> {
  ExercisePickerCubit(this._getExercises) : super(const ExercisePickerState());

  final GetExercisesUseCase _getExercises;

  /// Refresh keeps [ExercisePickerState.items]. Failure does too.
  Future<void> load({String? search}) async {
    emit(state.copyWith(status: LoadStatus.loading, failure: null));

    final text = search?.trim();
    final result = await _getExercises(
      GetExercisesParams(
        filter: ExerciseFilter(
          searchText: (text == null || text.isEmpty) ? null : text,
        ),
      ),
    );
    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(status: LoadStatus.failure, failure: failure),
      ),
      (page) => emit(
        state.copyWith(
          status: LoadStatus.success,
          items: page.items,
          failure: null,
        ),
      ),
    );
  }
}
