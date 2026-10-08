import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/features/notifications/data/services/device_token_service.dart';
import 'package:luxeknox/features/notifications/domain/entities/device_platform.dart';
import 'package:luxeknox/features/notifications/domain/entities/notification_device.dart';
import 'package:luxeknox/features/notifications/domain/repositories/device_token_store.dart';
import 'package:luxeknox/features/notifications/domain/repositories/notifications_repository.dart';
import 'package:luxeknox/features/notifications/domain/repositories/push_token_provider.dart';
import 'package:mocktail/mocktail.dart';

class MockNotificationsRepository extends Mock
    implements NotificationsRepository {}

class MockPushTokenProvider extends Mock implements PushTokenProvider {}

class FakeDeviceTokenStore implements DeviceTokenStore {
  String? token;
  String? deviceId;
  String? registration;

  @override
  Future<String?> readToken() async => token;

  @override
  Future<void> writeToken(String value) async => token = value;

  @override
  Future<String?> readDeviceId() async => deviceId;

  @override
  Future<void> writeDeviceId(String id) async => deviceId = id;

  @override
  Future<void> clearDeviceId() async {
    deviceId = null;
    registration = null;
  }

  @override
  Future<String?> readRegistration() async => registration;

  @override
  Future<void> writeRegistration(String marker) async => registration = marker;

  @override
  Future<void> clearRegistration() async => registration = null;

  @override
  Future<void> clearAll() async {
    token = null;
    await clearDeviceId();
  }
}

void main() {
  late MockNotificationsRepository repository;
  late FakeDeviceTokenStore store;
  late DeviceTokenService service;

  NotificationDevice device(String token) => NotificationDevice(
    id: '7',
    userId: '1',
    deviceToken: token,
    devicePlatform: DevicePlatform.android,
  );

  void stubRegister() {
    when(
      () => repository.registerDevice(
        deviceToken: any(named: 'deviceToken'),
        platform: any(named: 'platform'),
      ),
    ).thenAnswer(
      (inv) async => Right(device(inv.namedArguments[#deviceToken] as String)),
    );
  }

  void verifyRegistered(int times) => verify(
    () => repository.registerDevice(
      deviceToken: any(named: 'deviceToken'),
      platform: any(named: 'platform'),
    ),
  ).called(times);

  setUpAll(() => registerFallbackValue(DevicePlatform.android));

  setUp(() {
    repository = MockNotificationsRepository();
    store = FakeDeviceTokenStore();
    service = DeviceTokenService(repository, store, MockPushTokenProvider());
    stubRegister();
  });

  test('skips the request when the token and user are unchanged', () async {
    await service.syncToken('t1', userId: '1');
    await service.syncToken('t1', userId: '1');

    verifyRegistered(1);
  });

  test('registers again for a different user or token', () async {
    await service.syncToken('t1', userId: '1');
    await service.syncToken('t1', userId: '2');
    await service.syncToken('t2', userId: '2');

    verifyRegistered(3);
  });

  test('concurrent syncs share one request', () async {
    final pending = Completer<Either<Failure, NotificationDevice>>();
    when(
      () => repository.registerDevice(
        deviceToken: any(named: 'deviceToken'),
        platform: any(named: 'platform'),
      ),
    ).thenAnswer((_) => pending.future);

    final first = service.syncToken('t1', userId: '1');
    final second = service.syncToken('t1', userId: '1');
    pending.complete(Right(device('t1')));
    await Future.wait([first, second]);

    verifyRegistered(1);
  });

  test('registers again after logout clears the device id', () async {
    await service.syncToken('t1', userId: '1');
    await store.clearDeviceId();
    await service.syncToken('t1', userId: '1');

    verifyRegistered(2);
  });

  test('a failed registration is retried on the next sync', () async {
    when(
      () => repository.registerDevice(
        deviceToken: any(named: 'deviceToken'),
        platform: any(named: 'platform'),
      ),
    ).thenAnswer((_) async => const Left(NetworkFailure()));
    await service.syncToken('t1', userId: '1');

    stubRegister();
    await service.syncToken('t1', userId: '1');

    verifyRegistered(2);
    expect(store.registration, '1|t1');
  });

  test(
    'registerOrRotate clears the marker since the owner is unknown',
    () async {
      await service.syncToken('t1', userId: '1');
      await service.registerOrRotate(tokenOverride: 't1');
      await service.syncToken('t1', userId: '1');

      verifyRegistered(3);
    },
  );
}
