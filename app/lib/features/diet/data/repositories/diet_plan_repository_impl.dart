import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/error/map_thrown.dart';
import '../../../../core/pagination/cursor_page.dart';
import '../../domain/entities/diet_plan.dart';
import '../../domain/entities/diet_plan_meal_input.dart';
import '../../domain/entities/diet_plan_version.dart';
import '../../domain/repositories/diet_plan_repository.dart';
import '../datasources/diet_plan_remote_datasource.dart';
import '../models/diet_plan_mappers.dart';

@LazySingleton(as: DietPlanRepository)
class DietPlanRepositoryImpl implements DietPlanRepository {
  DietPlanRepositoryImpl(this._remoteDataSource);

  final DietPlanRemoteDataSource _remoteDataSource;

  int? _parseId(String id) => int.tryParse(id);

  @override
  Future<Either<Failure, CursorPage<DietPlan>>> listPlans({
    String? memberId,
    bool? isTemplate,
    int? limit,
    int? offset,
  }) async {
    try {
      final page = await _remoteDataSource.listPlans(
        memberId: memberId == null ? null : int.tryParse(memberId),
        isTemplate: isTemplate,
        limit: limit,
        offset: offset,
      );
      return Right(
        CursorPage<DietPlan>(
          items: page.data.map((p) => p.toDomain()).toList(),
          nextCursor: page.meta.nextCursor,
          hasMore: page.meta.hasMore,
        ),
      );
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, DietPlan>> getPlan(String id) async {
    final intId = _parseId(id);
    if (intId == null) return const Left(NotFoundFailure());
    try {
      final model = await _remoteDataSource.getPlan(intId);
      return Right(model.toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, DietPlan>> createPlan({
    required String title,
    String? memberId,
    String? trainerId,
    int? dailyCalorieTarget,
    num? proteinTargetG,
    num? carbsTargetG,
    num? fatTargetG,
    bool? isTemplate,
  }) async {
    try {
      final created = await _remoteDataSource.createPlan(
        toDietPlanWrite(
          title: title,
          memberId: memberId,
          trainerId: trainerId,
          dailyCalorieTarget: dailyCalorieTarget,
          proteinTargetG: proteinTargetG,
          carbsTargetG: carbsTargetG,
          fatTargetG: fatTargetG,
          isTemplate: isTemplate,
        ),
      );
      return Right(created.toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, DietPlan>> updatePlan(
    String id, {
    String? title,
    String? memberId,
    String? trainerId,
    int? dailyCalorieTarget,
    num? proteinTargetG,
    num? carbsTargetG,
    num? fatTargetG,
    bool? isTemplate,
    required int rowVersion,
  }) async {
    final intId = _parseId(id);
    if (intId == null) return const Left(NotFoundFailure());
    try {
      final updated = await _remoteDataSource.updatePlan(
        intId,
        toDietPlanWrite(
          title: title,
          memberId: memberId,
          trainerId: trainerId,
          dailyCalorieTarget: dailyCalorieTarget,
          proteinTargetG: proteinTargetG,
          carbsTargetG: carbsTargetG,
          fatTargetG: fatTargetG,
          isTemplate: isTemplate,
          rowVersion: rowVersion,
        ),
      );
      return Right(updated.toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, DietPlan>> replaceMeals(
    String id, {
    required int rowVersion,
    String? changelog,
    required List<DietPlanMealInput> meals,
  }) async {
    final intId = _parseId(id);
    if (intId == null) return const Left(NotFoundFailure());
    try {
      final updated = await _remoteDataSource.replaceMeals(
        intId,
        toDietPlanMealsWrite(
          rowVersion: rowVersion,
          changelog: changelog,
          meals: meals,
        ),
      );
      return Right(updated.toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, DietPlan>> publish(String id) async {
    final intId = _parseId(id);
    if (intId == null) return const Left(NotFoundFailure());
    try {
      final updated = await _remoteDataSource.publish(intId);
      return Right(updated.toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, DietPlan>> archive(String id) async {
    final intId = _parseId(id);
    if (intId == null) return const Left(NotFoundFailure());
    try {
      final updated = await _remoteDataSource.archive(intId);
      return Right(updated.toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, DietPlan>> assign(
    String planId,
    String memberId,
  ) async {
    final intPlanId = _parseId(planId);
    if (intPlanId == null || int.tryParse(memberId) == null) {
      return const Left(ValidationFailure(['Invalid plan or member id']));
    }
    try {
      final assigned = await _remoteDataSource.assign(
        intPlanId,
        toAssignPlanRequest(memberId),
      );
      return Right(assigned.toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<DietPlanVersion>>> listVersions(
    String planId,
  ) async {
    final intId = _parseId(planId);
    if (intId == null) return const Left(NotFoundFailure());
    try {
      final page = await _remoteDataSource.listVersions(intId);
      return Right(page.data.map((v) => v.toDomain()).toList());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }
}

