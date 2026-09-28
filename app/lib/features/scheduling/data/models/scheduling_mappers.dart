import 'package:api_client/api_client.dart' as api;

import '../../domain/entities/schedule_catalog.dart';
import '../../domain/entities/schedule_enums.dart';
import '../../domain/entities/schedule_session.dart';
import '../../../membership/data/models/membership_date.dart';

extension ScheduleMapper on api.Schedule {
  ScheduleSession toDomain() {
    return ScheduleSession(
      id: id.toString(),
      seriesId: seriesId?.toString(),
      scheduleTypeId: scheduleTypeId.toString(),
      facilityId: facilityId?.toString(),
      trainerId: trainerId?.toString(),
      title: title,
      startTime: startTime.toLocal(),
      endTime: endTime.toLocal(),
      maxCapacity: maxCapacity,
      status: scheduleSessionStatusFromName(status.name),
      notes: notes,
      rowVersion: rowVersion,
      participants:
          participants?.map((p) => p.toDomain()).toList() ?? const [],
    );
  }
}

extension ScheduleParticipantMapper on api.ScheduleParticipant {
  ScheduleParticipantEntry toDomain() {
    return ScheduleParticipantEntry(
      id: id.toString(),
      scheduleId: scheduleId.toString(),
      memberId: memberId.toString(),
      bookingStatus: bookingStatusFromName(bookingStatus.name),
      attended: attended,
      bookedAt: bookedAt?.toLocal(),
    );
  }
}

extension ScheduleTypeMapper on api.ScheduleType {
  ScheduleTypeInfo toDomain() {
    return ScheduleTypeInfo(
      id: id.toString(),
      name: name,
      colorCode: colorCode,
      defaultDurationMinutes: defaultDurationMinutes,
      requiresTrainer: requiresTrainer,
    );
  }
}

extension FacilityMapper on api.Facility {
  FacilityInfo toDomain() {
    return FacilityInfo(
      id: id.toString(),
      name: name,
      capacity: capacity,
      locationDetails: locationDetails,
      isActive: isActive,
    );
  }
}

extension TrainerAvailabilityMapper on api.TrainerAvailability {
  TrainerAvailabilitySlot toDomain() {
    return TrainerAvailabilitySlot(
      id: id.toString(),
      trainerId: trainerId.toString(),
      dayOfWeek: dayOfWeek,
      startTime: startTime,
      endTime: endTime,
      isRecurring: isRecurring,
      overrideDate:
          overrideDate == null ? null : apiDateToDateTime(overrideDate!),
      isAvailable: isAvailable,
    );
  }
}

api.ScheduleWrite scheduleWriteFromInput({
  String? seriesId,
  String? scheduleTypeId,
  String? facilityId,
  String? trainerId,
  String? title,
  DateTime? startTime,
  DateTime? endTime,
  int? maxCapacity,
  String? notes,
  int? rowVersion,
  DateTime? recurUntil,
}) {
  return api.ScheduleWrite((b) {
    if (seriesId != null) b.seriesId = int.tryParse(seriesId);
    if (scheduleTypeId != null) {
      b.scheduleTypeId = int.tryParse(scheduleTypeId);
    }
    if (facilityId != null) b.facilityId = int.tryParse(facilityId);
    if (trainerId != null) b.trainerId = int.tryParse(trainerId);
    if (title != null) b.title = title;
    if (startTime != null) b.startTime = startTime.toUtc();
    if (endTime != null) b.endTime = endTime.toUtc();
    if (maxCapacity != null) b.maxCapacity = maxCapacity;
    if (notes != null) b.notes = notes;
    if (rowVersion != null) b.rowVersion = rowVersion;
    if (recurUntil != null) b.recurUntil = dateTimeToApiDate(recurUntil);
  });
}

api.TrainerAvailability trainerAvailabilityToApi(TrainerAvailabilitySlot slot) {
  return api.TrainerAvailability((b) {
    b
      ..id = int.tryParse(slot.id) ?? 0
      ..trainerId = int.tryParse(slot.trainerId) ?? 0
      ..dayOfWeek = slot.dayOfWeek
      ..startTime = slot.startTime
      ..endTime = slot.endTime
      ..isRecurring = slot.isRecurring
      ..isAvailable = slot.isAvailable;
    if (slot.overrideDate != null) {
      b.overrideDate = dateTimeToApiDate(slot.overrideDate!);
    }
  });
}
