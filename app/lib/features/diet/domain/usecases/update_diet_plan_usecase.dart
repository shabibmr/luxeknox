import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/diet_plan.dart';
import '../repositories/diet_plan_repository.dart';

class UpdateDietPlanParams extends Equatable {
  const UpdateDietPlanParams({
    required this.id,
    required this.rowVersion,
    this.title,
    this.memberId,
    this.trainerId,
    this.dailyCalorieTarget,
    this.proteinTargetG,
    this.carbsTargetG,
    this.fatTargetG,
    this.isTemplate,
  });

  final String id;
  final int rowVersion;
  final String? title;
  final String? memberId;
  final String? trainerId;
  final int? dailyCalorieTarget;
  final num? proteinTargetG;
  final num? carbsTargetG;
  final num? fatTargetG;
  final bool? isTemplate;

  @override
  List<Object?> get props => [
    id,
    rowVersion,
    title,
    memberId,
    trainerId,
    dailyCalorieTarget,
    proteinTargetG,
    carbsTargetG,
    fatTargetG,
    isTemplate,
  ];
}

@lazySingleton
class UpdateDietPlanUseCase
    implements UseCase<DietPlan, UpdateDietPlanParams> {
  const UpdateDietPlanUseCase(this._repository);

  final DietPlanRepository _repository;

  @override
  Future<Either<Failure, DietPlan>> call(UpdateDietPlanParams params) {
    return _repository.updatePlan(
      params.id,
      title: params.title,
      memberId: params.memberId,
      trainerId: params.trainerId,
      dailyCalorieTarget: params.dailyCalorieTarget,
      proteinTargetG: params.proteinTargetG,
      carbsTargetG: params.carbsTargetG,
      fatTargetG: params.fatTargetG,
      isTemplate: params.isTemplate,
      rowVersion: params.rowVersion,
    );
  }
}
