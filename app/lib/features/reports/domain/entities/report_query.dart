import 'package:equatable/equatable.dart';

import 'app_report_type.dart';

enum ReportExportFormat { json, csv }

class ReportQuery extends Equatable {
  const ReportQuery({
    required this.type,
    this.from,
    this.to,
    this.productId,
    this.trainerId,
    this.format = ReportExportFormat.json,
  });

  final AppReportType type;
  final DateTime? from;
  final DateTime? to;
  final String? productId;
  final String? trainerId;
  final ReportExportFormat format;

  ReportQuery copyWith({
    AppReportType? type,
    DateTime? from,
    DateTime? to,
    String? productId,
    String? trainerId,
    ReportExportFormat? format,
    bool clearFrom = false,
    bool clearTo = false,
    bool clearProductId = false,
    bool clearTrainerId = false,
  }) {
    return ReportQuery(
      type: type ?? this.type,
      from: clearFrom ? null : (from ?? this.from),
      to: clearTo ? null : (to ?? this.to),
      productId: clearProductId ? null : (productId ?? this.productId),
      trainerId: clearTrainerId ? null : (trainerId ?? this.trainerId),
      format: format ?? this.format,
    );
  }

  @override
  List<Object?> get props => [type, from, to, productId, trainerId, format];
}
