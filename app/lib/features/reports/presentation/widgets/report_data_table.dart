import 'package:flutter/material.dart';

import '../report_strings.dart';

class ReportDataTable extends StatelessWidget {
  const ReportDataTable({
    super.key,
    required this.columns,
    required this.rows,
  });

  final List<String> columns;
  final List<Map<String, dynamic>> rows;

  @override
  Widget build(BuildContext context) {
    if (rows.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: Text(ReportStrings.emptyRows)),
      );
    }

    final cols = columns.isEmpty
        ? rows.first.keys.toList()
        : columns;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: [
          for (final c in cols) DataColumn(label: Text(c)),
        ],
        rows: [
          for (final row in rows)
            DataRow(
              cells: [
                for (final c in cols)
                  DataCell(Text('${row[c] ?? ''}')),
              ],
            ),
        ],
      ),
    );
  }
}
