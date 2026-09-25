import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/pagination/cursor_page.dart';
import '../entities/schedule_catalog.dart';
import '../entities/schedule_session.dart';

class CreateScheduleInput extends Equatable {
  const CreateScheduleInput({
    this.seriesId,
    this.scheduleTypeId,
    this.facilityId,
    this.trainerId,
    this.title,
    this.startTime,
    this.endTime,
    this.maxCapacity,
    this.notes,
    this.rowVersion,
    this.recurUntil,
    this.idempotencyKey,
  });

  final String? seriesId;
  final String? scheduleTypeId;
  final String? facilityId;
  final String? trainerId;
  final String? title;
  final DateTime? startTime;
  final DateTime? endTime;
  final int? maxCapacity;
  final String? notes;
  final int? rowVersion;
  final DateTime? recurUntil;
  final String? idempotencyKey;

  @override
  List<Object?> get props => [
    seriesId,
    scheduleTypeId,
    facilityId,
    trainerId,
    title,
    startTime,
    endTime,
    maxCapacity,
    notes,
    rowVersion,
    recurUntil,
    idempotencyKey,
  ];
}

abstract class SchedulingRepository {
  Future<Either<Failure, CursorPage<ScheduleSession>>> listSchedules({
    DateTime? from,
    DateTime? to,
    String? trainerId,
    String? memberId,
    String? cursor,
    int? limit,
  });

  Future<Either<Failure, ScheduleSession>> getSchedule(String id);

  Future<Either<Failure, ScheduleSession>> createSchedule(
    CreateScheduleInput input,
  );

  Future<Either<Failure, ScheduleSession>> updateSchedule({
    required String id,
    required CreateScheduleInput input,
  });

  Future<Either<Failure, ScheduleSession>> cancelSchedule({
    required String id,
    String? reason,
    int? rowVersion,
  });

  Future<Either<Failure, ScheduleParticipantEntry>> addParticipant({
    required String scheduleId,
    required String memberId,
    String? idempotencyKey,
  });

  Future<Either<Failure, Unit>> removeParticipant({
    required String scheduleId,
    required String memberId,
    String? reason,
  });

  Future<Either<Failure, ScheduleSession>> startSchedule(String id);

  Future<Either<Failure, ScheduleSession>> completeSchedule(String id);

  Future<Either<Failure, List<ScheduleTypeInfo>>> listScheduleTypes();

  Future<Either<Failure, ScheduleTypeInfo>> createScheduleType({
    required String name,
    String? colorCode,
    int? defaultDurationMinutes,
    bool? requiresTrainer,
  });

  Future<Either<Failure, List<FacilityInfo>>> listFacilities();

  Future<Either<Failure, FacilityInfo>> createFacility({
    required String name,
    int? capacity,
    String? locationDetails,
    bool? isActive,
  });

  Future<Either<Failure, List<TrainerAvailabilitySlot>>> getTrainerAvailability(
    String trainerId,
  );

  Future<Either<Failure, List<TrainerAvailabilitySlot>>> putTrainerAvailability({
    required String trainerId,
    required List<TrainerAvailabilitySlot> slots,
  });
}
