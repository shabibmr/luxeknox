import 'package:equatable/equatable.dart';

import 'schedule_enums.dart';

class ScheduleParticipantEntry extends Equatable {
  const ScheduleParticipantEntry({
    required this.id,
    required this.scheduleId,
    required this.memberId,
    required this.bookingStatus,
    this.attended,
    this.bookedAt,
  });

  final String id;
  final String scheduleId;
  final String memberId;
  final BookingStatus bookingStatus;
  final bool? attended;
  final DateTime? bookedAt;

  @override
  List<Object?> get props => [
    id,
    scheduleId,
    memberId,
    bookingStatus,
    attended,
    bookedAt,
  ];
}

class ScheduleSession extends Equatable {
  const ScheduleSession({
    required this.id,
    this.seriesId,
    required this.scheduleTypeId,
    this.facilityId,
    this.trainerId,
    required this.title,
    required this.startTime,
    required this.endTime,
    this.maxCapacity,
    required this.status,
    this.notes,
    required this.rowVersion,
    this.participants = const [],
  });

  final String id;
  final String? seriesId;
  final String scheduleTypeId;
  final String? facilityId;
  final String? trainerId;
  final String title;
  final DateTime startTime;
  final DateTime endTime;
  final int? maxCapacity;
  final ScheduleSessionStatus status;
  final String? notes;
  final int rowVersion;
  final List<ScheduleParticipantEntry> participants;

  int get bookedCount =>
      participants.where((p) => p.bookingStatus == BookingStatus.booked).length;

  int get waitlistedCount => participants
      .where((p) => p.bookingStatus == BookingStatus.waitlisted)
      .length;

  bool get isFull =>
      maxCapacity != null && bookedCount >= maxCapacity!;

  bool get isRecurring => seriesId != null && seriesId!.isNotEmpty;

  @override
  List<Object?> get props => [
    id,
    seriesId,
    scheduleTypeId,
    facilityId,
    trainerId,
    title,
    startTime,
    endTime,
    maxCapacity,
    status,
    notes,
    rowVersion,
    participants,
  ];
}
