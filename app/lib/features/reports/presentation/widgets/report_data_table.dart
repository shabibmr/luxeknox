import 'package:flutter/material.dart';

import '../../../../core/widgets/app_currency_text.dart';
import '../../../../core/widgets/app_empty_view.dart';
import '../report_strings.dart';

class ReportDataTable extends StatelessWidget {
  const ReportDataTable({super.key, required this.columns, required this.rows});

  final List<String> columns;
  final List<Map<String, dynamic>> rows;

  bool _isCurrencyColumn(String column) {
    final normalized = column.toLowerCase().replaceAll(RegExp(r'[^a-z]'), '');
    return const [
      'amount',
      'amountpaid',
      'amountdue',
      'balance',
      'revenue',
      'collection',
      'fee',
      'price',
      'paymentamount',
      'totalamount',
      'subtotal',
      'taxamount',
      'discountamount',
      'outstanding',
    ].any((keyword) => normalized.contains(keyword));
  }

  @override
  Widget build(BuildContext context) {
    if (rows.isEmpty) {
      return const AppEmptyView(message: ReportStrings.emptyRows);
    }

    final cols = columns.isEmpty ? rows.first.keys.toList() : columns;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: [for (final c in cols) DataColumn(label: Text(c))],
        rows: [
          for (final row in rows)
            DataRow(
              cells: [
                for (final c in cols)
                  DataCell(
                    _isCurrencyColumn(c)
                        ? AppCurrencyText(row[c]?.toString())
                        : Text('${row[c] ?? ''}'),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}
