import 'package:app/core/usecase/usecase.dart';
import 'package:app/session/domain/entities/capabilities.dart';
import 'package:app/session/domain/entities/principal.dart';
import 'package:app/session/domain/entities/user_type.dart';
import 'package:app/session/domain/repositories/session_repository.dart';
import 'package:app/session/domain/usecases/change_password_usecase.dart';
import 'package:app/session/domain/usecases/forgot_password_usecase.dart';
import 'package:app/session/domain/usecases/get_me_usecase.dart';
import 'package:app/session/domain/usecases/login_usecase.dart';
import 'package:app/features/notifications/domain/usecases/unregister_device_on_logout.dart';
import 'package:app/session/domain/usecases/logout_usecase.dart';
import 'package:app/session/domain/usecases/refresh_session_usecase.dart';
import 'package:app/session/domain/usecases/reset_password_usecase.dart';
import 'package:app/session/domain/usecases/restore_session_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockSessionRepository extends Mock implements SessionRepository {}

class MockUnregisterDeviceOnLogoutUseCase extends Mock
    implements UnregisterDeviceOnLogoutUseCase {}

void main() {
  late MockSessionRepository mockRepository;
  const tPrincipal = Principal(
    userId: 'user-1',
    userType: UserType.admin,
    displayName: 'Admin User',
    profileId: 'prof-1',
  );
  const tCapabilities = Capabilities(
    slugs: ['exercises.read', 'exercises.create'],
  );

  setUp(() {
    mockRepository = MockSessionRepository();
  });

  group('Session UseCases (F4)', () {
    test('LoginUseCase calls repository.login and returns result', () async {
      when(
        () => mockRepository.login('admin@luxeknox.com', 'password123'),
      ).thenAnswer((_) async => const Right((tPrincipal, tCapabilities)));

      final useCase = LoginUseCase(mockRepository);
      final result = await useCase(
        const LoginParams(
          identifier: 'admin@luxeknox.com',
          password: 'password123',
        ),
      );

      expect(result, const Right((tPrincipal, tCapabilities)));
      verify(
        () => mockRepository.login('admin@luxeknox.com', 'password123'),
      ).called(1);
    });

    test('LogoutUseCase calls repository.logout', () async {
      final mockUnregisterDevice = MockUnregisterDeviceOnLogoutUseCase();
      when(
        () => mockRepository.logout(),
      ).thenAnswer((_) async => const Right(null));
      when(
        () => mockUnregisterDevice(const NoParams()),
      ).thenAnswer((_) async => const Right(null));

      final useCase = LogoutUseCase(mockRepository, mockUnregisterDevice);
      final result = await useCase(const NoParams());

      expect(result, const Right(null));
      verify(() => mockRepository.logout()).called(1);
    });

    test('RefreshSessionUseCase calls repository.refresh', () async {
      when(
        () => mockRepository.refresh(),
      ).thenAnswer((_) async => const Right(null));

      final useCase = RefreshSessionUseCase(mockRepository);
      final result = await useCase(const NoParams());

      expect(result, const Right(null));
      verify(() => mockRepository.refresh()).called(1);
    });

    test('GetMeUseCase calls repository.getMe', () async {
      when(
        () => mockRepository.getMe(),
      ).thenAnswer((_) async => const Right((tPrincipal, tCapabilities)));

      final useCase = GetMeUseCase(mockRepository);
      final result = await useCase(const NoParams());

      expect(result, const Right((tPrincipal, tCapabilities)));
      verify(() => mockRepository.getMe()).called(1);
    });

    test('RestoreSessionUseCase calls repository.restore', () async {
      when(
        () => mockRepository.restore(),
      ).thenAnswer((_) async => const Right((tPrincipal, tCapabilities)));

      final useCase = RestoreSessionUseCase(mockRepository);
      final result = await useCase(const NoParams());

      expect(result, const Right((tPrincipal, tCapabilities)));
      verify(() => mockRepository.restore()).called(1);
    });

    test('ChangePasswordUseCase calls repository.changePassword', () async {
      when(
        () => mockRepository.changePassword(
          currentPassword: 'old',
          newPassword: 'newpass12',
        ),
      ).thenAnswer((_) async => const Right(null));

      final useCase = ChangePasswordUseCase(mockRepository);
      final result = await useCase(
        const ChangePasswordParams(
          currentPassword: 'old',
          newPassword: 'newpass12',
        ),
      );

      expect(result, const Right(null));
      verify(
        () => mockRepository.changePassword(
          currentPassword: 'old',
          newPassword: 'newpass12',
        ),
      ).called(1);
    });

    test('ForgotPasswordUseCase calls repository.forgotPassword', () async {
      when(
        () => mockRepository.forgotPassword('a@b.com'),
      ).thenAnswer((_) async => const Right(null));

      final useCase = ForgotPasswordUseCase(mockRepository);
      final result = await useCase(
        const ForgotPasswordParams(identifier: 'a@b.com'),
      );

      expect(result, const Right(null));
      verify(() => mockRepository.forgotPassword('a@b.com')).called(1);
    });

    test('ResetPasswordUseCase calls repository.resetPassword', () async {
      when(
        () => mockRepository.resetPassword(
          token: 'tok',
          newPassword: 'newpass12',
        ),
      ).thenAnswer((_) async => const Right(null));

      final useCase = ResetPasswordUseCase(mockRepository);
      final result = await useCase(
        const ResetPasswordParams(token: 'tok', newPassword: 'newpass12'),
      );

      expect(result, const Right(null));
      verify(
        () => mockRepository.resetPassword(
          token: 'tok',
          newPassword: 'newpass12',
        ),
      ).called(1);
    });
  });
}
