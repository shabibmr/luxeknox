import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/idempotency/idempotency_key.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../attendance/domain/usecases/attendance_usecases.dart';
import '../../domain/entities/schedule_enums.dart';
import '../../domain/entities/schedule_session.dart';
import '../../domain/repositories/scheduling_repository.dart';
import '../../domain/usecases/schedule_usecases.dart';
import '../scheduling_strings.dart';

part 'schedule_detail_cubit.freezed.dart';

@freezed
abstract class ScheduleDetailState with _$ScheduleDetailState {
  const factory ScheduleDetailState({
    @Default(LoadStatus.initial) LoadStatus status,
    ScheduleSession? session,
    @Default(false) bool actionInFlight,
    /// Success / action copy. API errors use [failure] (and optionally [message]
    /// for move-booking cap / rollback copy).
    String? message,
    Failure? failure,
    /// Staff reschedule hit a stale `rowVersion` (409); session was reloaded.
    @Default(false) bool isConflict,
    /// Set after a successful move so the UI can navigate to the new session.
    String? movedToScheduleId,
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
    this._updateSchedule,
  ) : super(const ScheduleDetailState());

  final GetScheduleUseCase _getSchedule;
  final BookScheduleUseCase _book;
  final UnbookScheduleUseCase _unbook;
  final CancelScheduleUseCase _cancel;
  final StartScheduleUseCase _start;
  final CompleteScheduleUseCase _complete;
  final MarkSessionAttendanceUseCase _markAttendance;
  final UpdateScheduleUseCase _updateSchedule;

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
        isConflict: false,
        movedToScheduleId: null,
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
          isConflict: false,
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
        isConflict: false,
        movedToScheduleId: null,
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
        isConflict: false,
        movedToScheduleId: null,
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

  Future<void> cancel({String? reason, bool cancelSeries = false}) async {
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
        isConflict: false,
        movedToScheduleId: null,
      ),
    );
    final result = await _cancel(
      CancelScheduleParams(
        scheduleId: scheduleId,
        reason: reason,
        rowVersion: session.rowVersion,
        cancelSeries: cancelSeries,
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
        isConflict: false,
        movedToScheduleId: null,
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
        isConflict: false,
        movedToScheduleId: null,
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
        isConflict: false,
        movedToScheduleId: null,
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

  /// Staff: patch session start/end with optimistic concurrency via [rowVersion].
  Future<bool> reschedule({
    required DateTime start,
    required DateTime end,
  }) async {
    if (!_canAct) return false;
    if (!end.isAfter(start)) {
      emit(
        state.copyWith(
          failure: const ValidationFailure([
            SchedulingStrings.endBeforeStartError,
          ]),
          message: null,
          isConflict: false,
        ),
      );
      return false;
    }
    final scheduleId = _scheduleId ?? state.session!.id;
    final session = state.session!;
    emit(
      state.copyWith(
        actionInFlight: true,
        message: null,
        failure: null,
        status: LoadStatus.success,
        isConflict: false,
        movedToScheduleId: null,
      ),
    );
    final result = await _updateSchedule(
      UpdateScheduleParams(
        id: scheduleId,
        input: CreateScheduleInput(
          startTime: start,
          endTime: end,
          rowVersion: session.rowVersion,
        ),
      ),
    );

    return await result.fold(
      (failure) async {
        final isConflict = failure is ConflictFailure;
        if (isConflict) {
          await load(scheduleId);
          if (!isClosed) {
            emit(
              state.copyWith(
                isConflict: true,
                message: SchedulingStrings.rowVersionConflict,
                failure: failure,
                actionInFlight: false,
              ),
            );
          }
        } else {
          emit(
            state.copyWith(
              actionInFlight: false,
              status: LoadStatus.failure,
              failure: failure,
              message: null,
              isConflict: false,
            ),
          );
        }
        return false;
      },
      (updated) async {
        emit(
          state.copyWith(
            status: LoadStatus.success,
            failure: null,
            message: SchedulingStrings.rescheduleSuccess,
            actionInFlight: false,
            session: updated,
            isConflict: false,
          ),
        );
        return true;
      },
    );
  }

  /// Member: book [targetScheduleId], then cancel the seat on the current session.
  ///
  /// A [ConflictFailure] on book is treated as the member booking-cap and blocked
  /// (no cancel-then-book). If cancel fails after a successful book, emits a
  /// rollback warning — the member may hold seats on both sessions.
  Future<bool> moveBooking({
    required String targetScheduleId,
    required String memberId,
  }) async {
    if (!_canAct) return false;
    final currentId = _scheduleId ?? state.session?.id;
    if (currentId == null || targetScheduleId == currentId) return false;

    emit(
      state.copyWith(
        actionInFlight: true,
        message: null,
        failure: null,
        status: LoadStatus.success,
        isConflict: false,
        movedToScheduleId: null,
      ),
    );

    final bookKey = newIdempotencyKey();
    final bookResult = await _book(
      BookScheduleParams(
        scheduleId: targetScheduleId,
        memberId: memberId,
        idempotencyKey: bookKey,
      ),
    );

    final bookFailed = bookResult.fold<Failure?>((f) => f, (_) => null);
    if (bookFailed != null) {
      final isCap = bookFailed is ConflictFailure;
      emit(
        state.copyWith(
          actionInFlight: false,
          status: LoadStatus.failure,
          failure: bookFailed,
          message: isCap ? SchedulingStrings.moveBookingCapBlocked : null,
        ),
      );
      return false;
    }

    final cancelResult = await _unbook(
      UnbookScheduleParams(
        scheduleId: currentId,
        memberId: memberId,
        reason: 'Moved to schedule $targetScheduleId',
      ),
    );

    return cancelResult.fold(
      (failure) {
        emit(
          state.copyWith(
            actionInFlight: false,
            status: LoadStatus.failure,
            failure: failure,
            message: SchedulingStrings.moveBookingCancelFailed,
            movedToScheduleId: targetScheduleId,
          ),
        );
        return false;
      },
      (_) {
        _scheduleId = targetScheduleId;
        emit(
          state.copyWith(
            actionInFlight: false,
            status: LoadStatus.success,
            failure: null,
            message: SchedulingStrings.moveBookingSuccess,
            movedToScheduleId: targetScheduleId,
          ),
        );
        return true;
      },
    );
  }
}
