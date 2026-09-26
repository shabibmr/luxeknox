import 'package:api_client/api_client.dart' as api;
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/error/map_thrown.dart';
import '../../../../core/pagination/cursor_page.dart';
import '../../domain/entities/attendance_history_day.dart';
import '../../domain/entities/attendance_occupancy.dart';
import '../../domain/entities/attendance_pass.dart';
import '../../domain/entities/attendance_record.dart';
import '../../domain/entities/attendance_summary.dart';
import '../../domain/entities/check_in_input.dart';
import '../../domain/repositories/attendance_repository.dart';
import '../../../membership/data/models/membership_date.dart';
import '../datasources/attendance_remote_datasource.dart';
import '../models/attendance_mappers.dart';

@LazySingleton(as: AttendanceRepository)
class AttendanceRepositoryImpl implements AttendanceRepository {
  AttendanceRepositoryImpl(this._remote);

  final AttendanceRemoteDataSource _remote;

  int? _parseId(String? id) => id == null ? null : int.tryParse(id);

  @override
  Future<Either<Failure, AttendancePass>> getPass() async {
    try {
      final pass = await _remote.getPass();
      return Right(pass.toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, AttendanceRecord>> checkIn(CheckInInput input) async {
    try {
      final userId = _parseId(input.userId);
      if (input.userId != null && userId == null) {
        return const Left(ValidationFailure(['Invalid user id']));
      }
      final request = api.CheckInRequest(
        (b) {
          if (userId != null) b.userId = userId;
          if (input.method != null) b.method = input.method!.toApi();
          if (input.gateIdentifier != null) {
            b.gateIdentifier = input.gateIdentifier;
          }
          if (input.payload != null) b.payload = input.payload;
        },
      );
      final attendance = await _remote.checkIn(
        request: request,
        idempotencyKey: input.idempotencyKey,
      );
      return Right(attendance.toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, AttendanceRecord>> checkOut(
    String attendanceId,
  ) async {
    final id = _parseId(attendanceId);
    if (id == null) {
      return const Left(ValidationFailure(['Invalid attendance id']));
    }
    try {
      final attendance = await _remote.checkOut(id);
      return Right(attendance.toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, CursorPage<AttendanceRecord>>> listAttendances({
    String? userId,
    DateTime? from,
    DateTime? to,
    String? cursor,
    int? limit,
  }) async {
    final parsedUserId = _parseId(userId);
    if (userId != null && parsedUserId == null) {
      return const Left(ValidationFailure(['Invalid user id']));
    }
    try {
      final page = await _remote.listAttendances(
        userId: parsedUserId,
        from: from,
        to: to,
        cursor: cursor,
        limit: limit,
      );
      return Right(
        CursorPage(
          items: page.data.map((a) => a.toDomain()).toList(),
          nextCursor: page.meta.nextCursor,
          hasMore: page.meta.hasMore,
        ),
      );
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, AttendanceSummaryInfo>> getSummary({
    String? memberId,
  }) async {
    final parsed = _parseId(memberId);
    if (memberId != null && parsed == null) {
      return const Left(ValidationFailure(['Invalid member id']));
    }
    try {
      final summary = await _remote.getSummary(memberId: parsed);
      return Right(summary.toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, AttendanceOccupancy>> getOccupancy() async {
    try {
      final occupancy = await _remote.getOccupancy();
      return Right(occupancy.toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<AttendanceHistoryDay>>> listHistories({
    DateTime? from,
    DateTime? to,
  }) async {
    try {
      final page = await _remote.listHistories(
        from: from == null ? null : dateTimeToApiDate(from),
        to: to == null ? null : dateTimeToApiDate(to),
      );
      return Right(page.data.map((h) => h.toDomain()).toList());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> markSessionAttendance({
    required String scheduleId,
    required String participantId,
    required bool attended,
  }) async {
    final schedId = _parseId(scheduleId);
    final partId = _parseId(participantId);
    if (schedId == null || partId == null) {
      return const Left(
        ValidationFailure(['Invalid schedule or participant id']),
      );
    }
    try {
      await _remote.markSessionAttendance(
        scheduleId: schedId,
        participantId: partId,
        attended: attended,
      );
      return const Right(unit);
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }
}
