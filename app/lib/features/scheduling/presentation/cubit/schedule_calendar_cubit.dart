import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failure_messages.dart';
import '../../domain/entities/schedule_session.dart';
import '../../domain/usecases/schedule_usecases.dart';

sealed class ScheduleCalendarState extends Equatable {
  const ScheduleCalendarState();

  @override
  List<Object?> get props => [];
}

final class ScheduleCalendarLoading extends ScheduleCalendarState {
  const ScheduleCalendarLoading();
}

final class ScheduleCalendarLoaded extends ScheduleCalendarState {
  const ScheduleCalendarLoaded({
    required this.items,
    required this.from,
    required this.to,
  });

  final List<ScheduleSession> items;
  final DateTime from;
  final DateTime to;

  @override
  List<Object?> get props => [items, from, to];
}

final class ScheduleCalendarFailure extends ScheduleCalendarState {
  const ScheduleCalendarFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

@injectable
class ScheduleCalendarCubit extends Cubit<ScheduleCalendarState> {
  ScheduleCalendarCubit(this._listSchedules)
    : super(const ScheduleCalendarLoading());

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
    emit(const ScheduleCalendarLoading());
    final result = await _listSchedules(
      ListSchedulesParams(
        from: _from,
        to: _to,
        trainerId: _trainerId,
        memberId: _memberId,
      ),
    );
    result.fold(
      (failure) => emit(ScheduleCalendarFailure(failureMessage(failure))),
      (page) => emit(
        ScheduleCalendarLoaded(items: page.items, from: _from!, to: _to!),
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
