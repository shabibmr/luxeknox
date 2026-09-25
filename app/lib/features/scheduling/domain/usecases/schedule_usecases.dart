import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/pagination/cursor_page.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/schedule_session.dart';
import '../repositories/scheduling_repository.dart';

class ListSchedulesParams extends Equatable {
  const ListSchedulesParams({
    this.from,
    this.to,
    this.trainerId,
    this.memberId,
    this.cursor,
    this.limit,
  });

  final DateTime? from;
  final DateTime? to;
  final String? trainerId;
  final String? memberId;
  final String? cursor;
  final int? limit;

  @override
  List<Object?> get props => [from, to, trainerId, memberId, cursor, limit];
}

@lazySingleton
class ListSchedulesUseCase
    implements UseCase<CursorPage<ScheduleSession>, ListSchedulesParams> {
  const ListSchedulesUseCase(this._repository);

  final SchedulingRepository _repository;

  @override
  Future<Either<Failure, CursorPage<ScheduleSession>>> call(
    ListSchedulesParams params,
  ) {
    return _repository.listSchedules(
      from: params.from,
      to: params.to,
      trainerId: params.trainerId,
      memberId: params.memberId,
      cursor: params.cursor,
      limit: params.limit,
    );
  }
}

@lazySingleton
class GetScheduleUseCase implements UseCase<ScheduleSession, String> {
  const GetScheduleUseCase(this._repository);

  final SchedulingRepository _repository;

  @override
  Future<Either<Failure, ScheduleSession>> call(String id) {
    return _repository.getSchedule(id);
  }
}

@lazySingleton
class CreateScheduleUseCase
    implements UseCase<ScheduleSession, CreateScheduleInput> {
  const CreateScheduleUseCase(this._repository);

  final SchedulingRepository _repository;

  @override
  Future<Either<Failure, ScheduleSession>> call(CreateScheduleInput params) {
    return _repository.createSchedule(params);
  }
}

class CancelScheduleParams extends Equatable {
  const CancelScheduleParams({
    required this.scheduleId,
    this.reason,
    this.rowVersion,
  });

  final String scheduleId;
  final String? reason;
  final int? rowVersion;

  @override
  List<Object?> get props => [scheduleId, reason, rowVersion];
}

@lazySingleton
class CancelScheduleUseCase
    implements UseCase<ScheduleSession, CancelScheduleParams> {
  const CancelScheduleUseCase(this._repository);

  final SchedulingRepository _repository;

  @override
  Future<Either<Failure, ScheduleSession>> call(CancelScheduleParams params) {
    return _repository.cancelSchedule(
      id: params.scheduleId,
      reason: params.reason,
      rowVersion: params.rowVersion,
    );
  }
}

class BookScheduleParams extends Equatable {
  const BookScheduleParams({
    required this.scheduleId,
    required this.memberId,
    required this.idempotencyKey,
  });

  final String scheduleId;
  final String memberId;
  final String idempotencyKey;

  @override
  List<Object?> get props => [scheduleId, memberId, idempotencyKey];
}

@lazySingleton
class BookScheduleUseCase
    implements UseCase<ScheduleParticipantEntry, BookScheduleParams> {
  const BookScheduleUseCase(this._repository);

  final SchedulingRepository _repository;

  @override
  Future<Either<Failure, ScheduleParticipantEntry>> call(
    BookScheduleParams params,
  ) {
    return _repository.addParticipant(
      scheduleId: params.scheduleId,
      memberId: params.memberId,
      idempotencyKey: params.idempotencyKey,
    );
  }
}

class UnbookScheduleParams extends Equatable {
  const UnbookScheduleParams({
    required this.scheduleId,
    required this.memberId,
    this.reason,
  });

  final String scheduleId;
  final String memberId;
  final String? reason;

  @override
  List<Object?> get props => [scheduleId, memberId, reason];
}

@lazySingleton
class UnbookScheduleUseCase implements UseCase<Unit, UnbookScheduleParams> {
  const UnbookScheduleUseCase(this._repository);

  final SchedulingRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(UnbookScheduleParams params) {
    return _repository.removeParticipant(
      scheduleId: params.scheduleId,
      memberId: params.memberId,
      reason: params.reason,
    );
  }
}

@lazySingleton
class StartScheduleUseCase implements UseCase<ScheduleSession, String> {
  const StartScheduleUseCase(this._repository);

  final SchedulingRepository _repository;

  @override
  Future<Either<Failure, ScheduleSession>> call(String id) {
    return _repository.startSchedule(id);
  }
}

@lazySingleton
class CompleteScheduleUseCase implements UseCase<ScheduleSession, String> {
  const CompleteScheduleUseCase(this._repository);

  final SchedulingRepository _repository;

  @override
  Future<Either<Failure, ScheduleSession>> call(String id) {
    return _repository.completeSchedule(id);
  }
}
