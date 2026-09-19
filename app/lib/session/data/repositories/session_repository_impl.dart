import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../core/error/failures.dart';
import '../../../core/error/map_thrown.dart';
import '../../../core/storage/token_storage.dart';
import '../../domain/entities/capabilities.dart';
import '../../domain/entities/principal.dart';
import '../../domain/repositories/session_repository.dart';
import '../datasources/session_remote_datasource.dart';
import '../models/session_mapper.dart';

@LazySingleton(as: SessionRepository)
class SessionRepositoryImpl implements SessionRepository {
  SessionRepositoryImpl(this._remoteDataSource, this._tokenStorage);

  final SessionRemoteDataSource _remoteDataSource;
  final TokenStorage _tokenStorage;

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

      // If we have token credentials, try getMe()
      final meResult = await getMe();
      return meResult.fold((failure) async {
        // If access token failed (e.g. AuthFailure), attempt refresh once
        if (refreshToken != null) {
          final refreshResult = await refresh();
          return refreshResult.fold(
            (refreshFailure) => Left(refreshFailure),
            (_) => getMe(),
          );
        }
        return Left(failure);
      }, (data) => Right(data));
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }
}
