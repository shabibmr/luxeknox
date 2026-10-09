import 'package:flutter/material.dart';

import '../workout_strings.dart';

/// Horizontal pill selector to switch between days in the workout split.
class TodaysDaySelector extends StatelessWidget {
  const TodaysDaySelector({
    super.key,
    required this.days,
    required this.selectedDay,
    required this.onDaySelected,
  });

  final List<int> days;
  final int selectedDay;
  final ValueChanged<int> onDaySelected;

  @override
  Widget build(BuildContext context) {
    if (days.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: days.map((day) {
          final isSelected = day == selectedDay;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(WorkoutStrings.dayHeader(day)),
              selected: isSelected,
              onSelected: (_) => onDaySelected(day),
              selectedColor: theme.colorScheme.primaryContainer,
              labelStyle: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? theme.colorScheme.onPrimaryContainer
                    : theme.colorScheme.onSurface,
              ),
              showCheckmark: false,
            ),
          );
        }).toList(),
      ),
    );
  }
}
