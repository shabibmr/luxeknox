import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/pagination/cursor_page.dart';
import '../entities/attendance_history_day.dart';
import '../entities/attendance_occupancy.dart';
import '../entities/attendance_pass.dart';
import '../entities/attendance_record.dart';
import '../entities/attendance_summary.dart';
import '../entities/check_in_input.dart';

abstract class AttendanceRepository {
  Future<Either<Failure, AttendancePass>> getPass();

  Future<Either<Failure, AttendanceRecord>> checkIn(CheckInInput input);

  Future<Either<Failure, AttendanceRecord>> checkOut(String attendanceId);

  Future<Either<Failure, CursorPage<AttendanceRecord>>> listAttendances({
    String? userId,
    DateTime? from,
    DateTime? to,
    String? cursor,
    int? limit,
  });

  Future<Either<Failure, AttendanceSummaryInfo>> getSummary({String? memberId});

  Future<Either<Failure, AttendanceOccupancy>> getOccupancy();

  Future<Either<Failure, List<AttendanceHistoryDay>>> listHistories({
    DateTime? from,
    DateTime? to,
  });

  Future<Either<Failure, Unit>> markSessionAttendance({
    required String scheduleId,
    required String participantId,
    required bool attended,
  });
}
