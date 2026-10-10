import 'package:api_client/api_client.dart' as api;
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

abstract class GoalsRemoteDataSource {
  Future<api.GoalMetricPage> listGoalMetrics({
    String? q,
    String? category,
    bool? isActive,
    int? limit,
    String? cursor,
  });

  Future<api.GoalMetric> createGoalMetric(api.GoalMetricWrite write);

  Future<api.GoalMetric> updateGoalMetric(int id, api.GoalMetricWrite write);

  Future<api.GoalPage> listAllGoals({
    int? limit,
    String? cursor,
    String? status,
    int? metricId,
  });

  Future<api.GoalPage> listMemberGoals(int memberId);

  Future<api.Goal> getGoal(int id);

  Future<api.Goal> createMemberGoal(int memberId, api.GoalWrite write);

  Future<api.Goal> updateGoal(int id, api.GoalWrite write);

  Future<api.GoalHistory> checkInGoal(int id, api.GoalCheckInWrite write);

  Future<api.MeasurementPage> listAllMeasurements({
    int? limit,
    String? cursor,
    DateTime? from,
    DateTime? to,
  });

  Future<api.MeasurementPage> listMeasurements({
    required int memberId,
    int? limit,
    String? cursor,
  });

  Future<api.Measurement> getMeasurement(int id);

  Future<api.MeasurementChartResponse> getMeasurementChart({
    required int memberId,
    required int metricId,
    DateTime? from,
    DateTime? to,
  });

  Future<api.Measurement> createMeasurement(
    int memberId,
    api.MeasurementWrite write,
  );

  Future<api.ProgressPhotoPage> listAllProgressPhotos({
    int? limit,
    String? cursor,
    String? pose,
  });

  Future<api.ProgressPhotoPage> listProgressPhotos({required int memberId});

  Future<api.ProgressPhoto> createProgressPhoto(
    int memberId,
    api.ProgressPhotoWrite write,
  );

  Future<api.ProgressPhotoComparison> compareProgressPhotos({
    required int memberId,
    required DateTime date1,
    required DateTime date2,
  });

  Future<void> deleteProgressPhoto(int id);

  Future<api.ProgressAggregate> getProgressAggregate();

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
  Future<api.GoalMetricPage> listGoalMetrics({
    String? q,
    String? category,
    bool? isActive,
    int? limit,
    String? cursor,
  }) async {
    return _unwrap(
      await _goalApi.listGoalMetrics(
        q: q,
        category: category,
        isActive: isActive,
        limit: limit,
        cursor: cursor,
      ),
    );
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
  Future<api.GoalPage> listAllGoals({
    int? limit,
    String? cursor,
    String? status,
    int? metricId,
  }) async {
    return _unwrap(
      await _goalApi.listAllGoals(
        limit: limit,
        cursor: cursor,
        status: status,
        metricId: metricId,
      ),
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
    return _unwrap(await _goalApi.checkInGoal(id: id, goalCheckInWrite: write));
  }

  @override
  Future<api.MeasurementPage> listAllMeasurements({
    int? limit,
    String? cursor,
    DateTime? from,
    DateTime? to,
  }) async {
    return _unwrap(
      await _goalApi.listAllMeasurements(
        limit: limit,
        cursor: cursor,
        from: from,
        to: to,
      ),
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
  Future<api.MeasurementChartResponse> getMeasurementChart({
    required int memberId,
    required int metricId,
    DateTime? from,
    DateTime? to,
  }) async {
    return _unwrap(
      await _goalApi.getMeasurementChart(
        id: memberId,
        metricId: metricId,
        from: from,
        to: to,
      ),
    );
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
  Future<api.ProgressPhotoPage> listAllProgressPhotos({
    int? limit,
    String? cursor,
    String? pose,
  }) async {
    return _unwrap(
      await _goalApi.listAllProgressPhotos(
        limit: limit,
        cursor: cursor,
        pose: pose,
      ),
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
  Future<api.ProgressPhotoComparison> compareProgressPhotos({
    required int memberId,
    required DateTime date1,
    required DateTime date2,
  }) async {
    return _unwrap(
      await _goalApi.compareProgressPhotos(
        id: memberId,
        date1: api.Date(date1.year, date1.month, date1.day),
        date2: api.Date(date2.year, date2.month, date2.day),
      ),
    );
  }

  @override
  Future<void> deleteProgressPhoto(int id) async {
    await _goalApi.deleteProgressPhoto(id: id);
  }

  @override
  Future<api.ProgressAggregate> getProgressAggregate() async {
    return _unwrap(await _goalApi.getProgressAggregate());
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
      await _goalApi.createProgressNote(id: memberId, progressNoteWrite: write),
    );
  }
}
