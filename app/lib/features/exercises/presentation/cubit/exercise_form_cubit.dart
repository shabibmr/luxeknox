import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../domain/entities/exercise.dart';
import '../../domain/usecases/create_exercise_usecase.dart';
import '../../domain/usecases/deactivate_exercise_usecase.dart';
import '../../domain/usecases/update_exercise_usecase.dart';

part 'exercise_form_cubit.freezed.dart';

@freezed
abstract class ExerciseFormState with _$ExerciseFormState {
  const factory ExerciseFormState({
    @Default(LoadStatus.initial) LoadStatus status,
    Failure? failure,
  }) = _ExerciseFormState;
}

@injectable
class ExerciseFormCubit extends Cubit<ExerciseFormState> {
  ExerciseFormCubit(
    this._createExercise,
    this._updateExercise,
    this._deactivateExercise,
  ) : super(const ExerciseFormState());

  final CreateExerciseUseCase _createExercise;
  final UpdateExerciseUseCase _updateExercise;
  final DeactivateExerciseUseCase _deactivateExercise;

  Future<void> create(Exercise exercise) {
    return _run(() => _createExercise(exercise));
  }

  Future<void> update(Exercise exercise) {
    return _run(() => _updateExercise(exercise));
  }

  Future<void> deactivate(String id) {
    return _run(() => _deactivateExercise(id));
  }

  Future<void> _run<T>(Future<Either<Failure, T>> Function() action) async {
    emit(const ExerciseFormState(status: LoadStatus.loading));
    final result = await action();
    if (isClosed) return;
    result.fold(
      (failure) => emit(
        ExerciseFormState(status: LoadStatus.failure, failure: failure),
      ),
      (_) => emit(const ExerciseFormState(status: LoadStatus.success)),
    );
  }
}
