import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/extensions/capability_extension.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../../session/presentation/session_cubit.dart';
import '../../../attendance/presentation/attendance_strings.dart';
import '../../domain/entities/schedule_enums.dart';
import '../cubit/schedule_detail_cubit.dart';
import '../schedule_role.dart';
import '../scheduling_strings.dart';
import '../widgets/move_booking_sheet.dart';
import '../widgets/reschedule_sheet.dart';

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

  bool _memberIsBooked(ScheduleDetailState state, String? memberId) {
    if (memberId == null || state.session == null) return false;
    return state.session!.participants.any(
      (p) =>
          p.memberId == memberId && p.bookingStatus == BookingStatus.booked,
    );
  }

  Future<void> _openReschedule(BuildContext context) async {
    final session = context.read<ScheduleDetailCubit>().state.session;
    if (session == null) return;
    await showRescheduleSheet(context: context, session: session);
  }

  Future<void> _openMoveBooking(
    BuildContext context, {
    required String memberId,
  }) async {
    final session = context.read<ScheduleDetailCubit>().state.session;
    if (session == null) return;
    final moved = await showMoveBookingSheet(
      context: context,
      session: session,
      memberId: memberId,
    );
    if (!context.mounted) return;
    final target =
        context.read<ScheduleDetailCubit>().state.movedToScheduleId;
    if (moved == true && target != null) {
      context.go(Routes.memberScheduleById(target));
    }
  }

  @override
  Widget build(BuildContext context) {
    final canWrite = context.can('schedules.write');
    final canBook = context.can('schedules.book');
    final canCancelBooking = context.can('schedules.cancel');
    final showReschedule = role.canRescheduleSession && canWrite;
    final showMove =
        role.canMoveBooking && canBook && canCancelBooking;

    return BlocConsumer<ScheduleDetailCubit, ScheduleDetailState>(
      listenWhen: (previous, current) {
        final messageShown =
            current.message != null && current.message != previous.message;
        final actionFailed =
            current.session != null &&
            current.status == LoadStatus.failure &&
            current.failure != previous.failure;
        final conflict =
            current.isConflict && current.isConflict != previous.isConflict;
        return messageShown || actionFailed || conflict;
      },
      listener: (context, state) {
        final text = state.message ??
            (state.failure == null ? null : failureMessage(state.failure!));
        if (text == null) return;
        final messenger = ScaffoldMessenger.of(context);
        messenger.hideCurrentSnackBar();
        messenger.showSnackBar(
          SnackBar(
            content: Text(text),
            action: state.isConflict
                ? SnackBarAction(
                    label: SchedulingStrings.retryReschedule,
                    onPressed: () => _openReschedule(context),
                  )
                : null,
          ),
        );
      },
      builder: (context, state) {
        final session = state.session;
        final actionInFlight = state.actionInFlight;
        final sessionState = context.read<SessionCubit>().state;
        final memberId = sessionState is SessionAuthenticated
            ? sessionState.principal.profileId
            : null;
        final memberBooked = _memberIsBooked(state, memberId);
        final canRescheduleNow = showReschedule &&
            session != null &&
            session.status == ScheduleSessionStatus.scheduled;
        final canMoveNow = showMove && memberBooked && session != null;

        return Scaffold(
          appBar: AppBar(
            title: const Text(SchedulingStrings.detailTitle),
            actions: [
              if (role == ScheduleCalendarRole.admin && session != null)
                IconButton(
                  key: const Key('admin_edit_schedule_action'),
                  icon: const Icon(Icons.edit),
                  onPressed: () async {
                    if (session.isRecurring) {
                      final scope = await showDialog<String>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title:
                              const Text(SchedulingStrings.editRecurringTitle),
                          content: const Text(
                            SchedulingStrings.editRecurringMessage,
                          ),
                          actions: [
                            TextButton(
                              key: const Key('edit_whole_series_button'),
                              onPressed: () => Navigator.of(ctx).pop('all'),
                              child:
                                  const Text(SchedulingStrings.editWholeSeries),
                            ),
                            FilledButton(
                              key: const Key('edit_this_session_button'),
                              onPressed: () => Navigator.of(ctx).pop('one'),
                              child: const Text(
                                SchedulingStrings.editThisSessionOnly,
                              ),
                            ),
                          ],
                        ),
                      );
                      if (scope == null || !context.mounted) return;
                      if (scope == 'all') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              SchedulingStrings.editSeriesNotSupported,
                            ),
                          ),
                        );
                        return;
                      }
                    }
                    final updated = await context.push<bool>(
                      Routes.adminSchedulesEditById(session.id),
                    );
                    if (updated == true && context.mounted) {
                      context.read<ScheduleDetailCubit>().load(scheduleId);
                    }
                  },
                ),
            ],
          ),
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
                    if (session.isRecurring) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.repeat, size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            SchedulingStrings.recurringSeries,
                            key: const Key('recurring_series_indicator'),
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
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
                                    child: const Text(
                                      SchedulingStrings.unbook,
                                    ),
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
                                if (memberId == null) return;
                                context.read<ScheduleDetailCubit>().book(
                                  memberId: memberId,
                                );
                              },
                        child: Text(
                          actionInFlight
                              ? SchedulingStrings.submitting
                              : SchedulingStrings.book,
                        ),
                      ),
                    if (canMoveNow) ...[
                      const SizedBox(height: 8),
                      OutlinedButton(
                        key: const Key('move_booking_button'),
                        onPressed: actionInFlight || memberId == null
                            ? null
                            : () => _openMoveBooking(
                                context,
                                memberId: memberId,
                              ),
                        child: const Text(SchedulingStrings.moveBooking),
                      ),
                    ],
                    if (canRescheduleNow) ...[
                      const SizedBox(height: 8),
                      OutlinedButton(
                        key: const Key('reschedule_button'),
                        onPressed: actionInFlight
                            ? null
                            : () => _openReschedule(context),
                        child: const Text(SchedulingStrings.reschedule),
                      ),
                    ],
                    if (role.canManageLifecycle) ...[
                      const SizedBox(height: 8),
                      OutlinedButton(
                        onPressed: actionInFlight
                            ? null
                            : () =>
                                context.read<ScheduleDetailCubit>().start(),
                        child: const Text(SchedulingStrings.startSession),
                      ),
                      const SizedBox(height: 8),
                      OutlinedButton(
                        onPressed: actionInFlight
                            ? null
                            : () => context
                                .read<ScheduleDetailCubit>()
                                .complete(),
                        child: const Text(SchedulingStrings.completeSession),
                      ),
                    ],
                    if (role.canCancelSession) ...[
                      const SizedBox(height: 8),
                      TextButton(
                        key: const Key('cancel_session_button'),
                        onPressed: actionInFlight
                            ? null
                            : () async {
                                if (session.isRecurring) {
                                  final cancelSeries =
                                      await showDialog<bool>(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: const Text(
                                        SchedulingStrings.cancelRecurringTitle,
                                      ),
                                      content: const Text(
                                        SchedulingStrings
                                            .cancelRecurringMessage,
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(ctx).pop(null),
                                          child: const Text('Dismiss'),
                                        ),
                                        TextButton(
                                          key: const Key(
                                            'cancel_this_session_button',
                                          ),
                                          onPressed: () =>
                                              Navigator.of(ctx).pop(false),
                                          child: const Text(
                                            SchedulingStrings
                                                .cancelThisSessionOnly,
                                          ),
                                        ),
                                        FilledButton(
                                          key: const Key(
                                            'cancel_all_series_button',
                                          ),
                                          onPressed: () =>
                                              Navigator.of(ctx).pop(true),
                                          child: const Text(
                                            SchedulingStrings
                                                .cancelAllFutureSessions,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                  if (cancelSeries != null &&
                                      context.mounted) {
                                    context
                                        .read<ScheduleDetailCubit>()
                                        .cancel(cancelSeries: cancelSeries);
                                  }
                                } else {
                                  context.read<ScheduleDetailCubit>().cancel();
                                }
                              },
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
