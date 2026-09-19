import 'package:api_client/api_client.dart';
import 'package:app/core/config/app_config.dart';
import 'package:app/core/di/injector.dart';
import 'package:app/core/network/auth_interceptor.dart';
import 'package:app/core/network/error_interceptor.dart';
import 'package:app/core/network/logging_interceptor.dart';
import 'package:app/core/network/refresh_interceptor.dart';
import 'package:app/core/storage/token_storage.dart';
import 'package:app/features/exercises/domain/usecases/get_exercises_usecase.dart';
import 'package:app/features/exercises/presentation/bloc/exercise_list_bloc.dart';
import 'package:app/session/presentation/session_cubit.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  setUp(() async {
    await getIt.reset();
  });

  tearDown(() async {
    await getIt.reset();
  });

  group('Dependency Injection bootstrap (E2 & E3)', () {
    test('configureDependencies runs with no missing-registration error', () {
      expect(configureDependencies, returnsNormally);
    });

    test(
      'getIt provides configured Dio, APIs, router, SessionCubit, and use cases',
      () {
        configureDependencies();

        expect(getIt<AppConfig>(), isA<AppConfig>());
        expect(getIt<FlutterSecureStorage>(), isA<FlutterSecureStorage>());
        expect(getIt<TokenStorage>(), isA<TokenStorage>());

        final dio = getIt<Dio>();
        expect(dio, isA<Dio>());
        // Dio's own constructor prepends an ImplyContentTypeInterceptor
        // ahead of the app-configured chain.
        final appInterceptors = dio.interceptors.skip(1).toList();
        expect(appInterceptors, hasLength(4));
        expect(appInterceptors[0], isA<AuthInterceptor>());
        expect(appInterceptors[1], isA<RefreshInterceptor>());
        expect(appInterceptors[2], isA<ErrorInterceptor>());
        expect(appInterceptors[3], isA<LoggingInterceptor>());

        expect(getIt<SessionCubit>(), isA<SessionCubit>());
        expect(getIt<GoRouter>(), isA<GoRouter>());
        expect(getIt<AUTHApi>(), isA<AUTHApi>());
        expect(getIt<WORKApi>(), isA<WORKApi>());
        expect(getIt<GetExercisesUseCase>(), isA<GetExercisesUseCase>());

        expect(identical(getIt<Dio>(), getIt<Dio>()), isTrue);
        expect(identical(getIt<SessionCubit>(), getIt<SessionCubit>()), isTrue);

        final bloc1 = getIt<ExerciseListBloc>();
        final bloc2 = getIt<ExerciseListBloc>();
        expect(identical(bloc1, bloc2), isFalse);
      },
    );
  });
}
