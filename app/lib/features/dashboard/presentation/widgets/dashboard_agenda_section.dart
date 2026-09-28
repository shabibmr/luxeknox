import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/error/failure_messages.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../core/router/routes.dart';
import '../../../../session/domain/entities/user_type.dart';
import '../../../scheduling/domain/entities/schedule_session.dart';
import '../cubit/dashboard_agenda_cubit.dart';
import '../dashboard_strings.dart';
import 'today_agenda_card.dart';
import 'upcoming_agenda_list.dart';

/// Member/trainer agenda block with its own loading, error, and empty states.
///
/// Failures here do not blank the rest of the dashboard.
class DashboardAgendaSection extends StatelessWidget {
  const DashboardAgendaSection({super.key});

  String _detailPath(UserType? role, String id) => switch (role) {
    UserType.trainer => Routes.trainerScheduleById(id),
    UserType.admin => '${Routes.adminSchedules}/$id',
    _ => Routes.memberScheduleById(id),
  };

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardAgendaCubit, DashboardAgendaState>(
      builder: (context, state) {
        final role = state.role;
        if (role != UserType.member && role != UserType.trainer) {
          return const SizedBox.shrink();
        }

        if (state.status == LoadStatus.loading && !state.hasLoaded) {
          return const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Card(
              key: Key('agenda_section_loading'),
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
          );
        }

        if (state.status == LoadStatus.failure && !state.hasLoaded) {
          final message = state.failure == null
              ? DashboardStrings.agendaError
              : failureMessage(state.failure!);
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Card(
              key: const Key('agenda_section_error'),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DashboardStrings.agendaSectionTitle,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(message),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: () =>
                          context.read<DashboardAgendaCubit>().refresh(),
                      child: const Text(DashboardStrings.retry),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        void openSession(ScheduleSession session) {
          context.go(_detailPath(role, session.id));
        }

        final todayTitle = role == UserType.trainer
            ? DashboardStrings.todayAgendaTrainerTitle
            : DashboardStrings.todayAgendaMemberTitle;
        final todayEmpty = role == UserType.trainer
            ? DashboardStrings.todayAgendaTrainerEmpty
            : DashboardStrings.todayAgendaMemberEmpty;

        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TodayAgendaCard(
                items: state.todayItems,
                title: todayTitle,
                emptyMessage: todayEmpty,
                onTapSession: openSession,
              ),
              const SizedBox(height: 12),
              UpcomingAgendaList(
                items: state.upcomingItems,
                onTapSession: openSession,
              ),
            ],
          ),
        );
      },
    );
  }
}
