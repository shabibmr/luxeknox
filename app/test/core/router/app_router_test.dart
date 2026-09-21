import 'package:app/core/di/injector.dart';
import 'package:app/core/error/failures.dart';
import 'package:app/core/l10n/shell_strings.dart';
import 'package:app/core/router/app_router.dart';
import 'package:app/core/router/routes.dart';
import 'package:app/core/usecase/usecase.dart';
import 'package:app/core/widgets/adaptive_shell.dart';
import 'package:app/core/widgets/destination_hub_screen.dart';
import 'package:app/core/widgets/more_hub_screen.dart';
import 'package:app/core/widgets/not_found_screen.dart';
import 'package:app/core/widgets/placeholder_screen.dart';
import 'package:app/features/auth/presentation/cubit/login_cubit.dart';
import 'package:app/features/dashboard/domain/usecases/get_dashboard_usecase.dart';
import 'package:app/features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:app/session/domain/entities/capabilities.dart';
import 'package:app/session/domain/entities/principal.dart';
import 'package:app/session/domain/entities/user_type.dart';
import 'package:app/session/presentation/session_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

class MockSessionCubit extends MockCubit<SessionState>
    implements SessionCubit {}

class MockGetDashboardUseCase extends Mock implements GetDashboardUseCase {}

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
    test(
      'signed-out user on protected route redirects to /login with redirect',
      () {
        final redirect = appRedirectLogic(
          sessionState: const SessionUnauthenticated(),
          currentPath: Routes.memberHome,
        );
        expect(redirect, Routes.loginWithRedirect(Routes.memberHome));
      },
    );

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
      // DashboardScreen (now the member/trainer/admin home route) resolves
      // DashboardCubit from getIt — router-reachability tests below don't
      // care about its data, just that the route builds without crashing.
      final mockGetDashboard = MockGetDashboardUseCase();
      when(
        () => mockGetDashboard(const NoParams()),
      ).thenAnswer((_) async => const Left(NetworkFailure()));
      getIt.registerFactory<DashboardCubit>(
        () => DashboardCubit(mockGetDashboard),
      );
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

    group('trainer routing skeleton', () {
      Future<GoRouter> pumpTrainerRouter(WidgetTester tester) => pumpRouter(
        tester,
        const SessionAuthenticated(
          principal: trainerPrincipal,
          capabilities: emptyCaps,
        ),
      );

      for (final path in <String>[
        Routes.trainerHome,
        Routes.trainerSessionsToday,
        Routes.trainerNotifications,
        // Members directory/dossier, schedule stack, and workout plan screens
        // need live DI — excluded (GetIt/cubit failures cascade).
        Routes.trainerPlans,
        Routes.trainerPlansDietsCreate,
        Routes.trainerPlansDietsHistory,
        '/trainer/plans/diets/9',
        Routes.trainerProfile,
        Routes.trainerProfileEdit,
      ]) {
        testWidgets('$path is reachable and does not redirect', (tester) async {
          final router = await pumpTrainerRouter(tester);
          router.go(path);
          await tester.pumpAndSettle();
          expect(router.routeInformationProvider.value.uri.path, path);
        });
      }
    });

    group('role shells — five destinations', () {
      Future<void> pumpAtWidth(
        WidgetTester tester,
        SessionState session,
        String path, {
        double width = 390,
      }) async {
        final sessionCubit = MockSessionCubit();
        when(() => sessionCubit.restore()).thenAnswer((_) async {});
        whenListen(
          sessionCubit,
          const Stream<SessionState>.empty(),
          initialState: session,
        );
        final router = createRouter(sessionCubit);
        await tester.pumpWidget(
          MaterialApp.router(
            routerConfig: router,
            builder: (context, child) => BlocProvider<SessionCubit>.value(
              value: sessionCubit,
              child: Center(
                child: SizedBox(width: width, height: 800, child: child),
              ),
            ),
          ),
        );
        router.go(path);
        await tester.pumpAndSettle();
      }

      testWidgets('member shell has five NavigationBar destinations', (
        tester,
      ) async {
        await pumpAtWidth(
          tester,
          const SessionAuthenticated(
            principal: memberPrincipal,
            capabilities: emptyCaps,
          ),
          Routes.memberHome,
        );

        expect(find.byType(AdaptiveShell), findsOneWidget);
        expect(find.byType(NavigationBar), findsOneWidget);
        for (final label in [
          ShellStrings.home,
          ShellStrings.membership,
          ShellStrings.schedule,
          ShellStrings.progress,
          ShellStrings.profile,
        ]) {
          expect(find.text(label), findsWidgets);
        }
      });

      testWidgets('trainer shell has five NavigationBar destinations', (
        tester,
      ) async {
        await pumpAtWidth(
          tester,
          const SessionAuthenticated(
            principal: trainerPrincipal,
            capabilities: emptyCaps,
          ),
          Routes.trainerHome,
        );

        expect(find.byType(AdaptiveShell), findsOneWidget);
        expect(find.byType(NavigationBar), findsOneWidget);
        for (final label in [
          ShellStrings.home,
          ShellStrings.members,
          ShellStrings.schedule,
          ShellStrings.plans,
          ShellStrings.profile,
        ]) {
          expect(find.text(label), findsWidgets);
        }
      });

      testWidgets('admin shell has five NavigationBar destinations', (
        tester,
      ) async {
        await pumpAtWidth(
          tester,
          const SessionAuthenticated(
            principal: adminPrincipal,
            capabilities: emptyCaps,
          ),
          Routes.adminDashboard,
        );

        expect(find.byType(AdaptiveShell), findsOneWidget);
        expect(find.byType(NavigationBar), findsOneWidget);
        for (final label in [
          ShellStrings.dashboard,
          ShellStrings.members,
          ShellStrings.memberships,
          ShellStrings.payments,
          ShellStrings.more,
        ]) {
          expect(find.text(label), findsWidgets);
        }
      });

      testWidgets('admin More root overlays MoreHubScreen', (tester) async {
        await pumpAtWidth(
          tester,
          const SessionAuthenticated(
            principal: adminPrincipal,
            capabilities: emptyCaps,
          ),
          Routes.adminMore,
        );

        expect(find.byType(MoreHubScreen), findsOneWidget);
        expect(find.text(ShellStrings.workoutLibrary), findsOneWidget);
      });

      testWidgets('trainer Plans tab shows DestinationHubScreen', (
        tester,
      ) async {
        await pumpAtWidth(
          tester,
          const SessionAuthenticated(
            principal: trainerPrincipal,
            capabilities: emptyCaps,
          ),
          Routes.trainerPlans,
        );

        expect(find.byType(DestinationHubScreen), findsOneWidget);
        expect(find.text(ShellStrings.workoutLibrary), findsOneWidget);
        expect(find.text(ShellStrings.dietLibrary), findsOneWidget);
      });

      testWidgets('member shell uses NavigationRail at tablet width', (
        tester,
      ) async {
        await pumpAtWidth(
          tester,
          const SessionAuthenticated(
            principal: memberPrincipal,
            capabilities: emptyCaps,
          ),
          Routes.memberHome,
          width: AdaptiveShellBreakpoints.compact + 40,
        );

        expect(find.byType(NavigationRail), findsOneWidget);
        expect(find.byType(NavigationBar), findsNothing);
      });
    });

    group('deep links', () {
      testWidgets('parameterized member path builds and stays', (tester) async {
        final router = await pumpRouter(
          tester,
          const SessionAuthenticated(
            principal: memberPrincipal,
            capabilities: emptyCaps,
          ),
        );
        final path = Routes.memberProgressGoalById('99');
        router.go(path);
        await tester.pumpAndSettle();
        expect(router.routeInformationProvider.value.uri.path, path);
        expect(find.text(ShellStrings.memberProgressGoalDetail), findsWidgets);
      });

      testWidgets('unauthenticated deep link preserves redirect query', (
        tester,
      ) async {
        final router = await pumpRouter(tester, const SessionUnauthenticated());
        final intended = Routes.memberProgressGoalById('5');
        router.go(intended);
        await tester.pumpAndSettle();
        final uri = router.routeInformationProvider.value.uri;
        expect(uri.path, Routes.login);
        expect(uri.queryParameters[Routes.redirectQueryParam], intended);
      });

      testWidgets('authenticated on login?redirect= restores intended path', (
        tester,
      ) async {
        final router = await pumpRouter(
          tester,
          const SessionAuthenticated(
            principal: memberPrincipal,
            capabilities: emptyCaps,
          ),
        );
        final intended = Routes.memberProgressGoalById('12');
        router.go(Routes.loginWithRedirect(intended));
        await tester.pumpAndSettle();
        expect(router.routeInformationProvider.value.uri.path, intended);
      });
    });

    group('capability redirects', () {
      testWidgets('admin without memberships.create leaves create route', (
        tester,
      ) async {
        final router = await pumpRouter(
          tester,
          const SessionAuthenticated(
            principal: adminPrincipal,
            capabilities: emptyCaps,
          ),
        );
        router.go(Routes.adminMembershipsCreate);
        await tester.pumpAndSettle();
        expect(
          router.routeInformationProvider.value.uri.path,
          Routes.adminDashboard,
        );
      });

      testWidgets('admin with reports.read stays on reports deep link', (
        tester,
      ) async {
        final router = await pumpRouter(
          tester,
          const SessionAuthenticated(
            principal: adminPrincipal,
            capabilities: Capabilities(slugs: ['reports.read']),
          ),
        );
        final path = Routes.adminReportsCategory('revenue');
        router.go(path);
        await tester.pumpAndSettle();
        expect(router.routeInformationProvider.value.uri.path, path);
        expect(find.textContaining('revenue'), findsWidgets);
      });

      testWidgets('admin without reports.read leaves reports route', (
        tester,
      ) async {
        final router = await pumpRouter(
          tester,
          const SessionAuthenticated(
            principal: adminPrincipal,
            capabilities: emptyCaps,
          ),
        );
        router.go(Routes.adminReportsCategory('revenue'));
        await tester.pumpAndSettle();
        expect(
          router.routeInformationProvider.value.uri.path,
          Routes.adminDashboard,
        );
      });
    });

    group('nested-stack preservation', () {
      testWidgets('switching tabs keeps Progress nested route', (tester) async {
        final sessionCubit = MockSessionCubit();
        when(() => sessionCubit.restore()).thenAnswer((_) async {});
        whenListen(
          sessionCubit,
          const Stream<SessionState>.empty(),
          initialState: const SessionAuthenticated(
            principal: memberPrincipal,
            capabilities: emptyCaps,
          ),
        );
        final router = createRouter(sessionCubit);
        await tester.pumpWidget(
          MaterialApp.router(
            routerConfig: router,
            builder: (context, child) => BlocProvider<SessionCubit>.value(
              value: sessionCubit,
              child: Center(
                child: SizedBox(width: 390, height: 800, child: child),
              ),
            ),
          ),
        );

        final nested = Routes.memberProgressGoalById('3');
        router.go(nested);
        await tester.pumpAndSettle();
        expect(find.text(ShellStrings.memberProgressGoalDetail), findsWidgets);

        await tester.tap(find.text(ShellStrings.home).last);
        await tester.pumpAndSettle();
        expect(
          router.routeInformationProvider.value.uri.path,
          Routes.memberHome,
        );

        await tester.tap(find.text(ShellStrings.progress).last);
        await tester.pumpAndSettle();
        expect(router.routeInformationProvider.value.uri.path, nested);
        expect(find.byType(PlaceholderScreen), findsWidgets);
        expect(find.text(ShellStrings.memberProgressGoalDetail), findsWidgets);
      });
    });

    group('unknown routes', () {
      testWidgets('unmatched path shows NotFoundScreen', (tester) async {
        final router = await pumpRouter(
          tester,
          const SessionAuthenticated(
            principal: memberPrincipal,
            capabilities: emptyCaps,
          ),
        );
        router.go('/this/path/does/not/exist');
        await tester.pumpAndSettle();
        expect(find.byType(NotFoundScreen), findsOneWidget);
        expect(find.text(ShellStrings.notFoundTitle), findsOneWidget);
      });
    });
  });
}
