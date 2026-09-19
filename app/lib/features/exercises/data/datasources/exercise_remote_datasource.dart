import 'package:api_client/api_client.dart' as api;
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/exercise_filter.dart';

abstract class ExerciseRemoteDataSource {
  Future<api.ExercisePage> getExercises({
    required ExerciseFilter filter,
    String? cursor,
    int? limit,
  });

  Future<api.Exercise> getExercise(int id);

  Future<api.Exercise> createExercise(api.ExerciseWrite exerciseWrite);

  Future<api.Exercise> updateExercise(int id, api.ExerciseWrite exerciseWrite);
}

@LazySingleton(as: ExerciseRemoteDataSource)
class ExerciseRemoteDataSourceImpl implements ExerciseRemoteDataSource {
  ExerciseRemoteDataSourceImpl(this._workApi);

  final api.WORKApi _workApi;

  @override
  Future<api.ExercisePage> getExercises({
    required ExerciseFilter filter,
    String? cursor,
    int? limit,
  }) async {
    final offset = int.tryParse(cursor ?? '') ?? 0;
    final response = await _workApi.listExercises(
      q: filter.searchText,
      primaryMuscleGroup: filter.muscleGroup,
      equipmentNeeded: filter.equipment,
      difficultyLevel: filter.difficulty,
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
  Future<api.Exercise> getExercise(int id) async {
    final response = await _workApi.getExercise(id: id);
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
  Future<api.Exercise> createExercise(api.ExerciseWrite exerciseWrite) async {
    final response = await _workApi.createExercise(
      exerciseWrite: exerciseWrite,
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
  Future<api.Exercise> updateExercise(
    int id,
    api.ExerciseWrite exerciseWrite,
  ) async {
    final response = await _workApi.updateExercise(
      id: id,
      exerciseWrite: exerciseWrite,
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
}
