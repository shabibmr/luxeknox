import 'package:luxeknox/core/di/injector.dart';
import 'package:luxeknox/core/presentation/load_status.dart';
import 'package:luxeknox/features/membership/domain/entities/membership.dart';
import 'package:luxeknox/features/membership/domain/entities/membership_freeze.dart';
import 'package:luxeknox/features/membership/domain/entities/membership_product.dart';
import 'package:luxeknox/features/membership/domain/entities/membership_status.dart';
import 'package:luxeknox/features/membership/presentation/cubit/membership_detail_cubit.dart';
import 'package:luxeknox/features/membership/presentation/cubit/membership_freeze_cubit.dart';
import 'package:luxeknox/features/membership/presentation/cubit/membership_history_cubit.dart';
import 'package:luxeknox/features/membership/presentation/membership_strings.dart';
import 'package:luxeknox/features/membership/presentation/screens/membership_detail_screen.dart';
import 'package:luxeknox/session/domain/entities/capabilities.dart';
import 'package:luxeknox/session/domain/entities/principal.dart';
import 'package:luxeknox/session/domain/entities/user_type.dart';
import 'package:luxeknox/session/presentation/session_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockMembershipDetailCubit extends MockCubit<MembershipDetailState>
    implements MembershipDetailCubit {}

class MockMembershipFreezeCubit extends MockCubit<MembershipFreezeState>
    implements MembershipFreezeCubit {}

class MockMembershipHistoryCubit extends MockCubit<MembershipHistoryState>
    implements MembershipHistoryCubit {}

class MockSessionCubit extends MockCubit<SessionState> implements SessionCubit {}

/// ADR-0006 §11 — memberships.approve actions render only when that slug
/// is on the principal, for member, trainer, and admin.
void main() {
  final membership = Membership(
    id: 'm-1',
    memberId: '1',
    productId: '10',
    startDate: DateTime.utc(2026, 1, 1),
    endDate: DateTime.utc(2026, 12, 1),
    status: MembershipStatus.active,
    rowVersion: 1,
    product: MembershipProduct(
      id: '10',
      name: 'Gold',
      code: 'GOLD',
      durationDays: 30,
      basePrice: '99.00',
      isActive: true,
    ),
  );

  final pendingFreeze = MembershipFreeze(
    id: 'f-1',
    membershipId: 'm-1',
    startDate: DateTime.utc(2026, 2, 1),
    endDate: DateTime.utc(2026, 2, 10),
    status: FreezeStatus.pending,
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
  const canApprove = Capabilities(
    slugs: ['memberships.read', 'memberships.approve'],
  );

  setUp(() {
    final detailCubit = MockMembershipDetailCubit();
    final freezeCubit = MockMembershipFreezeCubit();
    final historyCubit = MockMembershipHistoryCubit();

    when(() => detailCubit.load('m-1')).thenAnswer((_) async {});
    when(
      () => freezeCubit.load(membershipId: 'm-1'),
    ).thenAnswer((_) async {});
    when(
      () => historyCubit.load(membershipId: 'm-1'),
    ).thenAnswer((_) async {});

    whenListen(
      detailCubit,
      const Stream<MembershipDetailState>.empty(),
      initialState: MembershipDetailState(
        status: LoadStatus.success,
        membership: membership,
      ),
    );
    whenListen(
      freezeCubit,
      const Stream<MembershipFreezeState>.empty(),
      initialState: MembershipFreezeState(
        status: LoadStatus.success,
        membershipId: 'm-1',
        items: [pendingFreeze],
      ),
    );
    whenListen(
      historyCubit,
      const Stream<MembershipHistoryState>.empty(),
      initialState: const MembershipHistoryState(
        status: LoadStatus.success,
        membershipId: 'm-1',
      ),
    );

    getIt.registerFactory<MembershipDetailCubit>(() => detailCubit);
    getIt.registerFactory<MembershipFreezeCubit>(() => freezeCubit);
    getIt.registerFactory<MembershipHistoryCubit>(() => historyCubit);
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
        child: const MembershipDetailScreen(membershipId: 'm-1'),
      ),
    );
  }

  void expectApproveActions(WidgetTester tester, {required bool visible}) {
    final matcher = visible ? findsOneWidget : findsNothing;
    expect(find.text(MembershipStrings.renew), matcher);
    expect(find.text(MembershipStrings.upgrade), matcher);
    expect(find.text(MembershipStrings.grantExtension), matcher);
    expect(find.text(MembershipStrings.cancelMembership), matcher);
    expect(find.byTooltip(MembershipStrings.approve), matcher);
    expect(find.byTooltip(MembershipStrings.reject), matcher);
    expect(find.text('Gold'), findsOneWidget);
  }

  testWidgets('member without memberships.approve sees no actions', (
    tester,
  ) async {
    await tester.pumpWidget(wrap(memberPrincipal, readOnly));
    await tester.pumpAndSettle();

    expectApproveActions(tester, visible: false);
  });

  testWidgets('trainer without memberships.approve sees no actions', (
    tester,
  ) async {
    await tester.pumpWidget(wrap(trainerPrincipal, readOnly));
    await tester.pumpAndSettle();

    expectApproveActions(tester, visible: false);
  });

  testWidgets('admin with memberships.approve sees the actions', (
    tester,
  ) async {
    await tester.pumpWidget(wrap(adminPrincipal, canApprove));
    await tester.pumpAndSettle();

    expectApproveActions(tester, visible: true);
  });

  testWidgets('admin without memberships.approve sees no actions', (
    tester,
  ) async {
    await tester.pumpWidget(wrap(adminPrincipal, readOnly));
    await tester.pumpAndSettle();

    expectApproveActions(tester, visible: false);
  });
}
