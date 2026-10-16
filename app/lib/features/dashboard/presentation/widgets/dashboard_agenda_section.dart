import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/error/failure_messages.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../core/router/routes.dart';
import '../../../../session/domain/entities/user_type.dart';
import '../../../scheduling/domain/entities/schedule_enums.dart';
import '../../../scheduling/domain/entities/schedule_session.dart';
import '../../../workout/presentation/workout_strings.dart';
import '../cubit/dashboard_agenda_cubit.dart';
import '../dashboard_strings.dart';
import 'dashboard_skeleton.dart';
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
            child: DashboardSkeletonCard(
              key: Key('agenda_section_loading'),
              height: 168,
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

        final schedulePath = role == UserType.trainer
            ? Routes.trainerSchedule
            : Routes.memberSchedule;

        final todayTitle = role == UserType.trainer
            ? DashboardStrings.todayAgendaTrainerTitle
            : DashboardStrings.todayAgendaMemberTitle;
        final todayEmpty = role == UserType.trainer
            ? DashboardStrings.todayAgendaTrainerEmpty
            : DashboardStrings.todayAgendaMemberEmpty;

        ScheduleSession? attendedSession;
        ScheduleParticipantEntry? attendedParticipant;
        if (role == UserType.trainer) {
          for (final s in state.todayItems) {
            if (s.status == ScheduleSessionStatus.cancelled ||
                s.status == ScheduleSessionStatus.completed) {
              continue;
            }
            for (final p in s.participants) {
              if (p.attended == true) {
                attendedSession = s;
                attendedParticipant = p;
                break;
              }
            }
            if (attendedSession != null) break;
          }
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (attendedSession != null && attendedParticipant != null) ...[
                Card(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.notifications_active,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              WorkoutStrings.sessionAlertTitle,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Member is checked in for "${attendedSession.title}"! Ready to start.',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer,
                              ),
                        ),
                        const SizedBox(height: 12),
                        FilledButton.icon(
                          icon: const Icon(Icons.play_circle_fill),
                          label: const Text(WorkoutStrings.startWorkoutCTA),
                          onPressed: () {
                            context.go(
                              Routes.trainerMembersWorkoutActiveById(
                                attendedParticipant!.memberId,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
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
              const SizedBox(height: 4),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () => context.go(schedulePath),
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text(DashboardStrings.viewSchedule),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
