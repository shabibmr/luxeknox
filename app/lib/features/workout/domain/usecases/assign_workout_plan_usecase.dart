import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/workout_plan.dart';
import '../repositories/workout_plan_repository.dart';

class AssignWorkoutPlanParams extends Equatable {
  const AssignWorkoutPlanParams({
    required this.planId,
    required this.memberId,
  });

  final String planId;
  final String memberId;

  @override
  List<Object?> get props => [planId, memberId];
}

@lazySingleton
class AssignWorkoutPlanUseCase
    implements UseCase<WorkoutPlan, AssignWorkoutPlanParams> {
  const AssignWorkoutPlanUseCase(this._repository);

  final WorkoutPlanRepository _repository;

  @override
  Future<Either<Failure, WorkoutPlan>> call(AssignWorkoutPlanParams params) {
    return _repository.assign(params.planId, params.memberId);
  }
}
