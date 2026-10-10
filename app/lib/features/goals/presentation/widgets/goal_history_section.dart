import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/widgets/app_chart_types.dart';
import '../../../../core/widgets/app_line_chart.dart';
import '../../domain/entities/goal_history.dart';
import '../goals_strings.dart';

class GoalHistorySection extends StatelessWidget {
  const GoalHistorySection({
    super.key,
    required this.history,
    this.unit,
    this.showEarlier = false,
  });

  final List<GoalHistoryEntry> history;
  final String? unit;
  final bool showEarlier;

  List<GoalHistoryEntry> _chartOrder() {
    final copy = [...history];
    copy.sort((a, b) {
      final byDate = a.recordedDate.compareTo(b.recordedDate);
      if (byDate != 0) return byDate;
      final aId = int.tryParse(a.id) ?? 0;
      final bId = int.tryParse(b.id) ?? 0;
      return aId.compareTo(bId);
    });
    return copy;
  }

  @override
  Widget build(BuildContext context) {
    final chartRows = _chartOrder();
    final origin = chartRows.isEmpty ? null : chartRows.first.recordedDate;
    final earlier = history.length > 1 ? history.skip(1) : const <GoalHistoryEntry>[];
    final unitSuffix = unit == null || unit!.isEmpty ? '' : ' $unit';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppLineChart(
          key: const Key('goal-view-chart'),
          series: [
            AppLineSeries(
              name: GoalsStrings.chartsSection,
              points: [
                for (final row in chartRows)
                  Offset(
                    row.recordedDate.difference(origin!).inDays.toDouble(),
                    row.recordedValue.toDouble(),
                  ),
              ],
            ),
          ],
          emptyMessage: GoalsStrings.chartsEmpty,
          xLabelFormatter: origin == null
              ? null
              : (x) => DateFormat('MMM d').format(
                  origin.add(Duration(days: x.round())),
                ),
        ),
        if (history.isEmpty) ...[
          const SizedBox(height: 8),
          const Text(GoalsStrings.noCheckInsYet),
        ],
        if (showEarlier && earlier.isNotEmpty) ...[
          const SizedBox(height: 12),
          Column(
            key: const Key('goal-view-history'),
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final row in earlier)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    '${GoalsStrings.calendarDate(row.recordedDate)}'
                    ' · ${row.recordedValue}$unitSuffix'
                    '${row.notes == null || row.notes!.isEmpty ? '' : ' · ${row.notes}'}',
                  ),
                ),
            ],
          ),
        ],
      ],
    );
  }
}
