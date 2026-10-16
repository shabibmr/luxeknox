import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:fpdart/fpdart.dart';
import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/core/presentation/load_status.dart';
import 'package:luxeknox/core/usecase/usecase.dart';
import 'package:luxeknox/features/accounting/presentation/cubit/accounting_home_cubit.dart';
import 'package:luxeknox/features/dashboard/domain/usecases/get_dashboard_usecase.dart';
import 'package:luxeknox/features/dashboard/presentation/cubit/dashboard_agenda_cubit.dart';
import 'package:luxeknox/features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:luxeknox/features/scheduling/domain/usecases/schedule_usecases.dart';
import 'package:mocktail/mocktail.dart';
import 'package:luxeknox/core/di/injector.dart';
import 'package:luxeknox/core/router/app_router.dart';
import 'package:luxeknox/core/router/routes.dart';
import 'package:luxeknox/features/accounting/presentation/accounting_strings.dart';
import 'package:luxeknox/session/domain/entities/capabilities.dart';
import 'package:luxeknox/session/domain/entities/principal.dart';
import 'package:luxeknox/session/domain/entities/user_type.dart';
import 'package:luxeknox/session/presentation/session_cubit.dart';

class MockGetDashboardUseCase extends Mock implements GetDashboardUseCase {}

class MockListSchedulesUseCase extends Mock implements ListSchedulesUseCase {}

class MockAccountingHomeCubit extends MockCubit<AccountingHomeState>
    implements AccountingHomeCubit {}

class MockSessionCubit extends MockCubit<SessionState>
    implements SessionCubit {}

/// Confirms the item routes resolve through the real admin router.
void main() {
  const admin = Principal(
    userId: '1',
    userType: UserType.admin,
    displayName: 'Admin',
    profileId: 'p1',
  );

  setUpAll(() => registerFallbackValue(const ListSchedulesParams()));

  setUp(() {
    final dashboard = MockGetDashboardUseCase();
    when(
      () => dashboard(const NoParams()),
    ).thenAnswer((_) async => const Left(NetworkFailure()));
    getIt.registerFactory<DashboardCubit>(() => DashboardCubit(dashboard));
    final schedules = MockListSchedulesUseCase();
    when(
      () => schedules(any()),
    ).thenAnswer((_) async => const Left(NetworkFailure()));
    getIt.registerFactory<DashboardAgendaCubit>(
      () => DashboardAgendaCubit(schedules),
    );
    final home = MockAccountingHomeCubit();
    when(() => home.load()).thenAnswer((_) async {});
    when(
      () => home.state,
    ).thenReturn(const AccountingHomeState(status: LoadStatus.loading));
    getIt.registerFactory<AccountingHomeCubit>(() => home);
  });

  tearDown(() => getIt.reset());

  Future<_H> pump(WidgetTester tester, List<String> slugs) async {
    final session = MockSessionCubit();
    whenListen(
      session,
      const Stream<SessionState>.empty(),
      initialState: SessionAuthenticated(
        principal: admin,
        capabilities: Capabilities(slugs: slugs),
      ),
    );
    getIt.registerSingleton<SessionCubit>(session);
    final router = createRouter(session);
    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: router,
        builder: (context, child) =>
            BlocProvider<SessionCubit>.value(value: session, child: child!),
      ),
    );
    await tester.pumpAndSettle();
    return _H(router);
  }

  testWidgets('deep link /items/5 opens the detail screen', (tester) async {
    final h = await pump(tester, ['inventory.read']);
    h.router.go(Routes.adminAccountingItemById('5'));
    await tester.pumpAndSettle();
    expect(find.text(AccountingStrings.itemDetailTitle), findsOneWidget);
  });

  testWidgets('create is not swallowed by :id', (tester) async {
    final h = await pump(tester, [
      'inventory.read',
      'accounting.accounts_write',
    ]);
    h.router.go(Routes.adminAccountingItemsCreate);
    await tester.pumpAndSettle();
    expect(find.text(AccountingStrings.createItemTitle), findsOneWidget);
  });

  testWidgets('edit route opens the form in edit mode', (tester) async {
    final h = await pump(tester, [
      'inventory.read',
      'accounting.accounts_write',
    ]);
    h.router.go(Routes.adminAccountingItemEditById('5'));
    await tester.pumpAndSettle();
    expect(find.text(AccountingStrings.editItemTitle), findsOneWidget);
  });

  testWidgets('list route opens the list screen', (tester) async {
    final h = await pump(tester, ['inventory.read']);
    h.router.go(Routes.adminAccountingItems);
    await tester.pumpAndSettle();
    expect(find.text(AccountingStrings.itemsTitle), findsOneWidget);
  });
}

class _H {
  _H(this.router);
  final GoRouter router;
}
