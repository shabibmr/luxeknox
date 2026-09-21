import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/diet_plan.dart';
import '../repositories/diet_plan_repository.dart';

class CreateDietPlanParams extends Equatable {
  const CreateDietPlanParams({
    required this.title,
    this.memberId,
    this.trainerId,
    this.dailyCalorieTarget,
    this.proteinTargetG,
    this.carbsTargetG,
    this.fatTargetG,
    this.isTemplate,
  });

  final String title;
  final String? memberId;
  final String? trainerId;
  final int? dailyCalorieTarget;
  final num? proteinTargetG;
  final num? carbsTargetG;
  final num? fatTargetG;
  final bool? isTemplate;

  @override
  List<Object?> get props => [
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
class CreateDietPlanUseCase
    implements UseCase<DietPlan, CreateDietPlanParams> {
  const CreateDietPlanUseCase(this._repository);

  final DietPlanRepository _repository;

  @override
  Future<Either<Failure, DietPlan>> call(CreateDietPlanParams params) {
    return _repository.createPlan(
      title: params.title,
      memberId: params.memberId,
      trainerId: params.trainerId,
      dailyCalorieTarget: params.dailyCalorieTarget,
      proteinTargetG: params.proteinTargetG,
      carbsTargetG: params.carbsTargetG,
      fatTargetG: params.fatTargetG,
      isTemplate: params.isTemplate,
    );
  }
}
