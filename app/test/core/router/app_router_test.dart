import 'package:app/core/di/injector.dart';
import 'package:app/core/router/app_router.dart';
import 'package:app/core/router/routes.dart';
import 'package:app/features/auth/presentation/cubit/login_cubit.dart';
import 'package:app/session/domain/entities/capabilities.dart';
import 'package:app/session/domain/entities/principal.dart';
import 'package:app/session/domain/entities/user_type.dart';
import 'package:app/session/presentation/session_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

class MockSessionCubit extends MockCubit<SessionState>
    implements SessionCubit {}

void main() {
  const memberPrincipal = Principal(
    userId: '1',
    userType: UserType.member,
    displayName: 'Member One',
    profileId: 'p1',
  );
  const trainerPrincipal = Principal(
    userId: '2',
    userType: UserType.trainer,
    displayName: 'Trainer One',
    profileId: 'p2',
  );
  const adminPrincipal = Principal(
    userId: '3',
    userType: UserType.admin,
    displayName: 'Admin One',
    profileId: 'p3',
  );
  const emptyCaps = Capabilities(slugs: []);

  group('Router Redirect Logic (G3)', () {
    test('signed-out user on protected route redirects to /login', () {
      final redirect = appRedirectLogic(
        sessionState: const SessionUnauthenticated(),
        currentPath: Routes.memberHome,
      );
      expect(redirect, Routes.login);
    });

    test('signed-out user already on /login does not redirect (no loop)', () {
      final redirect = appRedirectLogic(
        sessionState: const SessionUnauthenticated(),
        currentPath: Routes.login,
      );
      expect(redirect, isNull);
    });

    test('unknown session on /login redirects to /splash', () {
      final redirect = appRedirectLogic(
        sessionState: const SessionUnknown(),
        currentPath: Routes.login,
      );
      expect(redirect, Routes.splash);
    });

    test('unknown session on /splash does not redirect (no loop)', () {
      final redirect = appRedirectLogic(
        sessionState: const SessionUnknown(),
        currentPath: Routes.splash,
      );
      expect(redirect, isNull);
    });

    test('signed-in member on /login redirects to /home', () {
      final redirect = appRedirectLogic(
        sessionState: const SessionAuthenticated(
          principal: memberPrincipal,
          capabilities: emptyCaps,
        ),
        currentPath: Routes.login,
      );
      expect(redirect, Routes.memberHome);
    });

    test('signed-in trainer on /login redirects to /trainer/home', () {
      final redirect = appRedirectLogic(
        sessionState: const SessionAuthenticated(
          principal: trainerPrincipal,
          capabilities: emptyCaps,
        ),
        currentPath: Routes.login,
      );
      expect(redirect, Routes.trainerHome);
    });

    test('signed-in admin on /login redirects to /admin/dashboard', () {
      final redirect = appRedirectLogic(
        sessionState: const SessionAuthenticated(
          principal: adminPrincipal,
          capabilities: emptyCaps,
        ),
        currentPath: Routes.login,
      );
      expect(redirect, Routes.adminDashboard);
    });

    test(
      'member accessing out-of-role route /admin/dashboard is redirected to /home',
      () {
        final redirect = appRedirectLogic(
          sessionState: const SessionAuthenticated(
            principal: memberPrincipal,
            capabilities: emptyCaps,
          ),
          currentPath: Routes.adminDashboard,
        );
        expect(redirect, Routes.memberHome);
      },
    );

    test(
      'admin accessing /admin/workout-library stays on path (no redirect)',
      () {
        final redirect = appRedirectLogic(
          sessionState: const SessionAuthenticated(
            principal: adminPrincipal,
            capabilities: emptyCaps,
          ),
          currentPath: Routes.adminWorkoutLibrary,
        );
        expect(redirect, isNull);
      },
    );
  });

  group('GoRouter redirect + loop guard (L5)', () {
    setUp(() {
      getIt.registerFactory<LoginCubit>(() => LoginCubit(MockSessionCubit()));
    });

    tearDown(() => getIt.reset());

    Future<GoRouter> pumpRouter(
      WidgetTester tester,
      SessionState initial,
    ) async {
      final sessionCubit = MockSessionCubit();
      when(() => sessionCubit.restore()).thenAnswer((_) async {});
      whenListen(
        sessionCubit,
        const Stream<SessionState>.empty(),
        initialState: initial,
      );
      final router = createRouter(sessionCubit);
      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: router,
          builder: (context, child) => BlocProvider<SessionCubit>.value(
            value: sessionCubit,
            child: child!,
          ),
        ),
      );
      if (initial is SessionUnknown) {
        await tester.pump();
      } else {
        await tester.pumpAndSettle();
      }
      return router;
    }

    testWidgets('signed-out on protected route lands on login', (tester) async {
      final router = await pumpRouter(tester, const SessionUnauthenticated());
      router.go(Routes.memberHome);
      await tester.pumpAndSettle();
      expect(router.routeInformationProvider.value.uri.path, Routes.login);
    });

    testWidgets('signed-in member on login lands on member home', (
      tester,
    ) async {
      final router = await pumpRouter(
        tester,
        const SessionAuthenticated(
          principal: memberPrincipal,
          capabilities: emptyCaps,
        ),
      );
      router.go(Routes.login);
      await tester.pumpAndSettle();
      expect(router.routeInformationProvider.value.uri.path, Routes.memberHome);
    });

    testWidgets('member cannot stay on admin path', (tester) async {
      final router = await pumpRouter(
        tester,
        const SessionAuthenticated(
          principal: memberPrincipal,
          capabilities: emptyCaps,
        ),
      );
      router.go(Routes.adminDashboard);
      await tester.pumpAndSettle();
      expect(router.routeInformationProvider.value.uri.path, Routes.memberHome);
    });

    testWidgets('unauthenticated on login does not loop', (tester) async {
      final router = await pumpRouter(tester, const SessionUnauthenticated());
      router.go(Routes.login);
      await tester.pumpAndSettle();
      expect(router.routeInformationProvider.value.uri.path, Routes.login);
      // Second navigation to login stays put (no redirect oscillation).
      router.go(Routes.login);
      await tester.pumpAndSettle();
      expect(router.routeInformationProvider.value.uri.path, Routes.login);
    });

    testWidgets('unknown session stays on splash without looping', (
      tester,
    ) async {
      final router = await pumpRouter(tester, const SessionUnknown());
      expect(router.routeInformationProvider.value.uri.path, Routes.splash);
      router.go(Routes.splash);
      await tester.pump();
      expect(router.routeInformationProvider.value.uri.path, Routes.splash);
    });
  });
}
