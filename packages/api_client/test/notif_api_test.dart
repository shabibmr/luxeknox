import 'package:test/test.dart';
import 'package:api_client/api_client.dart';


/// tests for NOTIFApi
void main() {
  final instance = ApiClient().getNOTIFApi();

  group(NOTIFApi, () {
    // Broadcast to a role-scoped audience
    //
    //Future<Notification> broadcastNotification(BroadcastRequest broadcastRequest) async
    test('test broadcastNotification', () async {
      // TODO
    });

    // Unregister a device
    //
    //Future deleteDevice(int id) async
    test('test deleteDevice', () async {
      // TODO
    });

    // Notification detail
    //
    //Future<Notification> getNotification(int id) async
    test('test getNotification', () async {
      // TODO
    });

    // Sent broadcasts
    //
    //Future<NotificationPage> listBroadcasts({ int limit, int offset }) async
    test('test listBroadcasts', () async {
      // TODO
    });

    // Registered push devices for the current user
    //
    //Future<DevicePage> listDevices() async
    test('test listDevices', () async {
      // TODO
    });

    // Inbox
    //
    //Future<NotificationPage> listNotifications({ int limit, String cursor }) async
    test('test listNotifications', () async {
      // TODO
    });

    // Mark all read
    //
    //Future markAllNotificationsRead() async
    test('test markAllNotificationsRead', () async {
      // TODO
    });

    // Mark one notification read
    //
    //Future<Notification> markNotificationRead(int id) async
    test('test markNotificationRead', () async {
      // TODO
    });

    // Register a push token
    //
    //Future<Device> registerDevice(DeviceWrite deviceWrite) async
    test('test registerDevice', () async {
      // TODO
    });

  });
}
