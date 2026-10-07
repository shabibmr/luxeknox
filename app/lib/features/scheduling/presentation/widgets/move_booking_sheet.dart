import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/schedule_session.dart';
import '../cubit/schedule_detail_cubit.dart';
import '../scheduling_strings.dart';

Future<bool?> showMoveBookingSheet({
  required BuildContext context,
  required ScheduleSession session,
  required String memberId,
  required List<ScheduleSession> alternatives,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    builder: (_) => BlocProvider.value(
      value: context.read<ScheduleDetailCubit>(),
      child: MoveBookingSheet(
        session: session,
        memberId: memberId,
        alternatives: alternatives,
      ),
    ),
  );
}

class MoveBookingSheet extends StatelessWidget {
  const MoveBookingSheet({
    super.key,
    required this.session,
    required this.memberId,
    required this.alternatives,
  });

  final ScheduleSession session;
  final String memberId;
  final List<ScheduleSession> alternatives;

  Future<void> _select(BuildContext context, ScheduleSession target) async {
    final ok = await context.read<ScheduleDetailCubit>().moveBooking(
      targetScheduleId: target.id,
      memberId: memberId,
    );
    if (!context.mounted) return;
    if (ok) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 0.6;
    final fmt = DateFormat('EEE, MMM d • h:mm a');
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
            Expanded(
              child: BlocBuilder<ScheduleDetailCubit, ScheduleDetailState>(
                builder: (context, state) {
                  final busy = state.actionInFlight;
                  if (alternatives.isEmpty) {
                    return const Center(
                      child: Text(SchedulingStrings.moveBookingEmpty),
                    );
                  }
                  return ListView.separated(
                    itemCount: alternatives.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final s = alternatives[index];
                      return ListTile(
                        key: Key('move_booking_option_${s.id}'),
                        title: Text(s.title),
                        subtitle: Text(
                          '${fmt.format(s.startTime)} → '
                          '${fmt.format(s.endTime)}',
                        ),
                        trailing: TextButton(
                          onPressed: busy ? null : () => _select(context, s),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
