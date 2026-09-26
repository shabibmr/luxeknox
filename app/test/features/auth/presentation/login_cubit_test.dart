import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/core/presentation/load_status.dart';
import 'package:luxeknox/features/auth/presentation/cubit/login_cubit.dart';
import 'package:luxeknox/session/domain/entities/capabilities.dart';
import 'package:luxeknox/session/domain/entities/principal.dart';
import 'package:luxeknox/session/domain/entities/user_type.dart';
import 'package:luxeknox/session/domain/usecases/login_usecase.dart';
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

void main() {
  late MockRestoreSessionUseCase mockRestoreUseCase;
  late MockLoginUseCase mockLoginUseCase;
  late MockLogoutUseCase mockLogoutUseCase;
  late SessionCubit sessionCubit;

  const tPrincipal = Principal(
    userId: 'user-1',
    userType: UserType.member,
    displayName: 'Member One',
    profileId: 'prof-1',
  );
  const tCapabilities = Capabilities(slugs: ['exercises.read']);

  setUpAll(() {
    registerFallbackValue(const LoginParams(identifier: '', password: ''));
  });

  setUp(() {
    mockRestoreUseCase = MockRestoreSessionUseCase();
    mockLoginUseCase = MockLoginUseCase();
    mockLogoutUseCase = MockLogoutUseCase();
    sessionCubit = SessionCubit(
      restoreSessionUseCase: mockRestoreUseCase,
      loginUseCase: mockLoginUseCase,
      logoutUseCase: mockLogoutUseCase,
    );
  });

  tearDown(() => sessionCubit.close());

  group('LoginCubit (H2 & H4)', () {
    blocTest<LoginCubit, LoginState>(
      'empty identifier is rejected client-side without calling the use case',
      build: () => LoginCubit(sessionCubit),
      act: (cubit) => cubit.submit('', 'password123'),
      expect: () => [
        isA<LoginState>()
            .having((s) => s.status, 'status', LoadStatus.failure)
            .having((s) => s.errorMessage, 'errorMessage', isNotNull),
      ],
      verify: (_) {
        verifyNever(() => mockLoginUseCase(any()));
      },
    );

    blocTest<LoginCubit, LoginState>(
      'empty password is rejected client-side without calling the use case',
      build: () => LoginCubit(sessionCubit),
      act: (cubit) => cubit.submit('user@luxeknox.com', ''),
      expect: () => [
        isA<LoginState>().having(
          (s) => s.status,
          'status',
          LoadStatus.failure,
        ),
      ],
      verify: (_) {
        verifyNever(() => mockLoginUseCase(any()));
      },
    );

    blocTest<LoginCubit, LoginState>(
      'success emits [submitting, idle] and leaves SessionCubit authenticated',
      build: () {
        when(
          () => mockLoginUseCase(
            const LoginParams(
              identifier: 'user@luxeknox.com',
              password: 'password123',
            ),
          ),
        ).thenAnswer((_) async => const Right((tPrincipal, tCapabilities)));
        return LoginCubit(sessionCubit);
      },
      act: (cubit) => cubit.submit('user@luxeknox.com', 'password123'),
      expect: () => [
        const LoginState(status: LoadStatus.loading),
        const LoginState(),
      ],
      verify: (_) {
        expect(
          sessionCubit.state,
          const SessionAuthenticated(
            principal: tPrincipal,
            capabilities: tCapabilities,
          ),
        );
      },
    );

    blocTest<LoginCubit, LoginState>(
      'wrong password shows the same message as an unknown identifier (FR-AUTH-002)',
      build: () {
        when(
          () => mockLoginUseCase(
            const LoginParams(
              identifier: 'wrong@luxeknox.com',
              password: 'bad',
            ),
          ),
        ).thenAnswer((_) async => const Left(AuthFailure()));
        return LoginCubit(sessionCubit);
      },
      act: (cubit) => cubit.submit('wrong@luxeknox.com', 'bad'),
      expect: () => [
        const LoginState(status: LoadStatus.loading),
        isA<LoginState>()
            .having((s) => s.status, 'status', LoadStatus.failure)
            .having(
              (s) => s.errorMessage,
              'errorMessage',
              'Incorrect email/phone or password.',
            ),
      ],
    );

    blocTest<LoginCubit, LoginState>(
      'suspended account shows the identical AuthFailure message, not a distinct one',
      build: () {
        when(
          () => mockLoginUseCase(
            const LoginParams(
              identifier: 'suspended@luxeknox.com',
              password: 'password123',
            ),
          ),
        ).thenAnswer((_) async => const Left(AuthFailure()));
        return LoginCubit(sessionCubit);
      },
      act: (cubit) => cubit.submit('suspended@luxeknox.com', 'password123'),
      expect: () => [
        const LoginState(status: LoadStatus.loading),
        isA<LoginState>()
            .having((s) => s.status, 'status', LoadStatus.failure)
            .having(
              (s) => s.errorMessage,
              'errorMessage',
              'Incorrect email/phone or password.',
            ),
      ],
    );

    blocTest<LoginCubit, LoginState>(
      'rate limited (429) shows a distinct message',
      build: () {
        when(
          () => mockLoginUseCase(
            const LoginParams(
              identifier: 'user@luxeknox.com',
              password: 'password123',
            ),
          ),
        ).thenAnswer((_) async => const Left(RateLimitFailure()));
        return LoginCubit(sessionCubit);
      },
      act: (cubit) => cubit.submit('user@luxeknox.com', 'password123'),
      expect: () => [
        const LoginState(status: LoadStatus.loading),
        isA<LoginState>()
            .having((s) => s.status, 'status', LoadStatus.failure)
            .having(
              (s) => s.errorMessage,
              'errorMessage',
              'Too many attempts. Please wait a moment and try again.',
            ),
      ],
    );

    test('identifier is trimmed before submission', () async {
      when(
        () => mockLoginUseCase(
          const LoginParams(
            identifier: 'user@luxeknox.com',
            password: 'password123',
          ),
        ),
      ).thenAnswer((_) async => const Right((tPrincipal, tCapabilities)));

      final cubit = LoginCubit(sessionCubit);
      await cubit.submit('  user@luxeknox.com  ', 'password123');

      verify(
        () => mockLoginUseCase(
          const LoginParams(
            identifier: 'user@luxeknox.com',
            password: 'password123',
          ),
        ),
      ).called(1);
      await cubit.close();
    });
  });
}
