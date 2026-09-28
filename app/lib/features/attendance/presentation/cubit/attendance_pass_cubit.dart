import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/attendance_pass.dart';
import '../../domain/entities/attendance_record.dart';
import '../../domain/usecases/attendance_usecases.dart';
import '../attendance_strings.dart';

part 'attendance_pass_cubit.freezed.dart';

@freezed
abstract class AttendancePassState with _$AttendancePassState {
  const factory AttendancePassState({
    @Default(LoadStatus.initial) LoadStatus status,
    AttendancePass? pass,
    AttendanceRecord? openAttendance,
    @Default(false) bool actionInFlight,
    Failure? failure,
    String? message,
  }) = _AttendancePassState;
}

@injectable
class AttendancePassCubit extends Cubit<AttendancePassState> {
  AttendancePassCubit(
    this._getPass,
    this._listAttendances,
    this._checkOut,
  ) : super(const AttendancePassState());

  final GetAttendancePassUseCase _getPass;
  final ListAttendancesUseCase _listAttendances;
  final CheckOutUseCase _checkOut;

  Future<void> load() async {
    emit(
      state.copyWith(
        status: LoadStatus.loading,
        failure: null,
        message: null,
        actionInFlight: false,
      ),
    );
    final passResult = await _getPass(const NoParams());
    await passResult.fold(
      (failure) async => emit(
        state.copyWith(status: LoadStatus.failure, failure: failure),
      ),
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
        emit(
          state.copyWith(
            status: LoadStatus.success,
            pass: pass,
            openAttendance: open,
            failure: null,
            actionInFlight: false,
          ),
        );
      },
    );
  }

  Future<void> refreshPass() => load();

  Future<void> checkOut() async {
    final current = state;
    final open = current.openAttendance;
    if (current.pass == null || open == null) return;
    if (current.actionInFlight) {
      emit(
        current.copyWith(message: AttendanceStrings.doubleSubmitBlocked),
      );
      return;
    }
    emit(
      current.copyWith(
        actionInFlight: true,
        message: null,
        failure: null,
      ),
    );
    final result = await _checkOut(CheckOutParams(open.id));
    result.fold(
      (failure) => emit(
        current.copyWith(
          actionInFlight: false,
          failure: failure,
          message: null,
        ),
      ),
      (record) => emit(
        current.copyWith(
          actionInFlight: false,
          failure: null,
          openAttendance: record.checkOutTime == null ? record : null,
          message: AttendanceStrings.checkOutSuccess,
        ),
      ),
    );
  }
}
