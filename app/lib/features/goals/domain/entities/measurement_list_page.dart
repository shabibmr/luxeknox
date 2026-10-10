import 'package:equatable/equatable.dart';

import 'measurement.dart';

/// Member measurement list page including server `mandatory_metric_ids`.
class MeasurementListPage extends Equatable {
  const MeasurementListPage({
    required this.items,
    required this.nextCursor,
    required this.hasMore,
    this.mandatoryMetricIds = const [],
  });

  final List<MeasurementSession> items;
  final String? nextCursor;
  final bool hasMore;
  final List<String> mandatoryMetricIds;

  @override
  List<Object?> get props => [items, nextCursor, hasMore, mandatoryMetricIds];
}
