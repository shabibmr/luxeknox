import 'package:api_client/api_client.dart' as api;
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

abstract class AttendanceRemoteDataSource {
  Future<api.AttendancePass> getPass();

  Future<api.Attendance> checkIn({
    required api.CheckInRequest request,
    required String idempotencyKey,
  });

  Future<api.Attendance> checkOut(int id);

  Future<api.AttendancePage> listAttendances({
    int? userId,
    DateTime? from,
    DateTime? to,
    String? cursor,
    int? limit,
  });

  Future<api.AttendanceSummary> getSummary({int? memberId});

  Future<api.AttendanceHistoryPage> listHistories({
    api.Date? from,
    api.Date? to,
  });

  Future<api.ScheduleParticipant> markSessionAttendance({
    required int scheduleId,
    required int participantId,
    required bool attended,
  });
}

@LazySingleton(as: AttendanceRemoteDataSource)
class AttendanceRemoteDataSourceImpl implements AttendanceRemoteDataSource {
  AttendanceRemoteDataSourceImpl(this._attnApi);

  final api.ATTNApi _attnApi;

  T _unwrap<T>(Response<T> response) {
    final data = response.data;
    if (data == null) {
      throw DioException(
        requestOptions: response.requestOptions,
        type: DioExceptionType.badResponse,
        response: response,
      );
    }
    return data;
  }

  @override
  Future<api.AttendancePass> getPass() async {
    return _unwrap(await _attnApi.getAttendancePass());
  }

  @override
  Future<api.Attendance> checkIn({
    required api.CheckInRequest request,
    required String idempotencyKey,
  }) async {
    return _unwrap(
      await _attnApi.checkIn(
        checkInRequest: request,
        idempotencyKey: idempotencyKey,
      ),
    );
  }

  @override
  Future<api.Attendance> checkOut(int id) async {
    return _unwrap(await _attnApi.checkOut(id: id));
  }

  @override
  Future<api.AttendancePage> listAttendances({
    int? userId,
    DateTime? from,
    DateTime? to,
    String? cursor,
    int? limit,
  }) async {
    return _unwrap(
      await _attnApi.listAttendances(
        userId: userId,
        from: from?.toUtc(),
        to: to?.toUtc(),
        cursor: cursor,
        limit: limit,
      ),
    );
  }

  @override
  Future<api.AttendanceSummary> getSummary({int? memberId}) async {
    return _unwrap(await _attnApi.getAttendanceSummary(memberId: memberId));
  }

  @override
  Future<api.AttendanceHistoryPage> listHistories({
    api.Date? from,
    api.Date? to,
  }) async {
    return _unwrap(
      await _attnApi.listAttendanceHistories(from: from, to: to),
    );
  }

  @override
  Future<api.ScheduleParticipant> markSessionAttendance({
    required int scheduleId,
    required int participantId,
    required bool attended,
  }) async {
    return _unwrap(
      await _attnApi.markSessionAttendance(
        id: scheduleId,
        participantId: participantId,
        markAttendanceRequest: api.MarkAttendanceRequest(
          (b) => b.attended = attended,
        ),
      ),
    );
  }
}
