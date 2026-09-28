import 'package:api_client/api_client.dart' as api;
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

abstract class NotificationsRemoteDataSource {
  Future<api.NotificationPage> listNotifications({int? limit, String? cursor});

  Future<api.Notification> getNotification(int id);

  Future<api.Notification> markNotificationRead(int id);

  Future<void> markAllNotificationsRead();

  Future<api.Notification> broadcastNotification(api.BroadcastRequest request);

  Future<api.NotificationPage> listBroadcasts({int? limit, int? offset});

  Future<api.DevicePage> listDevices();

  Future<api.Device> registerDevice(api.DeviceWrite write);

  Future<void> deleteDevice(int id);
}

@LazySingleton(as: NotificationsRemoteDataSource)
class NotificationsRemoteDataSourceImpl
    implements NotificationsRemoteDataSource {
  NotificationsRemoteDataSourceImpl(this._api);

  final api.NOTIFApi _api;

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
  Future<api.NotificationPage> listNotifications({
    int? limit,
    String? cursor,
  }) async {
    return _unwrap(
      await _api.listNotifications(limit: limit, cursor: cursor),
    );
  }

  @override
  Future<api.Notification> getNotification(int id) async {
    return _unwrap(await _api.getNotification(id: id));
  }

  @override
  Future<api.Notification> markNotificationRead(int id) async {
    return _unwrap(await _api.markNotificationRead(id: id));
  }

  @override
  Future<void> markAllNotificationsRead() async {
    await _api.markAllNotificationsRead();
  }

  @override
  Future<api.Notification> broadcastNotification(
    api.BroadcastRequest request,
  ) async {
    return _unwrap(
      await _api.broadcastNotification(broadcastRequest: request),
    );
  }

  @override
  Future<api.NotificationPage> listBroadcasts({
    int? limit,
    int? offset,
  }) async {
    return _unwrap(await _api.listBroadcasts(limit: limit, offset: offset));
  }

  @override
  Future<api.DevicePage> listDevices() async {
    return _unwrap(await _api.listDevices());
  }

  @override
  Future<api.Device> registerDevice(api.DeviceWrite write) async {
    return _unwrap(await _api.registerDevice(deviceWrite: write));
  }

  @override
  Future<void> deleteDevice(int id) async {
    await _api.deleteDevice(id: id);
  }
}
