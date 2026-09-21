import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/pagination/cursor_page.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/goal_metric.dart';
import '../entities/goal_metric_category.dart';
import '../repositories/goal_metrics_repository.dart';

@lazySingleton
class ListGoalMetricsUseCase
    implements UseCase<CursorPage<GoalMetric>, NoParams> {
  const ListGoalMetricsUseCase(this._repository);

  final GoalMetricsRepository _repository;

  @override
  Future<Either<Failure, CursorPage<GoalMetric>>> call(NoParams params) {
    return _repository.listMetrics();
  }
}

class CreateGoalMetricParams extends Equatable {
  const CreateGoalMetricParams({
    required this.name,
    required this.unitOfMeasure,
    required this.category,
    this.isActive,
  });

  final String name;
  final String unitOfMeasure;
  final GoalMetricCategory category;
  final bool? isActive;

  @override
  List<Object?> get props => [name, unitOfMeasure, category, isActive];
}

@lazySingleton
class CreateGoalMetricUseCase
    implements UseCase<GoalMetric, CreateGoalMetricParams> {
  const CreateGoalMetricUseCase(this._repository);

  final GoalMetricsRepository _repository;

  @override
  Future<Either<Failure, GoalMetric>> call(CreateGoalMetricParams params) {
    return _repository.createMetric(
      name: params.name,
      unitOfMeasure: params.unitOfMeasure,
      category: params.category,
      isActive: params.isActive,
    );
  }
}

class UpdateGoalMetricParams extends Equatable {
  const UpdateGoalMetricParams({
    required this.id,
    required this.name,
    required this.unitOfMeasure,
    required this.category,
    this.isActive,
  });

  final String id;
  final String name;
  final String unitOfMeasure;
  final GoalMetricCategory category;
  final bool? isActive;

  @override
  List<Object?> get props => [id, name, unitOfMeasure, category, isActive];
}

@lazySingleton
class UpdateGoalMetricUseCase
    implements UseCase<GoalMetric, UpdateGoalMetricParams> {
  const UpdateGoalMetricUseCase(this._repository);

  final GoalMetricsRepository _repository;

  @override
  Future<Either<Failure, GoalMetric>> call(UpdateGoalMetricParams params) {
    return _repository.updateMetric(
      id: params.id,
      name: params.name,
      unitOfMeasure: params.unitOfMeasure,
      category: params.category,
      isActive: params.isActive,
    );
  }
}
