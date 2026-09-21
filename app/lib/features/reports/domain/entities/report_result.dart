import 'package:equatable/equatable.dart';

import 'app_report_type.dart';

class ReportResult extends Equatable {
  const ReportResult({
    required this.type,
    required this.from,
    required this.to,
    required this.rows,
  });

  final AppReportType type;
  final DateTime from;
  final DateTime to;
  final List<Map<String, dynamic>> rows;

  List<String> get columns {
    if (rows.isEmpty) return const [];
    final keys = <String>{};
    for (final row in rows) {
      keys.addAll(row.keys);
    }
    return keys.toList()..sort();
  }

  @override
  List<Object?> get props => [type, from, to, rows];
}
