import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/idempotency/idempotency_key.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../attendance/domain/usecases/attendance_usecases.dart';
import '../../domain/entities/schedule_enums.dart';
import '../../domain/entities/schedule_session.dart';
import '../../domain/usecases/schedule_usecases.dart';
import '../scheduling_strings.dart';

part 'schedule_detail_cubit.freezed.dart';

@freezed
abstract class ScheduleDetailState with _$ScheduleDetailState {
  const factory ScheduleDetailState({
    @Default(LoadStatus.initial) LoadStatus status,
    ScheduleSession? session,
    @Default(false) bool actionInFlight,
    /// Success copy and the double-submit guard. API errors use [failure].
    String? message,
    Failure? failure,
  }) = _ScheduleDetailState;
}

@injectable
class ScheduleDetailCubit extends Cubit<ScheduleDetailState> {
  ScheduleDetailCubit(
    this._getSchedule,
    this._book,
    this._unbook,
    this._cancel,
    this._start,
    this._complete,
    this._markAttendance,
  ) : super(const ScheduleDetailState());

  final GetScheduleUseCase _getSchedule;
  final BookScheduleUseCase _book;
  final UnbookScheduleUseCase _unbook;
  final CancelScheduleUseCase _cancel;
  final StartScheduleUseCase _start;
  final CompleteScheduleUseCase _complete;
  final MarkSessionAttendanceUseCase _markAttendance;

  String? _scheduleId;
  String? _activeIdempotencyKey;

  bool get _canAct =>
      state.session != null &&
      !state.actionInFlight &&
      state.status != LoadStatus.loading;

  Future<void> load(String scheduleId) async {
    _scheduleId = scheduleId;
    emit(
      state.copyWith(
        status: LoadStatus.loading,
        failure: null,
        message: null,
        actionInFlight: false,
      ),
    );
    final result = await _getSchedule(scheduleId);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: LoadStatus.failure,
          failure: failure,
          actionInFlight: false,
        ),
      ),
      (session) => emit(
        state.copyWith(
          status: LoadStatus.success,
          failure: null,
          message: null,
          actionInFlight: false,
          session: session,
        ),
      ),
    );
  }

  Future<void> book({required String memberId}) async {
    if (state.session == null || state.status == LoadStatus.loading) return;
    if (state.actionInFlight) {
      emit(state.copyWith(message: SchedulingStrings.doubleSubmitBlocked));
      return;
    }
    final scheduleId = _scheduleId ?? state.session!.id;
    _scheduleId = scheduleId;

    _activeIdempotencyKey ??= newIdempotencyKey();
    emit(
      state.copyWith(
        actionInFlight: true,
        message: null,
        failure: null,
        status: LoadStatus.success,
      ),
    );
    final result = await _book(
      BookScheduleParams(
        scheduleId: scheduleId,
        memberId: memberId,
        idempotencyKey: _activeIdempotencyKey!,
      ),
    );
    await result.fold(
      (failure) async {
        emit(
          state.copyWith(
            actionInFlight: false,
            status: LoadStatus.failure,
            failure: failure,
            message: null,
          ),
        );
      },
      (participant) async {
        _activeIdempotencyKey = null;
        final msg = participant.bookingStatus == BookingStatus.waitlisted
            ? SchedulingStrings.waitlistedSuccess
            : SchedulingStrings.bookSuccess;
        await load(scheduleId);
        if (state.status == LoadStatus.success && state.session != null) {
          emit(state.copyWith(message: msg));
        }
      },
    );
  }

  Future<void> unbook(String memberId) async {
    if (!_canAct) return;
    final scheduleId = _scheduleId;
    if (scheduleId == null) return;
    emit(
      state.copyWith(
        actionInFlight: true,
        message: null,
        failure: null,
        status: LoadStatus.success,
      ),
    );
    final result = await _unbook(
      UnbookScheduleParams(
        scheduleId: scheduleId,
        memberId: memberId,
      ),
    );
    await result.fold(
      (failure) async {
        emit(
          state.copyWith(
            actionInFlight: false,
            status: LoadStatus.failure,
            failure: failure,
            message: null,
          ),
        );
      },
      (_) async => load(scheduleId),
    );
  }

  Future<void> cancel({String? reason}) async {
    if (!_canAct) return;
    final scheduleId = _scheduleId;
    final session = state.session;
    if (scheduleId == null || session == null) return;
    emit(
      state.copyWith(
        actionInFlight: true,
        message: null,
        failure: null,
        status: LoadStatus.success,
      ),
    );
    final result = await _cancel(
      CancelScheduleParams(
        scheduleId: scheduleId,
        reason: reason,
        rowVersion: session.rowVersion,
      ),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          actionInFlight: false,
          status: LoadStatus.failure,
          failure: failure,
          message: null,
        ),
      ),
      (updated) => emit(
        state.copyWith(
          status: LoadStatus.success,
          failure: null,
          message: null,
          actionInFlight: false,
          session: updated,
        ),
      ),
    );
  }

  Future<void> start() async {
    if (!_canAct) return;
    final scheduleId = _scheduleId;
    if (scheduleId == null) return;
    emit(
      state.copyWith(
        actionInFlight: true,
        message: null,
        failure: null,
        status: LoadStatus.success,
      ),
    );
    final result = await _start(scheduleId);
    result.fold(
      (failure) => emit(
        state.copyWith(
          actionInFlight: false,
          status: LoadStatus.failure,
          failure: failure,
          message: null,
        ),
      ),
      (updated) => emit(
        state.copyWith(
          status: LoadStatus.success,
          failure: null,
          message: null,
          actionInFlight: false,
          session: updated,
        ),
      ),
    );
  }

  Future<void> complete() async {
    if (!_canAct) return;
    final scheduleId = _scheduleId;
    if (scheduleId == null) return;
    emit(
      state.copyWith(
        actionInFlight: true,
        message: null,
        failure: null,
        status: LoadStatus.success,
      ),
    );
    final result = await _complete(scheduleId);
    result.fold(
      (failure) => emit(
        state.copyWith(
          actionInFlight: false,
          status: LoadStatus.failure,
          failure: failure,
          message: null,
        ),
      ),
      (updated) => emit(
        state.copyWith(
          status: LoadStatus.success,
          failure: null,
          message: null,
          actionInFlight: false,
          session: updated,
        ),
      ),
    );
  }

  Future<void> markAttendance({
    required String participantId,
    required bool attended,
  }) async {
    if (!_canAct) return;
    final scheduleId = _scheduleId ?? state.session!.id;
    emit(
      state.copyWith(
        actionInFlight: true,
        message: null,
        failure: null,
        status: LoadStatus.success,
      ),
    );
    final result = await _markAttendance(
      MarkSessionAttendanceParams(
        scheduleId: scheduleId,
        participantId: participantId,
        attended: attended,
      ),
    );
    await result.fold(
      (failure) async {
        emit(
          state.copyWith(
            actionInFlight: false,
            status: LoadStatus.failure,
            failure: failure,
            message: null,
          ),
        );
      },
      (_) async => load(scheduleId),
    );
  }
}
