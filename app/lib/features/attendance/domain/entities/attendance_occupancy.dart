import 'package:equatable/equatable.dart';

class GateOccupancy extends Equatable {
  const GateOccupancy({required this.gateIdentifier, required this.count});

  final String gateIdentifier;
  final int count;

  @override
  List<Object?> get props => [gateIdentifier, count];
}

class AttendanceOccupancy extends Equatable {
  const AttendanceOccupancy({
    required this.checkedInNow,
    required this.asOf,
    required this.byGate,
  });

  final int checkedInNow;
  final DateTime asOf;
  final List<GateOccupancy> byGate;

  @override
  List<Object?> get props => [checkedInNow, asOf, byGate];
}
