import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failure_messages.dart';
import '../../../../core/idempotency/idempotency_key.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/attendance_enums.dart';
import '../../domain/entities/attendance_pass.dart';
import '../../domain/entities/attendance_record.dart';
import '../../domain/entities/check_in_input.dart';
import '../../domain/usecases/attendance_usecases.dart';
import '../attendance_strings.dart';

sealed class AttendancePassState extends Equatable {
  const AttendancePassState();

  @override
  List<Object?> get props => [];
}

final class AttendancePassLoading extends AttendancePassState {
  const AttendancePassLoading();
}

final class AttendancePassLoaded extends AttendancePassState {
  const AttendancePassLoaded({
    required this.pass,
    this.openAttendance,
    this.actionInFlight = false,
    this.message,
  });

  final AttendancePass pass;
  final AttendanceRecord? openAttendance;
  final bool actionInFlight;
  final String? message;

  AttendancePassLoaded copyWith({
    AttendancePass? pass,
    AttendanceRecord? openAttendance,
    bool? actionInFlight,
    String? message,
    bool clearMessage = false,
    bool clearOpen = false,
  }) {
    return AttendancePassLoaded(
      pass: pass ?? this.pass,
      openAttendance: clearOpen
          ? null
          : (openAttendance ?? this.openAttendance),
      actionInFlight: actionInFlight ?? this.actionInFlight,
      message: clearMessage ? null : (message ?? this.message),
    );
  }

  @override
  List<Object?> get props => [pass, openAttendance, actionInFlight, message];
}

final class AttendancePassFailure extends AttendancePassState {
  const AttendancePassFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

@injectable
class AttendancePassCubit extends Cubit<AttendancePassState> {
  AttendancePassCubit(
    this._getPass,
    this._listAttendances,
    this._checkOut,
  ) : super(const AttendancePassLoading());

  final GetAttendancePassUseCase _getPass;
  final ListAttendancesUseCase _listAttendances;
  final CheckOutUseCase _checkOut;

  Future<void> load() async {
    emit(const AttendancePassLoading());
    final passResult = await _getPass(const NoParams());
    await passResult.fold(
      (failure) async => emit(AttendancePassFailure(failureMessage(failure))),
      (pass) async {
        AttendanceRecord? open;
        final log = await _listAttendances(
          ListAttendancesParams(userId: pass.userId, limit: 5),
        );
        log.fold((_) {}, (page) {
          for (final record in page.items) {
            if (record.isOpen) {
              open = record;
              break;
            }
          }
        });
        emit(AttendancePassLoaded(pass: pass, openAttendance: open));
      },
    );
  }

  Future<void> refreshPass() => load();

  Future<void> checkOut() async {
    final current = state;
    if (current is! AttendancePassLoaded) return;
    final open = current.openAttendance;
    if (open == null) return;
    if (current.actionInFlight) {
      emit(current.copyWith(message: AttendanceStrings.doubleSubmitBlocked));
      return;
    }
    emit(current.copyWith(actionInFlight: true, clearMessage: true));
    final result = await _checkOut(CheckOutParams(open.id));
    result.fold(
      (failure) => emit(
        current.copyWith(
          actionInFlight: false,
          message: failureMessage(failure),
        ),
      ),
      (record) => emit(
        current.copyWith(
          actionInFlight: false,
          clearOpen: record.checkOutTime != null,
          openAttendance: record.checkOutTime == null ? record : null,
          message: AttendanceStrings.checkOutSuccess,
        ),
      ),
    );
  }
}

sealed class CheckInCubitState extends Equatable {
  const CheckInCubitState();

  @override
  List<Object?> get props => [];
}

final class CheckInIdle extends CheckInCubitState {
  const CheckInIdle({this.message, this.actionInFlight = false});

  final String? message;
  final bool actionInFlight;

  CheckInIdle copyWith({
    String? message,
    bool? actionInFlight,
    bool clearMessage = false,
  }) {
    return CheckInIdle(
      message: clearMessage ? null : (message ?? this.message),
      actionInFlight: actionInFlight ?? this.actionInFlight,
    );
  }

  @override
  List<Object?> get props => [message, actionInFlight];
}

final class CheckInSuccess extends CheckInCubitState {
  const CheckInSuccess(this.record);

  final AttendanceRecord record;

  @override
  List<Object?> get props => [record];
}

@injectable
class CheckInCubit extends Cubit<CheckInCubitState> {
  CheckInCubit(this._checkIn) : super(const CheckInIdle());

  final CheckInUseCase _checkIn;
  String? _activeIdempotencyKey;

  Future<void> submit({
    String? userId,
    AttendanceCheckInMethod? method,
    String? gateIdentifier,
    String? payload,
  }) async {
    final current = state;
    if (current is CheckInIdle && current.actionInFlight) {
      emit(current.copyWith(message: AttendanceStrings.doubleSubmitBlocked));
      return;
    }
    _activeIdempotencyKey ??= newIdempotencyKey();
    emit(const CheckInIdle(actionInFlight: true));
    final result = await _checkIn(
      CheckInInput(
        idempotencyKey: _activeIdempotencyKey!,
        userId: userId,
        method: method,
        gateIdentifier: gateIdentifier,
        payload: payload,
      ),
    );
    result.fold(
      (failure) {
        emit(
          CheckInIdle(
            actionInFlight: false,
            message: failureMessage(failure),
          ),
        );
      },
      (record) {
        _activeIdempotencyKey = null;
        emit(CheckInSuccess(record));
      },
    );
  }

  void reset() {
    _activeIdempotencyKey = null;
    emit(const CheckInIdle());
  }
}
