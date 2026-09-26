import 'package:flutter/material.dart';

import '../../../../core/extensions/capability_extension.dart';
import '../../../../core/widgets/app_bar_chart.dart';
import '../../../../core/widgets/app_heatmap.dart';
import '../../../../core/widgets/app_line_chart.dart';
import '../../../attendance/presentation/widgets/attendance_occupancy_tile.dart';
import '../../domain/entities/app_report_type.dart';
import '../charts/report_chart_data.dart';
import '../report_strings.dart';

/// Collapsible chart section shown above the data table in
/// [ReportViewerScreen]. Renders nothing when the report type has no
/// chartable rows (e.g. payments, blocked pending the financial-charts
/// vertical).
class ReportChartSection extends StatefulWidget {
  const ReportChartSection({
    super.key,
    required this.type,
    required this.rows,
  });

  final AppReportType type;
  final List<Map<String, dynamic>> rows;

  @override
  State<ReportChartSection> createState() => _ReportChartSectionState();
}

class _ReportChartSectionState extends State<ReportChartSection> {
  bool _expanded = true;

  @override
  Widget build(BuildContext context) {
    final blocks = buildReportChartBlocks(widget.type, widget.rows);
    final showOccupancy =
        widget.type == AppReportType.attendance &&
        context.can('attendance.read');

    if (blocks.isEmpty && !showOccupancy) return const SizedBox.shrink();

    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    ReportStrings.chartsTitle,
                    style: theme.textTheme.titleSmall,
                  ),
                ),
                IconButton(
                  tooltip: _expanded
                      ? ReportStrings.hideCharts
                      : ReportStrings.showCharts,
                  icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                  onPressed: () => setState(() => _expanded = !_expanded),
                ),
              ],
            ),
            if (_expanded) ...[
              if (showOccupancy) const AttendanceOccupancyTile(),
              for (var i = 0; i < blocks.length; i++) ...[
                if (i > 0) const SizedBox(height: 16),
                Text(blocks[i].title, style: theme.textTheme.labelLarge),
                const SizedBox(height: 8),
                _ChartBlockView(block: blocks[i]),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

class _ChartBlockView extends StatelessWidget {
  const _ChartBlockView({required this.block});

  final ReportChartBlock block;

  @override
  Widget build(BuildContext context) {
    final b = block;
    return switch (b) {
      BarChartBlock() => AppBarChart(data: b.points),
      LineChartBlock() => AppLineChart(series: b.series),
      HeatmapChartBlock() => AppHeatmap(
          values: b.values,
          rowLabels: b.rowLabels,
          colLabels: b.colLabels,
        ),
    };
  }
}
