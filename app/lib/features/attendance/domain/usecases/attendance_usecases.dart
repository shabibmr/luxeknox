import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/pagination/cursor_page.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/attendance_history_day.dart';
import '../entities/attendance_occupancy.dart';
import '../entities/attendance_pass.dart';
import '../entities/attendance_record.dart';
import '../entities/attendance_summary.dart';
import '../entities/check_in_input.dart';
import '../repositories/attendance_repository.dart';

@lazySingleton
class GetAttendancePassUseCase implements UseCase<AttendancePass, NoParams> {
  const GetAttendancePassUseCase(this._repository);

  final AttendanceRepository _repository;

  @override
  Future<Either<Failure, AttendancePass>> call(NoParams params) {
    return _repository.getPass();
  }
}

@lazySingleton
class CheckInUseCase implements UseCase<AttendanceRecord, CheckInInput> {
  const CheckInUseCase(this._repository);

  final AttendanceRepository _repository;

  @override
  Future<Either<Failure, AttendanceRecord>> call(CheckInInput params) {
    return _repository.checkIn(params);
  }
}

class CheckOutParams {
  const CheckOutParams(this.attendanceId);

  final String attendanceId;
}

@lazySingleton
class CheckOutUseCase implements UseCase<AttendanceRecord, CheckOutParams> {
  const CheckOutUseCase(this._repository);

  final AttendanceRepository _repository;

  @override
  Future<Either<Failure, AttendanceRecord>> call(CheckOutParams params) {
    return _repository.checkOut(params.attendanceId);
  }
}

class ListAttendancesParams {
  const ListAttendancesParams({
    this.userId,
    this.from,
    this.to,
    this.cursor,
    this.limit,
  });

  final String? userId;
  final DateTime? from;
  final DateTime? to;
  final String? cursor;
  final int? limit;
}

@lazySingleton
class ListAttendancesUseCase
    implements UseCase<CursorPage<AttendanceRecord>, ListAttendancesParams> {
  const ListAttendancesUseCase(this._repository);

  final AttendanceRepository _repository;

  @override
  Future<Either<Failure, CursorPage<AttendanceRecord>>> call(
    ListAttendancesParams params,
  ) {
    return _repository.listAttendances(
      userId: params.userId,
      from: params.from,
      to: params.to,
      cursor: params.cursor,
      limit: params.limit,
    );
  }
}

class GetAttendanceSummaryParams {
  const GetAttendanceSummaryParams({this.memberId});

  final String? memberId;
}

@lazySingleton
class GetAttendanceSummaryUseCase
    implements UseCase<AttendanceSummaryInfo, GetAttendanceSummaryParams> {
  const GetAttendanceSummaryUseCase(this._repository);

  final AttendanceRepository _repository;

  @override
  Future<Either<Failure, AttendanceSummaryInfo>> call(
    GetAttendanceSummaryParams params,
  ) {
    return _repository.getSummary(memberId: params.memberId);
  }
}

@lazySingleton
class GetAttendanceOccupancyUseCase
    implements UseCase<AttendanceOccupancy, NoParams> {
  const GetAttendanceOccupancyUseCase(this._repository);

  final AttendanceRepository _repository;

  @override
  Future<Either<Failure, AttendanceOccupancy>> call(NoParams params) {
    return _repository.getOccupancy();
  }
}

class ListAttendanceHistoriesParams {
  const ListAttendanceHistoriesParams({this.from, this.to});

  final DateTime? from;
  final DateTime? to;
}

@lazySingleton
class ListAttendanceHistoriesUseCase
    implements UseCase<List<AttendanceHistoryDay>, ListAttendanceHistoriesParams> {
  const ListAttendanceHistoriesUseCase(this._repository);

  final AttendanceRepository _repository;

  @override
  Future<Either<Failure, List<AttendanceHistoryDay>>> call(
    ListAttendanceHistoriesParams params,
  ) {
    return _repository.listHistories(from: params.from, to: params.to);
  }
}

class MarkSessionAttendanceParams {
  const MarkSessionAttendanceParams({
    required this.scheduleId,
    required this.participantId,
    required this.attended,
  });

  final String scheduleId;
  final String participantId;
  final bool attended;
}

@lazySingleton
class MarkSessionAttendanceUseCase
    implements UseCase<Unit, MarkSessionAttendanceParams> {
  const MarkSessionAttendanceUseCase(this._repository);

  final AttendanceRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(MarkSessionAttendanceParams params) {
    return _repository.markSessionAttendance(
      scheduleId: params.scheduleId,
      participantId: params.participantId,
      attended: params.attended,
    );
  }
}
