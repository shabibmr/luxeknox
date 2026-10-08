import 'package:api_client/api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

import '../../session/domain/usecases/refresh_session_usecase.dart';
import '../../session/presentation/session_cubit.dart';
import '../config/app_config.dart';
import '../config/app_config_bootstrap.dart';
import '../network/dio_client.dart';
import '../router/app_router.dart';
import '../storage/token_storage.dart';
import '../usecase/usecase.dart';

@module
abstract class RegisterModule {
  @singleton
  AppConfig get appConfig => AppConfigBootstrap.resolved ?? AppConfig.fromEnv();

  @singleton
  FlutterSecureStorage get secureStorage => const FlutterSecureStorage();

  @singleton
  TokenStorage tokenStorage(FlutterSecureStorage storage) =>
      TokenStorage(storage: storage);

  @lazySingleton
  Dio dio(AppConfig config, TokenStorage tokenStorage) {
    return configureDioClient(
      config: config,
      tokenStorage: tokenStorage,
      onRefreshToken: () =>
          GetIt.instance<RefreshSessionUseCase>()(const NoParams()),
      onSignedOut: () => GetIt.instance<SessionCubit>().onSignedOut(),
    );
  }

  @lazySingleton
  AUTHApi authApi(Dio dio) => AUTHApi(dio, standardSerializers);

  @lazySingleton
  WORKApi workApi(Dio dio) => WORKApi(dio, standardSerializers);

  @lazySingleton
  DIETApi dietApi(Dio dio) => DIETApi(dio, standardSerializers);

  @lazySingleton
  PEOPLEApi peopleApi(Dio dio) => PEOPLEApi(dio, standardSerializers);

  @lazySingleton
  HEALTHApi healthApi(Dio dio) => HEALTHApi(dio, standardSerializers);

  @lazySingleton
  MEDIAApi mediaApi(Dio dio) => MEDIAApi(dio, standardSerializers);

  @lazySingleton
  MEMBApi membApi(Dio dio) => MEMBApi(dio, standardSerializers);

  @lazySingleton
  PTApi ptApi(Dio dio) => PTApi(dio, standardSerializers);

  @lazySingleton
  DASHApi dashApi(Dio dio) => DASHApi(dio, standardSerializers);

  @lazySingleton
  SCHEDApi schedApi(Dio dio) => SCHEDApi(dio, standardSerializers);

  @lazySingleton
  ATTNApi attnApi(Dio dio) => ATTNApi(dio, standardSerializers);

  @lazySingleton
  PAYApi payApi(Dio dio) => PAYApi(dio, standardSerializers);

  @lazySingleton
  RPTApi rptApi(Dio dio) => RPTApi(dio, standardSerializers);

  @lazySingleton
  GOALApi goalApi(Dio dio) => GOALApi(dio, standardSerializers);

  @lazySingleton
  NOTIFApi notifApi(Dio dio) => NOTIFApi(dio, standardSerializers);

  @lazySingleton
  SYSApi sysApi(Dio dio) => SYSApi(dio, standardSerializers);

  @lazySingleton
  RBACApi rbacApi(Dio dio) => RBACApi(dio, standardSerializers);

  @singleton
  GoRouter router(SessionCubit session) => createRouter(session);
}
