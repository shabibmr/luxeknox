import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failure_messages.dart';
import '../../domain/entities/workout_personal_record.dart';
import '../../domain/entities/workout_session.dart';
import '../../domain/usecases/list_workout_sessions_usecase.dart';

sealed class WorkoutHistoryState extends Equatable {
  const WorkoutHistoryState();

  @override
  List<Object?> get props => [];
}

final class WorkoutHistoryLoading extends WorkoutHistoryState {
  const WorkoutHistoryLoading();
}

final class WorkoutHistoryLoaded extends WorkoutHistoryState {
  const WorkoutHistoryLoaded({
    required this.items,
    required this.personalRecords,
    required this.totalVolumeKg,
    this.nextCursor,
    this.hasMore = false,
    this.loadingMore = false,
  });

  final List<WorkoutSession> items;
  final List<WorkoutPersonalRecord> personalRecords;
  final num totalVolumeKg;
  final String? nextCursor;
  final bool hasMore;
  final bool loadingMore;

  WorkoutHistoryLoaded copyWith({
    List<WorkoutSession>? items,
    List<WorkoutPersonalRecord>? personalRecords,
    num? totalVolumeKg,
    String? nextCursor,
    bool? hasMore,
    bool? loadingMore,
  }) {
    return WorkoutHistoryLoaded(
      items: items ?? this.items,
      personalRecords: personalRecords ?? this.personalRecords,
      totalVolumeKg: totalVolumeKg ?? this.totalVolumeKg,
      nextCursor: nextCursor ?? this.nextCursor,
      hasMore: hasMore ?? this.hasMore,
      loadingMore: loadingMore ?? this.loadingMore,
    );
  }

  @override
  List<Object?> get props => [
    items,
    personalRecords,
    totalVolumeKg,
    nextCursor,
    hasMore,
    loadingMore,
  ];
}

final class WorkoutHistoryFailure extends WorkoutHistoryState {
  const WorkoutHistoryFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

@injectable
class WorkoutHistoryCubit extends Cubit<WorkoutHistoryState> {
  WorkoutHistoryCubit(this._listSessions)
    : super(const WorkoutHistoryLoading());

  final ListWorkoutSessionsUseCase _listSessions;
  String? _memberId;

  static const _pageSize = 30;

  Future<void> load({String? memberId}) async {
    _memberId = memberId;
    emit(const WorkoutHistoryLoading());
    final result = await _listSessions(
      ListWorkoutSessionsParams(
        memberId: memberId,
        limit: _pageSize,
      ),
    );
    result.fold(
      (failure) => emit(WorkoutHistoryFailure(failureMessage(failure))),
      (page) {
        final items = page.items;
        emit(
          WorkoutHistoryLoaded(
            items: items,
            personalRecords: computePersonalRecords(items),
            totalVolumeKg: _sumCompletedVolume(items),
            nextCursor: page.nextCursor,
            hasMore: page.hasMore,
          ),
        );
      },
    );
  }

  Future<void> loadMore() async {
    final current = state;
    if (current is! WorkoutHistoryLoaded ||
        !current.hasMore ||
        current.loadingMore) {
      return;
    }
    emit(current.copyWith(loadingMore: true));
    final result = await _listSessions(
      ListWorkoutSessionsParams(
        memberId: _memberId,
        cursor: current.nextCursor,
        limit: _pageSize,
      ),
    );
    result.fold(
      (failure) => emit(current.copyWith(loadingMore: false)),
      (page) {
        final items = [...current.items, ...page.items];
        emit(
          WorkoutHistoryLoaded(
            items: items,
            personalRecords: computePersonalRecords(items),
            totalVolumeKg: _sumCompletedVolume(items),
            nextCursor: page.nextCursor,
            hasMore: page.hasMore,
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
