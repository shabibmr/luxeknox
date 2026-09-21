import 'package:equatable/equatable.dart';

class AttendanceSummaryInfo extends Equatable {
  const AttendanceSummaryInfo({
    this.streakDays,
    this.lastCheckIn,
    this.visitsThisMonth,
  });

  final int? streakDays;
  final DateTime? lastCheckIn;
  final int? visitsThisMonth;

  @override
  List<Object?> get props => [streakDays, lastCheckIn, visitsThisMonth];
}
