import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/error/map_thrown.dart';
import '../../../../core/pagination/cursor_page.dart';
import '../../domain/entities/goal_history.dart';
import '../../domain/entities/goal_status.dart';
import '../../domain/entities/member_goal.dart';
import '../../domain/repositories/goals_repository.dart';
import '../datasources/goals_remote_datasource.dart';
import '../models/goals_mappers.dart';

@LazySingleton(as: GoalsRepository)
class GoalsRepositoryImpl implements GoalsRepository {
  GoalsRepositoryImpl(this._remote);

  final GoalsRemoteDataSource _remote;

  int? _parseId(String id) => int.tryParse(id);

  @override
  Future<Either<Failure, CursorPage<MemberGoal>>> listMemberGoals(
    String memberId,
  ) async {
    final intId = _parseId(memberId);
    if (intId == null) {
      return const Left(ValidationFailure(['Invalid member id']));
    }
    try {
      final page = await _remote.listMemberGoals(intId);
      return Right(
        CursorPage(
          items: page.data.map((g) => g.toDomain()).toList(),
          nextCursor: page.meta.nextCursor,
          hasMore: page.meta.hasMore,
        ),
      );
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, MemberGoal>> getGoal(String id) async {
    final intId = _parseId(id);
    if (intId == null) return const Left(NotFoundFailure());
    try {
      final goal = await _remote.getGoal(intId);
      return Right(goal.toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, MemberGoal>> createMemberGoal({
    required String memberId,
    required String metricId,
    num? baselineValue,
    num? targetValue,
    DateTime? startDate,
    DateTime? targetDate,
    GoalStatus? status,
  }) async {
    final intMemberId = _parseId(memberId);
    if (intMemberId == null) {
      return const Left(ValidationFailure(['Invalid member id']));
    }
    try {
      final created = await _remote.createMemberGoal(
        intMemberId,
        toGoalWrite(
          metricId: metricId,
          baselineValue: baselineValue,
          targetValue: targetValue,
          startDate: startDate,
          targetDate: targetDate,
          status: status,
        ),
      );
      return Right(created.toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, MemberGoal>> updateGoal({
    required String id,
    String? metricId,
    num? baselineValue,
    num? targetValue,
    DateTime? startDate,
    DateTime? targetDate,
    GoalStatus? status,
  }) async {
    final intId = _parseId(id);
    if (intId == null) return const Left(NotFoundFailure());
    try {
      final updated = await _remote.updateGoal(
        intId,
        toGoalWrite(
          metricId: metricId,
          baselineValue: baselineValue,
          targetValue: targetValue,
          startDate: startDate,
          targetDate: targetDate,
          status: status,
        ),
      );
      return Right(updated.toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, GoalHistoryEntry>> checkInGoal({
    required String id,
    required num recordedValue,
    DateTime? recordedDate,
    String? notes,
  }) async {
    final intId = _parseId(id);
    if (intId == null) return const Left(NotFoundFailure());
    try {
      final entry = await _remote.checkInGoal(
        intId,
        toGoalCheckInWrite(
          recordedValue: recordedValue,
          recordedDate: recordedDate,
          notes: notes,
        ),
      );
      return Right(entry.toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }
}
