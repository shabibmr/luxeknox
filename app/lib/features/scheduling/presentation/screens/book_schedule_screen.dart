import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/idempotency/idempotency_key.dart';
import '../../../../core/widgets/app_empty_view.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../../session/presentation/session_cubit.dart';
import '../../domain/entities/schedule_enums.dart';
import '../../domain/usecases/schedule_usecases.dart';
import '../cubit/schedule_calendar_cubit.dart';
import '../scheduling_strings.dart';

/// Member booking surface: lists upcoming sessions and books with idempotency.
class BookScheduleScreen extends StatelessWidget {
  const BookScheduleScreen({super.key, required this.isPt});

  final bool isPt;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ScheduleCalendarCubit>()..load(),
      child: _BookScheduleBody(isPt: isPt),
    );
  }
}

class _BookScheduleBody extends StatelessWidget {
  const _BookScheduleBody({required this.isPt});

  final bool isPt;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isPt
              ? SchedulingStrings.bookPtTitle
              : SchedulingStrings.bookClassTitle,
        ),
      ),
      body: BlocBuilder<ScheduleCalendarCubit, ScheduleCalendarState>(
        builder: (context, state) {
          return switch (state) {
            ScheduleCalendarLoading() => const AppLoading(),
            ScheduleCalendarFailure(:final message) => AppErrorView(
              message: message,
              onRetry: () => context.read<ScheduleCalendarCubit>().load(),
            ),
            ScheduleCalendarLoaded(:final items) => () {
              final open = items
                  .where(
                    (s) =>
                        s.status == ScheduleSessionStatus.scheduled &&
                        !s.isFull,
                  )
                  .toList();
              if (open.isEmpty) {
                return const AppEmptyView(message: SchedulingStrings.noneFound);
              }
              return ListView.builder(
                itemCount: open.length,
                itemBuilder: (context, index) {
                  final session = open[index];
                  return ListTile(
                    title: Text(session.title),
                    subtitle: Text(session.startTime.toString()),
                    trailing: _BookAction(scheduleId: session.id),
                    onTap: () => context.go('/schedule/${session.id}'),
                  );
                },
              );
            }(),
          };
        },
      ),
    );
  }
}

class _BookAction extends StatefulWidget {
  const _BookAction({required this.scheduleId});

  final String scheduleId;

  @override
  State<_BookAction> createState() => _BookActionState();
}

class _BookActionState extends State<_BookAction> {
  bool _inFlight = false;
  String? _key;

  Future<void> _book() async {
    if (_inFlight) return;
    final session = context.read<SessionCubit>().state;
    if (session is! SessionAuthenticated) return;
    setState(() => _inFlight = true);
    _key ??= newIdempotencyKey();
    final result = await getIt<BookScheduleUseCase>()(
      BookScheduleParams(
        scheduleId: widget.scheduleId,
        memberId: session.principal.profileId,
        idempotencyKey: _key!,
      ),
    );
    if (!mounted) return;
    result.fold(
      (failure) {
        setState(() => _inFlight = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(failureMessage(failure))),
        );
      },
      (participant) {
        _key = null;
        setState(() => _inFlight = false);
        final msg = participant.bookingStatus == BookingStatus.waitlisted
            ? SchedulingStrings.waitlistedSuccess
            : SchedulingStrings.bookSuccess;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(msg)));
        context.read<ScheduleCalendarCubit>().load();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: _inFlight ? null : _book,
      child: Text(
        _inFlight ? SchedulingStrings.submitting : SchedulingStrings.book,
      ),
    );
  }
}
