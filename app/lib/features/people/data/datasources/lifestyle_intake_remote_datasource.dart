import 'package:api_client/api_client.dart' as api;
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

abstract class LifestyleIntakeRemoteDataSource {
  Future<api.LifestyleIntake> get(int memberId);

  Future<api.LifestyleIntake> put(int memberId, api.LifestyleIntakeWrite body);
}

@LazySingleton(as: LifestyleIntakeRemoteDataSource)
class LifestyleIntakeRemoteDataSourceImpl
    implements LifestyleIntakeRemoteDataSource {
  LifestyleIntakeRemoteDataSourceImpl(this._healthApi);

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
  Future<api.LifestyleIntake> get(int memberId) async {
    return _unwrap(await _healthApi.getLifestyleIntake(id: memberId));
  }

  @override
  Future<api.LifestyleIntake> put(
    int memberId,
    api.LifestyleIntakeWrite body,
  ) async {
    return _unwrap(
      await _healthApi.putLifestyleIntake(
        id: memberId,
        lifestyleIntakeWrite: body,
      ),
    );
  }
}
