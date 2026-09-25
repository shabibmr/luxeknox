import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../core/widgets/app_empty_view.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../../session/presentation/session_cubit.dart';
import '../../domain/entities/schedule_enums.dart';
import '../bloc/book_schedule_bloc.dart';
import '../cubit/schedule_calendar_cubit.dart';
import '../scheduling_strings.dart';

/// Member booking surface: lists upcoming sessions and books with idempotency.
class BookScheduleScreen extends StatelessWidget {
  const BookScheduleScreen({super.key, required this.isPt});

  final bool isPt;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<ScheduleCalendarCubit>()..load(),
        ),
        BlocProvider(create: (_) => getIt<BookScheduleBloc>()),
      ],
      child: _BookScheduleBody(isPt: isPt),
    );
  }
}

class _BookScheduleBody extends StatelessWidget {
  const _BookScheduleBody({required this.isPt});

  final bool isPt;

  @override
  Widget build(BuildContext context) {
    return BlocListener<BookScheduleBloc, BookScheduleState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == LoadStatus.failure && state.failure != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(failureMessage(state.failure!))),
          );
          return;
        }
        final participant = state.participant;
        if (state.status == LoadStatus.success && participant != null) {
          final msg = participant.bookingStatus == BookingStatus.waitlisted
              ? SchedulingStrings.waitlistedSuccess
              : SchedulingStrings.bookSuccess;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(msg)),
          );
          context.read<ScheduleCalendarCubit>().load();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            isPt
                ? SchedulingStrings.bookPtTitle
                : SchedulingStrings.bookClassTitle,
          ),
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
            final open = state.items
                .where(
                  (s) =>
                      s.status == ScheduleSessionStatus.scheduled && !s.isFull,
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
          },
        ),
      ),
    );
  }
}

class _BookAction extends StatelessWidget {
  const _BookAction({required this.scheduleId});

  final String scheduleId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookScheduleBloc, BookScheduleState>(
      builder: (context, state) {
        final submitting = state.status == LoadStatus.loading;
        return TextButton(
          onPressed: submitting ? null : () => _book(context),
          child: Text(
            submitting && state.scheduleId == scheduleId
                ? SchedulingStrings.submitting
                : SchedulingStrings.book,
          ),
        );
      },
    );
  }

  void _book(BuildContext context) {
    final session = context.read<SessionCubit>().state;
    if (session is! SessionAuthenticated) return;
    context.read<BookScheduleBloc>().add(
      BookScheduleRequested(
        scheduleId: scheduleId,
        memberId: session.principal.profileId,
      ),
    );
  }
}
