import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../domain/entities/schedule_session.dart';
import '../../domain/usecases/schedule_usecases.dart';

part 'schedule_calendar_cubit.freezed.dart';

@freezed
abstract class ScheduleCalendarState with _$ScheduleCalendarState {
  const factory ScheduleCalendarState({
    @Default(LoadStatus.initial) LoadStatus status,
    @Default(<ScheduleSession>[]) List<ScheduleSession> items,
    /// True after a successful fetch, so an empty range is still data.
    @Default(false) bool hasLoaded,
    DateTime? from,
    DateTime? to,
    Failure? failure,
  }) = _ScheduleCalendarState;
}

@injectable
class ScheduleCalendarCubit extends Cubit<ScheduleCalendarState> {
  ScheduleCalendarCubit(this._listSchedules)
    : super(const ScheduleCalendarState());

  final ListSchedulesUseCase _listSchedules;

  String? _trainerId;
  String? _memberId;
  DateTime? _from;
  DateTime? _to;

  Future<void> load({
    DateTime? from,
    DateTime? to,
    String? trainerId,
    String? memberId,
  }) async {
    final now = DateTime.now();
    _from = from ?? DateTime(now.year, now.month, now.day);
    _to = to ?? _from!.add(const Duration(days: 7));
    _trainerId = trainerId ?? _trainerId;
    _memberId = memberId ?? _memberId;
    emit(
      state.copyWith(
        status: LoadStatus.loading,
        failure: null,
        from: _from,
        to: _to,
      ),
    );
    final result = await _listSchedules(
      ListSchedulesParams(
        from: _from,
        to: _to,
        trainerId: _trainerId,
        memberId: _memberId,
      ),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(status: LoadStatus.failure, failure: failure),
      ),
      (page) => emit(
        state.copyWith(
          status: LoadStatus.success,
          failure: null,
          items: page.items,
          hasLoaded: true,
          from: _from,
          to: _to,
        ),
      ),
    );
  }

  Future<void> shiftRange(int days) async {
    if (_from == null || _to == null) return;
    await load(
      from: _from!.add(Duration(days: days)),
      to: _to!.add(Duration(days: days)),
    );
  }
}
