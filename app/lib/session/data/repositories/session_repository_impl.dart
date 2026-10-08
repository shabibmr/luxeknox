import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../core/error/failures.dart';
import '../../../core/error/map_thrown.dart';
import '../../../core/storage/token_storage.dart';
import '../../../features/auth/data/services/firebase_auth_service.dart';
import '../../domain/entities/capabilities.dart';
import '../../domain/entities/principal.dart';
import '../../domain/repositories/session_repository.dart';
import '../datasources/session_remote_datasource.dart';
import '../models/session_mapper.dart';

@LazySingleton(as: SessionRepository)
class SessionRepositoryImpl implements SessionRepository {
  SessionRepositoryImpl(
    this._remoteDataSource,
    this._tokenStorage,
    this._firebaseAuthService,
  );

  final SessionRemoteDataSource _remoteDataSource;
  final TokenStorage _tokenStorage;
  final FirebaseAuthService _firebaseAuthService;

  @override
  Future<Either<Failure, (Principal, Capabilities)>> login(
    String identifier,
    String password,
  ) async {
    try {
      final session = await _remoteDataSource.login(identifier, password);
      await _tokenStorage.writeAccessToken(session.accessToken);
      await _tokenStorage.writeRefreshToken(session.refreshToken);
      return Right(SessionMapper.fromSessionResponse(session));
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, (Principal, Capabilities)>> loginWithGoogle() async {
    try {
      final credential = await _firebaseAuthService.signInWithGoogle();
      if (credential == null || credential.user == null) {
        return const Left(CancelledFailure());
      }

      final idToken = await credential.user!.getIdToken();
      if (idToken == null) {
        throw StateError('Firebase returned no ID token');
      }

      final session = await _remoteDataSource.loginWithFirebase(idToken);
      await _tokenStorage.writeAccessToken(session.accessToken);
      await _tokenStorage.writeRefreshToken(session.refreshToken);
      return Right(SessionMapper.fromSessionResponse(session));
    } catch (e) {
      // Firebase may be signed in even though LuxeKnox rejected the exchange.
      // Drop that session so the next attempt starts from a clean state.
      await _discardFirebaseSession();
      if (e is FirebaseAuthException && e.code == 'network-request-failed') {
        return const Left(NetworkFailure());
      }
      return Left(mapThrownToFailure(e));
    }
  }

  Future<void> _discardFirebaseSession() async {
    try {
      await _firebaseAuthService.signOut();
    } catch (_) {
      // Best effort. The sign-in error is what the user needs to see.
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      final refreshToken = await _tokenStorage.readRefreshToken();
      if (refreshToken != null) {
        try {
          await _remoteDataSource.logout(refreshToken);
        } catch (_) {
          // Failure on remote logout should not block local clearance
        }
      }
      try {
        await _firebaseAuthService.signOut();
      } catch (_) {}
      await _tokenStorage.clear();
      return const Right(null);
    } catch (e) {
      await _tokenStorage.clear();
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> refresh() async {
    try {
      final refreshToken = await _tokenStorage.readRefreshToken();
      if (refreshToken == null) {
        return const Left(AuthFailure());
      }
      final session = await _remoteDataSource.refresh(refreshToken);
      await _tokenStorage.writeAccessToken(session.accessToken);
      await _tokenStorage.writeRefreshToken(session.refreshToken);
      return const Right(null);
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, (Principal, Capabilities)>> getMe() async {
    try {
      final me = await _remoteDataSource.getMe();
      return Right(SessionMapper.fromMeResponse(me));
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, (Principal, Capabilities)>> restore() async {
    try {
      final accessToken = await _tokenStorage.readAccessToken();
      final refreshToken = await _tokenStorage.readRefreshToken();

      if (accessToken == null && refreshToken == null) {
        return const Left(AuthFailure());
      }

      // getMe() uses Dio, which has RefreshInterceptor attached.
      // If the access token is expired, RefreshInterceptor automatically
      // triggers token refresh and retries getMe().
      final meResult = await getMe();
      return await meResult.fold(
        (failure) async {
          // Only clear stored tokens if authentication explicitly failed
          // (i.e. revoked/expired tokens), never on network or server errors.
          if (failure is AuthFailure) {
            await _tokenStorage.clear();
          }
          return Left(failure);
        },
        (data) async => Right(data),
      );
    } catch (e) {
      final failure = mapThrownToFailure(e);
      if (failure is AuthFailure) {
        await _tokenStorage.clear();
      }
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await _remoteDataSource.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      return const Right(null);
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> forgotPassword(String identifier) async {
    try {
      await _remoteDataSource.forgotPassword(identifier);
      return const Right(null);
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      await _remoteDataSource.resetPassword(
        token: token,
        newPassword: newPassword,
      );
      return const Right(null);
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }
}
