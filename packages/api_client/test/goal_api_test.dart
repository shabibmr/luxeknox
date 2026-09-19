import 'package:test/test.dart';
import 'package:api_client/api_client.dart';


/// tests for GOALApi
void main() {
  final instance = ApiClient().getGOALApi();

  group(GOALApi, () {
    // Record a goal check-in
    //
    //Future<GoalHistory> checkInGoal(int id, GoalCheckInWrite goalCheckInWrite) async
    test('test checkInGoal', () async {
      // TODO
    });

    // Create a metric
    //
    //Future<GoalMetric> createGoalMetric(GoalMetricWrite goalMetricWrite) async
    test('test createGoalMetric', () async {
      // TODO
    });

    // Record a measurement session
    //
    //Future<Measurement> createMeasurement(int id, MeasurementWrite measurementWrite) async
    test('test createMeasurement', () async {
      // TODO
    });

    // Create a goal
    //
    //Future<Goal> createMemberGoal(int id, GoalWrite goalWrite) async
    test('test createMemberGoal', () async {
      // TODO
    });

    // Add a progress note
    //
    //Future<ProgressNote> createProgressNote(int id, ProgressNoteWrite progressNoteWrite) async
    test('test createProgressNote', () async {
      // TODO
    });

    // Add a progress photo (deferred)
    //
    //Future<ProgressPhoto> createProgressPhoto(int id, ProgressPhotoWrite progressPhotoWrite) async
    test('test createProgressPhoto', () async {
      // TODO
    });

    // Delete a progress photo (deferred)
    //
    //Future deleteProgressPhoto(int id) async
    test('test deleteProgressPhoto', () async {
      // TODO
    });

    // Goal detail
    //
    //Future<Goal> getGoal(int id) async
    test('test getGoal', () async {
      // TODO
    });

    // Measurement session with values
    //
    //Future<Measurement> getMeasurement(int id) async
    test('test getMeasurement', () async {
      // TODO
    });

    // Measurement type catalog
    //
    //Future<GoalMetricPage> listGoalMetrics() async
    test('test listGoalMetrics', () async {
      // TODO
    });

    // Measurement sessions
    //
    //Future<MeasurementPage> listMeasurements(int id, { int limit, String cursor }) async
    test('test listMeasurements', () async {
      // TODO
    });

    // Member goals
    //
    //Future<GoalPage> listMemberGoals(int id) async
    test('test listMemberGoals', () async {
      // TODO
    });

    // Coach / member notes
    //
    //Future<ProgressNotePage> listProgressNotes(int id, { String cursor }) async
    test('test listProgressNotes', () async {
      // TODO
    });

    // Progress photos (deferred)
    //
    //Future<ProgressPhotoPage> listProgressPhotos(int id) async
    test('test listProgressPhotos', () async {
      // TODO
    });

    // Update a goal
    //
    //Future<Goal> updateGoal(int id, GoalWrite goalWrite) async
    test('test updateGoal', () async {
      // TODO
    });

    // Update a metric
    //
    //Future<GoalMetric> updateGoalMetric(int id, GoalMetricWrite goalMetricWrite) async
    test('test updateGoalMetric', () async {
      // TODO
    });

  });
}
