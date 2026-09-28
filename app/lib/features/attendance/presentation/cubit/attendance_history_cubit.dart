import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../domain/entities/attendance_history_day.dart';
import '../../domain/entities/attendance_record.dart';
import '../../domain/entities/attendance_summary.dart';
import '../../domain/usecases/attendance_usecases.dart';

part 'attendance_history_cubit.freezed.dart';

@freezed
abstract class AttendanceHistoryState with _$AttendanceHistoryState {
  const factory AttendanceHistoryState({
    @Default(LoadStatus.initial) LoadStatus status,
    @Default(<AttendanceRecord>[]) List<AttendanceRecord> items,
    String? nextCursor,
    @Default(false) bool hasMore,
    @Default(false) bool loadingMore,
    Failure? failure,
  }) = _AttendanceHistoryState;
}

@injectable
class AttendanceHistoryCubit extends Cubit<AttendanceHistoryState> {
  AttendanceHistoryCubit(this._listAttendances)
    : super(const AttendanceHistoryState());

  final ListAttendancesUseCase _listAttendances;
  String? _userId;

  Future<void> load({String? userId}) async {
    _userId = userId;
    emit(
      state.copyWith(
        status: LoadStatus.loading,
        failure: null,
        loadingMore: false,
      ),
    );
    final result = await _listAttendances(
      ListAttendancesParams(userId: userId, limit: 30),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(status: LoadStatus.failure, failure: failure),
      ),
      (page) => emit(
        state.copyWith(
          status: LoadStatus.success,
          items: page.items,
          nextCursor: page.nextCursor,
          hasMore: page.hasMore,
          failure: null,
          loadingMore: false,
        ),
      ),
    );
  }

  Future<void> loadMore() async {
    final current = state;
    if (current.status == LoadStatus.loading || current.loadingMore) return;
    if (!current.hasMore || current.nextCursor == null) return;
    if (current.items.isEmpty && current.status != LoadStatus.success) {
      return;
    }
    emit(current.copyWith(loadingMore: true, failure: null));
    final result = await _listAttendances(
      ListAttendancesParams(
        userId: _userId,
        cursor: current.nextCursor,
        limit: 30,
      ),
    );
    result.fold(
      (failure) => emit(
        current.copyWith(
          loadingMore: false,
          failure: failure,
        ),
      ),
      (page) => emit(
        current.copyWith(
          status: LoadStatus.success,
          items: [...current.items, ...page.items],
          nextCursor: page.nextCursor ?? current.nextCursor,
          hasMore: page.hasMore,
          loadingMore: false,
          failure: null,
        ),
      ),
    );
  }
}

@freezed
abstract class AttendanceSummaryState with _$AttendanceSummaryState {
  const factory AttendanceSummaryState({
    @Default(LoadStatus.initial) LoadStatus status,
    AttendanceSummaryInfo? summary,
    @Default(<DateTime>{}) Set<DateTime> heatmapDays,
    Failure? failure,
  }) = _AttendanceSummaryState;
}

@injectable
class AttendanceSummaryCubit extends Cubit<AttendanceSummaryState> {
  AttendanceSummaryCubit(this._getSummary, this._listAttendances)
    : super(const AttendanceSummaryState());

  final GetAttendanceSummaryUseCase _getSummary;
  final ListAttendancesUseCase _listAttendances;

  Future<void> load({String? memberId}) async {
    emit(state.copyWith(status: LoadStatus.loading, failure: null));
    final summaryResult = await _getSummary(
      GetAttendanceSummaryParams(memberId: memberId),
    );
    await summaryResult.fold(
      (failure) async => emit(
        state.copyWith(status: LoadStatus.failure, failure: failure),
      ),
      (summary) async {
        final now = DateTime.now();
        final from = DateTime(now.year, now.month - 2, 1);
        final history = await _listAttendances(
          ListAttendancesParams(
            userId: memberId,
            from: from,
            to: now,
            limit: 100,
          ),
        );
        final days = <DateTime>{};
        history.fold((_) {}, (page) {
          for (final r in page.items) {
            final d = r.checkInTime;
            days.add(DateTime(d.year, d.month, d.day));
          }
        });
        emit(
          state.copyWith(
            status: LoadStatus.success,
            summary: summary,
            heatmapDays: days,
            failure: null,
          ),
        );
      },
    );
  }
}

@freezed
abstract class LiveFeedState with _$LiveFeedState {
  const factory LiveFeedState({
    @Default(LoadStatus.initial) LoadStatus status,
    @Default(<AttendanceRecord>[]) List<AttendanceRecord> items,
    @Default(<AttendanceHistoryDay>[]) List<AttendanceHistoryDay> footfall,
    String? nextCursor,
    @Default(false) bool hasMore,
    Failure? failure,
  }) = _LiveFeedState;
}

@injectable
class AttendanceLiveFeedCubit extends Cubit<LiveFeedState> {
  AttendanceLiveFeedCubit(this._listAttendances, this._listHistories)
    : super(const LiveFeedState());

  final ListAttendancesUseCase _listAttendances;
  final ListAttendanceHistoriesUseCase _listHistories;

  Future<void> load() async {
    emit(state.copyWith(status: LoadStatus.loading, failure: null));
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final feed = await _listAttendances(
      ListAttendancesParams(from: startOfDay, to: now, limit: 50),
    );
    final histories = await _listHistories(
      ListAttendanceHistoriesParams(
        from: startOfDay.subtract(const Duration(days: 28)),
        to: now,
      ),
    );
    feed.fold(
      (failure) => emit(
        state.copyWith(status: LoadStatus.failure, failure: failure),
      ),
      (page) {
        histories.fold(
          (failure) => emit(
            state.copyWith(
              status: LoadStatus.failure,
              failure: failure,
              items: page.items,
              nextCursor: page.nextCursor,
              hasMore: page.hasMore,
            ),
          ),
          (days) => emit(
            state.copyWith(
              status: LoadStatus.success,
              items: page.items,
              footfall: days,
              nextCursor: page.nextCursor,
              hasMore: page.hasMore,
              failure: null,
            ),
          ),
        );
      },
    );
  }
}
