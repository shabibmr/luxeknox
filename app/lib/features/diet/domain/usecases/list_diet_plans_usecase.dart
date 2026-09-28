import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/pagination/cursor_page.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/diet_plan.dart';
import '../repositories/diet_plan_repository.dart';

class ListDietPlansParams extends Equatable {
  const ListDietPlansParams({
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
class ListDietPlansUseCase
    implements UseCase<CursorPage<DietPlan>, ListDietPlansParams> {
  const ListDietPlansUseCase(this._repository);

  final DietPlanRepository _repository;

  @override
  Future<Either<Failure, CursorPage<DietPlan>>> call(
    ListDietPlansParams params,
  ) {
    return _repository.listPlans(
      memberId: params.memberId,
      isTemplate: params.isTemplate,
      limit: params.limit,
      offset: params.offset,
    );
  }
}
