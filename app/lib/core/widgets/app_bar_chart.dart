import 'package:luxeknox/core/widgets/app_chart_types.dart';
import 'package:luxeknox/core/widgets/app_empty_view.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

/// Themed bar chart wrapper around fl_chart's [BarChart].
class AppBarChart extends StatelessWidget {
  const AppBarChart({
    super.key,
    required this.data,
    this.height = 220,
    this.barColor,
    this.emptyMessage = 'No data to display',
    this.valueFormatter,
  });

  final List<AppChartPoint> data;
  final double height;
  final Color? barColor;
  final String emptyMessage;
  final String Function(double value)? valueFormatter;

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return SizedBox(
        height: height,
        child: AppEmptyView(
          message: emptyMessage,
          icon: Icons.bar_chart_outlined,
        ),
      );
    }

    final theme = Theme.of(context);
    final color = barColor ?? theme.colorScheme.primary;
    final axisLabelStyle = theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );
    final peak = data.map((e) => e.value).reduce((a, b) => a > b ? a : b);

    return SizedBox(
      height: height,
      child: BarChart(
        BarChartData(
          maxY: peak <= 0 ? 1 : peak * 1.2,
          barGroups: [
            for (var i = 0; i < data.length; i++)
              BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: data[i].value,
                    color: color,
                    width: 16,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
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
                  valueFormatter?.call(value) ?? value.toStringAsFixed(0),
                  style: axisLabelStyle,
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= data.length) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(data[index].label, style: axisLabelStyle),
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
