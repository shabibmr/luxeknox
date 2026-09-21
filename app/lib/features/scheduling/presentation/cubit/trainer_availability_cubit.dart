import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failure_messages.dart';
import '../../domain/entities/schedule_catalog.dart';
import '../../domain/usecases/catalog_usecases.dart';

sealed class TrainerAvailabilityState extends Equatable {
  const TrainerAvailabilityState();

  @override
  List<Object?> get props => [];
}

final class TrainerAvailabilityLoading extends TrainerAvailabilityState {
  const TrainerAvailabilityLoading();
}

final class TrainerAvailabilityLoaded extends TrainerAvailabilityState {
  const TrainerAvailabilityLoaded(this.slots, {this.saving = false, this.message});

  final List<TrainerAvailabilitySlot> slots;
  final bool saving;
  final String? message;

  @override
  List<Object?> get props => [slots, saving, message];
}

final class TrainerAvailabilityFailure extends TrainerAvailabilityState {
  const TrainerAvailabilityFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

@injectable
class TrainerAvailabilityCubit extends Cubit<TrainerAvailabilityState> {
  TrainerAvailabilityCubit(this._get, this._put)
    : super(const TrainerAvailabilityLoading());

  final GetTrainerAvailabilityUseCase _get;
  final PutTrainerAvailabilityUseCase _put;

  String? _trainerId;

  Future<void> load(String trainerId) async {
    _trainerId = trainerId;
    emit(const TrainerAvailabilityLoading());
    final result = await _get(trainerId);
    result.fold(
      (failure) => emit(TrainerAvailabilityFailure(failureMessage(failure))),
      (slots) => emit(TrainerAvailabilityLoaded(slots)),
    );
  }

  Future<void> save(List<TrainerAvailabilitySlot> slots) async {
    final trainerId = _trainerId;
    final current = state;
    if (trainerId == null || current is! TrainerAvailabilityLoaded) return;
    if (current.saving) return;
    emit(TrainerAvailabilityLoaded(current.slots, saving: true));
    final result = await _put(
      PutTrainerAvailabilityParams(trainerId: trainerId, slots: slots),
    );
    result.fold(
      (failure) => emit(
        TrainerAvailabilityLoaded(
          current.slots,
          message: failureMessage(failure),
        ),
      ),
      (saved) => emit(TrainerAvailabilityLoaded(saved)),
    );
  }
}
