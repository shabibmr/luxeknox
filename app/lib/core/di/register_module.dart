import 'package:api_client/api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

import '../../session/domain/usecases/refresh_session_usecase.dart';
import '../../session/presentation/session_cubit.dart';
import '../config/app_config.dart';
import '../network/dio_client.dart';
import '../router/app_router.dart';
import '../storage/token_storage.dart';
import '../usecase/usecase.dart';

@module
abstract class RegisterModule {
  @singleton
  AppConfig get appConfig => AppConfig.fromEnv();

  @singleton
  FlutterSecureStorage get secureStorage => const FlutterSecureStorage();

  @singleton
  TokenStorage tokenStorage(FlutterSecureStorage storage) =>
      TokenStorage(storage: storage);

  @singleton
  Dio dio(AppConfig config, TokenStorage tokenStorage) {
    return configureDioClient(
      config: config,
      tokenStorage: tokenStorage,
      onRefreshToken: () =>
          GetIt.instance<RefreshSessionUseCase>()(const NoParams()),
      onSignedOut: () => GetIt.instance<SessionCubit>().onSignedOut(),
    );
  }

  @singleton
  AUTHApi authApi(Dio dio) => AUTHApi(dio, standardSerializers);

  @singleton
  WORKApi workApi(Dio dio) => WORKApi(dio, standardSerializers);

  @singleton
  DIETApi dietApi(Dio dio) => DIETApi(dio, standardSerializers);

  @singleton
  PEOPLEApi peopleApi(Dio dio) => PEOPLEApi(dio, standardSerializers);

  @singleton
  HEALTHApi healthApi(Dio dio) => HEALTHApi(dio, standardSerializers);

  @singleton
  MEDIAApi mediaApi(Dio dio) => MEDIAApi(dio, standardSerializers);

  @singleton
  GoRouter router(SessionCubit session) => createRouter(session);
}
