import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/time/gym_timezone_provider.dart';
import '../scheduling_strings.dart';

/// Date + start/end time picker for schedule forms (F2.4).
///
/// Validates `end > start` and shows the gym's configured timezone (from
/// `GET /settings/public`, via [GymTimezoneProvider]) as a caption so admins
/// know the times they pick are interpreted in the gym's timezone, not
/// necessarily their device's.
class DateTimeRangeField extends StatefulWidget {
  const DateTimeRangeField({
    super.key,
    required this.start,
    required this.end,
    required this.onStartChanged,
    required this.onEndChanged,
    this.timezoneProvider,
    this.firstDate,
    this.lastDate,
  });

  final DateTime? start;
  final DateTime? end;
  final ValueChanged<DateTime> onStartChanged;
  final ValueChanged<DateTime> onEndChanged;

  /// Test seam; defaults to the DI-registered [GymTimezoneProvider].
  final GymTimezoneProvider? timezoneProvider;

  final DateTime? firstDate;
  final DateTime? lastDate;

  /// `null` when the range is valid (or incomplete).
  static String? validateRange(DateTime? start, DateTime? end) {
    if (start == null || end == null) return null;
    if (!end.isAfter(start)) return SchedulingStrings.endBeforeStartError;
    return null;
  }

  @override
  State<DateTimeRangeField> createState() => _DateTimeRangeFieldState();
}

class _DateTimeRangeFieldState extends State<DateTimeRangeField> {
  late final GymTimezoneProvider _timezoneProvider =
      widget.timezoneProvider ?? getIt<GymTimezoneProvider>();

  String? _timezoneLabel;

  @override
  void initState() {
    super.initState();
    _loadTimezone();
  }

  Future<void> _loadTimezone() async {
    final tz = await _timezoneProvider.timezone();
    if (!mounted || tz == null) return;
    setState(() => _timezoneLabel = tz);
  }

  Future<void> _pickStart() async {
    final picked = await _pickDateTime(widget.start ?? DateTime.now());
    if (picked != null) widget.onStartChanged(picked);
  }

  Future<void> _pickEnd() async {
    final picked = await _pickDateTime(
      widget.end ?? widget.start ?? DateTime.now(),
    );
    if (picked != null) widget.onEndChanged(picked);
  }

  Future<DateTime?> _pickDateTime(DateTime initial) async {
    final date = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: widget.firstDate ?? DateTime(2000),
      lastDate: widget.lastDate ?? DateTime(2100),
    );
    if (date == null || !mounted) return null;
    final time = await showTimePicker(
      // ignore: use_build_context_synchronously
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
    );
    if (time == null) return null;
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  @override
  Widget build(BuildContext context) {
    final rangeError = DateTimeRangeField.validateRange(
      widget.start,
      widget.end,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          key: const Key('schedule_start_field'),
          onTap: _pickStart,
          child: InputDecorator(
            decoration: const InputDecoration(
              labelText: SchedulingStrings.startTimeLabel,
              suffixIcon: Icon(Icons.event),
            ),
            child: Text(_format(widget.start)),
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          key: const Key('schedule_end_field'),
          onTap: _pickEnd,
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: SchedulingStrings.endTimeLabel,
              suffixIcon: const Icon(Icons.event),
              errorText: rangeError,
            ),
            child: Text(_format(widget.end)),
          ),
        ),
        if (_timezoneLabel != null) ...[
          const SizedBox(height: 4),
          Text(
            'Times shown in $_timezoneLabel',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ],
    );
  }

  String _format(DateTime? value) {
    if (value == null) return SchedulingStrings.dateTimePlaceholder;
    return DateFormat('EEE, MMM d • h:mm a').format(value);
  }
}
