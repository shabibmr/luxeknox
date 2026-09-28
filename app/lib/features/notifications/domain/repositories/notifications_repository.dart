import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/pagination/cursor_page.dart';
import '../entities/app_notification.dart';
import '../entities/broadcast_request_input.dart';
import '../entities/device_platform.dart';
import '../entities/notification_device.dart';

abstract class NotificationsRepository {
  Future<Either<Failure, CursorPage<AppNotification>>> listNotifications({
    int? limit,
    String? cursor,
  });

  Future<Either<Failure, AppNotification>> getNotification(String id);

  Future<Either<Failure, AppNotification>> markNotificationRead(String id);

  Future<Either<Failure, void>> markAllNotificationsRead();

  Future<Either<Failure, AppNotification>> broadcastNotification(
    BroadcastRequestInput input,
  );

  Future<Either<Failure, CursorPage<AppNotification>>> listBroadcasts({
    int? limit,
    int? offset,
  });

  Future<Either<Failure, List<NotificationDevice>>> listDevices();

  Future<Either<Failure, NotificationDevice>> registerDevice({
    required String deviceToken,
    required DevicePlatform platform,
  });

  Future<Either<Failure, void>> deleteDevice(String id);
}
