import 'package:api_client/api_client.dart' as api;
import 'package:built_value/serializer.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

abstract class WorkoutPlanRemoteDataSource {
  Future<api.WorkoutPlanPage> listPlans({
    int? limit,
    int? offset,
    int? memberId,
    bool? isTemplate,
  });

  Future<api.WorkoutPlan> getPlan(int id);

  Future<api.WorkoutPlan> createPlan(api.WorkoutPlanWrite write);

  Future<api.WorkoutPlan> updatePlan(int id, api.WorkoutPlanWrite write);

  Future<api.WorkoutPlan> replaceExercises(
    int id,
    api.WorkoutPlanExercisesWrite write,
  );

  Future<api.WorkoutPlan> publish(int id);

  Future<api.WorkoutPlan> archive(int id);

  Future<api.WorkoutPlan> assign(int id, api.AssignPlanRequest request);

  Future<api.WorkoutPlanVersionPage> listVersions(int id);
}

@LazySingleton(as: WorkoutPlanRemoteDataSource)
class WorkoutPlanRemoteDataSourceImpl implements WorkoutPlanRemoteDataSource {
  WorkoutPlanRemoteDataSourceImpl(this._workApi, this._dio);

  final api.WORKApi _workApi;
  final Dio _dio;

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
  Future<api.WorkoutPlanPage> listPlans({
    int? limit,
    int? offset,
    int? memberId,
    bool? isTemplate,
  }) async {
    return _unwrap(
      await _workApi.listWorkoutPlans(
        limit: limit,
        offset: offset,
        memberId: memberId,
        isTemplate: isTemplate,
      ),
    );
  }

  @override
  Future<api.WorkoutPlan> getPlan(int id) async {
    return _unwrap(await _workApi.getWorkoutPlan(id: id));
  }

  @override
  Future<api.WorkoutPlan> createPlan(api.WorkoutPlanWrite write) async {
    return _unwrap(
      await _workApi.createWorkoutPlan(workoutPlanWrite: write),
    );
  }

  @override
  Future<api.WorkoutPlan> updatePlan(int id, api.WorkoutPlanWrite write) async {
    return _unwrap(
      await _workApi.updateWorkoutPlan(id: id, workoutPlanWrite: write),
    );
  }

  @override
  Future<api.WorkoutPlan> replaceExercises(
    int id,
    api.WorkoutPlanExercisesWrite write,
  ) async {
    return _unwrap(
      await _workApi.replaceWorkoutPlanExercises(
        id: id,
        workoutPlanExercisesWrite: write,
      ),
    );
  }

  @override
  Future<api.WorkoutPlan> publish(int id) async {
    return _unwrap(await _workApi.publishWorkoutPlan(id: id));
  }

  @override
  Future<api.WorkoutPlan> archive(int id) async {
    // WRK-007 forward-compatible; not yet on generated WORKApi.
    final response = await _dio.post<Object>('/workout-plans/$id/archive');
    try {
      final raw = response.data;
      if (raw == null) {
        throw DioException(
          requestOptions: response.requestOptions,
          type: DioExceptionType.badResponse,
          response: response,
        );
      }
      return api.standardSerializers.deserialize(
        raw,
        specifiedType: const FullType(api.WorkoutPlan),
      ) as api.WorkoutPlan;
    } catch (error, stackTrace) {
      if (error is DioException) rethrow;
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<api.WorkoutPlan> assign(int id, api.AssignPlanRequest request) async {
    return _unwrap(
      await _workApi.assignWorkoutPlan(id: id, assignPlanRequest: request),
    );
  }

  @override
  Future<api.WorkoutPlanVersionPage> listVersions(int id) async {
    return _unwrap(await _workApi.listWorkoutPlanVersions(id: id));
  }
}
