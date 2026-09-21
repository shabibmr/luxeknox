import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/pagination/cursor_page.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/workout_plan.dart';
import '../repositories/workout_plan_repository.dart';

class ListWorkoutPlansParams extends Equatable {
  const ListWorkoutPlansParams({
    this.memberId,
    this.isTemplate,
    this.limit,
    this.offset,
  });

  final String? memberId;
  final bool? isTemplate;
  final int? limit;
  final int? offset;

  @override
  List<Object?> get props => [memberId, isTemplate, limit, offset];
}

@lazySingleton
class ListWorkoutPlansUseCase
    implements UseCase<CursorPage<WorkoutPlan>, ListWorkoutPlansParams> {
  const ListWorkoutPlansUseCase(this._repository);

  final WorkoutPlanRepository _repository;

  @override
  Future<Either<Failure, CursorPage<WorkoutPlan>>> call(
    ListWorkoutPlansParams params,
  ) {
    return _repository.listPlans(
      memberId: params.memberId,
      isTemplate: params.isTemplate,
      limit: params.limit,
      offset: params.offset,
    );
  }
}
