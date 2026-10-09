import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/core/usecase/usecase.dart';
import 'package:luxeknox/session/domain/entities/capabilities.dart';
import 'package:luxeknox/session/domain/entities/principal.dart';
import 'package:luxeknox/session/domain/entities/user_type.dart';
import 'package:luxeknox/session/domain/usecases/login_usecase.dart';
import 'package:luxeknox/session/domain/usecases/login_with_google_usecase.dart';
import 'package:luxeknox/session/domain/usecases/logout_usecase.dart';
import 'package:luxeknox/session/domain/usecases/restore_session_usecase.dart';
import 'package:luxeknox/session/presentation/session_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockRestoreSessionUseCase extends Mock implements RestoreSessionUseCase {}

class MockLoginUseCase extends Mock implements LoginUseCase {}

class MockLogoutUseCase extends Mock implements LogoutUseCase {}

class MockLoginWithGoogleUseCase extends Mock
    implements LoginWithGoogleUseCase {}

void main() {
  late MockRestoreSessionUseCase mockRestoreUseCase;
  late MockLoginUseCase mockLoginUseCase;
  late MockLogoutUseCase mockLogoutUseCase;
  late MockLoginWithGoogleUseCase mockLoginWithGoogleUseCase;

  const tPrincipal = Principal(
    userId: 'user-1',
    userType: UserType.member,
    displayName: 'Member One',
    profileId: 'prof-1',
  );
  const tCapabilities = Capabilities(slugs: ['exercises.read']);

  setUp(() {
    mockRestoreUseCase = MockRestoreSessionUseCase();
    mockLoginUseCase = MockLoginUseCase();
    mockLogoutUseCase = MockLogoutUseCase();
    mockLoginWithGoogleUseCase = MockLoginWithGoogleUseCase();
  });

  SessionCubit createCubit() => SessionCubit(
    restoreSessionUseCase: mockRestoreUseCase,
    loginUseCase: mockLoginUseCase,
    logoutUseCase: mockLogoutUseCase,
    loginWithGoogleUseCase: mockLoginWithGoogleUseCase,
  );

  group('SessionCubit (F7)', () {
    test('initial state is SessionUnknown', () {
      final cubit = createCubit();
      expect(cubit.state, equals(const SessionUnknown()));
    });

    blocTest<SessionCubit, SessionState>(
      'restore-success emits [SessionAuthenticated]',
      build: () {
        when(
          () => mockRestoreUseCase(const NoParams()),
        ).thenAnswer((_) async => const Right((tPrincipal, tCapabilities)));
        return createCubit();
      },
      act: (cubit) => cubit.restore(),
      expect: () => [
        const SessionAuthenticated(
          principal: tPrincipal,
          capabilities: tCapabilities,
        ),
      ],
    );

    blocTest<SessionCubit, SessionState>(
      'restore-failure emits [SessionUnauthenticated]',
      build: () {
        when(
          () => mockRestoreUseCase(const NoParams()),
        ).thenAnswer((_) async => const Left(AuthFailure()));
        return createCubit();
      },
      act: (cubit) => cubit.restore(),
      expect: () => [const SessionUnauthenticated()],
    );

    blocTest<SessionCubit, SessionState>(
      'suspended/revoked session (AuthFailure on restore) → unauthenticated (L4)',
      build: () {
        when(
          () => mockRestoreUseCase(const NoParams()),
        ).thenAnswer((_) async => const Left(AuthFailure()));
        return createCubit();
      },
      act: (cubit) => cubit.restore(),
      expect: () => [const SessionUnauthenticated()],
    );

    test('UnknownFailure (server error) is not retried', () async {
      when(
        () => mockRestoreUseCase(const NoParams()),
      ).thenAnswer((_) async => const Left(UnknownFailure()));
      final cubit = createCubit();

      await cubit.restore();

      verify(() => mockRestoreUseCase(const NoParams())).called(1);
      expect(cubit.state, const SessionUnauthenticated());
    });

    test('retryable 503 is retried and a later success authenticates', () {
      fakeAsync((async) {
        var calls = 0;
        when(() => mockRestoreUseCase(const NoParams())).thenAnswer((_) async {
          calls++;
          return calls < 2
              ? const Left(UnknownFailure(retryable: true))
              : const Right((tPrincipal, tCapabilities));
        });
        final cubit = createCubit();

        cubit.restore();
        async.elapse(const Duration(seconds: 2));

        expect(calls, 2);
        expect(cubit.state, isA<SessionAuthenticated>());
      });
    });

    test('NetworkFailure is retried and a later success authenticates', () {
      fakeAsync((async) {
        var calls = 0;
        when(() => mockRestoreUseCase(const NoParams())).thenAnswer((_) async {
          calls++;
          return calls < 3
              ? const Left(NetworkFailure())
              : const Right((tPrincipal, tCapabilities));
        });
        final cubit = createCubit();

        cubit.restore();
        async.elapse(const Duration(seconds: 3));

        expect(calls, 3);
        expect(cubit.state, isA<SessionAuthenticated>());
      });
    });

    test('restore gives up after restoreTimeout when requests hang', () {
      fakeAsync((async) {
        when(
          () => mockRestoreUseCase(const NoParams()),
        ).thenAnswer((_) => Completer<Never>().future);
        final cubit = createCubit();

        cubit.restore();
        async.elapse(SessionCubit.restoreTimeout - const Duration(seconds: 1));
        expect(cubit.state, const SessionUnknown());
        async.elapse(const Duration(seconds: 1));

        expect(cubit.state, const SessionUnauthenticated());
      });
    });

    test('concurrent restore calls share one in-flight restore', () async {
      final pending = Completer<Either<Failure, (Principal, Capabilities)>>();
      when(
        () => mockRestoreUseCase(const NoParams()),
      ).thenAnswer((_) => pending.future);
      final cubit = createCubit();

      final first = cubit.restore();
      final second = cubit.restore();
      pending.complete(const Right((tPrincipal, tCapabilities)));
      await Future.wait([first, second]);

      verify(() => mockRestoreUseCase(const NoParams())).called(1);
    });

    test(
      'a sign-out during restore is not overridden by a late success',
      () async {
        final pending = Completer<Either<Failure, (Principal, Capabilities)>>();
        when(
          () => mockRestoreUseCase(const NoParams()),
        ).thenAnswer((_) => pending.future);
        final cubit = createCubit();

        final restoring = cubit.restore();
        cubit.onSignedOut();
        pending.complete(const Right((tPrincipal, tCapabilities)));
        await restoring;

        expect(cubit.state, const SessionUnauthenticated());
      },
    );

    blocTest<SessionCubit, SessionState>(
      'login success emits [SessionAuthenticated]',
      build: () {
        when(
          () => mockLoginUseCase(
            const LoginParams(
              identifier: 'user@luxeknox.com',
              password: 'password123',
            ),
          ),
        ).thenAnswer((_) async => const Right((tPrincipal, tCapabilities)));
        return createCubit();
      },
      act: (cubit) => cubit.login('user@luxeknox.com', 'password123'),
      expect: () => [
        const SessionAuthenticated(
          principal: tPrincipal,
          capabilities: tCapabilities,
        ),
      ],
    );

    blocTest<SessionCubit, SessionState>(
      'login failure emits [SessionUnauthenticated]',
      build: () {
        when(
          () => mockLoginUseCase(
            const LoginParams(
              identifier: 'wrong@luxeknox.com',
              password: 'password123',
            ),
          ),
        ).thenAnswer((_) async => const Left(AuthFailure()));
        return createCubit();
      },
      act: (cubit) => cubit.login('wrong@luxeknox.com', 'password123'),
      expect: () => [const SessionUnauthenticated()],
    );

    blocTest<SessionCubit, SessionState>(
      'loginWithGoogle success emits [SessionAuthenticated]',
      build: () {
        when(
          () => mockLoginWithGoogleUseCase(const NoParams()),
        ).thenAnswer((_) async => const Right((tPrincipal, tCapabilities)));
        return createCubit();
      },
      act: (cubit) => cubit.loginWithGoogle(),
      expect: () => [
        const SessionAuthenticated(
          principal: tPrincipal,
          capabilities: tCapabilities,
        ),
      ],
    );

    blocTest<SessionCubit, SessionState>(
      'loginWithGoogle failure emits [SessionUnauthenticated]',
      build: () {
        when(
          () => mockLoginWithGoogleUseCase(const NoParams()),
        ).thenAnswer((_) async => const Left(AuthFailure()));
        return createCubit();
      },
      act: (cubit) => cubit.loginWithGoogle(),
      expect: () => [const SessionUnauthenticated()],
    );

    blocTest<SessionCubit, SessionState>(
      'logout emits [SessionUnauthenticated]',
      build: () {
        when(
          () => mockLogoutUseCase(const NoParams()),
        ).thenAnswer((_) async => const Right(null));
        return createCubit();
      },
      act: (cubit) => cubit.logout(),
      expect: () => [const SessionUnauthenticated(explicitSignOut: true)],
    );

    blocTest<SessionCubit, SessionState>(
      'onSignedOut emits [SessionUnauthenticated]',
      build: () => createCubit(),
      act: (cubit) => cubit.onSignedOut(),
      expect: () => [const SessionUnauthenticated()],
    );
  });
}
