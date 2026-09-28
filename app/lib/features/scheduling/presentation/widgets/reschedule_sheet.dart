import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/time/gym_timezone_provider.dart';
import '../../domain/entities/schedule_session.dart';
import '../cubit/schedule_detail_cubit.dart';
import '../scheduling_strings.dart';
import 'date_time_range_field.dart';

/// Staff bottom sheet to change a session's start/end via [DateTimeRangeField].
///
/// Calls [ScheduleDetailCubit.reschedule] with the current `rowVersion`.
/// Returns `true` when the parent should close after a successful save.
Future<bool?> showRescheduleSheet({
  required BuildContext context,
  required ScheduleSession session,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    builder: (_) => BlocProvider.value(
      value: context.read<ScheduleDetailCubit>(),
      child: RescheduleSheet(session: session),
    ),
  );
}

class RescheduleSheet extends StatefulWidget {
  const RescheduleSheet({
    super.key,
    required this.session,
    this.timezoneProvider,
  });

  final ScheduleSession session;

  /// Test seam forwarded to [DateTimeRangeField].
  final GymTimezoneProvider? timezoneProvider;

  @override
  State<RescheduleSheet> createState() => _RescheduleSheetState();
}

class _RescheduleSheetState extends State<RescheduleSheet> {
  late DateTime? _start = widget.session.startTime;
  late DateTime? _end = widget.session.endTime;

  @override
  Widget build(BuildContext context) {
    final rangeError = DateTimeRangeField.validateRange(_start, _end);
    final canSubmit =
        _start != null && _end != null && rangeError == null;

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.viewInsetsOf(context).bottom + 16,
      ),
      child: BlocBuilder<ScheduleDetailCubit, ScheduleDetailState>(
        builder: (context, state) {
          final busy = state.actionInFlight;
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                SchedulingStrings.rescheduleTitle,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              DateTimeRangeField(
                start: _start,
                end: _end,
                onStartChanged: (value) => setState(() => _start = value),
                onEndChanged: (value) => setState(() => _end = value),
                timezoneProvider: widget.timezoneProvider,
              ),
              const SizedBox(height: 24),
              FilledButton(
                key: const Key('reschedule_submit'),
                onPressed: !canSubmit || busy
                    ? null
                    : () async {
                        final ok = await context
                            .read<ScheduleDetailCubit>()
                            .reschedule(start: _start!, end: _end!);
                        if (!context.mounted) return;
                        if (ok) {
                          Navigator.of(context).pop(true);
                        }
                      },
                child: Text(
                  busy
                      ? SchedulingStrings.submitting
                      : SchedulingStrings.rescheduleSubmit,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
