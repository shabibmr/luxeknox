import 'package:api_client/api_client.dart' as api;
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

abstract class GoalsRemoteDataSource {
  Future<api.GoalMetricPage> listGoalMetrics();

  Future<api.GoalMetric> createGoalMetric(api.GoalMetricWrite write);

  Future<api.GoalMetric> updateGoalMetric(int id, api.GoalMetricWrite write);

  Future<api.GoalPage> listMemberGoals(int memberId);

  Future<api.Goal> getGoal(int id);

  Future<api.Goal> createMemberGoal(int memberId, api.GoalWrite write);

  Future<api.Goal> updateGoal(int id, api.GoalWrite write);

  Future<api.GoalHistory> checkInGoal(int id, api.GoalCheckInWrite write);

  Future<api.MeasurementPage> listMeasurements({
    required int memberId,
    int? limit,
    String? cursor,
  });

  Future<api.Measurement> getMeasurement(int id);

  Future<api.Measurement> createMeasurement(
    int memberId,
    api.MeasurementWrite write,
  );

  Future<api.ProgressPhotoPage> listProgressPhotos({
    required int memberId,
  });

  Future<api.ProgressPhoto> createProgressPhoto(
    int memberId,
    api.ProgressPhotoWrite write,
  );

  Future<void> deleteProgressPhoto(int id);

  Future<api.ProgressNotePage> listProgressNotes({
    required int memberId,
    String? cursor,
  });

  Future<api.ProgressNote> createProgressNote(
    int memberId,
    api.ProgressNoteWrite write,
  );
}

@LazySingleton(as: GoalsRemoteDataSource)
class GoalsRemoteDataSourceImpl implements GoalsRemoteDataSource {
  GoalsRemoteDataSourceImpl(this._goalApi);

  final api.GOALApi _goalApi;

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
  Future<api.GoalMetricPage> listGoalMetrics() async {
    return _unwrap(await _goalApi.listGoalMetrics());
  }

  @override
  Future<api.GoalMetric> createGoalMetric(api.GoalMetricWrite write) async {
    return _unwrap(await _goalApi.createGoalMetric(goalMetricWrite: write));
  }

  @override
  Future<api.GoalMetric> updateGoalMetric(
    int id,
    api.GoalMetricWrite write,
  ) async {
    return _unwrap(
      await _goalApi.updateGoalMetric(id: id, goalMetricWrite: write),
    );
  }

  @override
  Future<api.GoalPage> listMemberGoals(int memberId) async {
    return _unwrap(await _goalApi.listMemberGoals(id: memberId));
  }

  @override
  Future<api.Goal> getGoal(int id) async {
    return _unwrap(await _goalApi.getGoal(id: id));
  }

  @override
  Future<api.Goal> createMemberGoal(int memberId, api.GoalWrite write) async {
    return _unwrap(
      await _goalApi.createMemberGoal(id: memberId, goalWrite: write),
    );
  }

  @override
  Future<api.Goal> updateGoal(int id, api.GoalWrite write) async {
    return _unwrap(await _goalApi.updateGoal(id: id, goalWrite: write));
  }

  @override
  Future<api.GoalHistory> checkInGoal(
    int id,
    api.GoalCheckInWrite write,
  ) async {
    return _unwrap(
      await _goalApi.checkInGoal(id: id, goalCheckInWrite: write),
    );
  }

  @override
  Future<api.MeasurementPage> listMeasurements({
    required int memberId,
    int? limit,
    String? cursor,
  }) async {
    return _unwrap(
      await _goalApi.listMeasurements(
        id: memberId,
        limit: limit,
        cursor: cursor,
      ),
    );
  }

  @override
  Future<api.Measurement> getMeasurement(int id) async {
    return _unwrap(await _goalApi.getMeasurement(id: id));
  }

  @override
  Future<api.Measurement> createMeasurement(
    int memberId,
    api.MeasurementWrite write,
  ) async {
    return _unwrap(
      await _goalApi.createMeasurement(id: memberId, measurementWrite: write),
    );
  }

  @override
  Future<api.ProgressPhotoPage> listProgressPhotos({
    required int memberId,
  }) async {
    return _unwrap(await _goalApi.listProgressPhotos(id: memberId));
  }

  @override
  Future<api.ProgressPhoto> createProgressPhoto(
    int memberId,
    api.ProgressPhotoWrite write,
  ) async {
    return _unwrap(
      await _goalApi.createProgressPhoto(
        id: memberId,
        progressPhotoWrite: write,
      ),
    );
  }

  @override
  Future<void> deleteProgressPhoto(int id) async {
    await _goalApi.deleteProgressPhoto(id: id);
  }

  @override
  Future<api.ProgressNotePage> listProgressNotes({
    required int memberId,
    String? cursor,
  }) async {
    return _unwrap(
      await _goalApi.listProgressNotes(id: memberId, cursor: cursor),
    );
  }

  @override
  Future<api.ProgressNote> createProgressNote(
    int memberId,
    api.ProgressNoteWrite write,
  ) async {
    return _unwrap(
      await _goalApi.createProgressNote(
        id: memberId,
        progressNoteWrite: write,
      ),
    );
  }
}
