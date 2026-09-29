import 'package:flutter/material.dart';

import '../../domain/entities/pt_schedule_grid.dart';
import '../pt_strings.dart';

/// Hours (rows) × trainers (columns). Free cells are tappable; occupied cells
/// show who holds the slot.
class PtScheduleGridView extends StatelessWidget {
  const PtScheduleGridView({
    super.key,
    required this.grid,
    required this.selectedTrainerId,
    required this.selectedSlot,
    required this.onSelect,
  });

  final PtScheduleGrid grid;
  final int? selectedTrainerId;
  final String? selectedSlot;
  final void Function(int trainerId, String slotStart) onSelect;

  static const _hourColWidth = 104.0;
  static const _cellWidth = 132.0;
  static const _cellHeight = 52.0;

  @override
  Widget build(BuildContext context) {
    if (grid.trainers.isEmpty || grid.hours.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Text(PtStrings.gridEmpty, style: Theme.of(context).textTheme.bodyMedium),
      );
    }
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _Legend(),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const SizedBox(width: _hourColWidth),
                  for (final t in grid.trainers)
                    SizedBox(
                      width: _cellWidth,
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Text(
                          t.name,
                          style: theme.textTheme.labelLarge,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                ],
              ),
              for (final hour in grid.hours)
                Row(
                  children: [
                    SizedBox(
                      width: _hourColWidth,
                      height: _cellHeight,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(ptHourLabel(hour), style: theme.textTheme.bodyMedium),
                      ),
                    ),
                    for (final t in grid.trainers)
                      _Cell(
                        cell: grid.cell(t.id, hour),
                        selected: selectedTrainerId == t.id && selectedSlot == hour,
                        onTap: () => onSelect(t.id, hour),
                        width: _cellWidth,
                        height: _cellHeight,
                      ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Cell extends StatelessWidget {
  const _Cell({
    required this.cell,
    required this.selected,
    required this.onTap,
    required this.width,
    required this.height,
  });

  final PtGridCell? cell;
  final bool selected;
  final VoidCallback onTap;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final status = cell?.status ?? PtGridCellStatus.unavailable;
    final (Color bg, Color fg, String label) = switch (status) {
      _ when selected => (scheme.primary, scheme.onPrimary, PtStrings.selected),
      PtGridCellStatus.free => (scheme.primaryContainer, scheme.onPrimaryContainer, PtStrings.free),
      PtGridCellStatus.occupied => (
        scheme.errorContainer,
        scheme.onErrorContainer,
        cell?.occupiedBy ?? PtStrings.occupied,
      ),
      PtGridCellStatus.unavailable => (
        scheme.surfaceContainerHighest,
        scheme.onSurfaceVariant,
        PtStrings.unavailable,
      ),
    };
    final clashes = cell?.conflictDates.length ?? 0;
    final tooltip = status == PtGridCellStatus.occupied && clashes > 0
        ? '${cell?.occupiedBy ?? PtStrings.occupied} · ${PtStrings.clashes(clashes)}'
        : label;

    return Padding(
      padding: const EdgeInsets.all(2),
      child: Tooltip(
        message: tooltip,
        child: Material(
          color: bg,
          borderRadius: BorderRadius.circular(8),
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: status == PtGridCellStatus.free ? onTap : null,
            child: SizedBox(
              width: width - 4,
              height: height - 4,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Text(
                    label,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(color: fg),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    Widget chip(Color c, String label) => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(3)),
        ),
        const SizedBox(width: 4),
        Text(label, style: Theme.of(context).textTheme.labelSmall),
      ],
    );
    return Wrap(
      spacing: 12,
      runSpacing: 4,
      children: [
        chip(scheme.primaryContainer, PtStrings.free),
        chip(scheme.errorContainer, PtStrings.occupied),
        chip(scheme.surfaceContainerHighest, PtStrings.unavailable),
        chip(scheme.primary, PtStrings.selected),
      ],
    );
  }
}
