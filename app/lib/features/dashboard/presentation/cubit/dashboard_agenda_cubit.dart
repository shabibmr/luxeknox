import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../core/time/gym_timezone_provider.dart';
import '../../../../session/domain/entities/user_type.dart';
import '../../domain/usecases/get_dashboard_agenda_usecase.dart';
import '../../../scheduling/domain/entities/schedule_session.dart';
import '../../../scheduling/domain/usecases/schedule_usecases.dart';

part 'dashboard_agenda_cubit.freezed.dart';

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
  DashboardAgendaCubit(this._listSchedules, [GymTimezoneProvider? timezoneProvider])
    : _getAgenda = GetDashboardAgendaUseCase(_listSchedules, timezoneProvider),
      super(const DashboardAgendaState());

  final ListSchedulesUseCase _listSchedules;
  final GetDashboardAgendaUseCase _getAgenda;

  UserType? _role;
  String? _profileId;

  /// Loads today + next 7 days via [ListSchedulesUseCase].
  ///
  /// Member: filters with [memberId] (my bookings).
  /// Trainer: filters with [trainerId] (my sessions).
  /// Other roles: emits an empty success state (section is hidden by the UI).
  Future<void> load({required UserType role, required String profileId}) async {
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

    emit(state.copyWith(status: LoadStatus.loading, failure: null, role: role));

    final result = await _getAgenda(role: role, profileId: profileId);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: LoadStatus.failure,
          failure: failure,
          role: role,
        ),
      ),
      (agenda) => emit(
        state.copyWith(
          status: LoadStatus.success,
          failure: null,
          todayItems: agenda.today,
          upcomingItems: agenda.upcoming,
          hasLoaded: true,
          role: role,
        ),
      ),
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
