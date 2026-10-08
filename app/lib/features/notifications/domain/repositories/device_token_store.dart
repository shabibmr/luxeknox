/// Local persistence for push token + registered device id.
abstract class DeviceTokenStore {
  Future<String?> readToken();

  Future<void> writeToken(String token);

  Future<String?> readDeviceId();

  Future<void> writeDeviceId(String id);

  /// Clears the device id and the registration marker.
  Future<void> clearDeviceId();

  /// Marker for the last successful registration (`<userId>|<token>`), used to
  /// skip re-registering an unchanged token for the same user.
  Future<String?> readRegistration();

  Future<void> writeRegistration(String marker);

  Future<void> clearRegistration();

  Future<void> clearAll();
}
