import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/bloc/event_transformers.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/idempotency/idempotency_key.dart';
import '../../../../core/presentation/load_status.dart';
import '../../domain/entities/attendance_enums.dart';
import '../../domain/entities/attendance_record.dart';
import '../../domain/entities/check_in_input.dart';
import '../../domain/usecases/attendance_usecases.dart';

part 'check_in_bloc.freezed.dart';

@freezed
abstract class CheckInState with _$CheckInState {
  const factory CheckInState({
    @Default(LoadStatus.initial) LoadStatus status,
    AttendanceRecord? record,
    String? message,
  }) = _CheckInState;
}

sealed class CheckInEvent extends Equatable {
  const CheckInEvent();

  @override
  List<Object?> get props => [];
}

final class CheckInSubmitted extends CheckInEvent {
  const CheckInSubmitted({
    this.userId,
    this.method,
    this.gateIdentifier,
    this.payload,
  });

  final String? userId;
  final AttendanceCheckInMethod? method;
  final String? gateIdentifier;
  final String? payload;

  @override
  List<Object?> get props => [userId, method, gateIdentifier, payload];
}

final class CheckInReset extends CheckInEvent {
  const CheckInReset();
}

/// Droppable check-in submit (ADR-0006 §4). A second tap while the request
/// is in flight is dropped, so one idempotency key covers that request.
@injectable
class CheckInBloc extends Bloc<CheckInEvent, CheckInState> {
  CheckInBloc(this._checkIn) : super(const CheckInState()) {
    on<CheckInSubmitted>(_onSubmitted, transformer: droppable());
    on<CheckInReset>(_onReset);
  }

  final CheckInUseCase _checkIn;
  String? _activeIdempotencyKey;

  Future<void> _onSubmitted(
    CheckInSubmitted event,
    Emitter<CheckInState> emit,
  ) async {
    _activeIdempotencyKey ??= newIdempotencyKey();
    emit(state.copyWith(status: LoadStatus.loading, message: null));
    final result = await _checkIn(
      CheckInInput(
        idempotencyKey: _activeIdempotencyKey!,
        userId: event.userId,
        method: event.method,
        gateIdentifier: event.gateIdentifier,
        payload: event.payload,
      ),
    );
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: LoadStatus.failure,
            message: failureMessage(failure),
          ),
        );
      },
      (record) {
        _activeIdempotencyKey = null;
        emit(
          state.copyWith(
            status: LoadStatus.success,
            record: record,
            message: null,
          ),
        );
      },
    );
  }

  void reset() => add(const CheckInReset());

  void _onReset(CheckInReset event, Emitter<CheckInState> emit) {
    _activeIdempotencyKey = null;
    emit(const CheckInState());
  }
}
