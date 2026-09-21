import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failure_messages.dart';
import '../../domain/entities/schedule_session.dart';
import '../../domain/usecases/schedule_usecases.dart';

sealed class TodaysSessionsState extends Equatable {
  const TodaysSessionsState();

  @override
  List<Object?> get props => [];
}

final class TodaysSessionsLoading extends TodaysSessionsState {
  const TodaysSessionsLoading();
}

final class TodaysSessionsLoaded extends TodaysSessionsState {
  const TodaysSessionsLoaded(this.items);

  final List<ScheduleSession> items;

  @override
  List<Object?> get props => [items];
}

final class TodaysSessionsFailure extends TodaysSessionsState {
  const TodaysSessionsFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

@injectable
class TodaysSessionsCubit extends Cubit<TodaysSessionsState> {
  TodaysSessionsCubit(this._listSchedules)
    : super(const TodaysSessionsLoading());

  final ListSchedulesUseCase _listSchedules;

  String? _trainerId;

  Future<void> load({String? trainerId}) async {
    _trainerId = trainerId ?? _trainerId;
    emit(const TodaysSessionsLoading());
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
      (failure) => emit(TodaysSessionsFailure(failureMessage(failure))),
      (page) {
        final items = [...page.items]
          ..sort((a, b) => a.startTime.compareTo(b.startTime));
        emit(TodaysSessionsLoaded(items));
      },
    );
  }
}
