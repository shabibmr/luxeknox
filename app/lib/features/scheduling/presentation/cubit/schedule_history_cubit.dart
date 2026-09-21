import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failure_messages.dart';
import '../../domain/entities/schedule_enums.dart';
import '../../domain/entities/schedule_session.dart';
import '../../domain/usecases/schedule_usecases.dart';

sealed class ScheduleHistoryState extends Equatable {
  const ScheduleHistoryState();

  @override
  List<Object?> get props => [];
}

final class ScheduleHistoryLoading extends ScheduleHistoryState {
  const ScheduleHistoryLoading();
}

final class ScheduleHistoryLoaded extends ScheduleHistoryState {
  const ScheduleHistoryLoaded({
    required this.items,
    this.nextCursor,
    this.hasMore = false,
    this.loadingMore = false,
  });

  final List<ScheduleSession> items;
  final String? nextCursor;
  final bool hasMore;
  final bool loadingMore;

  ScheduleHistoryLoaded copyWith({
    List<ScheduleSession>? items,
    String? nextCursor,
    bool? hasMore,
    bool? loadingMore,
  }) {
    return ScheduleHistoryLoaded(
      items: items ?? this.items,
      nextCursor: nextCursor ?? this.nextCursor,
      hasMore: hasMore ?? this.hasMore,
      loadingMore: loadingMore ?? this.loadingMore,
    );
  }

  @override
  List<Object?> get props => [items, nextCursor, hasMore, loadingMore];
}

final class ScheduleHistoryFailure extends ScheduleHistoryState {
  const ScheduleHistoryFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

/// Past (completed / cancelled) sessions for a member or trainer —
/// backs the Schedule History screens for both roles.
@injectable
class ScheduleHistoryCubit extends Cubit<ScheduleHistoryState> {
  ScheduleHistoryCubit(this._listSchedules) : super(const ScheduleHistoryLoading());

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
    emit(const ScheduleHistoryLoading());
    final result = await _listSchedules(
      ListSchedulesParams(
        memberId: memberId,
        trainerId: trainerId,
        limit: _pageSize,
      ),
    );
    result.fold(
      (failure) => emit(ScheduleHistoryFailure(failureMessage(failure))),
      (page) {
        final items = page.items.where(_isPast).toList()
          ..sort((a, b) => b.startTime.compareTo(a.startTime));
        emit(
          ScheduleHistoryLoaded(
            items: items,
            nextCursor: page.nextCursor,
            hasMore: page.hasMore,
          ),
        );
      },
    );
  }

  Future<void> loadMore() async {
    final current = state;
    if (current is! ScheduleHistoryLoaded ||
        !current.hasMore ||
        current.loadingMore) {
      return;
    }
    emit(current.copyWith(loadingMore: true));
    final result = await _listSchedules(
      ListSchedulesParams(
        memberId: _memberId,
        trainerId: _trainerId,
        cursor: current.nextCursor,
        limit: _pageSize,
      ),
    );
    result.fold(
      (failure) => emit(current.copyWith(loadingMore: false)),
      (page) {
        final merged = [...current.items, ...page.items.where(_isPast)]
          ..sort((a, b) => b.startTime.compareTo(a.startTime));
        emit(
          ScheduleHistoryLoaded(
            items: merged,
            nextCursor: page.nextCursor,
            hasMore: page.hasMore,
          ),
        );
      },
    );
  }
}
