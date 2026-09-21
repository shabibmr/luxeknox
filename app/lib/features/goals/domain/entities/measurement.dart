import 'package:equatable/equatable.dart';

class MeasurementValueEntry extends Equatable {
  const MeasurementValueEntry({
    this.id,
    this.measurementId,
    required this.metricId,
    required this.value,
  });

  final String? id;
  final String? measurementId;
  final String metricId;
  final num value;

  @override
  List<Object?> get props => [id, measurementId, metricId, value];
}

class MeasurementSession extends Equatable {
  const MeasurementSession({
    required this.id,
    required this.memberId,
    this.recordedByUserId,
    required this.recordedAt,
    this.notes,
    this.values = const [],
  });

  final String id;
  final String memberId;
  final String? recordedByUserId;
  final DateTime recordedAt;
  final String? notes;
  final List<MeasurementValueEntry> values;

  @override
  List<Object?> get props => [
    id,
    memberId,
    recordedByUserId,
    recordedAt,
    notes,
    values,
  ];
}
