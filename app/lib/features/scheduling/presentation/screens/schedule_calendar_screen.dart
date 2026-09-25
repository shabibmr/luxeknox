import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/widgets/app_empty_view.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../../session/domain/entities/user_type.dart';
import '../../../../session/presentation/session_cubit.dart';
import '../cubit/schedule_calendar_cubit.dart';
import '../schedule_role.dart';
import '../scheduling_strings.dart';

export '../schedule_role.dart';

class ScheduleCalendarScreen extends StatelessWidget {
  const ScheduleCalendarScreen({
    super.key,
    required this.role,
    this.memberId,
    this.trainerId,
  });

  final ScheduleCalendarRole role;

  /// When set (e.g. trainer viewing a client's schedule), filters by this
  /// member and skips auto-resolving the viewer's own profile id.
  final String? memberId;
  final String? trainerId;

  @override
  Widget build(BuildContext context) {
    final session = context.read<SessionCubit>().state;
    var resolvedTrainerId = trainerId;
    var resolvedMemberId = memberId;
    if (session is SessionAuthenticated) {
      if (resolvedMemberId == null &&
          resolvedTrainerId == null &&
          role == ScheduleCalendarRole.trainer &&
          session.principal.userType == UserType.trainer) {
        resolvedTrainerId = session.principal.profileId;
      }
      if (resolvedMemberId == null &&
          role == ScheduleCalendarRole.member &&
          session.principal.userType == UserType.member) {
        resolvedMemberId = session.principal.profileId;
      }
    }

    return BlocProvider(
      create: (_) => getIt<ScheduleCalendarCubit>()
        ..load(trainerId: resolvedTrainerId, memberId: resolvedMemberId),
      child: _ScheduleCalendarBody(role: role),
    );
  }
}

class _ScheduleCalendarBody extends StatelessWidget {
  const _ScheduleCalendarBody({required this.role});

  final ScheduleCalendarRole role;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(SchedulingStrings.calendarTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () =>
                context.read<ScheduleCalendarCubit>().shiftRange(-7),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () =>
                context.read<ScheduleCalendarCubit>().shiftRange(7),
          ),
          if (role == ScheduleCalendarRole.member) ...[
            IconButton(
              tooltip: SchedulingStrings.bookPtTitle,
              icon: const Icon(Icons.person_add_alt),
              onPressed: () => context.go(Routes.memberScheduleBookPt),
            ),
            IconButton(
              tooltip: SchedulingStrings.bookClassTitle,
              icon: const Icon(Icons.groups_outlined),
              onPressed: () => context.go(Routes.memberScheduleBookClass),
            ),
          ],
          if (role == ScheduleCalendarRole.trainer)
            IconButton(
              tooltip: SchedulingStrings.availabilityTitle,
              icon: const Icon(Icons.event_available_outlined),
              onPressed: () => context.go(Routes.trainerScheduleAvailability),
            ),
          if (role == ScheduleCalendarRole.admin)
            IconButton(
              tooltip: SchedulingStrings.facilitiesTitle,
              icon: const Icon(Icons.apartment_outlined),
              onPressed: () => context.go('${Routes.adminSchedules}/facilities'),
            ),
        ],
      ),
      body: BlocBuilder<ScheduleCalendarCubit, ScheduleCalendarState>(
        builder: (context, state) {
          if (state.status == LoadStatus.loading && !state.hasLoaded) {
            return const AppLoading();
          }
          if (state.status == LoadStatus.failure && !state.hasLoaded) {
            return AppErrorView(
              message: state.failure == null
                  ? 'Something went wrong'
                  : failureMessage(state.failure!),
              onRetry: () => context.read<ScheduleCalendarCubit>().load(),
            );
          }
          final items = state.items;
          final from = state.from;
          final to = state.to;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  from == null || to == null
                      ? ''
                      : '${from.toIso8601String().split('T').first} → '
                            '${to.toIso8601String().split('T').first}',
                ),
              ),
              Expanded(
                child: items.isEmpty
                    ? const AppEmptyView(message: SchedulingStrings.noneFound)
                    : RefreshIndicator(
                        onRefresh: () =>
                            context.read<ScheduleCalendarCubit>().load(),
                        child: ListView.builder(
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            final session = items[index];
                            return ListTile(
                              title: Text(session.title),
                              subtitle: Text(
                                '${session.startTime.toLocal()} · '
                                '${session.status.name}'
                                '${session.isFull ? ' · full' : ''}',
                              ),
                              onTap: () {
                                final path = switch (role) {
                                  ScheduleCalendarRole.member =>
                                    '/schedule/${session.id}',
                                  ScheduleCalendarRole.trainer =>
                                    '/trainer/schedule/${session.id}',
                                  ScheduleCalendarRole.admin =>
                                    '${Routes.adminSchedules}/${session.id}',
                                };
                                context.go(path);
                              },
                            );
                          },
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
