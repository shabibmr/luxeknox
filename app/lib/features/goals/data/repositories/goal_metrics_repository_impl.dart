import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/error/map_thrown.dart';
import '../../../../core/pagination/cursor_page.dart';
import '../../domain/entities/goal_metric.dart';
import '../../domain/entities/goal_metric_category.dart';
import '../../domain/repositories/goal_metrics_repository.dart';
import '../datasources/goals_remote_datasource.dart';
import '../models/goals_mappers.dart';

@LazySingleton(as: GoalMetricsRepository)
class GoalMetricsRepositoryImpl implements GoalMetricsRepository {
  GoalMetricsRepositoryImpl(this._remote);

  final GoalsRemoteDataSource _remote;

  int? _parseId(String id) => int.tryParse(id);

  @override
  Future<Either<Failure, CursorPage<GoalMetric>>> listMetrics() async {
    try {
      final page = await _remote.listGoalMetrics();
      return Right(
        CursorPage(
          items: page.data.map((m) => m.toDomain()).toList(),
          nextCursor: page.meta.nextCursor,
          hasMore: page.meta.hasMore,
        ),
      );
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, GoalMetric>> createMetric({
    required String name,
    required String unitOfMeasure,
    required GoalMetricCategory category,
    bool? isActive,
  }) async {
    try {
      final created = await _remote.createGoalMetric(
        toGoalMetricWrite(
          name: name,
          unitOfMeasure: unitOfMeasure,
          category: category,
          isActive: isActive,
        ),
      );
      return Right(created.toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, GoalMetric>> updateMetric({
    required String id,
    required String name,
    required String unitOfMeasure,
    required GoalMetricCategory category,
    bool? isActive,
  }) async {
    final intId = _parseId(id);
    if (intId == null) return const Left(NotFoundFailure());
    try {
      final updated = await _remote.updateGoalMetric(
        intId,
        toGoalMetricWrite(
          name: name,
          unitOfMeasure: unitOfMeasure,
          category: category,
          isActive: isActive,
        ),
      );
      return Right(updated.toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }
}
