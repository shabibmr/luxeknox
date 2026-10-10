import 'package:api_client/api_client.dart' as api;
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/core/storage/token_storage.dart';
import 'package:luxeknox/features/auth/data/services/firebase_auth_service.dart';
import 'package:luxeknox/session/data/datasources/session_remote_datasource.dart';
import 'package:luxeknox/session/data/repositories/session_repository_impl.dart';
import 'package:luxeknox/session/domain/entities/user_type.dart';
import 'package:mocktail/mocktail.dart';

class MockRemoteDataSource extends Mock implements SessionRemoteDataSource {}

class MockTokenStorage extends Mock implements TokenStorage {}

class MockFirebaseAuthService extends Mock implements FirebaseAuthService {}

void main() {
  late MockRemoteDataSource remote;
  late MockTokenStorage tokenStorage;
  late MockFirebaseAuthService firebaseAuth;
  late SessionRepositoryImpl repository;

  setUp(() {
    remote = MockRemoteDataSource();
    tokenStorage = MockTokenStorage();
    firebaseAuth = MockFirebaseAuthService();
    repository = SessionRepositoryImpl(remote, tokenStorage, firebaseAuth);
  });

  group('SessionRepositoryImpl.restore', () {
    test('returns AuthFailure when no tokens exist in storage', () async {
      when(() => tokenStorage.readAccessToken()).thenAnswer((_) async => null);
      when(() => tokenStorage.readRefreshToken()).thenAnswer((_) async => null);

      final result = await repository.restore();

      expect(result.getLeft().toNullable(), isA<AuthFailure>());
      verifyNever(() => remote.getMe());
      verifyNever(() => tokenStorage.clear());
    });

    test('returns Principal and Capabilities when getMe succeeds', () async {
      when(
        () => tokenStorage.readAccessToken(),
      ).thenAnswer((_) async => 'valid-access-token');
      when(
        () => tokenStorage.readRefreshToken(),
      ).thenAnswer((_) async => 'valid-refresh-token');

      final json = {
        'user': {
          'id': 1,
          'email': 'test@example.com',
          'user_type': 'member',
          'status': 'active',
          'created_at': '2026-01-01T00:00:00Z',
          'updated_at': '2026-01-01T00:00:00Z',
        },
        'principal': {
          'user_id': 1,
          'user_type': 'member',
          'role': 'member',
          'permissions': ['workout.read'],
        },
        'profile': {
          'id': 1,
          'user_id': 1,
          'membership_number': 'M001',
          'first_name': 'Test',
          'last_name': 'User',
        },
      };
      final meResponse = api.standardSerializers.deserializeWith(
        api.MeResponse.serializer,
        json,
      )!;
      when(() => remote.getMe()).thenAnswer((_) async => meResponse);

      final result = await repository.restore();

      expect(result.isRight(), isTrue);
      final (principal, capabilities) = result.getOrElse(
        (_) => throw Exception(),
      );
      expect(principal.userId, '1');
      expect(principal.userType, UserType.member);
      expect(capabilities.can('workout.read'), isTrue);
      verifyNever(() => tokenStorage.clear());
    });

    test(
      'retains token storage and does NOT clear tokens on NetworkFailure',
      () async {
        when(
          () => tokenStorage.readAccessToken(),
        ).thenAnswer((_) async => 'valid-access-token');
        when(
          () => tokenStorage.readRefreshToken(),
        ).thenAnswer((_) async => 'valid-refresh-token');

        when(() => remote.getMe()).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/auth/me'),
            type: DioExceptionType.connectionError,
            error: 'No internet connection',
          ),
        );

        final result = await repository.restore();

        expect(result.isLeft(), isTrue);
        expect(result.getLeft().toNullable(), isA<NetworkFailure>());
        // Crucial assertion: token storage must NOT be cleared on network loss!
        verifyNever(() => tokenStorage.clear());
      },
    );

    test(
      'clears token storage when getMe fails with AuthFailure (401)',
      () async {
        when(
          () => tokenStorage.readAccessToken(),
        ).thenAnswer((_) async => 'stale-access-token');
        when(
          () => tokenStorage.readRefreshToken(),
        ).thenAnswer((_) async => 'stale-refresh-token');
        when(() => tokenStorage.clear()).thenAnswer((_) async {});

        when(() => remote.getMe()).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/auth/me'),
            response: Response(
              requestOptions: RequestOptions(path: '/auth/me'),
              statusCode: 401,
            ),
            type: DioExceptionType.badResponse,
          ),
        );

        final result = await repository.restore();

        expect(result.isLeft(), isTrue);
        expect(result.getLeft().toNullable(), isA<AuthFailure>());
        verify(() => tokenStorage.clear()).called(1);
      },
    );

    test(
      'does NOT clear tokens a login stored while restore was running',
      () async {
        var reads = 0;
        when(
          () => tokenStorage.readAccessToken(),
        ).thenAnswer((_) async => reads++ < 2 ? 'old-access' : 'new-access');
        when(
          () => tokenStorage.readRefreshToken(),
        ).thenAnswer((_) async => reads < 2 ? 'old-refresh' : 'new-refresh');
        when(() => tokenStorage.clear()).thenAnswer((_) async {});
        when(() => remote.getMe()).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/auth/me'),
            response: Response(
              requestOptions: RequestOptions(path: '/auth/me'),
              statusCode: 401,
            ),
            type: DioExceptionType.badResponse,
          ),
        );

        final result = await repository.restore();

        expect(result.getLeft().toNullable(), isA<AuthFailure>());
        verifyNever(() => tokenStorage.clear());
      },
    );
  });
}
