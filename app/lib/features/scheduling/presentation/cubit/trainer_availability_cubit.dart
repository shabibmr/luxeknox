import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../domain/entities/schedule_catalog.dart';
import '../../domain/usecases/catalog_usecases.dart';

part 'trainer_availability_cubit.freezed.dart';

@freezed
abstract class TrainerAvailabilityState with _$TrainerAvailabilityState {
  const factory TrainerAvailabilityState({
    @Default(LoadStatus.initial) LoadStatus status,
    @Default(<TrainerAvailabilitySlot>[]) List<TrainerAvailabilitySlot> slots,
    /// True after a successful fetch, so an empty week is still data.
    @Default(false) bool hasLoaded,
    @Default(false) bool saving,
    Failure? failure,
  }) = _TrainerAvailabilityState;
}

@injectable
class TrainerAvailabilityCubit extends Cubit<TrainerAvailabilityState> {
  TrainerAvailabilityCubit(this._get, this._put)
    : super(const TrainerAvailabilityState());

  final GetTrainerAvailabilityUseCase _get;
  final PutTrainerAvailabilityUseCase _put;

  String? _trainerId;

  Future<void> load(String trainerId) async {
    _trainerId = trainerId;
    emit(
      state.copyWith(
        status: LoadStatus.loading,
        failure: null,
        saving: false,
      ),
    );
    final result = await _get(trainerId);
    result.fold(
      (failure) => emit(
        state.copyWith(status: LoadStatus.failure, failure: failure),
      ),
      (slots) => emit(
        state.copyWith(
          status: LoadStatus.success,
          failure: null,
          slots: slots,
          hasLoaded: true,
          saving: false,
        ),
      ),
    );
  }

  Future<void> save(List<TrainerAvailabilitySlot> slots) async {
    final trainerId = _trainerId;
    if (trainerId == null || !state.hasLoaded || state.saving) return;
    final current = state.slots;
    emit(
      state.copyWith(
        saving: true,
        failure: null,
        status: LoadStatus.success,
      ),
    );
    final result = await _put(
      PutTrainerAvailabilityParams(trainerId: trainerId, slots: slots),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: LoadStatus.failure,
          failure: failure,
          saving: false,
          slots: current,
        ),
      ),
      (saved) => emit(
        state.copyWith(
          status: LoadStatus.success,
          failure: null,
          saving: false,
          slots: saved,
          hasLoaded: true,
        ),
      ),
    );
  }
}
