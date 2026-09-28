import 'package:api_client/api_client.dart' as api;
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/food_filter.dart';

abstract class FoodRemoteDataSource {
  Future<api.FoodPage> getFoods({
    required FoodFilter filter,
    String? cursor,
    int? limit,
  });

  Future<api.Food> getFood(int id);

  Future<api.Food> createFood(api.FoodWrite foodWrite);

  Future<api.Food> updateFood(int id, api.FoodWrite foodWrite);
}

@LazySingleton(as: FoodRemoteDataSource)
class FoodRemoteDataSourceImpl implements FoodRemoteDataSource {
  FoodRemoteDataSourceImpl(this._dietApi);

  final api.DIETApi _dietApi;

  @override
  Future<api.FoodPage> getFoods({
    required FoodFilter filter,
    String? cursor,
    int? limit,
  }) async {
    final offset = int.tryParse(cursor ?? '') ?? 0;
    final response = await _dietApi.listFoods(
      q: filter.query,
      isVerified: filter.isVerified,
      isActive: filter.isActive,
      limit: limit,
      offset: offset,
    );

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
  Future<api.Food> getFood(int id) async {
    final response = await _dietApi.getFood(id: id);
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
  Future<api.Food> createFood(api.FoodWrite foodWrite) async {
    final response = await _dietApi.createFood(foodWrite: foodWrite);
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
  Future<api.Food> updateFood(int id, api.FoodWrite foodWrite) async {
    final response = await _dietApi.updateFood(id: id, foodWrite: foodWrite);
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
}
