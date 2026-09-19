import 'package:test/test.dart';
import 'package:api_client/api_client.dart';


/// tests for SCHEDApi
void main() {
  final instance = ApiClient().getSCHEDApi();

  group(SCHEDApi, () {
    // Book a member onto a schedule
    //
    //Future<ScheduleParticipant> addScheduleParticipant(int id, ScheduleParticipantWrite scheduleParticipantWrite, { String idempotencyKey }) async
    test('test addScheduleParticipant', () async {
      // TODO
    });

    // Cancel a schedule
    //
    //Future<Schedule> cancelSchedule(int id, CancelRequest cancelRequest) async
    test('test cancelSchedule', () async {
      // TODO
    });

    // Mark schedule completed
    //
    //Future<Schedule> completeSchedule(int id) async
    test('test completeSchedule', () async {
      // TODO
    });

    // Create a facility
    //
    //Future<Facility> createFacility(FacilityWrite facilityWrite) async
    test('test createFacility', () async {
      // TODO
    });

    // Create a booking or class occurrence
    //
    //Future<Schedule> createSchedule(ScheduleWrite scheduleWrite, { String idempotencyKey }) async
    test('test createSchedule', () async {
      // TODO
    });

    // Create a schedule type
    //
    //Future<ScheduleType> createScheduleType(ScheduleTypeWrite scheduleTypeWrite) async
    test('test createScheduleType', () async {
      // TODO
    });

    // Schedule detail
    //
    //Future<Schedule> getSchedule(int id) async
    test('test getSchedule', () async {
      // TODO
    });

    // Trainer hours and block-outs
    //
    //Future<TrainerAvailabilityPage> getTrainerAvailability(int id) async
    test('test getTrainerAvailability', () async {
      // TODO
    });

    // Rooms and studios
    //
    //Future<FacilityPage> listFacilities() async
    test('test listFacilities', () async {
      // TODO
    });

    // Schedule history
    //
    //Future<ScheduleHistoryPage> listScheduleHistory(int id, { String cursor }) async
    test('test listScheduleHistory', () async {
      // TODO
    });

    // Schedule types
    //
    //Future<ScheduleTypePage> listScheduleTypes() async
    test('test listScheduleTypes', () async {
      // TODO
    });

    // Calendar list
    //
    //Future<SchedulePage> listSchedules({ int limit, String cursor, DateTime from, DateTime to, int trainerId, int memberId }) async
    test('test listSchedules', () async {
      // TODO
    });

    // Replace trainer availability
    //
    //Future<TrainerAvailabilityPage> putTrainerAvailability(int id, TrainerAvailabilityWrite trainerAvailabilityWrite) async
    test('test putTrainerAvailability', () async {
      // TODO
    });

    // Cancel a booking
    //
    //Future removeScheduleParticipant(int id, int participantId) async
    test('test removeScheduleParticipant', () async {
      // TODO
    });

    // Mark schedule ongoing
    //
    //Future<Schedule> startSchedule(int id) async
    test('test startSchedule', () async {
      // TODO
    });

    // Update a schedule (requires row_version)
    //
    //Future<Schedule> updateSchedule(int id, ScheduleWrite scheduleWrite) async
    test('test updateSchedule', () async {
      // TODO
    });

  });
}
