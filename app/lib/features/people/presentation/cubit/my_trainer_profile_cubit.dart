import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../domain/entities/trainer_summary.dart';
import '../../domain/usecases/get_assigned_trainer_usecase.dart';

part 'my_trainer_profile_cubit.freezed.dart';

@freezed
abstract class MyTrainerProfileState with _$MyTrainerProfileState {
  const factory MyTrainerProfileState({
    @Default(LoadStatus.initial) LoadStatus status,
    TrainerSummary? trainer,
    Failure? failure,
  }) = _MyTrainerProfileState;
}

@injectable
class MyTrainerProfileCubit extends Cubit<MyTrainerProfileState> {
  MyTrainerProfileCubit(this._getAssignedTrainer)
    : super(const MyTrainerProfileState());

  final GetAssignedTrainerUseCase _getAssignedTrainer;

  Future<void> load(int memberId) async {
    emit(state.copyWith(status: LoadStatus.loading, failure: null));
    final result = await _getAssignedTrainer(memberId);
    result.fold(
      (failure) =>
          emit(state.copyWith(status: LoadStatus.failure, failure: failure)),
      (trainer) => emit(
        state.copyWith(
          status: LoadStatus.success,
          trainer: trainer,
          failure: null,
        ),
      ),
    );
  }
}
