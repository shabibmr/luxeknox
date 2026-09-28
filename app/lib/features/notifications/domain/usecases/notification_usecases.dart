import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/pagination/cursor_page.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/app_notification.dart';
import '../entities/broadcast_request_input.dart';
import '../entities/device_platform.dart';
import '../entities/notification_device.dart';
import '../repositories/notifications_repository.dart';

class ListNotificationsParams extends Equatable {
  const ListNotificationsParams({this.limit, this.cursor});

  final int? limit;
  final String? cursor;

  @override
  List<Object?> get props => [limit, cursor];
}

@lazySingleton
class ListNotificationsUseCase
    implements UseCase<CursorPage<AppNotification>, ListNotificationsParams> {
  const ListNotificationsUseCase(this._repository);

  final NotificationsRepository _repository;

  @override
  Future<Either<Failure, CursorPage<AppNotification>>> call(
    ListNotificationsParams params,
  ) {
    return _repository.listNotifications(
      limit: params.limit,
      cursor: params.cursor,
    );
  }
}

@lazySingleton
class GetNotificationUseCase implements UseCase<AppNotification, String> {
  const GetNotificationUseCase(this._repository);

  final NotificationsRepository _repository;

  @override
  Future<Either<Failure, AppNotification>> call(String id) {
    return _repository.getNotification(id);
  }
}

@lazySingleton
class MarkNotificationReadUseCase implements UseCase<AppNotification, String> {
  const MarkNotificationReadUseCase(this._repository);

  final NotificationsRepository _repository;

  @override
  Future<Either<Failure, AppNotification>> call(String id) {
    return _repository.markNotificationRead(id);
  }
}

@lazySingleton
class MarkAllNotificationsReadUseCase implements UseCase<void, NoParams> {
  const MarkAllNotificationsReadUseCase(this._repository);

  final NotificationsRepository _repository;

  @override
  Future<Either<Failure, void>> call(NoParams params) {
    return _repository.markAllNotificationsRead();
  }
}

@lazySingleton
class BroadcastNotificationUseCase
    implements UseCase<AppNotification, BroadcastRequestInput> {
  const BroadcastNotificationUseCase(this._repository);

  final NotificationsRepository _repository;

  @override
  Future<Either<Failure, AppNotification>> call(BroadcastRequestInput params) {
    return _repository.broadcastNotification(params);
  }
}

class ListBroadcastsParams extends Equatable {
  const ListBroadcastsParams({this.limit, this.offset});

  final int? limit;
  final int? offset;

  @override
  List<Object?> get props => [limit, offset];
}

@lazySingleton
class ListBroadcastsUseCase
    implements UseCase<CursorPage<AppNotification>, ListBroadcastsParams> {
  const ListBroadcastsUseCase(this._repository);

  final NotificationsRepository _repository;

  @override
  Future<Either<Failure, CursorPage<AppNotification>>> call(
    ListBroadcastsParams params,
  ) {
    return _repository.listBroadcasts(
      limit: params.limit,
      offset: params.offset,
    );
  }
}

@lazySingleton
class ListDevicesUseCase implements UseCase<List<NotificationDevice>, NoParams> {
  const ListDevicesUseCase(this._repository);

  final NotificationsRepository _repository;

  @override
  Future<Either<Failure, List<NotificationDevice>>> call(NoParams params) {
    return _repository.listDevices();
  }
}

class RegisterDeviceParams extends Equatable {
  const RegisterDeviceParams({
    required this.deviceToken,
    required this.platform,
  });

  final String deviceToken;
  final DevicePlatform platform;

  @override
  List<Object?> get props => [deviceToken, platform];
}

@lazySingleton
class RegisterDeviceUseCase
    implements UseCase<NotificationDevice, RegisterDeviceParams> {
  const RegisterDeviceUseCase(this._repository);

  final NotificationsRepository _repository;

  @override
  Future<Either<Failure, NotificationDevice>> call(RegisterDeviceParams params) {
    return _repository.registerDevice(
      deviceToken: params.deviceToken,
      platform: params.platform,
    );
  }
}

@lazySingleton
class DeleteDeviceUseCase implements UseCase<void, String> {
  const DeleteDeviceUseCase(this._repository);

  final NotificationsRepository _repository;

  @override
  Future<Either<Failure, void>> call(String id) {
    return _repository.deleteDevice(id);
  }
}
