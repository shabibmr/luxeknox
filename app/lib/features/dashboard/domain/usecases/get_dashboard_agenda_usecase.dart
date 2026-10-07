import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/time/gym_timezone_provider.dart';
import '../../../scheduling/domain/entities/schedule_enums.dart';
import '../../../scheduling/domain/entities/schedule_session.dart';
import '../../../scheduling/domain/usecases/schedule_usecases.dart';
import '../../../session/domain/entities/user_type.dart';

const int kDashboardAgendaDaySpan = 8;

class DashboardAgendaResult extends Equatable {
  const DashboardAgendaResult({
    required this.today,
    required this.upcoming,
  });

  final List<ScheduleSession> today;
  final List<ScheduleSession> upcoming;

  @override
  List<Object?> get props => [today, upcoming];
}

/// Owns the dashboard agenda business rules so the presentation cubit only
/// coordinates loading and state transitions.
class GetDashboardAgendaUseCase {
  const GetDashboardAgendaUseCase(this._listSchedules, this._timezoneProvider);

  final ListSchedulesUseCase _listSchedules;
  final GymTimezoneProvider? _timezoneProvider;

  Future<Either<Failure, DashboardAgendaResult>> call({
    required UserType role,
    required String profileId,
  }) async {
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

    return result.map((page) {
      final items =
          page.items
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

      return DashboardAgendaResult(today: today, upcoming: upcoming);
    });
  }

  static bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}
