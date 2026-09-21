import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/error/map_thrown.dart';
import '../../../../core/pagination/cursor_page.dart';
import '../../domain/entities/workout_plan.dart';
import '../../domain/entities/workout_plan_exercise_input.dart';
import '../../domain/entities/workout_plan_version.dart';
import '../../domain/repositories/workout_plan_repository.dart';
import '../datasources/workout_plan_remote_datasource.dart';
import '../models/workout_plan_mappers.dart';

@LazySingleton(as: WorkoutPlanRepository)
class WorkoutPlanRepositoryImpl implements WorkoutPlanRepository {
  WorkoutPlanRepositoryImpl(this._remoteDataSource);

  final WorkoutPlanRemoteDataSource _remoteDataSource;

  int? _parseId(String id) => int.tryParse(id);

  @override
  Future<Either<Failure, CursorPage<WorkoutPlan>>> listPlans({
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
        CursorPage<WorkoutPlan>(
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
  Future<Either<Failure, WorkoutPlan>> getPlan(String id) async {
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
  Future<Either<Failure, WorkoutPlan>> createPlan({
    required String title,
    String? description,
    String? memberId,
    String? trainerId,
    String? targetGoal,
    String? difficulty,
    int? durationWeeks,
    bool? isTemplate,
  }) async {
    try {
      final created = await _remoteDataSource.createPlan(
        toWorkoutPlanWrite(
          title: title,
          description: description,
          memberId: memberId,
          trainerId: trainerId,
          targetGoal: targetGoal,
          difficulty: difficulty,
          durationWeeks: durationWeeks,
          isTemplate: isTemplate,
        ),
      );
      return Right(created.toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, WorkoutPlan>> updatePlan(
    String id, {
    String? title,
    String? description,
    String? memberId,
    String? trainerId,
    String? targetGoal,
    String? difficulty,
    int? durationWeeks,
    bool? isTemplate,
    required int rowVersion,
  }) async {
    final intId = _parseId(id);
    if (intId == null) return const Left(NotFoundFailure());
    try {
      final updated = await _remoteDataSource.updatePlan(
        intId,
        toWorkoutPlanWrite(
          title: title,
          description: description,
          memberId: memberId,
          trainerId: trainerId,
          targetGoal: targetGoal,
          difficulty: difficulty,
          durationWeeks: durationWeeks,
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
  Future<Either<Failure, WorkoutPlan>> replaceExercises(
    String id, {
    required int rowVersion,
    String? changelog,
    required List<WorkoutPlanExerciseInput> exercises,
  }) async {
    final intId = _parseId(id);
    if (intId == null) return const Left(NotFoundFailure());
    try {
      final updated = await _remoteDataSource.replaceExercises(
        intId,
        toWorkoutPlanExercisesWrite(
          rowVersion: rowVersion,
          changelog: changelog,
          exercises: exercises,
        ),
      );
      return Right(updated.toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, WorkoutPlan>> publish(String id) async {
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
  Future<Either<Failure, WorkoutPlan>> archive(String id) async {
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
  Future<Either<Failure, WorkoutPlan>> assign(
    String planId,
    String memberId,
  ) async {
    final intId = _parseId(planId);
    final memberInt = int.tryParse(memberId);
    if (intId == null || memberInt == null) {
      return const Left(ValidationFailure(['Invalid plan or member id']));
    }
    try {
      final assigned = await _remoteDataSource.assign(
        intId,
        toAssignPlanRequest(memberId),
      );
      return Right(assigned.toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<WorkoutPlanVersion>>> listVersions(
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
