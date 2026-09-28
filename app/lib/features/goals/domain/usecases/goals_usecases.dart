import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/pagination/cursor_page.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/goal_history.dart';
import '../entities/goal_status.dart';
import '../entities/member_goal.dart';
import '../repositories/goals_repository.dart';

class MemberIdParams extends Equatable {
  const MemberIdParams(this.memberId);

  final String memberId;

  @override
  List<Object?> get props => [memberId];
}

@lazySingleton
class ListMemberGoalsUseCase
    implements UseCase<CursorPage<MemberGoal>, MemberIdParams> {
  const ListMemberGoalsUseCase(this._repository);

  final GoalsRepository _repository;

  @override
  Future<Either<Failure, CursorPage<MemberGoal>>> call(MemberIdParams params) {
    return _repository.listMemberGoals(params.memberId);
  }
}

@lazySingleton
class GetGoalUseCase implements UseCase<MemberGoal, String> {
  const GetGoalUseCase(this._repository);

  final GoalsRepository _repository;

  @override
  Future<Either<Failure, MemberGoal>> call(String id) {
    return _repository.getGoal(id);
  }
}

class CreateMemberGoalParams extends Equatable {
  const CreateMemberGoalParams({
    required this.memberId,
    required this.metricId,
    this.baselineValue,
    this.targetValue,
    this.startDate,
    this.targetDate,
    this.status,
  });

  final String memberId;
  final String metricId;
  final num? baselineValue;
  final num? targetValue;
  final DateTime? startDate;
  final DateTime? targetDate;
  final GoalStatus? status;

  @override
  List<Object?> get props => [
    memberId,
    metricId,
    baselineValue,
    targetValue,
    startDate,
    targetDate,
    status,
  ];
}

@lazySingleton
class CreateMemberGoalUseCase
    implements UseCase<MemberGoal, CreateMemberGoalParams> {
  const CreateMemberGoalUseCase(this._repository);

  final GoalsRepository _repository;

  @override
  Future<Either<Failure, MemberGoal>> call(CreateMemberGoalParams params) {
    return _repository.createMemberGoal(
      memberId: params.memberId,
      metricId: params.metricId,
      baselineValue: params.baselineValue,
      targetValue: params.targetValue,
      startDate: params.startDate,
      targetDate: params.targetDate,
      status: params.status,
    );
  }
}

class UpdateGoalParams extends Equatable {
  const UpdateGoalParams({
    required this.id,
    this.metricId,
    this.baselineValue,
    this.targetValue,
    this.startDate,
    this.targetDate,
    this.status,
  });

  final String id;
  final String? metricId;
  final num? baselineValue;
  final num? targetValue;
  final DateTime? startDate;
  final DateTime? targetDate;
  final GoalStatus? status;

  @override
  List<Object?> get props => [
    id,
    metricId,
    baselineValue,
    targetValue,
    startDate,
    targetDate,
    status,
  ];
}

@lazySingleton
class UpdateGoalUseCase implements UseCase<MemberGoal, UpdateGoalParams> {
  const UpdateGoalUseCase(this._repository);

  final GoalsRepository _repository;

  @override
  Future<Either<Failure, MemberGoal>> call(UpdateGoalParams params) {
    return _repository.updateGoal(
      id: params.id,
      metricId: params.metricId,
      baselineValue: params.baselineValue,
      targetValue: params.targetValue,
      startDate: params.startDate,
      targetDate: params.targetDate,
      status: params.status,
    );
  }
}

class CheckInGoalParams extends Equatable {
  const CheckInGoalParams({
    required this.id,
    required this.recordedValue,
    this.recordedDate,
    this.notes,
  });

  final String id;
  final num recordedValue;
  final DateTime? recordedDate;
  final String? notes;

  @override
  List<Object?> get props => [id, recordedValue, recordedDate, notes];
}

@lazySingleton
class CheckInGoalUseCase
    implements UseCase<GoalHistoryEntry, CheckInGoalParams> {
  const CheckInGoalUseCase(this._repository);

  final GoalsRepository _repository;

  @override
  Future<Either<Failure, GoalHistoryEntry>> call(CheckInGoalParams params) {
    return _repository.checkInGoal(
      id: params.id,
      recordedValue: params.recordedValue,
      recordedDate: params.recordedDate,
      notes: params.notes,
    );
  }
}
