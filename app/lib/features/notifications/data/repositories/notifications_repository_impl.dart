import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/error/map_thrown.dart';
import '../../../../core/pagination/cursor_page.dart';
import '../../domain/entities/app_notification.dart';
import '../../domain/entities/broadcast_request_input.dart';
import '../../domain/entities/device_platform.dart';
import '../../domain/entities/notification_device.dart';
import '../../domain/repositories/notifications_repository.dart';
import '../datasources/notifications_remote_datasource.dart';
import '../models/notifications_mappers.dart';

@LazySingleton(as: NotificationsRepository)
class NotificationsRepositoryImpl implements NotificationsRepository {
  NotificationsRepositoryImpl(this._remote);

  final NotificationsRemoteDataSource _remote;

  int? _parseId(String id) => int.tryParse(id);

  @override
  Future<Either<Failure, CursorPage<AppNotification>>> listNotifications({
    int? limit,
    String? cursor,
  }) async {
    try {
      final page = await _remote.listNotifications(
        limit: limit,
        cursor: cursor,
      );
      return Right(
        CursorPage(
          items: page.data.map((n) => n.toDomain()).toList(),
          nextCursor: page.meta.nextCursor,
          hasMore: page.meta.hasMore,
        ),
      );
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, AppNotification>> getNotification(String id) async {
    final intId = _parseId(id);
    if (intId == null) return const Left(NotFoundFailure());
    try {
      final notification = await _remote.getNotification(intId);
      return Right(notification.toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, AppNotification>> markNotificationRead(
    String id,
  ) async {
    final intId = _parseId(id);
    if (intId == null) return const Left(NotFoundFailure());
    try {
      final notification = await _remote.markNotificationRead(intId);
      return Right(notification.toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> markAllNotificationsRead() async {
    try {
      await _remote.markAllNotificationsRead();
      return const Right(null);
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, AppNotification>> broadcastNotification(
    BroadcastRequestInput input,
  ) async {
    try {
      final created = await _remote.broadcastNotification(
        toBroadcastRequest(input),
      );
      return Right(created.toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, CursorPage<AppNotification>>> listBroadcasts({
    int? limit,
    int? offset,
  }) async {
    try {
      final page = await _remote.listBroadcasts(limit: limit, offset: offset);
      final nextOffset = page.meta.hasMore
          ? ((page.meta.offset ?? offset ?? 0) + page.data.length).toString()
          : null;
      return Right(
        CursorPage(
          items: page.data.map((n) => n.toDomain()).toList(),
          nextCursor: nextOffset,
          hasMore: page.meta.hasMore,
        ),
      );
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<NotificationDevice>>> listDevices() async {
    try {
      final page = await _remote.listDevices();
      return Right(page.data.map((d) => d.toDomain()).toList());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, NotificationDevice>> registerDevice({
    required String deviceToken,
    required DevicePlatform platform,
  }) async {
    try {
      final device = await _remote.registerDevice(
        toDeviceWrite(deviceToken: deviceToken, platform: platform),
      );
      return Right(device.toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> deleteDevice(String id) async {
    final intId = _parseId(id);
    if (intId == null) return const Left(NotFoundFailure());
    try {
      await _remote.deleteDevice(intId);
      return const Right(null);
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }
}
