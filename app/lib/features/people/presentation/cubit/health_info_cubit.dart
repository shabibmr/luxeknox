import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/error/failure_messages.dart';
import '../../domain/entities/health_info.dart';
import '../../domain/usecases/get_health_info_usecase.dart';
import '../../domain/usecases/update_health_info_usecase.dart';

sealed class HealthInfoState extends Equatable {
  const HealthInfoState();

  @override
  List<Object?> get props => [];
}

final class HealthInfoLoading extends HealthInfoState {
  const HealthInfoLoading();
}

final class HealthInfoLoaded extends HealthInfoState {
  const HealthInfoLoaded(this.info, {this.message});

  final HealthInfo info;
  final String? message;

  @override
  List<Object?> get props => [info, message];
}

final class HealthInfoFailure extends HealthInfoState {
  const HealthInfoFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class HealthInfoCubit extends Cubit<HealthInfoState> {
  HealthInfoCubit(this._getHealth, this._updateHealth)
    : super(const HealthInfoLoading());

  final GetHealthInfoUseCase _getHealth;
  final UpdateHealthInfoUseCase _updateHealth;

  Future<void> load(int memberId) async {
    emit(const HealthInfoLoading());
    final result = await _getHealth(memberId);
    result.fold(
      (failure) => emit(HealthInfoFailure(_message(failure))),
      (info) => emit(HealthInfoLoaded(info)),
    );
  }

  Future<void> save(HealthInfo info) async {
    final result = await _updateHealth(info);
    result.fold(
      (failure) => emit(HealthInfoFailure(_message(failure))),
      (updated) => emit(HealthInfoLoaded(updated, message: 'saved')),
    );
  }

  String _message(Failure failure) => failureMessage(failure);
}
