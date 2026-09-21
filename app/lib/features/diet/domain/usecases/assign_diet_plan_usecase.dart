import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/diet_plan.dart';
import '../repositories/diet_plan_repository.dart';

class AssignDietPlanParams extends Equatable {
  const AssignDietPlanParams({
    required this.planId,
    required this.memberId,
  });

  final String planId;
  final String memberId;

  @override
  List<Object?> get props => [planId, memberId];
}

@lazySingleton
class AssignDietPlanUseCase implements UseCase<DietPlan, AssignDietPlanParams> {
  const AssignDietPlanUseCase(this._repository);

  final DietPlanRepository _repository;

  @override
  Future<Either<Failure, DietPlan>> call(AssignDietPlanParams params) {
    return _repository.assign(params.planId, params.memberId);
  }
}
