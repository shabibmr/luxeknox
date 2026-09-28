import 'package:equatable/equatable.dart';

import 'goal_metric.dart';
import 'goal_status.dart';

class MemberGoal extends Equatable {
  const MemberGoal({
    required this.id,
    required this.memberId,
    required this.metricId,
    this.baselineValue,
    this.targetValue,
    this.currentValue,
    this.startDate,
    this.targetDate,
    required this.status,
    this.metric,
  });

  final String id;
  final String memberId;
  final String metricId;
  final num? baselineValue;
  final num? targetValue;
  final num? currentValue;
  final DateTime? startDate;
  final DateTime? targetDate;
  final GoalStatus status;
  final GoalMetric? metric;

  @override
  List<Object?> get props => [
    id,
    memberId,
    metricId,
    baselineValue,
    targetValue,
    currentValue,
    startDate,
    targetDate,
    status,
    metric,
  ];
}
