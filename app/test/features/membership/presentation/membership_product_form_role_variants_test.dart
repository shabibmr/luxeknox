import 'package:luxeknox/core/di/injector.dart';
import 'package:luxeknox/features/membership/domain/entities/membership_product.dart';
import 'package:luxeknox/features/membership/presentation/cubit/membership_product_form_cubit.dart';
import 'package:luxeknox/features/membership/presentation/membership_strings.dart';
import 'package:luxeknox/features/membership/presentation/screens/membership_product_form_screen.dart';
import 'package:luxeknox/session/domain/entities/capabilities.dart';
import 'package:luxeknox/session/domain/entities/principal.dart';
import 'package:luxeknox/session/domain/entities/user_type.dart';
import 'package:luxeknox/session/presentation/session_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class MockMembershipProductFormCubit extends MockCubit<MembershipProductFormState>
    implements MembershipProductFormCubit {}

class MockSessionCubit extends MockCubit<SessionState> implements SessionCubit {}

/// ADR-0006 §11 — the product form follows `memberships.create` when adding
/// and `memberships.update` when editing, for member, trainer, and admin.
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

  setUp(() {
    final cubit = MockMembershipProductFormCubit();
    whenListen(
      cubit,
      const Stream<MembershipProductFormState>.empty(),
      initialState: const MembershipProductFormState(),
    );
    getIt.registerFactory<MembershipProductFormCubit>(() => cubit);
  });

  tearDown(() => getIt.reset());

  Widget wrap(
    Principal principal,
    Capabilities capabilities, {
    MembershipProduct? product,
  }) {
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
        child: MembershipProductFormScreen(product: product),
      ),
    );
  }

  void expectForm(WidgetTester tester, {required bool allowed}) {
    if (allowed) {
      expect(find.text(MembershipStrings.noPermission), findsNothing);
      expect(
        find.text(MembershipStrings.save, skipOffstage: false),
        findsOneWidget,
      );
      expect(find.text(MembershipStrings.nameLabel), findsOneWidget);
    } else {
      expect(find.text(MembershipStrings.noPermission), findsOneWidget);
      expect(
        find.text(MembershipStrings.save, skipOffstage: false),
        findsNothing,
      );
    }
  }

  testWidgets('member cannot open the create form', (tester) async {
    await tester.pumpWidget(
      wrap(memberPrincipal, const Capabilities(slugs: ['memberships.read'])),
    );
    await tester.pumpAndSettle();

    expectForm(tester, allowed: false);
  });

  testWidgets('trainer cannot open the create form', (tester) async {
    await tester.pumpWidget(
      wrap(trainerPrincipal, const Capabilities(slugs: ['memberships.read'])),
    );
    await tester.pumpAndSettle();

    expectForm(tester, allowed: false);
  });

  testWidgets('admin with memberships.create sees the create form', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(
        adminPrincipal,
        const Capabilities(slugs: ['memberships.create']),
      ),
    );
    await tester.pumpAndSettle();

    expectForm(tester, allowed: true);
    expect(find.text(MembershipStrings.addTitle), findsOneWidget);
  });

  testWidgets('admin without memberships.create is denied the create form', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(adminPrincipal, const Capabilities(slugs: ['memberships.read'])),
    );
    await tester.pumpAndSettle();

    expectForm(tester, allowed: false);
  });

  testWidgets('member cannot open the edit form', (tester) async {
    await tester.pumpWidget(
      wrap(
        memberPrincipal,
        const Capabilities(slugs: ['memberships.read']),
        product: product,
      ),
    );
    await tester.pumpAndSettle();

    expectForm(tester, allowed: false);
  });

  testWidgets('trainer cannot open the edit form', (tester) async {
    await tester.pumpWidget(
      wrap(
        trainerPrincipal,
        const Capabilities(slugs: ['memberships.read']),
        product: product,
      ),
    );
    await tester.pumpAndSettle();

    expectForm(tester, allowed: false);
  });

  testWidgets('admin with memberships.update sees the edit form', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(
        adminPrincipal,
        const Capabilities(slugs: ['memberships.update']),
        product: product,
      ),
    );
    await tester.pumpAndSettle();

    expectForm(tester, allowed: true);
    expect(find.text(MembershipStrings.editTitle), findsOneWidget);
  });

  testWidgets('admin without memberships.update is denied the edit form', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(
        adminPrincipal,
        const Capabilities(slugs: ['memberships.read', 'memberships.create']),
        product: product,
      ),
    );
    await tester.pumpAndSettle();

    expectForm(tester, allowed: false);
  });
}
