enum AttendanceCheckInMethod {
  qrCode,
  rfid,
  biometric,
  manualOverride,
}

extension AttendanceCheckInMethodX on AttendanceCheckInMethod {
  String get label => switch (this) {
    AttendanceCheckInMethod.qrCode => 'QR',
    AttendanceCheckInMethod.rfid => 'RFID',
    AttendanceCheckInMethod.biometric => 'Biometric',
    AttendanceCheckInMethod.manualOverride => 'Manual',
  };
}
