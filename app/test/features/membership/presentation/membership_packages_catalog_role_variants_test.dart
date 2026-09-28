import 'package:luxeknox/core/di/injector.dart';
import 'package:luxeknox/core/presentation/load_status.dart';
import 'package:luxeknox/features/membership/domain/entities/membership_product.dart';
import 'package:luxeknox/features/membership/presentation/cubit/membership_packages_catalog_cubit.dart';
import 'package:luxeknox/features/membership/presentation/screens/membership_packages_catalog_screen.dart';
import 'package:luxeknox/session/domain/entities/capabilities.dart';
import 'package:luxeknox/session/domain/entities/principal.dart';
import 'package:luxeknox/session/domain/entities/user_type.dart';
import 'package:luxeknox/session/presentation/session_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockMembershipPackagesCatalogCubit
    extends MockCubit<MembershipPackagesCatalogState>
    implements MembershipPackagesCatalogCubit {}

class MockSessionCubit extends MockCubit<SessionState> implements SessionCubit {}

/// ADR-0006 §11 — catalog create follows `memberships.create` and row
/// update follows `memberships.update`, for member, trainer, and admin.
void main() {
  const product = MembershipProduct(
    id: '10',
    name: 'Gold',
    code: 'GOLD',
    durationDays: 30,
    basePrice: '99.00',
    isActive: true,
  );

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

  const readOnly = Capabilities(slugs: ['memberships.read']);

  setUp(() {
    final cubit = MockMembershipPackagesCatalogCubit();
    when(() => cubit.load()).thenAnswer((_) async {});
    whenListen(
      cubit,
      const Stream<MembershipPackagesCatalogState>.empty(),
      initialState: const MembershipPackagesCatalogState(
        status: LoadStatus.success,
        items: [product],
      ),
    );
    getIt.registerFactory<MembershipPackagesCatalogCubit>(() => cubit);
  });

  tearDown(() => getIt.reset());

  Widget wrap(Principal principal, Capabilities capabilities) {
    final sessionCubit = MockSessionCubit();
    whenListen(
      sessionCubit,
      const Stream<SessionState>.empty(),
      initialState: SessionAuthenticated(
        principal: principal,
        capabilities: capabilities,
      ),
    );
    return MaterialApp(
      home: BlocProvider<SessionCubit>.value(
        value: sessionCubit,
        child: const MembershipPackagesCatalogScreen(),
      ),
    );
  }

  Future<void> expectControls(
    WidgetTester tester, {
    required bool canCreate,
    required bool canUpdate,
  }) async {
    expect(find.byIcon(Icons.add), canCreate ? findsOneWidget : findsNothing);
    expect(find.text('Gold'), findsOneWidget);
    final tile = tester.widget<ListTile>(find.byType(ListTile));
    if (canUpdate) {
      expect(tile.onTap, isNotNull);
    } else {
      expect(tile.onTap, isNull);
    }
  }

  testWidgets('member sees browse only', (tester) async {
    await tester.pumpWidget(wrap(memberPrincipal, readOnly));
    await tester.pumpAndSettle();

    await expectControls(tester, canCreate: false, canUpdate: false);
  });

  testWidgets('trainer sees browse only', (tester) async {
    await tester.pumpWidget(wrap(trainerPrincipal, readOnly));
    await tester.pumpAndSettle();

    await expectControls(tester, canCreate: false, canUpdate: false);
  });

  testWidgets('admin with create and update sees both controls', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(
        adminPrincipal,
        const Capabilities(
          slugs: [
            'memberships.read',
            'memberships.create',
            'memberships.update',
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();

    await expectControls(tester, canCreate: true, canUpdate: true);
  });

  testWidgets('memberships.create alone shows add but not row edit', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(
        adminPrincipal,
        const Capabilities(slugs: ['memberships.read', 'memberships.create']),
      ),
    );
    await tester.pumpAndSettle();

    await expectControls(tester, canCreate: true, canUpdate: false);
  });

  testWidgets('memberships.update alone shows row edit but not add', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(
        adminPrincipal,
        const Capabilities(slugs: ['memberships.read', 'memberships.update']),
      ),
    );
    await tester.pumpAndSettle();

    await expectControls(tester, canCreate: false, canUpdate: true);
  });
}
