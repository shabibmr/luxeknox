import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../core/error/failures.dart';
import '../../../core/usecase/usecase.dart';
import '../../../features/notifications/domain/usecases/unregister_device_on_logout.dart';
import '../repositories/session_repository.dart';

@lazySingleton
class LogoutUseCase implements UseCase<void, NoParams> {
  const LogoutUseCase(this._repository, this._unregisterDevice);

  final SessionRepository _repository;
  final UnregisterDeviceOnLogoutUseCase _unregisterDevice;

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    await _unregisterDevice(const NoParams());
    return _repository.logout();
  }
}
