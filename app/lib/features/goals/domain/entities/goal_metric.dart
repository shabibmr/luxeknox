import 'package:equatable/equatable.dart';

import 'goal_metric_category.dart';

class GoalMetric extends Equatable {
  const GoalMetric({
    required this.id,
    required this.name,
    required this.unitOfMeasure,
    required this.category,
    required this.isActive,
  });

  final String id;
  final String name;
  final String unitOfMeasure;
  final GoalMetricCategory category;
  final bool isActive;

  @override
  List<Object?> get props => [id, name, unitOfMeasure, category, isActive];
}
