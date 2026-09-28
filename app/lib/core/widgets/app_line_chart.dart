import 'package:luxeknox/core/widgets/app_chart_types.dart';
import 'package:luxeknox/core/widgets/app_empty_view.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

/// Sorted unique x values across all series points.
List<double> appLineChartUniqueXs(List<AppLineSeries> series) {
  final xs = <double>{
    for (final s in series)
      for (final p in s.points) p.dx,
  }.toList()
    ..sort();
  return xs;
}

/// Minimum positive gap between consecutive [values], or `1` when undefined.
double appLineChartAxisInterval(List<double> values) {
  if (values.length < 2) return 1;
  var minGap = double.infinity;
  for (var i = 1; i < values.length; i++) {
    final gap = values[i] - values[i - 1];
    if (gap > 0 && gap < minGap) minGap = gap;
  }
  return minGap.isFinite ? minGap : 1;
}

bool appLineChartIsDataX(double value, List<double> xs, double tolerance) {
  for (final x in xs) {
    if ((value - x).abs() <= tolerance) return true;
  }
  return false;
}

/// Themed line chart wrapper around fl_chart's [LineChart]. Supports one or
/// more named series sharing the same x-axis.
class AppLineChart extends StatelessWidget {
  const AppLineChart({
    super.key,
    required this.series,
    this.height = 220,
    this.emptyMessage = 'No data to display',
    this.xLabelFormatter,
    this.yLabelFormatter,
  });

  final List<AppLineSeries> series;
  final double height;
  final String emptyMessage;
  final String Function(double x)? xLabelFormatter;
  final String Function(double y)? yLabelFormatter;

  bool get _hasData => series.any((s) => s.points.isNotEmpty);

  @override
  Widget build(BuildContext context) {
    if (!_hasData) {
      return SizedBox(
        height: height,
        child: AppEmptyView(
          message: emptyMessage,
          icon: Icons.show_chart_outlined,
        ),
      );
    }

    final theme = Theme.of(context);
    final palette = [
      theme.colorScheme.primary,
      theme.colorScheme.tertiary,
      theme.colorScheme.secondary,
    ];
    final axisLabelStyle = theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );

    // fl_chart samples the axis densely when [SideTitles.interval] is null;
    // formatting those samples with toStringAsFixed(0) produces dozens of
    // duplicate labels. Label only at data x values with a data-derived interval.
    final xs = appLineChartUniqueXs(series);
    final xInterval = appLineChartAxisInterval(xs);
    final xTolerance = xInterval / 4;

    return SizedBox(
      height: height,
      child: LineChart(
        LineChartData(
          lineBarsData: [
            for (var i = 0; i < series.length; i++)
              LineChartBarData(
                spots: [
                  for (final p in series[i].points) FlSpot(p.dx, p.dy),
                ],
                color: series[i].color ?? palette[i % palette.length],
                barWidth: 2,
                dotData: const FlDotData(show: false),
              ),
          ],
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) => Text(
                  yLabelFormatter?.call(value) ?? value.toStringAsFixed(0),
                  style: axisLabelStyle,
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                interval: xInterval,
                getTitlesWidget: (value, meta) {
                  if (!appLineChartIsDataX(value, xs, xTolerance)) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      xLabelFormatter?.call(value) ??
                          value.toStringAsFixed(0),
                      style: axisLabelStyle,
                    ),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (value) => FlLine(
              color: theme.colorScheme.outlineVariant,
              strokeWidth: 1,
            ),
          ),
        ),
      ),
    );
  }
}
