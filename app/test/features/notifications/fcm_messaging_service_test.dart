import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:go_router/go_router.dart';
import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/core/monitoring/crash_reporter.dart';
import 'package:luxeknox/features/notifications/data/services/fcm_messaging_service.dart';
import 'package:luxeknox/features/notifications/domain/repositories/device_token_registrar.dart';
import 'package:luxeknox/features/notifications/domain/repositories/push_token_provider.dart';
import 'package:luxeknox/session/domain/entities/capabilities.dart';
import 'package:luxeknox/session/domain/entities/principal.dart';
import 'package:luxeknox/session/domain/entities/user_type.dart';
import 'package:luxeknox/session/presentation/session_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockPushTokenProvider extends Mock implements PushTokenProvider {}

class MockDeviceTokenRegistrar extends Mock implements DeviceTokenRegistrar {}

class MockGoRouter extends Mock implements GoRouter {}

class MockSessionCubit extends Mock implements SessionCubit {}

class MockCrashReporter extends Mock implements CrashReporter {}

void main() {
  late MockPushTokenProvider pushTokens;
  late MockDeviceTokenRegistrar deviceTokens;
  late MockSessionCubit sessionCubit;
  late StreamController<SessionState> sessionStates;
  late FcmMessagingService service;

  const authenticated = SessionAuthenticated(
    principal: Principal(
      userId: '1',
      userType: UserType.member,
      displayName: 'Member',
      profileId: 'p1',
    ),
    capabilities: Capabilities(slugs: []),
  );

  setUp(() {
    pushTokens = MockPushTokenProvider();
    deviceTokens = MockDeviceTokenRegistrar();
    sessionCubit = MockSessionCubit();
    sessionStates = StreamController<SessionState>.broadcast();

    when(() => sessionCubit.stream).thenAnswer((_) => sessionStates.stream);
    when(() => sessionCubit.state).thenReturn(const SessionUnknown());
    when(() => pushTokens.ensureStarted()).thenAnswer((_) async {});
    when(() => pushTokens.isLive).thenReturn(false);
    when(
      () => deviceTokens.registerOrRotate(
        tokenOverride: any(named: 'tokenOverride'),
      ),
    ).thenAnswer((_) async => const Left(UnknownFailure()));

    service = FcmMessagingService(
      pushTokens,
      deviceTokens,
      MockGoRouter(),
      sessionCubit,
      MockCrashReporter(),
    );
  });

  tearDown(() {
    service.dispose();
    sessionStates.close();
  });

  test('a failing start() is caught and can be retried', () async {
    when(() => pushTokens.ensureStarted()).thenThrow(StateError('boom'));

    await service.start();

    when(() => pushTokens.ensureStarted()).thenAnswer((_) async {});
    await service.start();

    verify(() => pushTokens.ensureStarted()).called(2);
  });

  test(
    'syncs the device token when the session becomes authenticated',
    () async {
      when(() => pushTokens.getToken()).thenAnswer((_) async => 'fcm-token');
      await service.start();

      when(() => sessionCubit.state).thenReturn(authenticated);
      sessionStates.add(authenticated);
      await pumpEventQueue();

      verify(
        () => deviceTokens.registerOrRotate(tokenOverride: 'fcm-token'),
      ).called(1);
    },
  );

  test('a failing token sync does not escape the session listener', () async {
    when(() => pushTokens.getToken()).thenThrow(StateError('no token'));
    await service.start();

    when(() => sessionCubit.state).thenReturn(authenticated);
    sessionStates.add(authenticated);
    await pumpEventQueue();

    verifyNever(
      () => deviceTokens.registerOrRotate(
        tokenOverride: any(named: 'tokenOverride'),
      ),
    );
  });
}
