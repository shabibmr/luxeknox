import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

import '../../domain/repositories/device_token_store.dart';

@LazySingleton(as: DeviceTokenStore)
class DeviceTokenLocalStore implements DeviceTokenStore {
  DeviceTokenLocalStore(this._storage);

  static const _tokenKey = 'notif_device_token';
  static const _deviceIdKey = 'notif_device_id';
  static const _registrationKey = 'notif_device_registration';

  final FlutterSecureStorage _storage;

  @override
  Future<String?> readToken() => _storage.read(key: _tokenKey);

  @override
  Future<void> writeToken(String token) =>
      _storage.write(key: _tokenKey, value: token);

  @override
  Future<String?> readDeviceId() => _storage.read(key: _deviceIdKey);

  @override
  Future<void> writeDeviceId(String id) =>
      _storage.write(key: _deviceIdKey, value: id);

  @override
  Future<void> clearDeviceId() async {
    await Future.wait([
      _storage.delete(key: _deviceIdKey),
      clearRegistration(),
    ]);
  }

  @override
  Future<String?> readRegistration() => _storage.read(key: _registrationKey);

  @override
  Future<void> writeRegistration(String marker) =>
      _storage.write(key: _registrationKey, value: marker);

  @override
  Future<void> clearRegistration() => _storage.delete(key: _registrationKey);

  @override
  Future<void> clearAll() async {
    await Future.wait([
      _storage.delete(key: _tokenKey),
      _storage.delete(key: _deviceIdKey),
      clearRegistration(),
    ]);
  }
}
