import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../domain/entities/schedule_enums.dart';
import '../../domain/entities/schedule_session.dart';
import '../../domain/usecases/schedule_usecases.dart';

part 'schedule_history_cubit.freezed.dart';

@freezed
abstract class ScheduleHistoryState with _$ScheduleHistoryState {
  const factory ScheduleHistoryState({
    @Default(LoadStatus.initial) LoadStatus status,
    @Default(<ScheduleSession>[]) List<ScheduleSession> items,
    /// True after a successful fetch, so an empty archive is still data.
    @Default(false) bool hasLoaded,
    String? nextCursor,
    @Default(false) bool hasMore,
    @Default(false) bool loadingMore,
    Failure? failure,
  }) = _ScheduleHistoryState;
}

/// Past (completed / cancelled) sessions for a member or trainer —
/// backs the Schedule History screens for both roles.
@injectable
class ScheduleHistoryCubit extends Cubit<ScheduleHistoryState> {
  ScheduleHistoryCubit(this._listSchedules) : super(const ScheduleHistoryState());

  final ListSchedulesUseCase _listSchedules;

  String? _memberId;
  String? _trainerId;

  static const _pageSize = 30;

  bool _isPast(ScheduleSession s) =>
      s.status == ScheduleSessionStatus.completed ||
      s.status == ScheduleSessionStatus.cancelled;

  Future<void> load({String? memberId, String? trainerId}) async {
    _memberId = memberId;
    _trainerId = trainerId;
    emit(
      state.copyWith(
        status: LoadStatus.loading,
        failure: null,
        loadingMore: false,
      ),
    );
    final result = await _listSchedules(
      ListSchedulesParams(
        memberId: memberId,
        trainerId: trainerId,
        limit: _pageSize,
      ),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(status: LoadStatus.failure, failure: failure),
      ),
      (page) {
        final items = page.items.where(_isPast).toList()
          ..sort((a, b) => b.startTime.compareTo(a.startTime));
        emit(
          state.copyWith(
            status: LoadStatus.success,
            failure: null,
            items: items,
            hasLoaded: true,
            nextCursor: page.nextCursor,
            hasMore: page.hasMore,
            loadingMore: false,
          ),
        );
      },
    );
  }

  Future<void> loadMore() async {
    if (!state.hasLoaded || !state.hasMore || state.loadingMore) return;
    if (state.status == LoadStatus.loading) return;
    final existing = state.items;
    final cursor = state.nextCursor;
    emit(state.copyWith(loadingMore: true, failure: null));
    final result = await _listSchedules(
      ListSchedulesParams(
        memberId: _memberId,
        trainerId: _trainerId,
        cursor: cursor,
        limit: _pageSize,
      ),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: LoadStatus.failure,
          failure: failure,
          loadingMore: false,
        ),
      ),
      (page) {
        final merged = [...existing, ...page.items.where(_isPast)]
          ..sort((a, b) => b.startTime.compareTo(a.startTime));
        emit(
          state.copyWith(
            status: LoadStatus.success,
            failure: null,
            items: merged,
            nextCursor: page.nextCursor,
            hasMore: page.hasMore,
            loadingMore: false,
          ),
        );
      },
    );
  }
}
