import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:luxeknox/core/di/injector.dart';
import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/core/presentation/load_status.dart';
import 'package:luxeknox/core/router/routes.dart';
import 'package:luxeknox/core/widgets/app_empty_view.dart';
import 'package:luxeknox/core/widgets/app_error_view.dart';
import 'package:luxeknox/core/widgets/app_loading.dart';
import 'package:luxeknox/features/accounting/domain/entities/vendor.dart';
import 'package:luxeknox/features/accounting/presentation/accounting_strings.dart';
import 'package:luxeknox/features/accounting/presentation/cubit/vendors_cubit.dart';
import 'package:luxeknox/features/accounting/presentation/screens/vendors_list_screen.dart';
import 'package:luxeknox/session/domain/entities/capabilities.dart';
import 'package:luxeknox/session/domain/entities/principal.dart';
import 'package:luxeknox/session/domain/entities/user_type.dart';
import 'package:luxeknox/session/presentation/session_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockVendorsCubit extends MockCubit<VendorsState>
    implements VendorsCubit {}

class MockSessionCubit extends MockCubit<SessionState>
    implements SessionCubit {}

void main() {
  late MockVendorsCubit mockVendorsCubit;
  late MockSessionCubit mockSessionCubit;

  const tVendor1 = Vendor(
    id: 'v-1',
    name: 'Acme Fitness Equipments',
    phone: '+1 555-0100',
    contactEmail: 'contact@acme.com',
    taxNumber: '29ABCDE1234F1Z5',
    isActive: true,
  );

  const tVendor2 = Vendor(
    id: 'v-2',
    name: 'Beverage Suppliers Ltd',
    phone: '+1 555-0200',
    contactEmail: 'orders@beverages.com',
    taxNumber: '27AAACU9876P1Z3',
    isActive: false,
  );

  const writeCapabilities = Capabilities(
    slugs: ['accounting.read', 'accounting.vendors_write'],
  );
  const readOnlyCapabilities = Capabilities(
    slugs: ['accounting.read'],
  );
  const noCapabilities = Capabilities(
    slugs: [],
  );

  const tPrincipal = Principal(
    userId: 'u1',
    userType: UserType.admin,
    displayName: 'Admin User',
    profileId: 'p1',
  );

  setUp(() {
    mockVendorsCubit = MockVendorsCubit();
    mockSessionCubit = MockSessionCubit();

    when(() => mockVendorsCubit.load(
          refresh: any(named: 'refresh'),
          search: any(named: 'search'),
          isActive: any(named: 'isActive'),
          clearSearch: any(named: 'clearSearch'),
          clearActiveFilter: any(named: 'clearActiveFilter'),
        )).thenAnswer((_) async {});
    when(() => mockVendorsCubit.searchVendors(any())).thenReturn(null);
    when(() => mockVendorsCubit.filterByActive(any()))
        .thenAnswer((_) async {});

    if (getIt.isRegistered<VendorsCubit>()) {
      getIt.unregister<VendorsCubit>();
    }
    getIt.registerFactory<VendorsCubit>(() => mockVendorsCubit);
  });

  tearDown(() {
    if (getIt.isRegistered<VendorsCubit>()) {
      getIt.unregister<VendorsCubit>();
    }
  });

  Widget buildTestableWidget({
    Capabilities capabilities = writeCapabilities,
    VendorsState state = const VendorsState(
      status: LoadStatus.success,
      hasReachedMax: true,
    ),
  }) {
    whenListen(
      mockSessionCubit,
      const Stream<SessionState>.empty(),
      initialState: SessionAuthenticated(
        principal: tPrincipal,
        capabilities: capabilities,
      ),
    );

    whenListen(
      mockVendorsCubit,
      const Stream<VendorsState>.empty(),
      initialState: state,
    );

    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, routerState) => BlocProvider<SessionCubit>.value(
            value: mockSessionCubit,
            child: VendorsListScreen(cubit: mockVendorsCubit),
          ),
        ),
        GoRoute(
          path: Routes.adminAccountingVendorsCreate,
          builder: (context, routerState) =>
              const Scaffold(body: Text('Create Vendor Destination')),
        ),
        GoRoute(
          path: Routes.adminAccountingVendorsEdit,
          builder: (context, routerState) => Scaffold(
            body: Text(
              'Edit Vendor Destination ${routerState.pathParameters['id']}',
            ),
          ),
        ),
      ],
    );

    return MaterialApp.router(routerConfig: router);
  }

  group('Permission check', () {
    testWidgets('shows noPermission when user lacks accounting.read',
        (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          capabilities: noCapabilities,
        ),
      );

      expect(find.text(AccountingStrings.noPermission), findsOneWidget);
      expect(find.byKey(const Key('vendor_search_field')), findsNothing);
    });
  });

  group('Loading, Error, and Empty states', () {
    testWidgets('displays AppLoading when status is loading and list is empty',
        (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          state: const VendorsState(status: LoadStatus.loading),
        ),
      );

      expect(find.byType(AppLoading), findsOneWidget);
    });

    testWidgets('displays AppErrorView when status is failure', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          state: const VendorsState(
            status: LoadStatus.failure,
            failure: BusinessRuleFailure('Could not load vendors'),
          ),
        ),
      );

      expect(find.byType(AppErrorView), findsOneWidget);
    });

    testWidgets('displays AppEmptyView when vendors list is empty',
        (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          state: const VendorsState(
            status: LoadStatus.success,
            vendors: [],
          ),
        ),
      );

      expect(find.byType(AppEmptyView), findsOneWidget);
      expect(find.text(AccountingStrings.noneFound), findsOneWidget);
    });
  });

  group('List content and actions', () {
    testWidgets('renders vendors with name, phone, email, gstin, and status badge',
        (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          state: const VendorsState(
            status: LoadStatus.success,
            vendors: [tVendor1, tVendor2],
          ),
        ),
      );

      expect(find.text('Acme Fitness Equipments'), findsOneWidget);
      expect(find.text('+1 555-0100'), findsOneWidget);
      expect(find.text('contact@acme.com'), findsOneWidget);
      expect(find.text('${AccountingStrings.gstinLabel}: 29ABCDE1234F1Z5'),
          findsOneWidget);
      expect(find.byKey(const Key('vendor_status_chip_v-1')), findsOneWidget);

      expect(find.text('Beverage Suppliers Ltd'), findsOneWidget);
      expect(find.text('+1 555-0200'), findsOneWidget);
      expect(find.text('orders@beverages.com'), findsOneWidget);
      expect(find.text('${AccountingStrings.gstinLabel}: 27AAACU9876P1Z3'),
          findsOneWidget);
      expect(find.byKey(const Key('vendor_status_chip_v-2')), findsOneWidget);
    });

    testWidgets('entering query in search field calls searchVendors',
        (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          state: const VendorsState(
            status: LoadStatus.success,
            vendors: [tVendor1],
          ),
        ),
      );

      final searchField = find.byKey(const Key('vendor_search_field'));
      expect(searchField, findsOneWidget);

      await tester.enterText(searchField, 'Acme');
      verify(() => mockVendorsCubit.searchVendors('Acme')).called(1);
    });

    testWidgets('tapping active filter chip calls filterByActive',
        (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          state: const VendorsState(
            status: LoadStatus.success,
            vendors: [tVendor1],
          ),
        ),
      );

      final activeChip = find.byKey(const Key('vendor_active_filter_chip'));
      expect(activeChip, findsOneWidget);

      await tester.tap(activeChip);
      verify(() => mockVendorsCubit.filterByActive(true)).called(1);
    });

    testWidgets('FAB is shown when user has accounting.vendors_write',
        (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          capabilities: writeCapabilities,
          state: const VendorsState(
            status: LoadStatus.success,
            vendors: [tVendor1],
          ),
        ),
      );

      expect(find.byKey(const Key('create_vendor_fab')), findsOneWidget);
    });

    testWidgets('FAB is hidden when user lacks accounting.vendors_write',
        (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          capabilities: readOnlyCapabilities,
          state: const VendorsState(
            status: LoadStatus.success,
            vendors: [tVendor1],
          ),
        ),
      );

      expect(find.byKey(const Key('create_vendor_fab')), findsNothing);
    });

    testWidgets('FAB opens create vendor destination', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          capabilities: writeCapabilities,
          state: const VendorsState(
            status: LoadStatus.success,
            vendors: [tVendor1],
            hasReachedMax: true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('create_vendor_fab')));
      await tester.pumpAndSettle();

      expect(find.text('Create Vendor Destination'), findsOneWidget);
    });

    testWidgets('row tap opens edit vendor destination', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          capabilities: writeCapabilities,
          state: const VendorsState(
            status: LoadStatus.success,
            vendors: [tVendor1],
            hasReachedMax: true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Acme Fitness Equipments'));
      await tester.pumpAndSettle();

      expect(find.text('Edit Vendor Destination v-1'), findsOneWidget);
    });
  });
}
