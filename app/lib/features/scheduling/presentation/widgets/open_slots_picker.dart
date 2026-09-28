import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/open_slot.dart';
import '../scheduling_strings.dart';

/// Day strip + slot chips for picking a bookable open PT slot.
class OpenSlotsPicker extends StatelessWidget {
  const OpenSlotsPicker({
    super.key,
    required this.days,
    required this.selectedDay,
    required this.slotsForDay,
    required this.onDaySelected,
    required this.onSlotSelected,
    this.selectedScheduleId,
    this.enabled = true,
  });

  final List<DateTime> days;
  final DateTime? selectedDay;
  final List<BookableOpenSlot> slotsForDay;
  final ValueChanged<DateTime> onDaySelected;
  final ValueChanged<BookableOpenSlot> onSlotSelected;
  final String? selectedScheduleId;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dayFmt = DateFormat('E');
    final dateFmt = DateFormat('d');
    final timeFmt = DateFormat('h:mm a');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 72,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: days.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final day = days[index];
              final selected = selectedDay != null &&
                  day.year == selectedDay!.year &&
                  day.month == selectedDay!.month &&
                  day.day == selectedDay!.day;
              return FilterChip(
                key: Key(
                  'open_slots_day_${day.year}_${day.month}_${day.day}',
                ),
                selected: selected,
                label: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(dayFmt.format(day), style: theme.textTheme.labelSmall),
                    Text(dateFmt.format(day), style: theme.textTheme.titleSmall),
                  ],
                ),
                onSelected: enabled
                    ? (_) => onDaySelected(day)
                    : null,
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        if (slotsForDay.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Text(
              SchedulingStrings.openSlotsEmptyDay,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final slot in slotsForDay)
                ChoiceChip(
                  key: Key('open_slot_chip_${slot.scheduleId}'),
                  label: Text(timeFmt.format(slot.start)),
                  selected: selectedScheduleId == slot.scheduleId,
                  onSelected: enabled
                      ? (_) => onSlotSelected(slot)
                      : null,
                ),
            ],
          ),
      ],
    );
  }
}
