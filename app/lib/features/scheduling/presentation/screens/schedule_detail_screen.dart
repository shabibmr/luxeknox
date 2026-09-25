import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../../session/presentation/session_cubit.dart';
import '../../../attendance/presentation/attendance_strings.dart';
import '../../domain/entities/schedule_enums.dart';
import '../cubit/schedule_detail_cubit.dart';
import '../schedule_role.dart';
import '../scheduling_strings.dart';

class ScheduleDetailScreen extends StatelessWidget {
  const ScheduleDetailScreen({
    super.key,
    required this.scheduleId,
    required this.role,
  });

  final String scheduleId;
  final ScheduleCalendarRole role;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ScheduleDetailCubit>()..load(scheduleId),
      child: _ScheduleDetailBody(scheduleId: scheduleId, role: role),
    );
  }
}

class _ScheduleDetailBody extends StatelessWidget {
  const _ScheduleDetailBody({required this.scheduleId, required this.role});

  final String scheduleId;
  final ScheduleCalendarRole role;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ScheduleDetailCubit, ScheduleDetailState>(
      listenWhen: (previous, current) {
        final messageShown =
            current.message != null && current.message != previous.message;
        final actionFailed =
            current.session != null &&
            current.status == LoadStatus.failure &&
            current.failure != previous.failure;
        return messageShown || actionFailed;
      },
      listener: (context, state) {
        final text =
            state.message ??
            (state.failure == null ? null : failureMessage(state.failure!));
        if (text == null) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(text)));
      },
      builder: (context, state) {
        final session = state.session;
        final actionInFlight = state.actionInFlight;
        return Scaffold(
          appBar: AppBar(title: const Text(SchedulingStrings.detailTitle)),
          body: session == null
              ? state.status == LoadStatus.failure
                    ? AppErrorView(
                        message: state.failure == null
                            ? 'Something went wrong'
                            : failureMessage(state.failure!),
                        onRetry: () => context
                            .read<ScheduleDetailCubit>()
                            .load(scheduleId),
                      )
                    : state.status == LoadStatus.loading
                    ? const AppLoading()
                    : const SizedBox.shrink()
              : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Text(
                    session.title,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text('${session.startTime} → ${session.endTime}'),
                  Text('Status: ${session.status.name}'),
                  if (session.maxCapacity != null)
                    Text(
                      'Capacity: ${session.bookedCount}/${session.maxCapacity}'
                      '${session.isFull ? ' (full)' : ''}',
                    ),
                  const SizedBox(height: 16),
                  Text(
                    SchedulingStrings.roster,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  ...session.participants
                      .where((p) => p.bookingStatus == BookingStatus.booked)
                      .map(
                        (p) => ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text('Member #${p.memberId}'),
                          subtitle: p.attended == null
                              ? null
                              : Text(
                                  p.attended!
                                      ? AttendanceStrings.markAttended
                                      : AttendanceStrings.markNoShow,
                                ),
                          trailing: role.canManageLifecycle
                              ? Wrap(
                                  spacing: 4,
                                  children: [
                                    TextButton(
                                      onPressed: actionInFlight
                                          ? null
                                          : () => context
                                              .read<ScheduleDetailCubit>()
                                              .markAttendance(
                                                participantId: p.id,
                                                attended: true,
                                              ),
                                      child: const Text(
                                        AttendanceStrings.markAttended,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: actionInFlight
                                          ? null
                                          : () => context
                                              .read<ScheduleDetailCubit>()
                                              .markAttendance(
                                                participantId: p.id,
                                                attended: false,
                                              ),
                                      child: const Text(
                                        AttendanceStrings.markNoShow,
                                      ),
                                    ),
                                    if (role.showBookActions)
                                      TextButton(
                                        onPressed: actionInFlight
                                            ? null
                                            : () => context
                                                .read<ScheduleDetailCubit>()
                                                .unbook(p.memberId),
                                        child: const Text(
                                          SchedulingStrings.unbook,
                                        ),
                                      ),
                                  ],
                                )
                              : role.showBookActions
                              ? TextButton(
                                  onPressed: actionInFlight
                                      ? null
                                      : () => context
                                          .read<ScheduleDetailCubit>()
                                          .unbook(p.memberId),
                                  child: const Text(SchedulingStrings.unbook),
                                )
                              : null,
                        ),
                      ),
                  const SizedBox(height: 8),
                  Text(
                    SchedulingStrings.waitlist,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  ...session.participants
                      .where(
                        (p) => p.bookingStatus == BookingStatus.waitlisted,
                      )
                      .map(
                        (p) => ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text('Member #${p.memberId}'),
                          trailing: role.showBookActions
                              ? TextButton(
                                  onPressed: actionInFlight
                                      ? null
                                      : () => context
                                          .read<ScheduleDetailCubit>()
                                          .unbook(p.memberId),
                                  child: const Text(
                                    SchedulingStrings.leaveWaitlist,
                                  ),
                                )
                              : null,
                        ),
                      ),
                  const SizedBox(height: 24),
                  if (role.showBookActions)
                    FilledButton(
                      onPressed: actionInFlight
                          ? null
                          : () {
                              final sessionState =
                                  context.read<SessionCubit>().state;
                              if (sessionState is! SessionAuthenticated) {
                                return;
                              }
                              context.read<ScheduleDetailCubit>().book(
                                memberId: sessionState.principal.profileId,
                              );
                            },
                      child: Text(
                        actionInFlight
                            ? SchedulingStrings.submitting
                            : SchedulingStrings.book,
                      ),
                    ),
                  if (role.canManageLifecycle) ...[
                    const SizedBox(height: 8),
                    OutlinedButton(
                      onPressed: actionInFlight
                          ? null
                          : () => context.read<ScheduleDetailCubit>().start(),
                      child: const Text(SchedulingStrings.startSession),
                    ),
                    const SizedBox(height: 8),
                    OutlinedButton(
                      onPressed: actionInFlight
                          ? null
                          : () =>
                              context.read<ScheduleDetailCubit>().complete(),
                      child: const Text(SchedulingStrings.completeSession),
                    ),
                  ],
                  if (role.canCancelSession) ...[
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: actionInFlight
                          ? null
                          : () => context.read<ScheduleDetailCubit>().cancel(),
                      child: const Text(SchedulingStrings.cancelSession),
                    ),
                  ],
                ],
              ),
        );
      },
    );
  }
}
