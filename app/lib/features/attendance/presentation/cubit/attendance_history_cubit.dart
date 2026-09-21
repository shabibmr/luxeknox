import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failure_messages.dart';
import '../../domain/entities/attendance_history_day.dart';
import '../../domain/entities/attendance_record.dart';
import '../../domain/entities/attendance_summary.dart';
import '../../domain/usecases/attendance_usecases.dart';

sealed class AttendanceHistoryState extends Equatable {
  const AttendanceHistoryState();

  @override
  List<Object?> get props => [];
}

final class AttendanceHistoryLoading extends AttendanceHistoryState {
  const AttendanceHistoryLoading();
}

final class AttendanceHistoryLoaded extends AttendanceHistoryState {
  const AttendanceHistoryLoaded({
    required this.items,
    this.nextCursor,
    this.hasMore = false,
    this.loadingMore = false,
  });

  final List<AttendanceRecord> items;
  final String? nextCursor;
  final bool hasMore;
  final bool loadingMore;

  AttendanceHistoryLoaded copyWith({
    List<AttendanceRecord>? items,
    String? nextCursor,
    bool? hasMore,
    bool? loadingMore,
  }) {
    return AttendanceHistoryLoaded(
      items: items ?? this.items,
      nextCursor: nextCursor ?? this.nextCursor,
      hasMore: hasMore ?? this.hasMore,
      loadingMore: loadingMore ?? this.loadingMore,
    );
  }

  @override
  List<Object?> get props => [items, nextCursor, hasMore, loadingMore];
}

final class AttendanceHistoryFailure extends AttendanceHistoryState {
  const AttendanceHistoryFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

@injectable
class AttendanceHistoryCubit extends Cubit<AttendanceHistoryState> {
  AttendanceHistoryCubit(this._listAttendances)
    : super(const AttendanceHistoryLoading());

  final ListAttendancesUseCase _listAttendances;
  String? _userId;

  Future<void> load({String? userId}) async {
    _userId = userId;
    emit(const AttendanceHistoryLoading());
    final result = await _listAttendances(
      ListAttendancesParams(userId: userId, limit: 30),
    );
    result.fold(
      (failure) => emit(AttendanceHistoryFailure(failureMessage(failure))),
      (page) => emit(
        AttendanceHistoryLoaded(
          items: page.items,
          nextCursor: page.nextCursor,
          hasMore: page.hasMore,
        ),
      ),
    );
  }

  Future<void> loadMore() async {
    final current = state;
    if (current is! AttendanceHistoryLoaded ||
        !current.hasMore ||
        current.loadingMore) {
      return;
    }
    emit(current.copyWith(loadingMore: true));
    final result = await _listAttendances(
      ListAttendancesParams(
        userId: _userId,
        cursor: current.nextCursor,
        limit: 30,
      ),
    );
    result.fold(
      (failure) => emit(
        current.copyWith(loadingMore: false),
      ),
      (page) => emit(
        AttendanceHistoryLoaded(
          items: [...current.items, ...page.items],
          nextCursor: page.nextCursor,
          hasMore: page.hasMore,
        ),
      ),
    );
  }
}

sealed class AttendanceSummaryState extends Equatable {
  const AttendanceSummaryState();

  @override
  List<Object?> get props => [];
}

final class AttendanceSummaryLoading extends AttendanceSummaryState {
  const AttendanceSummaryLoading();
}

final class AttendanceSummaryLoaded extends AttendanceSummaryState {
  const AttendanceSummaryLoaded({
    required this.summary,
    required this.heatmapDays,
  });

  final AttendanceSummaryInfo summary;

  /// Days with at least one check-in (derived from personal history).
  final Set<DateTime> heatmapDays;

  @override
  List<Object?> get props => [summary, heatmapDays];
}

final class AttendanceSummaryFailure extends AttendanceSummaryState {
  const AttendanceSummaryFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

@injectable
class AttendanceSummaryCubit extends Cubit<AttendanceSummaryState> {
  AttendanceSummaryCubit(this._getSummary, this._listAttendances)
    : super(const AttendanceSummaryLoading());

  final GetAttendanceSummaryUseCase _getSummary;
  final ListAttendancesUseCase _listAttendances;

  Future<void> load({String? memberId}) async {
    emit(const AttendanceSummaryLoading());
    final summaryResult = await _getSummary(
      GetAttendanceSummaryParams(memberId: memberId),
    );
    await summaryResult.fold(
      (failure) async =>
          emit(AttendanceSummaryFailure(failureMessage(failure))),
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
        emit(AttendanceSummaryLoaded(summary: summary, heatmapDays: days));
      },
    );
  }
}

sealed class LiveFeedState extends Equatable {
  const LiveFeedState();

  @override
  List<Object?> get props => [];
}

final class LiveFeedLoading extends LiveFeedState {
  const LiveFeedLoading();
}

final class LiveFeedLoaded extends LiveFeedState {
  const LiveFeedLoaded({
    required this.items,
    required this.footfall,
    this.nextCursor,
    this.hasMore = false,
  });

  final List<AttendanceRecord> items;
  final List<AttendanceHistoryDay> footfall;
  final String? nextCursor;
  final bool hasMore;

  @override
  List<Object?> get props => [items, footfall, nextCursor, hasMore];
}

final class LiveFeedFailure extends LiveFeedState {
  const LiveFeedFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

@injectable
class AttendanceLiveFeedCubit extends Cubit<LiveFeedState> {
  AttendanceLiveFeedCubit(this._listAttendances, this._listHistories)
    : super(const LiveFeedLoading());

  final ListAttendancesUseCase _listAttendances;
  final ListAttendanceHistoriesUseCase _listHistories;

  Future<void> load() async {
    emit(const LiveFeedLoading());
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
      (failure) => emit(LiveFeedFailure(failureMessage(failure))),
      (page) {
        histories.fold(
          (failure) => emit(LiveFeedFailure(failureMessage(failure))),
          (days) => emit(
            LiveFeedLoaded(
              items: page.items,
              footfall: days,
              nextCursor: page.nextCursor,
              hasMore: page.hasMore,
            ),
          ),
        );
      },
    );
  }
}
