import 'package:luxeknox/core/widgets/app_empty_view.dart';
import 'package:flutter/material.dart';

/// Themed grid heatmap. `fl_chart` has no heatmap chart type, so this is a
/// small custom grid: [values] is row-major (`values[row][col]`), shaded
/// from [Theme.colorScheme.surfaceContainerHighest] (lowest) to
/// [Theme.colorScheme.primary] (highest).
class AppHeatmap extends StatelessWidget {
  const AppHeatmap({
    super.key,
    required this.values,
    required this.rowLabels,
    required this.colLabels,
    this.emptyMessage = 'No data to display',
    this.cellSize = 28,
    this.valueFormatter,
  });

  final List<List<double>> values;
  final List<String> rowLabels;
  final List<String> colLabels;
  final String emptyMessage;
  final double cellSize;
  final String Function(double value)? valueFormatter;

  @override
  Widget build(BuildContext context) {
    if (values.isEmpty || colLabels.isEmpty) {
      return AppEmptyView(message: emptyMessage, icon: Icons.grid_on_outlined);
    }

    final theme = Theme.of(context);
    final labelStyle = theme.textTheme.labelSmall?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );

    var maxValue = 0.0;
    for (final row in values) {
      for (final v in row) {
        if (v > maxValue) maxValue = v;
      }
    }

    Color colorFor(double value) {
      final t = maxValue <= 0 ? 0.0 : (value / maxValue).clamp(0.0, 1.0);
      return Color.lerp(
        theme.colorScheme.surfaceContainerHighest,
        theme.colorScheme.primary,
        t,
      )!;
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(width: cellSize * 1.5),
              for (final label in colLabels)
                SizedBox(
                  width: cellSize,
                  child: Text(label, textAlign: TextAlign.center, style: labelStyle),
                ),
            ],
          ),
          for (var r = 0; r < values.length; r++)
            Row(
              children: [
                SizedBox(
                  width: cellSize * 1.5,
                  child: Text(
                    r < rowLabels.length ? rowLabels[r] : '',
                    style: labelStyle,
                  ),
                ),
                for (final v in values[r])
                  Tooltip(
                    message: valueFormatter?.call(v) ?? v.toStringAsFixed(1),
                    child: Container(
                      width: cellSize,
                      height: cellSize,
                      margin: const EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: colorFor(v),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}
