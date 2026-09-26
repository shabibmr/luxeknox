import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../domain/entities/schedule_enums.dart';
import '../../domain/entities/schedule_session.dart';
import '../../domain/usecases/schedule_usecases.dart';
import '../cubit/schedule_detail_cubit.dart';
import '../scheduling_strings.dart';

/// Member bottom sheet: pick another session of the same type, then
/// book-new → cancel-old via [ScheduleDetailCubit.moveBooking].
Future<bool?> showMoveBookingSheet({
  required BuildContext context,
  required ScheduleSession session,
  required String memberId,
  ListSchedulesUseCase? listSchedules,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    builder: (_) => BlocProvider.value(
      value: context.read<ScheduleDetailCubit>(),
      child: MoveBookingSheet(
        session: session,
        memberId: memberId,
        listSchedules: listSchedules,
      ),
    ),
  );
}

class MoveBookingSheet extends StatefulWidget {
  const MoveBookingSheet({
    super.key,
    required this.session,
    required this.memberId,
    this.listSchedules,
  });

  final ScheduleSession session;
  final String memberId;

  /// Test seam; defaults to DI [ListSchedulesUseCase].
  final ListSchedulesUseCase? listSchedules;

  @override
  State<MoveBookingSheet> createState() => _MoveBookingSheetState();
}

class _MoveBookingSheetState extends State<MoveBookingSheet> {
  bool _loading = true;
  String? _error;
  List<ScheduleSession> _alternatives = const [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final list = widget.listSchedules ?? getIt<ListSchedulesUseCase>();
    final now = DateTime.now();
    final result = await list(
      ListSchedulesParams(
        from: now,
        to: now.add(const Duration(days: 14)),
        limit: 50,
      ),
    );
    if (!mounted) return;
    result.fold(
      (failure) => setState(() {
        _loading = false;
        _error = failureMessage(failure);
      }),
      (page) {
        final filtered = page.items
            .where(
              (s) =>
                  s.id != widget.session.id &&
                  s.scheduleTypeId == widget.session.scheduleTypeId &&
                  s.status == ScheduleSessionStatus.scheduled &&
                  !s.isFull,
            )
            .toList()
          ..sort((a, b) => a.startTime.compareTo(b.startTime));
        setState(() {
          _loading = false;
          _alternatives = filtered;
        });
      },
    );
  }

  Future<void> _select(ScheduleSession target) async {
    final ok = await context.read<ScheduleDetailCubit>().moveBooking(
      targetScheduleId: target.id,
      memberId: widget.memberId,
    );
    if (!mounted) return;
    if (ok) {
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 0.6;
    return SizedBox(
      height: height,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              SchedulingStrings.moveBookingTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Expanded(child: _body(context)),
          ],
        ),
      ),
    );
  }

  Widget _body(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_error!, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            TextButton(
              onPressed: _load,
              child: const Text(SchedulingStrings.retry),
            ),
          ],
        ),
      );
    }
    if (_alternatives.isEmpty) {
      return const Center(child: Text(SchedulingStrings.moveBookingEmpty));
    }

    final fmt = DateFormat('EEE, MMM d • h:mm a');
    return BlocBuilder<ScheduleDetailCubit, ScheduleDetailState>(
      builder: (context, state) {
        final busy = state.actionInFlight;
        return ListView.separated(
          itemCount: _alternatives.length,
          separatorBuilder: (_, _) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final s = _alternatives[index];
            return ListTile(
              key: Key('move_booking_option_${s.id}'),
              title: Text(s.title),
              subtitle: Text(
                '${fmt.format(s.startTime)} → ${fmt.format(s.endTime)}',
              ),
              trailing: TextButton(
                onPressed: busy ? null : () => _select(s),
                child: Text(
                  busy
                      ? SchedulingStrings.submitting
                      : SchedulingStrings.moveBookingSubmit,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
