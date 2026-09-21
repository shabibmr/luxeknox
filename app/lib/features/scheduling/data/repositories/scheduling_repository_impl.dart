import 'package:api_client/api_client.dart' as api;
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/error/map_thrown.dart';
import '../../../../core/pagination/cursor_page.dart';
import '../../domain/entities/schedule_catalog.dart';
import '../../domain/entities/schedule_session.dart';
import '../../domain/repositories/scheduling_repository.dart';
import '../datasources/scheduling_remote_datasource.dart';
import '../models/scheduling_mappers.dart';

@LazySingleton(as: SchedulingRepository)
class SchedulingRepositoryImpl implements SchedulingRepository {
  SchedulingRepositoryImpl(this._remote);

  final SchedulingRemoteDataSource _remote;

  int? _parseId(String id) => int.tryParse(id);

  @override
  Future<Either<Failure, CursorPage<ScheduleSession>>> listSchedules({
    DateTime? from,
    DateTime? to,
    String? trainerId,
    String? memberId,
    String? cursor,
    int? limit,
  }) async {
    try {
      final page = await _remote.listSchedules(
        from: from,
        to: to,
        trainerId: trainerId == null ? null : _parseId(trainerId),
        memberId: memberId == null ? null : _parseId(memberId),
        cursor: cursor,
        limit: limit,
      );
      return Right(
        CursorPage(
          items: page.data.map((s) => s.toDomain()).toList(),
          nextCursor: page.meta.nextCursor,
          hasMore: page.meta.hasMore,
        ),
      );
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, ScheduleSession>> getSchedule(String id) async {
    final intId = _parseId(id);
    if (intId == null) return const Left(NotFoundFailure());
    try {
      final schedule = await _remote.getSchedule(intId);
      return Right(schedule.toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, ScheduleSession>> createSchedule(
    CreateScheduleInput input,
  ) async {
    try {
      final created = await _remote.createSchedule(
        write: scheduleWriteFromInput(
          seriesId: input.seriesId,
          scheduleTypeId: input.scheduleTypeId,
          facilityId: input.facilityId,
          trainerId: input.trainerId,
          title: input.title,
          startTime: input.startTime,
          endTime: input.endTime,
          maxCapacity: input.maxCapacity,
          notes: input.notes,
          rowVersion: input.rowVersion,
          recurUntil: input.recurUntil,
        ),
        idempotencyKey: input.idempotencyKey,
      );
      return Right(created.toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, ScheduleSession>> updateSchedule({
    required String id,
    required CreateScheduleInput input,
  }) async {
    final intId = _parseId(id);
    if (intId == null) return const Left(NotFoundFailure());
    try {
      final updated = await _remote.updateSchedule(
        id: intId,
        write: scheduleWriteFromInput(
          seriesId: input.seriesId,
          scheduleTypeId: input.scheduleTypeId,
          facilityId: input.facilityId,
          trainerId: input.trainerId,
          title: input.title,
          startTime: input.startTime,
          endTime: input.endTime,
          maxCapacity: input.maxCapacity,
          notes: input.notes,
          rowVersion: input.rowVersion,
          recurUntil: input.recurUntil,
        ),
      );
      return Right(updated.toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, ScheduleSession>> cancelSchedule({
    required String id,
    String? reason,
    int? rowVersion,
  }) async {
    final intId = _parseId(id);
    if (intId == null) return const Left(NotFoundFailure());
    try {
      final cancelled = await _remote.cancelSchedule(
        id: intId,
        cancelRequest: api.CancelRequest(
          (b) => b
            ..reason = reason
            ..rowVersion = rowVersion,
        ),
      );
      return Right(cancelled.toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, ScheduleParticipantEntry>> addParticipant({
    required String scheduleId,
    required String memberId,
    String? idempotencyKey,
  }) async {
    final schedId = _parseId(scheduleId);
    final memId = _parseId(memberId);
    if (schedId == null || memId == null) {
      return const Left(ValidationFailure(['Invalid schedule or member id']));
    }
    try {
      final participant = await _remote.addParticipant(
        scheduleId: schedId,
        write: api.ScheduleParticipantWrite((b) => b.memberId = memId),
        idempotencyKey: idempotencyKey,
      );
      return Right(participant.toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> removeParticipant({
    required String scheduleId,
    required String participantId,
  }) async {
    final schedId = _parseId(scheduleId);
    final partId = _parseId(participantId);
    if (schedId == null || partId == null) {
      return const Left(ValidationFailure(['Invalid schedule or participant id']));
    }
    try {
      await _remote.removeParticipant(
        scheduleId: schedId,
        participantId: partId,
      );
      return const Right(unit);
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, ScheduleSession>> startSchedule(String id) async {
    final intId = _parseId(id);
    if (intId == null) return const Left(NotFoundFailure());
    try {
      return Right((await _remote.startSchedule(intId)).toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, ScheduleSession>> completeSchedule(String id) async {
    final intId = _parseId(id);
    if (intId == null) return const Left(NotFoundFailure());
    try {
      return Right((await _remote.completeSchedule(intId)).toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<ScheduleTypeInfo>>> listScheduleTypes() async {
    try {
      final page = await _remote.listScheduleTypes();
      return Right(page.data.map((t) => t.toDomain()).toList());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, ScheduleTypeInfo>> createScheduleType({
    required String name,
    String? colorCode,
    int? defaultDurationMinutes,
    bool? requiresTrainer,
  }) async {
    try {
      final created = await _remote.createScheduleType(
        api.ScheduleTypeWrite(
          (b) => b
            ..name = name
            ..colorCode = colorCode
            ..defaultDurationMinutes = defaultDurationMinutes
            ..requiresTrainer = requiresTrainer,
        ),
      );
      return Right(created.toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<FacilityInfo>>> listFacilities() async {
    try {
      final page = await _remote.listFacilities();
      return Right(page.data.map((f) => f.toDomain()).toList());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, FacilityInfo>> createFacility({
    required String name,
    int? capacity,
    String? locationDetails,
    bool? isActive,
  }) async {
    try {
      final created = await _remote.createFacility(
        api.FacilityWrite(
          (b) => b
            ..name = name
            ..capacity = capacity
            ..locationDetails = locationDetails
            ..isActive = isActive,
        ),
      );
      return Right(created.toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<TrainerAvailabilitySlot>>> getTrainerAvailability(
    String trainerId,
  ) async {
    final intId = _parseId(trainerId);
    if (intId == null) return const Left(NotFoundFailure());
    try {
      final page = await _remote.getTrainerAvailability(intId);
      return Right(page.data.map((s) => s.toDomain()).toList());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<TrainerAvailabilitySlot>>> putTrainerAvailability({
    required String trainerId,
    required List<TrainerAvailabilitySlot> slots,
  }) async {
    final intId = _parseId(trainerId);
    if (intId == null) return const Left(NotFoundFailure());
    try {
      final page = await _remote.putTrainerAvailability(
        trainerId: intId,
        write: api.TrainerAvailabilityWrite((b) {
          b.slots.addAll(slots.map(trainerAvailabilityToApi));
        }),
      );
      return Right(page.data.map((s) => s.toDomain()).toList());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }
}
