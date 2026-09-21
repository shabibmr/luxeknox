import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failure_messages.dart';
import '../../domain/entities/trainer_summary.dart';
import '../../domain/usecases/get_assigned_trainer_usecase.dart';

sealed class MyTrainerProfileState extends Equatable {
  const MyTrainerProfileState();

  @override
  List<Object?> get props => [];
}

final class MyTrainerProfileLoading extends MyTrainerProfileState {
  const MyTrainerProfileLoading();
}

final class MyTrainerProfileLoaded extends MyTrainerProfileState {
  const MyTrainerProfileLoaded({this.trainer});

  final TrainerSummary? trainer;

  @override
  List<Object?> get props => [trainer];
}

final class MyTrainerProfileFailure extends MyTrainerProfileState {
  const MyTrainerProfileFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

@injectable
class MyTrainerProfileCubit extends Cubit<MyTrainerProfileState> {
  MyTrainerProfileCubit(this._getAssignedTrainer)
      : super(const MyTrainerProfileLoading());

  final GetAssignedTrainerUseCase _getAssignedTrainer;

  Future<void> load(int memberId) async {
    emit(const MyTrainerProfileLoading());
    final result = await _getAssignedTrainer(memberId);
    result.fold(
      (failure) => emit(MyTrainerProfileFailure(failureMessage(failure))),
      (trainer) => emit(MyTrainerProfileLoaded(trainer: trainer)),
    );
  }
}
