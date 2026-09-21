import 'package:equatable/equatable.dart';

import 'attendance_enums.dart';

class CheckInInput extends Equatable {
  const CheckInInput({
    required this.idempotencyKey,
    this.userId,
    this.method,
    this.gateIdentifier,
    this.payload,
  });

  final String idempotencyKey;
  final String? userId;
  final AttendanceCheckInMethod? method;
  final String? gateIdentifier;
  final String? payload;

  @override
  List<Object?> get props => [
    idempotencyKey,
    userId,
    method,
    gateIdentifier,
    payload,
  ];
}
