import 'package:flutter/material.dart';

import '../../domain/entities/pt_progress_review.dart';
import '../pt_strings.dart';
import '../review_format.dart';

/// Start / current / change / target for body measures and performance markers.
class MeasuresComparisonTable extends StatelessWidget {
  const MeasuresComparisonTable({
    super.key,
    required this.bodyMetrics,
    required this.performanceMarkers,
  });

  final List<BodyMetricSnapshot> bodyMetrics;
  final List<PerformanceMarkerSnapshot> performanceMarkers;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final rows = <DataRow>[
      for (final metric in bodyMetrics)
        DataRow(
          cells: [
            DataCell(Text(metric.metric)),
            DataCell(Text(formatReviewMeasure(metric.startVal))),
            DataCell(Text(formatReviewMeasure(metric.currentVal))),
            DataCell(Text(formatReviewMeasure(metric.changeVal, signed: true))),
            DataCell(Text(formatReviewMeasure(metric.targetVal))),
          ],
        ),
      for (final marker in performanceMarkers)
        DataRow(
          cells: [
            DataCell(Text(marker.marker)),
            DataCell(Text(marker.startVal ?? PtStrings.emptyValue)),
            DataCell(Text(marker.currentVal ?? PtStrings.emptyValue)),
            DataCell(Text(marker.changeVal ?? PtStrings.emptyValue)),
            DataCell(Text(marker.targetVal ?? PtStrings.emptyValue)),
          ],
        ),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(PtStrings.measuresTitle, style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            if (rows.isEmpty)
              Text(PtStrings.noMeasures, style: theme.textTheme.bodyMedium)
            else
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text(PtStrings.measureColumn)),
                    DataColumn(label: Text(PtStrings.startColumn)),
                    DataColumn(label: Text(PtStrings.currentColumn)),
                    DataColumn(label: Text(PtStrings.changeColumn)),
                    DataColumn(label: Text(PtStrings.targetColumn)),
                  ],
                  rows: rows,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
