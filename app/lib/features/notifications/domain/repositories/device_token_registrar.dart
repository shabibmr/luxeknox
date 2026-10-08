import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/notification_device.dart';

/// Registers / rotates the local push device token (stub or real).
abstract class DeviceTokenRegistrar {
  Future<Either<Failure, NotificationDevice>> registerOrRotate({
    String? tokenOverride,
    bool forceNewToken = false,
  });

  /// Registers [token] for [userId], unless this device already registered
  /// the same token for the same user. Concurrent calls share one request.
  Future<Either<Failure, Unit>> syncToken(
    String token, {
    required String userId,
  });

  Future<void> unregisterBestEffort();
}
