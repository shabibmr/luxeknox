import 'package:app/core/error/failures.dart';
import 'package:app/core/usecase/usecase.dart';
import 'package:app/session/domain/entities/capabilities.dart';
import 'package:app/session/domain/entities/principal.dart';
import 'package:app/session/domain/entities/user_type.dart';
import 'package:app/session/domain/usecases/login_usecase.dart';
import 'package:app/session/domain/usecases/logout_usecase.dart';
import 'package:app/session/domain/usecases/restore_session_usecase.dart';
import 'package:app/session/presentation/session_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockRestoreSessionUseCase extends Mock implements RestoreSessionUseCase {}

class MockLoginUseCase extends Mock implements LoginUseCase {}

class MockLogoutUseCase extends Mock implements LogoutUseCase {}

void main() {
  late MockRestoreSessionUseCase mockRestoreUseCase;
  late MockLoginUseCase mockLoginUseCase;
  late MockLogoutUseCase mockLogoutUseCase;

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
  });

  group('SessionCubit (F7)', () {
    test('initial state is SessionUnknown', () {
      final cubit = SessionCubit(
        restoreSessionUseCase: mockRestoreUseCase,
        loginUseCase: mockLoginUseCase,
        logoutUseCase: mockLogoutUseCase,
      );
      expect(cubit.state, equals(const SessionUnknown()));
    });

    blocTest<SessionCubit, SessionState>(
      'restore-success emits [SessionAuthenticated]',
      build: () {
        when(
          () => mockRestoreUseCase(const NoParams()),
        ).thenAnswer((_) async => const Right((tPrincipal, tCapabilities)));
        return SessionCubit(
          restoreSessionUseCase: mockRestoreUseCase,
          loginUseCase: mockLoginUseCase,
          logoutUseCase: mockLogoutUseCase,
        );
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
        return SessionCubit(
          restoreSessionUseCase: mockRestoreUseCase,
          loginUseCase: mockLoginUseCase,
          logoutUseCase: mockLogoutUseCase,
        );
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
        return SessionCubit(
          restoreSessionUseCase: mockRestoreUseCase,
          loginUseCase: mockLoginUseCase,
          logoutUseCase: mockLogoutUseCase,
        );
      },
      act: (cubit) => cubit.restore(),
      expect: () => [const SessionUnauthenticated()],
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
        return SessionCubit(
          restoreSessionUseCase: mockRestoreUseCase,
          loginUseCase: mockLoginUseCase,
          logoutUseCase: mockLogoutUseCase,
        );
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
        return SessionCubit(
          restoreSessionUseCase: mockRestoreUseCase,
          loginUseCase: mockLoginUseCase,
          logoutUseCase: mockLogoutUseCase,
        );
      },
      act: (cubit) => cubit.login('wrong@luxeknox.com', 'password123'),
      expect: () => [const SessionUnauthenticated()],
    );

    blocTest<SessionCubit, SessionState>(
      'logout emits [SessionUnauthenticated]',
      build: () {
        when(
          () => mockLogoutUseCase(const NoParams()),
        ).thenAnswer((_) async => const Right(null));
        return SessionCubit(
          restoreSessionUseCase: mockRestoreUseCase,
          loginUseCase: mockLoginUseCase,
          logoutUseCase: mockLogoutUseCase,
        );
      },
      act: (cubit) => cubit.logout(),
      expect: () => [const SessionUnauthenticated()],
    );

    blocTest<SessionCubit, SessionState>(
      'onSignedOut emits [SessionUnauthenticated]',
      build: () => SessionCubit(
        restoreSessionUseCase: mockRestoreUseCase,
        loginUseCase: mockLoginUseCase,
        logoutUseCase: mockLogoutUseCase,
      ),
      act: (cubit) => cubit.onSignedOut(),
      expect: () => [const SessionUnauthenticated()],
    );
  });
}
