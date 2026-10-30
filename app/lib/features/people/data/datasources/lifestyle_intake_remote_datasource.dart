import 'package:api_client/api_client.dart' as api;
import '../../../../core/network/api_response_unwrap.dart';
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

  @override
  Future<api.LifestyleIntake> get(int memberId) async {
    return unwrapApiResponse(await _healthApi.getLifestyleIntake(id: memberId));
  }

  @override
  Future<api.LifestyleIntake> put(
    int memberId,
    api.LifestyleIntakeWrite body,
  ) async {
    return unwrapApiResponse(
      await _healthApi.putLifestyleIntake(
        id: memberId,
        lifestyleIntakeWrite: body,
      ),
    );
  }
}
