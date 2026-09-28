import 'package:api_client/api_client.dart' as api;
import 'package:built_value/serializer.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

abstract class DietPlanRemoteDataSource {
  Future<api.DietPlanPage> listPlans({
    int? limit,
    int? offset,
    int? memberId,
    bool? isTemplate,
  });

  Future<api.DietPlan> getPlan(int id);

  Future<api.DietPlan> createPlan(api.DietPlanWrite write);

  Future<api.DietPlan> updatePlan(int id, api.DietPlanWrite write);

  Future<api.DietPlan> replaceMeals(int id, api.DietPlanMealsWrite write);

  Future<api.DietPlan> publish(int id);

  Future<api.DietPlan> archive(int id);

  Future<api.DietPlan> assign(int id, api.AssignPlanRequest request);

  Future<api.DietPlanVersionPage> listVersions(int id);
}

@LazySingleton(as: DietPlanRemoteDataSource)
class DietPlanRemoteDataSourceImpl implements DietPlanRemoteDataSource {
  DietPlanRemoteDataSourceImpl(this._dietApi, this._dio);

  final api.DIETApi _dietApi;
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
  Future<api.DietPlanPage> listPlans({
    int? limit,
    int? offset,
    int? memberId,
    bool? isTemplate,
  }) async {
    return _unwrap(
      await _dietApi.listDietPlans(
        limit: limit,
        offset: offset,
        memberId: memberId,
        isTemplate: isTemplate,
      ),
    );
  }

  @override
  Future<api.DietPlan> getPlan(int id) async {
    return _unwrap(await _dietApi.getDietPlan(id: id));
  }

  @override
  Future<api.DietPlan> createPlan(api.DietPlanWrite write) async {
    return _unwrap(await _dietApi.createDietPlan(dietPlanWrite: write));
  }

  @override
  Future<api.DietPlan> updatePlan(int id, api.DietPlanWrite write) async {
    return _unwrap(
      await _dietApi.updateDietPlan(id: id, dietPlanWrite: write),
    );
  }

  @override
  Future<api.DietPlan> replaceMeals(
    int id,
    api.DietPlanMealsWrite write,
  ) async {
    return _unwrap(
      await _dietApi.replaceDietPlanMeals(
        id: id,
        dietPlanMealsWrite: write,
      ),
    );
  }

  @override
  Future<api.DietPlan> publish(int id) async {
    return _unwrap(await _dietApi.publishDietPlan(id: id));
  }

  @override
  Future<api.DietPlan> archive(int id) async {
    final response = await _dio.post<Object>('/diet-plans/$id/archive');
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
        specifiedType: const FullType(api.DietPlan),
      ) as api.DietPlan;
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
  Future<api.DietPlan> assign(int id, api.AssignPlanRequest request) async {
    return _unwrap(
      await _dietApi.assignDietPlan(id: id, assignPlanRequest: request),
    );
  }

  @override
  Future<api.DietPlanVersionPage> listVersions(int id) async {
    return _unwrap(await _dietApi.listDietPlanVersions(id: id));
  }
}
