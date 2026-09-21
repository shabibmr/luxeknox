import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/device_token_store.dart';
import '../repositories/notifications_repository.dart';

/// Clears the registered push device before session tokens are wiped.
@lazySingleton
class UnregisterDeviceOnLogoutUseCase implements UseCase<void, NoParams> {
  const UnregisterDeviceOnLogoutUseCase(this._repository, this._store);

  final NotificationsRepository _repository;
  final DeviceTokenStore _store;

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    final id = await _store.readDeviceId();
    if (id != null && id.isNotEmpty) {
      try {
        await _repository.deleteDevice(id);
      } catch (_) {
        // Best-effort — logout must proceed.
      }
    }
    await _store.clearDeviceId();
    return const Right(null);
  }
}
