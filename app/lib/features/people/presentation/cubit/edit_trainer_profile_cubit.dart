import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failure_messages.dart';
import '../../domain/entities/trainer_profile.dart';
import '../../domain/usecases/get_trainer_usecase.dart';
import '../../domain/usecases/update_trainer_usecase.dart';

sealed class EditTrainerProfileState extends Equatable {
  const EditTrainerProfileState();

  @override
  List<Object?> get props => [];
}

final class EditTrainerProfileLoading extends EditTrainerProfileState {
  const EditTrainerProfileLoading();
}

final class EditTrainerProfileLoaded extends EditTrainerProfileState {
  const EditTrainerProfileLoaded(this.profile, {this.message});

  final TrainerProfile profile;
  final String? message;

  @override
  List<Object?> get props => [profile, message];
}

final class EditTrainerProfileFailure extends EditTrainerProfileState {
  const EditTrainerProfileFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

@injectable
class EditTrainerProfileCubit extends Cubit<EditTrainerProfileState> {
  EditTrainerProfileCubit(this._getTrainer, this._updateTrainer)
    : super(const EditTrainerProfileLoading());

  final GetTrainerUseCase _getTrainer;
  final UpdateTrainerUseCase _updateTrainer;

  Future<void> load(int trainerId) async {
    emit(const EditTrainerProfileLoading());
    final result = await _getTrainer(trainerId);
    result.fold(
      (failure) => emit(EditTrainerProfileFailure(failureMessage(failure))),
      (profile) => emit(EditTrainerProfileLoaded(profile)),
    );
  }

  Future<void> save(TrainerProfile profile) async {
    final result = await _updateTrainer(profile);
    result.fold(
      (failure) => emit(EditTrainerProfileFailure(failureMessage(failure))),
      (updated) => emit(EditTrainerProfileLoaded(updated, message: 'saved')),
    );
  }
}
