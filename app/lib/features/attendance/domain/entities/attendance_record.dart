import 'package:equatable/equatable.dart';

import 'attendance_enums.dart';

class AttendanceRecord extends Equatable {
  const AttendanceRecord({
    required this.id,
    required this.userId,
    required this.checkInTime,
    this.checkOutTime,
    required this.method,
    this.gateIdentifier,
    this.verifiedByUserId,
  });

  final String id;
  final String userId;
  final DateTime checkInTime;
  final DateTime? checkOutTime;
  final AttendanceCheckInMethod method;
  final String? gateIdentifier;
  final String? verifiedByUserId;

  bool get isOpen => checkOutTime == null;

  @override
  List<Object?> get props => [
    id,
    userId,
    checkInTime,
    checkOutTime,
    method,
    gateIdentifier,
    verifiedByUserId,
  ];
}
