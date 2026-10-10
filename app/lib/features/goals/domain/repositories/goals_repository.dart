import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/pagination/cursor_page.dart';
import '../entities/goal_history.dart';
import '../entities/goal_status.dart';
import '../entities/member_goal.dart';
import '../entities/progress_aggregate.dart';

abstract class GoalsRepository {
  Future<Either<Failure, CursorPage<MemberGoal>>> listAllGoals({
    String? status,
    String? metricId,
    int? limit,
    String? cursor,
  });

  Future<Either<Failure, ProgressAggregateCounts>> getProgressAggregate();

  Future<Either<Failure, CursorPage<MemberGoal>>> listMemberGoals(
    String memberId,
  );

  Future<Either<Failure, MemberGoal>> getGoal(String id);

  Future<Either<Failure, MemberGoal>> createMemberGoal({
    required String memberId,
    required String metricId,
    num? baselineValue,
    num? targetValue,
    DateTime? startDate,
    DateTime? targetDate,
    GoalStatus? status,
  });

  Future<Either<Failure, MemberGoal>> updateGoal({
    required String id,
    String? metricId,
    num? baselineValue,
    num? targetValue,
    DateTime? startDate,
    DateTime? targetDate,
    GoalStatus? status,
  });

  Future<Either<Failure, GoalHistoryEntry>> checkInGoal({
    required String id,
    required num recordedValue,
    DateTime? recordedDate,
    String? notes,
  });
}
