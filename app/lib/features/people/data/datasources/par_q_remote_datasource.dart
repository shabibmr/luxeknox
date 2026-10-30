import 'package:api_client/api_client.dart' as api;
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

abstract class ParQRemoteDataSource {
  Future<api.ParQScreening> getLatest(int memberId);

  Future<api.ParQScreening> submit(int memberId, api.ParQSubmit body);

  Future<api.ParQScreening> review(int memberId, api.ParQTrainerReview body);

  Future<api.ParQScreening> clear(int memberId, api.ParQClearance body);
}

@LazySingleton(as: ParQRemoteDataSource)
class ParQRemoteDataSourceImpl implements ParQRemoteDataSource {
  ParQRemoteDataSourceImpl(this._healthApi);

  final api.HEALTHApi _healthApi;

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
  Future<api.ParQScreening> getLatest(int memberId) async {
    return _unwrap(await _healthApi.getParQ(id: memberId));
  }

  @override
  Future<api.ParQScreening> submit(int memberId, api.ParQSubmit body) async {
    return _unwrap(await _healthApi.submitParQ(id: memberId, parQSubmit: body));
  }

  @override
  Future<api.ParQScreening> review(
    int memberId,
    api.ParQTrainerReview body,
  ) async {
    return _unwrap(
      await _healthApi.reviewParQ(id: memberId, parQTrainerReview: body),
    );
  }

  @override
  Future<api.ParQScreening> clear(int memberId, api.ParQClearance body) async {
    return _unwrap(
      await _healthApi.clearParQ(id: memberId, parQClearance: body),
    );
  }
}
