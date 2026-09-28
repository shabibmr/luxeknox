import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../core/time/gym_timezone_provider.dart';
import '../../../../session/domain/entities/user_type.dart';
import '../../../scheduling/domain/entities/schedule_enums.dart';
import '../../../scheduling/domain/entities/schedule_session.dart';
import '../../../scheduling/domain/usecases/schedule_usecases.dart';

part 'dashboard_agenda_cubit.freezed.dart';

/// Agenda window: calendar today through the next 7 days (8 days total).
const int kDashboardAgendaDaySpan = 8;

@freezed
abstract class DashboardAgendaState with _$DashboardAgendaState {
  const factory DashboardAgendaState({
    @Default(LoadStatus.initial) LoadStatus status,
    @Default(<ScheduleSession>[]) List<ScheduleSession> todayItems,
    @Default(<ScheduleSession>[]) List<ScheduleSession> upcomingItems,
    /// True after a successful fetch, so an empty agenda is still data.
    @Default(false) bool hasLoaded,
    UserType? role,
    Failure? failure,
  }) = _DashboardAgendaState;
}

@injectable
class DashboardAgendaCubit extends Cubit<DashboardAgendaState> {
  DashboardAgendaCubit(
    this._listSchedules, [
    this._timezoneProvider,
  ]) : super(const DashboardAgendaState());

  final ListSchedulesUseCase _listSchedules;
  final GymTimezoneProvider? _timezoneProvider;

  UserType? _role;
  String? _profileId;

  /// Loads today + next 7 days via [ListSchedulesUseCase].
  ///
  /// Member: filters with [memberId] (my bookings).
  /// Trainer: filters with [trainerId] (my sessions).
  /// Other roles: emits an empty success state (section is hidden by the UI).
  Future<void> load({
    required UserType role,
    required String profileId,
  }) async {
    _role = role;
    _profileId = profileId;

    if (role != UserType.member && role != UserType.trainer) {
      emit(
        DashboardAgendaState(
          status: LoadStatus.success,
          hasLoaded: true,
          role: role,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: LoadStatus.loading,
        failure: null,
        role: role,
      ),
    );

    final tz = await _timezoneProvider?.timezone();
    final offset =
        _timezoneProvider?.getOffset(tz) ?? DateTime.now().timeZoneOffset;

    final utcNow = DateTime.now().toUtc();
    final gymNow = utcNow.add(offset);
    final from = DateTime(gymNow.year, gymNow.month, gymNow.day);
    final to = from.add(const Duration(days: kDashboardAgendaDaySpan));
    final result = await _listSchedules(
      ListSchedulesParams(
        from: from,
        to: to,
        trainerId: role == UserType.trainer ? profileId : null,
        memberId: role == UserType.member ? profileId : null,
        limit: 100,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: LoadStatus.failure,
          failure: failure,
          role: role,
        ),
      ),
      (page) {
        final items = page.items
            .where((s) => s.status != ScheduleSessionStatus.cancelled)
            .toList()
          ..sort((a, b) => a.startTime.compareTo(b.startTime));

        final today = <ScheduleSession>[];
        final upcoming = <ScheduleSession>[];
        for (final session in items) {
          final sessionGymTime = session.startTime.isUtc
              ? session.startTime.add(offset)
              : session.startTime.toUtc().add(offset);
          if (_isSameDay(sessionGymTime, from)) {
            today.add(session);
          } else if (sessionGymTime.isAfter(from)) {
            upcoming.add(session);
          }
        }

        emit(
          state.copyWith(
            status: LoadStatus.success,
            failure: null,
            todayItems: today,
            upcomingItems: upcoming,
            hasLoaded: true,
            role: role,
          ),
        );
      },
    );
  }

  Future<void> refresh() async {
    final role = _role;
    final profileId = _profileId;
    if (role == null || profileId == null) return;
    await load(role: role, profileId: profileId);
  }

  static bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}
