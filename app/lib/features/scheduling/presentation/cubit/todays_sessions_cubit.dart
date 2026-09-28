import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../domain/entities/schedule_session.dart';
import '../../domain/usecases/schedule_usecases.dart';

part 'todays_sessions_cubit.freezed.dart';

@freezed
abstract class TodaysSessionsState with _$TodaysSessionsState {
  const factory TodaysSessionsState({
    @Default(LoadStatus.initial) LoadStatus status,
    @Default(<ScheduleSession>[]) List<ScheduleSession> items,
    /// True after a successful fetch, so an empty day is still data.
    @Default(false) bool hasLoaded,
    Failure? failure,
  }) = _TodaysSessionsState;
}

@injectable
class TodaysSessionsCubit extends Cubit<TodaysSessionsState> {
  TodaysSessionsCubit(this._listSchedules) : super(const TodaysSessionsState());

  final ListSchedulesUseCase _listSchedules;

  String? _trainerId;

  Future<void> load({String? trainerId}) async {
    _trainerId = trainerId ?? _trainerId;
    emit(state.copyWith(status: LoadStatus.loading, failure: null));
    final now = DateTime.now();
    final from = DateTime(now.year, now.month, now.day);
    final to = from.add(const Duration(days: 1));
    final result = await _listSchedules(
      ListSchedulesParams(
        from: from,
        to: to,
        trainerId: _trainerId,
      ),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(status: LoadStatus.failure, failure: failure),
      ),
      (page) {
        final items = [...page.items]
          ..sort((a, b) => a.startTime.compareTo(b.startTime));
        emit(
          state.copyWith(
            status: LoadStatus.success,
            failure: null,
            items: items,
            hasLoaded: true,
          ),
        );
      },
    );
  }
}
