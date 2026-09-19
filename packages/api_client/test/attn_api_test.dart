import 'package:test/test.dart';
import 'package:api_client/api_client.dart';


/// tests for ATTNApi
void main() {
  final instance = ApiClient().getATTNApi();

  group(ATTNApi, () {
    // Gate check-in (user session or device key)
    //
    //Future<Attendance> checkIn(CheckInRequest checkInRequest, { String idempotencyKey }) async
    test('test checkIn', () async {
      // TODO
    });

    // Gate check-out
    //
    //Future<Attendance> checkOut(int id) async
    test('test checkOut', () async {
      // TODO
    });

    // Member digital pass (QR payload)
    //
    //Future<AttendancePass> getAttendancePass() async
    test('test getAttendancePass', () async {
      // TODO
    });

    // Scoped attendance summary
    //
    //Future<AttendanceSummary> getAttendanceSummary({ int memberId }) async
    test('test getAttendanceSummary', () async {
      // TODO
    });

    // Daily footfall aggregates
    //
    //Future<AttendanceHistoryPage> listAttendanceHistories({ Date from, Date to }) async
    test('test listAttendanceHistories', () async {
      // TODO
    });

    // Gate attendance log
    //
    //Future<AttendancePage> listAttendances({ int limit, String cursor, int userId, DateTime from, DateTime to }) async
    test('test listAttendances', () async {
      // TODO
    });

    // Mark session attended / no-show
    //
    //Future<ScheduleParticipant> markSessionAttendance(int id, int participantId, MarkAttendanceRequest markAttendanceRequest) async
    test('test markSessionAttendance', () async {
      // TODO
    });

  });
}
