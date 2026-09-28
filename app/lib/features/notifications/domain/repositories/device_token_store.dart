/// Local persistence for push token + registered device id.
abstract class DeviceTokenStore {
  Future<String?> readToken();

  Future<void> writeToken(String token);

  Future<String?> readDeviceId();

  Future<void> writeDeviceId(String id);

  Future<void> clearDeviceId();

  Future<void> clearAll();
}
