import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../domain/entities/health_info.dart';
import '../../domain/usecases/get_health_info_usecase.dart';
import '../../domain/usecases/update_health_info_usecase.dart';

part 'health_info_cubit.freezed.dart';

@freezed
abstract class HealthInfoState with _$HealthInfoState {
  const factory HealthInfoState({
    @Default(LoadStatus.initial) LoadStatus status,
    HealthInfo? info,
    String? message,
    Failure? failure,
  }) = _HealthInfoState;
}

class HealthInfoCubit extends Cubit<HealthInfoState> {
  HealthInfoCubit(this._getHealth, this._updateHealth)
    : super(const HealthInfoState());

  final GetHealthInfoUseCase _getHealth;
  final UpdateHealthInfoUseCase _updateHealth;

  Future<void> load(int memberId) async {
    emit(
      state.copyWith(status: LoadStatus.loading, failure: null, message: null),
    );
    final result = await _getHealth(memberId);
    result.fold(
      (failure) =>
          emit(state.copyWith(status: LoadStatus.failure, failure: failure)),
      (info) => emit(
        state.copyWith(
          status: LoadStatus.success,
          info: info,
          failure: null,
          message: null,
        ),
      ),
    );
  }

  Future<void> save(HealthInfo info) async {
    final result = await _updateHealth(info);
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
          info: updated,
          message: 'saved',
          failure: null,
        ),
      ),
    );
  }
}
