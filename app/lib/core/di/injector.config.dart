// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:api_client/api_client.dart' as _i633;
import 'package:dio/dio.dart' as _i361;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:go_router/go_router.dart' as _i583;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/auth/presentation/cubit/login_cubit.dart' as _i69;
import '../../features/exercises/data/datasources/exercise_remote_datasource.dart'
    as _i100;
import '../../features/exercises/data/repositories/exercise_repository_impl.dart'
    as _i340;
import '../../features/exercises/domain/repositories/exercise_repository.dart'
    as _i275;
import '../../features/exercises/domain/usecases/create_exercise_usecase.dart'
    as _i1062;
import '../../features/exercises/domain/usecases/deactivate_exercise_usecase.dart'
    as _i708;
import '../../features/exercises/domain/usecases/get_exercise_usecase.dart'
    as _i1031;
import '../../features/exercises/domain/usecases/get_exercises_usecase.dart'
    as _i870;
import '../../features/exercises/domain/usecases/update_exercise_usecase.dart'
    as _i790;
import '../../features/exercises/presentation/bloc/exercise_list_bloc.dart'
    as _i757;
import '../../features/exercises/presentation/cubit/exercise_detail_cubit.dart'
    as _i756;
import '../../session/data/datasources/session_remote_datasource.dart' as _i963;
import '../../session/data/repositories/session_repository_impl.dart' as _i803;
import '../../session/domain/repositories/session_repository.dart' as _i158;
import '../../session/domain/usecases/get_me_usecase.dart' as _i852;
import '../../session/domain/usecases/login_usecase.dart' as _i1059;
import '../../session/domain/usecases/logout_usecase.dart' as _i2;
import '../../session/domain/usecases/refresh_session_usecase.dart' as _i898;
import '../../session/domain/usecases/restore_session_usecase.dart' as _i123;
import '../../session/presentation/session_cubit.dart' as _i893;
import '../config/app_config.dart' as _i650;
import '../monitoring/crash_reporter.dart' as _i668;
import '../storage/token_storage.dart' as _i973;
import 'register_module.dart' as _i291;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    gh.singleton<_i650.AppConfig>(() => registerModule.appConfig);
    gh.singleton<_i558.FlutterSecureStorage>(
      () => registerModule.secureStorage,
    );
    gh.lazySingleton<_i668.CrashReporter>(
      () => const _i668.NoOpCrashReporter(),
    );
    gh.singleton<_i973.TokenStorage>(
      () => registerModule.tokenStorage(gh<_i558.FlutterSecureStorage>()),
    );
    gh.singleton<_i361.Dio>(
      () => registerModule.dio(gh<_i650.AppConfig>(), gh<_i973.TokenStorage>()),
    );
    gh.singleton<_i633.AUTHApi>(() => registerModule.authApi(gh<_i361.Dio>()));
    gh.singleton<_i633.WORKApi>(() => registerModule.workApi(gh<_i361.Dio>()));
    gh.lazySingleton<_i963.SessionRemoteDataSource>(
      () => _i963.SessionRemoteDataSourceImpl(gh<_i633.AUTHApi>()),
    );
    gh.lazySingleton<_i100.ExerciseRemoteDataSource>(
      () => _i100.ExerciseRemoteDataSourceImpl(gh<_i633.WORKApi>()),
    );
    gh.lazySingleton<_i158.SessionRepository>(
      () => _i803.SessionRepositoryImpl(
        gh<_i963.SessionRemoteDataSource>(),
        gh<_i973.TokenStorage>(),
      ),
    );
    gh.lazySingleton<_i852.GetMeUseCase>(
      () => _i852.GetMeUseCase(gh<_i158.SessionRepository>()),
    );
    gh.lazySingleton<_i1059.LoginUseCase>(
      () => _i1059.LoginUseCase(gh<_i158.SessionRepository>()),
    );
    gh.lazySingleton<_i2.LogoutUseCase>(
      () => _i2.LogoutUseCase(gh<_i158.SessionRepository>()),
    );
    gh.lazySingleton<_i898.RefreshSessionUseCase>(
      () => _i898.RefreshSessionUseCase(gh<_i158.SessionRepository>()),
    );
    gh.lazySingleton<_i123.RestoreSessionUseCase>(
      () => _i123.RestoreSessionUseCase(gh<_i158.SessionRepository>()),
    );
    gh.singleton<_i893.SessionCubit>(
      () => _i893.SessionCubit(
        restoreSessionUseCase: gh<_i123.RestoreSessionUseCase>(),
        loginUseCase: gh<_i1059.LoginUseCase>(),
        logoutUseCase: gh<_i2.LogoutUseCase>(),
      ),
    );
    gh.lazySingleton<_i275.ExerciseRepository>(
      () => _i340.ExerciseRepositoryImpl(gh<_i100.ExerciseRemoteDataSource>()),
    );
    gh.singleton<_i583.GoRouter>(
      () => registerModule.router(gh<_i893.SessionCubit>()),
    );
    gh.lazySingleton<_i1062.CreateExerciseUseCase>(
      () => _i1062.CreateExerciseUseCase(gh<_i275.ExerciseRepository>()),
    );
    gh.lazySingleton<_i708.DeactivateExerciseUseCase>(
      () => _i708.DeactivateExerciseUseCase(gh<_i275.ExerciseRepository>()),
    );
    gh.lazySingleton<_i1031.GetExerciseUseCase>(
      () => _i1031.GetExerciseUseCase(gh<_i275.ExerciseRepository>()),
    );
    gh.lazySingleton<_i870.GetExercisesUseCase>(
      () => _i870.GetExercisesUseCase(gh<_i275.ExerciseRepository>()),
    );
    gh.lazySingleton<_i790.UpdateExerciseUseCase>(
      () => _i790.UpdateExerciseUseCase(gh<_i275.ExerciseRepository>()),
    );
    gh.factory<_i69.LoginCubit>(
      () => _i69.LoginCubit(gh<_i893.SessionCubit>()),
    );
    gh.factory<_i756.ExerciseDetailCubit>(
      () => _i756.ExerciseDetailCubit(gh<_i1031.GetExerciseUseCase>()),
    );
    gh.factory<_i757.ExerciseListBloc>(
      () => _i757.ExerciseListBloc(
        getExercisesUseCase: gh<_i870.GetExercisesUseCase>(),
      ),
    );
    return this;
  }
}

class _$RegisterModule extends _i291.RegisterModule {}
