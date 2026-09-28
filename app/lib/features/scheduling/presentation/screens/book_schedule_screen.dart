import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../core/widgets/app_empty_view.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../../session/presentation/session_cubit.dart';
import '../../domain/entities/open_slot.dart';
import '../../domain/entities/schedule_enums.dart';
import '../bloc/book_schedule_bloc.dart';
import '../cubit/open_slots_cubit.dart';
import '../cubit/schedule_calendar_cubit.dart';
import '../scheduling_strings.dart';
import '../widgets/open_slots_picker.dart';

/// Member booking surface: PT uses open-slot picker; classes list upcoming sessions.
class BookScheduleScreen extends StatelessWidget {
  const BookScheduleScreen({
    super.key,
    required this.isPt,
    @visibleForTesting this.openSlotsCubit,
    @visibleForTesting this.bookBloc,
    @visibleForTesting this.calendarCubit,
  });

  final bool isPt;

  /// Test seam; production uses DI.
  final OpenSlotsCubit? openSlotsCubit;
  final BookScheduleBloc? bookBloc;
  final ScheduleCalendarCubit? calendarCubit;

  @override
  Widget build(BuildContext context) {
    if (isPt) {
      return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => openSlotsCubit ?? getIt<OpenSlotsCubit>(),
          ),
          BlocProvider(
            create: (_) => bookBloc ?? getIt<BookScheduleBloc>(),
          ),
        ],
        child: const _BookPtBody(),
      );
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) {
            final cubit = calendarCubit ?? getIt<ScheduleCalendarCubit>();
            if (calendarCubit == null) {
              cubit.load();
            }
            return cubit;
          },
        ),
        BlocProvider(
          create: (_) => bookBloc ?? getIt<BookScheduleBloc>(),
        ),
      ],
      child: const _BookClassBody(),
    );
  }
}

class _BookPtBody extends StatefulWidget {
  const _BookPtBody();

  @override
  State<_BookPtBody> createState() => _BookPtBodyState();
}

class _BookPtBodyState extends State<_BookPtBody> {
  BookableOpenSlot? _selected;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final session = context.read<SessionCubit>().state;
      if (session is! SessionAuthenticated) return;
      context.read<OpenSlotsCubit>().load(session.principal.profileId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BookScheduleBloc, BookScheduleState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == LoadStatus.failure && state.failure != null) {
          if (state.failure is ConflictFailure) {
            setState(() => _selected = null);
            context.read<OpenSlotsCubit>().refreshAfterStaleSlot();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text(SchedulingStrings.openSlotsStale)),
            );
            return;
          }
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
          setState(() => _selected = null);
          context.read<OpenSlotsCubit>().refresh();
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text(SchedulingStrings.bookPtTitle)),
        body: BlocBuilder<OpenSlotsCubit, OpenSlotsState>(
          builder: (context, state) {
            if (state.status == LoadStatus.loading && !state.hasLoaded) {
              return const AppLoading();
            }
            if (state.status == LoadStatus.failure && !state.hasLoaded) {
              return AppErrorView(
                message: state.failure == null
                    ? 'Something went wrong'
                    : failureMessage(state.failure!),
                onRetry: () {
                  final session = context.read<SessionCubit>().state;
                  if (session is! SessionAuthenticated) return;
                  context.read<OpenSlotsCubit>().load(
                        session.principal.profileId,
                      );
                },
              );
            }
            if (state.missingTrainer) {
              return const AppEmptyView(
                message: SchedulingStrings.openSlotsNoTrainer,
              );
            }

            final cubit = context.read<OpenSlotsCubit>();
            final daySlots = cubit.slotsForSelectedDay();
            final submitting = context.select(
              (BookScheduleBloc b) => b.state.status == LoadStatus.loading,
            );

            return RefreshIndicator(
              onRefresh: () => cubit.refresh(),
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  if (state.trainer != null) ...[
                    Text(
                      SchedulingStrings.openSlotsTrainerLabel,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      state.trainer!.fullName,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (state.staleSlot) ...[
                    Card(
                      color: Theme.of(context).colorScheme.errorContainer,
                      child: ListTile(
                        title: const Text(SchedulingStrings.openSlotsStale),
                        trailing: TextButton(
                          onPressed: () => cubit.refresh(),
                          child: const Text(SchedulingStrings.retry),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                  if (state.hasLoaded &&
                      state.slots.isEmpty &&
                      !state.missingTrainer)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 32),
                      child: Text(
                        SchedulingStrings.openSlotsEmptyRange,
                        textAlign: TextAlign.center,
                      ),
                    )
                  else ...[
                    Text(
                      SchedulingStrings.openSlotsSelectPrompt,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 12),
                    OpenSlotsPicker(
                      days: state.days,
                      selectedDay: state.selectedDay,
                      slotsForDay: daySlots,
                      selectedScheduleId: _selected?.scheduleId,
                      enabled: !submitting,
                      onDaySelected: (day) {
                        setState(() => _selected = null);
                        cubit.selectDay(day);
                      },
                      onSlotSelected: (slot) {
                        setState(() => _selected = slot);
                      },
                    ),
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: submitting || _selected == null
                          ? null
                          : () => _book(context, _selected!),
                      child: Text(
                        submitting
                            ? SchedulingStrings.submitting
                            : SchedulingStrings.openSlotsBook,
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _book(BuildContext context, BookableOpenSlot slot) {
    final session = context.read<SessionCubit>().state;
    if (session is! SessionAuthenticated) return;
    context.read<BookScheduleBloc>().add(
          BookScheduleRequested(
            scheduleId: slot.scheduleId,
            memberId: session.principal.profileId,
          ),
        );
  }
}

class _BookClassBody extends StatelessWidget {
  const _BookClassBody();

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
          title: const Text(SchedulingStrings.bookClassTitle),
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
