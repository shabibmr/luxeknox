import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../domain/entities/trainer_profile.dart';
import '../../domain/usecases/get_trainer_usecase.dart';
import '../../domain/usecases/update_trainer_usecase.dart';

part 'edit_trainer_profile_cubit.freezed.dart';

@freezed
abstract class EditTrainerProfileState with _$EditTrainerProfileState {
  const factory EditTrainerProfileState({
    @Default(LoadStatus.initial) LoadStatus status,
    TrainerProfile? profile,
    String? message,
    Failure? failure,
  }) = _EditTrainerProfileState;
}

@injectable
class EditTrainerProfileCubit extends Cubit<EditTrainerProfileState> {
  EditTrainerProfileCubit(this._getTrainer, this._updateTrainer)
    : super(const EditTrainerProfileState());

  final GetTrainerUseCase _getTrainer;
  final UpdateTrainerUseCase _updateTrainer;

  Future<void> load(int trainerId) async {
    emit(
      state.copyWith(status: LoadStatus.loading, failure: null, message: null),
    );
    final result = await _getTrainer(trainerId);
    result.fold(
      (failure) =>
          emit(state.copyWith(status: LoadStatus.failure, failure: failure)),
      (profile) => emit(
        state.copyWith(
          status: LoadStatus.success,
          profile: profile,
          failure: null,
          message: null,
        ),
      ),
    );
  }

  Future<void> save(TrainerProfile profile) async {
    final result = await _updateTrainer(profile);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: LoadStatus.failure,
          failure: failure,
          message: null,
        ),
      ),
      (updated) => emit(
        state.copyWith(
          status: LoadStatus.success,
          profile: updated,
          message: 'saved',
          failure: null,
        ),
      ),
    );
  }
}
