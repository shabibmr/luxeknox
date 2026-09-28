import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/notification_device.dart';

/// Registers / rotates the local push device token (stub or real).
abstract class DeviceTokenRegistrar {
  Future<Either<Failure, NotificationDevice>> registerOrRotate({
    String? tokenOverride,
    bool forceNewToken = false,
  });

  Future<void> unregisterBestEffort();
}
