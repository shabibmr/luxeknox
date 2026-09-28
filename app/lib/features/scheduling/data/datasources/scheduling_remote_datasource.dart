import 'package:api_client/api_client.dart' as api;
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

abstract class SchedulingRemoteDataSource {
  Future<api.SchedulePage> listSchedules({
    DateTime? from,
    DateTime? to,
    int? trainerId,
    int? memberId,
    String? cursor,
    int? limit,
  });

  Future<api.Schedule> getSchedule(int id);

  Future<api.Schedule> createSchedule({
    required api.ScheduleWrite write,
    String? idempotencyKey,
  });

  Future<api.Schedule> updateSchedule({
    required int id,
    required api.ScheduleWrite write,
  });

  Future<api.Schedule> cancelSchedule({
    required int id,
    required api.CancelRequest cancelRequest,
  });

  Future<api.ScheduleParticipant> addParticipant({
    required int scheduleId,
    required api.BookRequest write,
    String? idempotencyKey,
  });

  Future<void> removeParticipant({
    required int scheduleId,
    required int memberId,
    String? reason,
  });

  Future<api.Schedule> startSchedule(int id);

  Future<api.Schedule> completeSchedule(int id);

  Future<api.ScheduleTypePage> listScheduleTypes();

  Future<api.ScheduleType> createScheduleType(api.ScheduleTypeWrite write);

  Future<api.FacilityPage> listFacilities();

  Future<api.Facility> createFacility(api.FacilityWrite write);

  Future<api.TrainerAvailabilityPage> getTrainerAvailability(int trainerId);

  Future<api.TrainerAvailabilityPage> putTrainerAvailability({
    required int trainerId,
    required api.TrainerAvailabilityWrite write,
  });
}

@LazySingleton(as: SchedulingRemoteDataSource)
class SchedulingRemoteDataSourceImpl implements SchedulingRemoteDataSource {
  SchedulingRemoteDataSourceImpl(this._schedApi);

  final api.SCHEDApi _schedApi;

  T _unwrap<T>(Response<T> response) {
    final data = response.data;
    if (data == null) {
      throw DioException(
        requestOptions: response.requestOptions,
        type: DioExceptionType.badResponse,
        response: response,
      );
    }
    return data;
  }

  @override
  Future<api.SchedulePage> listSchedules({
    DateTime? from,
    DateTime? to,
    int? trainerId,
    int? memberId,
    String? cursor,
    int? limit,
  }) async {
    return _unwrap(
      await _schedApi.listSchedules(
        from: from?.toUtc(),
        to: to?.toUtc(),
        trainerId: trainerId,
        memberId: memberId,
        cursor: cursor,
        limit: limit,
      ),
    );
  }

  @override
  Future<api.Schedule> getSchedule(int id) async {
    return _unwrap(await _schedApi.getSchedule(id: id));
  }

  @override
  Future<api.Schedule> createSchedule({
    required api.ScheduleWrite write,
    String? idempotencyKey,
  }) async {
    return _unwrap(
      await _schedApi.createSchedule(
        scheduleWrite: write,
        idempotencyKey: idempotencyKey,
      ),
    );
  }

  @override
  Future<api.Schedule> updateSchedule({
    required int id,
    required api.ScheduleWrite write,
  }) async {
    return _unwrap(
      await _schedApi.updateSchedule(id: id, scheduleWrite: write),
    );
  }

  @override
  Future<api.Schedule> cancelSchedule({
    required int id,
    required api.CancelRequest cancelRequest,
  }) async {
    return _unwrap(
      await _schedApi.cancelSchedule(id: id, cancelRequest: cancelRequest),
    );
  }

  @override
  Future<api.ScheduleParticipant> addParticipant({
    required int scheduleId,
    required api.BookRequest write,
    String? idempotencyKey,
  }) async {
    return _unwrap(
      await _schedApi.bookSchedule(
        id: scheduleId,
        bookRequest: write,
      ),
    );
  }

  @override
  Future<void> removeParticipant({
    required int scheduleId,
    required int memberId,
    String? reason,
  }) async {
    await _schedApi.cancelBooking(
      id: scheduleId,
      memberId: memberId,
      cancelBookingRequest: api.CancelBookingRequest((b) => b.reason = reason),
    );
  }

  @override
  Future<api.Schedule> startSchedule(int id) async {
    return _unwrap(await _schedApi.startSchedule(id: id));
  }

  @override
  Future<api.Schedule> completeSchedule(int id) async {
    return _unwrap(await _schedApi.completeSchedule(id: id));
  }

  @override
  Future<api.ScheduleTypePage> listScheduleTypes() async {
    return _unwrap(await _schedApi.listScheduleTypes());
  }

  @override
  Future<api.ScheduleType> createScheduleType(api.ScheduleTypeWrite write) async {
    return _unwrap(
      await _schedApi.createScheduleType(scheduleTypeWrite: write),
    );
  }

  @override
  Future<api.FacilityPage> listFacilities() async {
    return _unwrap(await _schedApi.listFacilities());
  }

  @override
  Future<api.Facility> createFacility(api.FacilityWrite write) async {
    return _unwrap(await _schedApi.createFacility(facilityWrite: write));
  }

  @override
  Future<api.TrainerAvailabilityPage> getTrainerAvailability(
    int trainerId,
  ) async {
    return _unwrap(await _schedApi.getTrainerAvailability(id: trainerId));
  }

  @override
  Future<api.TrainerAvailabilityPage> putTrainerAvailability({
    required int trainerId,
    required api.TrainerAvailabilityWrite write,
  }) async {
    return _unwrap(
      await _schedApi.putTrainerAvailability(
        id: trainerId,
        trainerAvailabilityWrite: write,
      ),
    );
  }
}
