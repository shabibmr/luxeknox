import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failure_messages.dart';
import '../../../../core/idempotency/idempotency_key.dart';
import '../../../attendance/domain/usecases/attendance_usecases.dart';
import '../../domain/entities/schedule_enums.dart';
import '../../domain/entities/schedule_session.dart';
import '../../domain/usecases/schedule_usecases.dart';
import '../scheduling_strings.dart';

sealed class ScheduleDetailState extends Equatable {
  const ScheduleDetailState();

  @override
  List<Object?> get props => [];
}

final class ScheduleDetailLoading extends ScheduleDetailState {
  const ScheduleDetailLoading();
}

final class ScheduleDetailLoaded extends ScheduleDetailState {
  const ScheduleDetailLoaded({
    required this.session,
    this.actionInFlight = false,
    this.message,
  });

  final ScheduleSession session;
  final bool actionInFlight;
  final String? message;

  ScheduleDetailLoaded copyWith({
    ScheduleSession? session,
    bool? actionInFlight,
    String? message,
    bool clearMessage = false,
  }) {
    return ScheduleDetailLoaded(
      session: session ?? this.session,
      actionInFlight: actionInFlight ?? this.actionInFlight,
      message: clearMessage ? null : (message ?? this.message),
    );
  }

  @override
  List<Object?> get props => [session, actionInFlight, message];
}

final class ScheduleDetailFailure extends ScheduleDetailState {
  const ScheduleDetailFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
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
  ) : super(const ScheduleDetailLoading());

  final GetScheduleUseCase _getSchedule;
  final BookScheduleUseCase _book;
  final UnbookScheduleUseCase _unbook;
  final CancelScheduleUseCase _cancel;
  final StartScheduleUseCase _start;
  final CompleteScheduleUseCase _complete;
  final MarkSessionAttendanceUseCase _markAttendance;

  String? _scheduleId;
  String? _activeIdempotencyKey;

  Future<void> load(String scheduleId) async {
    _scheduleId = scheduleId;
    emit(const ScheduleDetailLoading());
    final result = await _getSchedule(scheduleId);
    result.fold(
      (failure) => emit(ScheduleDetailFailure(failureMessage(failure))),
      (session) => emit(ScheduleDetailLoaded(session: session)),
    );
  }

  Future<void> book({required String memberId}) async {
    final current = state;
    if (current is! ScheduleDetailLoaded) return;
    if (current.actionInFlight) {
      emit(
        current.copyWith(message: SchedulingStrings.doubleSubmitBlocked),
      );
      return;
    }
    final scheduleId = _scheduleId ?? current.session.id;
    _scheduleId = scheduleId;

    _activeIdempotencyKey ??= newIdempotencyKey();
    emit(current.copyWith(actionInFlight: true, clearMessage: true));
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
          current.copyWith(
            actionInFlight: false,
            message: failureMessage(failure),
          ),
        );
      },
      (participant) async {
        _activeIdempotencyKey = null;
        final msg = participant.bookingStatus == BookingStatus.waitlisted
            ? SchedulingStrings.waitlistedSuccess
            : SchedulingStrings.bookSuccess;
        await load(scheduleId);
        final loaded = state;
        if (loaded is ScheduleDetailLoaded) {
          emit(loaded.copyWith(message: msg));
        }
      },
    );
  }

  Future<void> unbook(String participantId) async {
    final current = state;
    if (current is! ScheduleDetailLoaded || current.actionInFlight) return;
    final scheduleId = _scheduleId;
    if (scheduleId == null) return;
    emit(current.copyWith(actionInFlight: true, clearMessage: true));
    final result = await _unbook(
      UnbookScheduleParams(
        scheduleId: scheduleId,
        participantId: participantId,
      ),
    );
    await result.fold(
      (failure) async {
        emit(
          current.copyWith(
            actionInFlight: false,
            message: failureMessage(failure),
          ),
        );
      },
      (_) async => load(scheduleId),
    );
  }

  Future<void> cancel({String? reason}) async {
    final current = state;
    if (current is! ScheduleDetailLoaded || current.actionInFlight) return;
    final scheduleId = _scheduleId;
    if (scheduleId == null) return;
    emit(current.copyWith(actionInFlight: true, clearMessage: true));
    final result = await _cancel(
      CancelScheduleParams(
        scheduleId: scheduleId,
        reason: reason,
        rowVersion: current.session.rowVersion,
      ),
    );
    result.fold(
      (failure) => emit(
        current.copyWith(
          actionInFlight: false,
          message: failureMessage(failure),
        ),
      ),
      (session) => emit(ScheduleDetailLoaded(session: session)),
    );
  }

  Future<void> start() async {
    final current = state;
    if (current is! ScheduleDetailLoaded || current.actionInFlight) return;
    final scheduleId = _scheduleId;
    if (scheduleId == null) return;
    emit(current.copyWith(actionInFlight: true, clearMessage: true));
    final result = await _start(scheduleId);
    result.fold(
      (failure) => emit(
        current.copyWith(
          actionInFlight: false,
          message: failureMessage(failure),
        ),
      ),
      (session) => emit(ScheduleDetailLoaded(session: session)),
    );
  }

  Future<void> complete() async {
    final current = state;
    if (current is! ScheduleDetailLoaded || current.actionInFlight) return;
    final scheduleId = _scheduleId;
    if (scheduleId == null) return;
    emit(current.copyWith(actionInFlight: true, clearMessage: true));
    final result = await _complete(scheduleId);
    result.fold(
      (failure) => emit(
        current.copyWith(
          actionInFlight: false,
          message: failureMessage(failure),
        ),
      ),
      (session) => emit(ScheduleDetailLoaded(session: session)),
    );
  }

  Future<void> markAttendance({
    required String participantId,
    required bool attended,
  }) async {
    final current = state;
    if (current is! ScheduleDetailLoaded || current.actionInFlight) return;
    final scheduleId = _scheduleId ?? current.session.id;
    emit(current.copyWith(actionInFlight: true, clearMessage: true));
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
          current.copyWith(
            actionInFlight: false,
            message: failureMessage(failure),
          ),
        );
      },
      (_) async => load(scheduleId),
    );
  }
}
