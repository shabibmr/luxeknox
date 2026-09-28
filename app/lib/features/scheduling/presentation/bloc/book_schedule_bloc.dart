import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/bloc/event_transformers.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/idempotency/idempotency_key.dart';
import '../../../../core/presentation/load_status.dart';
import '../../domain/entities/schedule_session.dart';
import '../../domain/usecases/schedule_usecases.dart';

part 'book_schedule_bloc.freezed.dart';

sealed class BookScheduleEvent extends Equatable {
  const BookScheduleEvent();

  @override
  List<Object?> get props => [];
}

final class BookScheduleRequested extends BookScheduleEvent {
  const BookScheduleRequested({
    required this.scheduleId,
    required this.memberId,
  });

  final String scheduleId;
  final String memberId;

  @override
  List<Object?> get props => [scheduleId, memberId];
}

@freezed
abstract class BookScheduleState with _$BookScheduleState {
  const factory BookScheduleState({
    @Default(LoadStatus.initial) LoadStatus status,
    Failure? failure,
    ScheduleParticipantEntry? participant,
    String? scheduleId,
  }) = _BookScheduleState;
}

@injectable
class BookScheduleBloc extends Bloc<BookScheduleEvent, BookScheduleState> {
  BookScheduleBloc(this._book) : super(const BookScheduleState()) {
    on<BookScheduleRequested>(_onRequested, transformer: droppable());
  }

  final BookScheduleUseCase _book;
  String? _idempotencyKey;

  Future<void> _onRequested(
    BookScheduleRequested event,
    Emitter<BookScheduleState> emit,
  ) async {
    _idempotencyKey ??= newIdempotencyKey();
    emit(
      state.copyWith(
        status: LoadStatus.loading,
        failure: null,
        participant: null,
        scheduleId: event.scheduleId,
      ),
    );
    final result = await _book(
      BookScheduleParams(
        scheduleId: event.scheduleId,
        memberId: event.memberId,
        idempotencyKey: _idempotencyKey!,
      ),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: LoadStatus.failure,
          failure: failure,
          participant: null,
          scheduleId: event.scheduleId,
        ),
      ),
      (participant) {
        _idempotencyKey = null;
        emit(
          state.copyWith(
            status: LoadStatus.success,
            failure: null,
            participant: participant,
            scheduleId: event.scheduleId,
          ),
        );
      },
    );
  }
}
