import 'package:api_client/api_client.dart' as api;

import '../../domain/entities/attendance_enums.dart';
import '../../domain/entities/attendance_history_day.dart';
import '../../domain/entities/attendance_occupancy.dart';
import '../../domain/entities/attendance_pass.dart';
import '../../domain/entities/attendance_record.dart';
import '../../domain/entities/attendance_summary.dart';
import '../../../membership/data/models/membership_date.dart';

extension AttendancePassMapper on api.AttendancePass {
  AttendancePass toDomain() {
    return AttendancePass(
      userId: userId.toString(),
      payload: payload,
      expiresAt: expiresAt.toLocal(),
    );
  }
}

extension AttendanceMethodMapper on api.AttendanceMethod {
  AttendanceCheckInMethod toDomain() {
    return switch (this) {
      api.AttendanceMethod.qrCode => AttendanceCheckInMethod.qrCode,
      api.AttendanceMethod.rfid => AttendanceCheckInMethod.rfid,
      api.AttendanceMethod.biometric => AttendanceCheckInMethod.biometric,
      api.AttendanceMethod.manualOverride =>
        AttendanceCheckInMethod.manualOverride,
      _ => AttendanceCheckInMethod.qrCode,
    };
  }
}

extension AttendanceCheckInMethodApiMapper on AttendanceCheckInMethod {
  api.AttendanceMethod toApi() {
    return switch (this) {
      AttendanceCheckInMethod.qrCode => api.AttendanceMethod.qrCode,
      AttendanceCheckInMethod.rfid => api.AttendanceMethod.rfid,
      AttendanceCheckInMethod.biometric => api.AttendanceMethod.biometric,
      AttendanceCheckInMethod.manualOverride =>
        api.AttendanceMethod.manualOverride,
    };
  }
}

extension AttendanceMapper on api.Attendance {
  AttendanceRecord toDomain() {
    return AttendanceRecord(
      id: id.toString(),
      userId: userId.toString(),
      checkInTime: checkInTime.toLocal(),
      checkOutTime: checkOutTime?.toLocal(),
      method: method.toDomain(),
      gateIdentifier: gateIdentifier,
      verifiedByUserId: verifiedByUserId?.toString(),
    );
  }
}

extension AttendanceSummaryMapper on api.AttendanceSummary {
  AttendanceSummaryInfo toDomain() {
    return AttendanceSummaryInfo(
      streakDays: streakDays,
      lastCheckIn: lastCheckIn?.toLocal(),
      visitsThisMonth: visitsThisMonth,
    );
  }
}

extension AttendanceOccupancyMapper on api.Occupancy {
  AttendanceOccupancy toDomain() {
    return AttendanceOccupancy(
      checkedInNow: checkedInNow,
      asOf: asOf.toLocal(),
      byGate: byGate
          .map(
            (g) => GateOccupancy(
              gateIdentifier: g.gateIdentifier,
              count: g.count,
            ),
          )
          .toList(),
    );
  }
}

extension AttendanceHistoryMapper on api.AttendanceHistory {
  AttendanceHistoryDay toDomain() {
    return AttendanceHistoryDay(
      id: id.toString(),
      date: apiDateToDateTime(date),
      totalMemberCheckins: totalMemberCheckins,
      totalTrainerCheckins: totalTrainerCheckins,
      peakHour: peakHour,
      peakCount: peakCount,
    );
  }
}
