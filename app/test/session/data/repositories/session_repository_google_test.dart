import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/core/storage/token_storage.dart';
import 'package:luxeknox/features/auth/data/services/firebase_auth_service.dart';
import 'package:luxeknox/session/data/datasources/session_remote_datasource.dart';
import 'package:luxeknox/session/data/repositories/session_repository_impl.dart';
import 'package:mocktail/mocktail.dart';

class MockRemoteDataSource extends Mock implements SessionRemoteDataSource {}

class MockTokenStorage extends Mock implements TokenStorage {}

class MockFirebaseAuthService extends Mock implements FirebaseAuthService {}

class MockUserCredential extends Mock implements UserCredential {}

class MockUser extends Mock implements User {}

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

  group('loginWithGoogle', () {
    test('returns CancelledFailure without touching the backend', () async {
      when(() => firebaseAuth.signInWithGoogle()).thenAnswer((_) async => null);

      final result = await repository.loginWithGoogle();

      expect(result.getLeft().toNullable(), isA<CancelledFailure>());
      verifyNever(() => remote.loginWithFirebase(any()));
    });

    test(
      'signs out of Firebase when the backend rejects the account',
      () async {
        final user = MockUser();
        final credential = MockUserCredential();
        when(() => credential.user).thenReturn(user);
        when(() => user.getIdToken()).thenAnswer((_) async => 'id-token');
        when(
          () => firebaseAuth.signInWithGoogle(),
        ).thenAnswer((_) async => credential);
        when(() => firebaseAuth.signOut()).thenAnswer((_) async {});
        when(() => remote.loginWithFirebase('id-token')).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/auth/firebase'),
            response: Response(
              requestOptions: RequestOptions(path: '/auth/firebase'),
              statusCode: 401,
            ),
            type: DioExceptionType.badResponse,
          ),
        );

        final result = await repository.loginWithGoogle();

        expect(result.getLeft().toNullable(), isA<AuthFailure>());
        verify(() => firebaseAuth.signOut()).called(1);
        verifyNever(() => tokenStorage.writeAccessToken(any()));
      },
    );

    test(
      'signs out and returns UnknownFailure when Firebase gives no ID token',
      () async {
        final user = MockUser();
        final credential = MockUserCredential();
        when(() => credential.user).thenReturn(user);
        when(() => user.getIdToken()).thenAnswer((_) async => null);
        when(
          () => firebaseAuth.signInWithGoogle(),
        ).thenAnswer((_) async => credential);
        when(() => firebaseAuth.signOut()).thenAnswer((_) async {});

        final result = await repository.loginWithGoogle();

        expect(result.getLeft().toNullable(), isA<UnknownFailure>());
        verify(() => firebaseAuth.signOut()).called(1);
        verifyNever(() => remote.loginWithFirebase(any()));
      },
    );
  });
}
