import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/pagination/cursor_page.dart';
import '../entities/goal_metric.dart';
import '../entities/goal_metric_category.dart';

abstract class GoalMetricsRepository {
  Future<Either<Failure, CursorPage<GoalMetric>>> listMetrics();

  Future<Either<Failure, GoalMetric>> createMetric({
    required String name,
    required String unitOfMeasure,
    required GoalMetricCategory category,
    bool? isActive,
  });

  Future<Either<Failure, GoalMetric>> updateMetric({
    required String id,
    required String name,
    required String unitOfMeasure,
    required GoalMetricCategory category,
    bool? isActive,
  });
}
