import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../domain/entities/health_info.dart';
import '../../domain/usecases/create_health_record_usecase.dart';
import '../../domain/usecases/list_health_history_usecase.dart';

part 'health_history_cubit.freezed.dart';

@freezed
abstract class HealthHistoryState with _$HealthHistoryState {
  const factory HealthHistoryState({
    @Default(LoadStatus.initial) LoadStatus status,
    @Default(<HealthInfo>[]) List<HealthInfo> records,
    @Default(0) int currentIndex,
    String? message,
    Failure? failure,
  }) = _HealthHistoryState;
}

class HealthHistoryCubit extends Cubit<HealthHistoryState> {
  HealthHistoryCubit(this._list, this._create)
    : super(const HealthHistoryState());

  final ListHealthHistoryUseCase _list;
  final CreateHealthRecordUseCase _create;

  bool _saving = false;

  bool get canGoPrevious => state.currentIndex < state.records.length - 1;
  bool get canGoNext => state.currentIndex > 0;
  HealthInfo? get current =>
      state.records.isEmpty ? null : state.records[state.currentIndex];

  Future<void> load(int memberId, {String? message}) async {
    emit(
      state.copyWith(status: LoadStatus.loading, failure: null, message: null),
    );
    final result = await _list(memberId);
    result.fold(
      (failure) => emit(state.copyWith(status: LoadStatus.failure, failure: failure)),
      (records) {
        if (records.isEmpty) {
          emit(
            state.copyWith(
              status: LoadStatus.success,
              records: [
                HealthInfo(
                  id: 0,
                  memberId: memberId,
                  recordedAt: DateTime.now(),
                ),
              ],
              currentIndex: 0,
              failure: null,
              message: message,
            ),
          );
        } else {
          emit(
            state.copyWith(
              status: LoadStatus.success,
              records: records,
              currentIndex: 0,
              failure: null,
              message: message,
            ),
          );
        }
      },
    );
  }

  Future<void> save(HealthInfo edited) async {
    if (_saving) return;
    _saving = true;
    try {
      final result = await _create(edited);
      await result.fold(
        (failure) async => emit(
          state.copyWith(status: LoadStatus.failure, failure: failure, message: null),
        ),
        (_) async => load(edited.memberId, message: 'saved'),
      );
    } finally {
      _saving = false;
    }
  }

  void previous() {
    if (canGoPrevious) {
      emit(state.copyWith(currentIndex: state.currentIndex + 1));
    }
  }

  void next() {
    if (canGoNext) {
      emit(state.copyWith(currentIndex: state.currentIndex - 1));
    }
  }
}
