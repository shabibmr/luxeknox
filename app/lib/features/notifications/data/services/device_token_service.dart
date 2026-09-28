import 'dart:io' show Platform;
import 'dart:math';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/device_platform.dart';
import '../../domain/entities/notification_device.dart';
import '../../domain/repositories/device_token_registrar.dart';
import '../../domain/repositories/device_token_store.dart';
import '../../domain/repositories/notifications_repository.dart';
import '../../domain/repositories/push_token_provider.dart';

/// Registers / rotates the device push token with the NOTIF API.
///
/// Prefers a live FCM token from [PushTokenProvider]; falls back to a stable
/// local stub UUID when Firebase is not configured (dev / web without setup).
@LazySingleton(as: DeviceTokenRegistrar)
class DeviceTokenService implements DeviceTokenRegistrar {
  DeviceTokenService(this._repository, this._store, this._pushTokens);

  final NotificationsRepository _repository;
  final DeviceTokenStore _store;
  final PushTokenProvider _pushTokens;

  DevicePlatform detectPlatform() {
    if (kIsWeb) return DevicePlatform.web;
    try {
      if (Platform.isIOS) return DevicePlatform.ios;
      if (Platform.isAndroid) return DevicePlatform.android;
    } catch (_) {
      // Platform may throw on unsupported targets.
    }
    return DevicePlatform.android;
  }

  Future<String> ensureLocalToken({bool forceRefresh = false}) async {
    await _pushTokens.ensureStarted();
    if (_pushTokens.isLive) {
      final fcm = await _pushTokens.getToken(forceRefresh: forceRefresh);
      if (fcm != null && fcm.isNotEmpty) {
        await _store.writeToken(fcm);
        return fcm;
      }
    }

    if (!forceRefresh) {
      final existing = await _store.readToken();
      if (existing != null && existing.isNotEmpty) return existing;
    }
    final token = _generateStubToken();
    await _store.writeToken(token);
    return token;
  }

  /// Registers the current token. Rotates when [forceNewToken] is true
  /// or when [tokenOverride] differs from the stored token.
  @override
  Future<Either<Failure, NotificationDevice>> registerOrRotate({
    String? tokenOverride,
    bool forceNewToken = false,
  }) async {
    final platform = detectPlatform();
    var token = tokenOverride;

    if (forceNewToken) {
      await _unregisterStoredBestEffort();
      token = await ensureLocalToken(forceRefresh: true);
    } else if (tokenOverride != null) {
      final previous = await _store.readToken();
      if (previous != null && previous != tokenOverride) {
        await _unregisterStoredBestEffort();
      }
      await _store.writeToken(tokenOverride);
      token = tokenOverride;
    } else {
      token = await ensureLocalToken();
    }

    final result = await _repository.registerDevice(
      deviceToken: token,
      platform: platform,
    );
    return result.fold(Left.new, (device) async {
      await _store.writeDeviceId(device.id);
      return Right(device);
    });
  }

  /// Best-effort unregister used on logout. Ignores API failures.
  @override
  Future<void> unregisterBestEffort() async {
    await _unregisterStoredBestEffort();
    await _store.clearDeviceId();
  }

  Future<String?> storedDeviceId() => _store.readDeviceId();

  Future<void> _unregisterStoredBestEffort() async {
    final id = await _store.readDeviceId();
    if (id == null || id.isEmpty) return;
    try {
      await _repository.deleteDevice(id);
    } catch (_) {
      // Ignore — logout must proceed.
    }
  }

  String _generateStubToken() {
    final rand = Random.secure();
    final bytes = List<int>.generate(16, (_) => rand.nextInt(256));
    bytes[6] = (bytes[6] & 0x0f) | 0x40;
    bytes[8] = (bytes[8] & 0x3f) | 0x80;
    String hex(int b) => b.toRadixString(16).padLeft(2, '0');
    final h = bytes.map(hex).join();
    return '${h.substring(0, 8)}-${h.substring(8, 12)}-'
        '${h.substring(12, 16)}-${h.substring(16, 20)}-${h.substring(20)}';
  }
}
