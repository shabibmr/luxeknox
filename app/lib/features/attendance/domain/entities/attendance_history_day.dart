import 'package:equatable/equatable.dart';

/// Gym-wide daily footfall aggregate (admin heatmap source).
class AttendanceHistoryDay extends Equatable {
  const AttendanceHistoryDay({
    required this.id,
    required this.date,
    required this.totalMemberCheckins,
    this.totalTrainerCheckins,
    this.peakHour,
    this.peakCount,
  });

  final String id;
  final DateTime date;
  final int totalMemberCheckins;
  final int? totalTrainerCheckins;
  final int? peakHour;
  final int? peakCount;

  @override
  List<Object?> get props => [
    id,
    date,
    totalMemberCheckins,
    totalTrainerCheckins,
    peakHour,
    peakCount,
  ];
}
