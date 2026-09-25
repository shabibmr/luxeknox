import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../domain/entities/workout_personal_record.dart';
import '../../domain/entities/workout_session.dart';
import '../../domain/usecases/list_workout_sessions_usecase.dart';

part 'workout_history_cubit.freezed.dart';

@freezed
abstract class WorkoutHistoryState with _$WorkoutHistoryState {
  const factory WorkoutHistoryState({
    @Default(LoadStatus.initial) LoadStatus status,
    @Default(<WorkoutSession>[]) List<WorkoutSession> items,
    @Default(<WorkoutPersonalRecord>[])
    List<WorkoutPersonalRecord> personalRecords,
    /// True after a successful fetch, so an empty history is still data.
    @Default(false) bool hasLoaded,
    @Default(0) num totalVolumeKg,
    String? nextCursor,
    @Default(false) bool hasMore,
    @Default(false) bool loadingMore,
    Failure? failure,
  }) = _WorkoutHistoryState;
}

@injectable
class WorkoutHistoryCubit extends Cubit<WorkoutHistoryState> {
  WorkoutHistoryCubit(this._listSessions) : super(const WorkoutHistoryState());

  final ListWorkoutSessionsUseCase _listSessions;
  String? _memberId;

  static const _pageSize = 30;

  Future<void> load({String? memberId}) async {
    _memberId = memberId;
    emit(
      state.copyWith(
        status: LoadStatus.loading,
        failure: null,
        loadingMore: false,
      ),
    );
    final result = await _listSessions(
      ListWorkoutSessionsParams(
        memberId: memberId,
        limit: _pageSize,
      ),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(status: LoadStatus.failure, failure: failure),
      ),
      (page) {
        final items = page.items;
        emit(
          state.copyWith(
            status: LoadStatus.success,
            failure: null,
            items: items,
            hasLoaded: true,
            personalRecords: computePersonalRecords(items),
            totalVolumeKg: _sumCompletedVolume(items),
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
    final cursor = state.nextCursor;
    final existing = state.items;
    emit(state.copyWith(loadingMore: true, failure: null));
    final result = await _listSessions(
      ListWorkoutSessionsParams(
        memberId: _memberId,
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
        final items = [...existing, ...page.items];
        emit(
          state.copyWith(
            status: LoadStatus.success,
            failure: null,
            items: items,
            personalRecords: computePersonalRecords(items),
            totalVolumeKg: _sumCompletedVolume(items),
            nextCursor: page.nextCursor,
            hasMore: page.hasMore,
            loadingMore: false,
          ),
        );
      },
    );
  }

  static num _sumCompletedVolume(List<WorkoutSession> sessions) {
    num total = 0;
    for (final s in sessions) {
      if (!s.isCompleted) continue;
      total += s.totalVolumeKg ?? 0;
    }
    return total;
  }
}
