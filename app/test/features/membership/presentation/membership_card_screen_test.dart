import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luxeknox/core/di/injector.dart';
import 'package:luxeknox/core/presentation/load_status.dart';
import 'package:luxeknox/features/membership/domain/entities/membership.dart';
import 'package:luxeknox/features/membership/domain/entities/membership_product.dart';
import 'package:luxeknox/features/membership/domain/entities/membership_status.dart';
import 'package:luxeknox/features/membership/presentation/cubit/membership_card_cubit.dart';
import 'package:luxeknox/features/membership/presentation/membership_strings.dart';
import 'package:luxeknox/features/membership/presentation/screens/membership_card_screen.dart';
import 'package:luxeknox/session/domain/entities/capabilities.dart';
import 'package:luxeknox/session/domain/entities/principal.dart';
import 'package:luxeknox/session/domain/entities/user_type.dart';
import 'package:luxeknox/session/presentation/session_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockMembershipCardCubit extends MockCubit<MembershipCardState>
    implements MembershipCardCubit {}

class MockSessionCubit extends MockCubit<SessionState>
    implements SessionCubit {}

void main() {
  late MockMembershipCardCubit cardCubit;
  late MockSessionCubit sessionCubit;

  const memberPrincipal = Principal(
    userId: '1',
    userType: UserType.member,
    displayName: 'Member One',
    profileId: 'm-profile-1',
  );

  const product = MembershipProduct(
    id: 'prod-1',
    name: 'Gold Annual',
    code: 'GOLD',
    description: 'All-inclusive annual gym access',
    durationDays: 365,
    basePrice: '1200.00',
    maxFreezeDays: 30,
    ptSessionsIncluded: 5,
    accessFacilities: ['Pool', 'Sauna'],
    isActive: true,
  );

  final activeMembership = Membership(
    id: 'mem-1',
    memberId: 'm-profile-1',
    productId: 'prod-1',
    startDate: DateTime.utc(2026, 1, 1),
    endDate: DateTime.utc(2026, 12, 31),
    remainingPtSessions: 4,
    status: MembershipStatus.active,
    rowVersion: 1,
    product: product,
  );

  setUp(() {
    cardCubit = MockMembershipCardCubit();
    sessionCubit = MockSessionCubit();

    when(() => cardCubit.load(any())).thenAnswer((_) async {});

    whenListen(
      sessionCubit,
      const Stream<SessionState>.empty(),
      initialState: const SessionAuthenticated(
        principal: memberPrincipal,
        capabilities: Capabilities(slugs: ['memberships.read']),
      ),
    );

    getIt.registerFactory<MembershipCardCubit>(() => cardCubit);
  });

  tearDown(() => getIt.reset());

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<SessionCubit>.value(
        value: sessionCubit,
        child: const MembershipCardScreen(),
      ),
    );
  }

  testWidgets(
    'renders active membership details, quota, and navigation links',
    (tester) async {
      whenListen(
        cardCubit,
        const Stream<MembershipCardState>.empty(),
        initialState: MembershipCardState(
          status: LoadStatus.success,
          membership: activeMembership,
        ),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Gold Annual'), findsOneWidget);
      expect(find.text(MembershipStrings.statusActive), findsOneWidget);
      expect(find.text('All-inclusive annual gym access'), findsOneWidget);
      expect(find.text(MembershipStrings.remainingDays), findsOneWidget);
      expect(find.text(MembershipStrings.remainingPtSessions), findsOneWidget);
      expect(find.text('4'), findsOneWidget);
      expect(find.text(MembershipStrings.maxFreezeDaysLabel), findsOneWidget);
      expect(find.text('30'), findsOneWidget);
      expect(find.text('Pool, Sauna'), findsOneWidget);

      expect(find.text(MembershipStrings.historyTitle), findsOneWidget);
      expect(find.text(MembershipStrings.freezesTitle), findsOneWidget);
      expect(find.text(MembershipStrings.catalogTitle), findsOneWidget);
      expect(find.text(MembershipStrings.requestFreeze), findsOneWidget);
    },
  );

  testWidgets('opens freeze request dialog with max freeze days quota', (
    tester,
  ) async {
    whenListen(
      cardCubit,
      const Stream<MembershipCardState>.empty(),
      initialState: MembershipCardState(
        status: LoadStatus.success,
        membership: activeMembership,
      ),
    );

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    await tester.tap(find.text(MembershipStrings.requestFreeze));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(
      find.text('${MembershipStrings.maxFreezeDaysLabel}: 30'),
      findsOneWidget,
    );
    expect(find.text(MembershipStrings.reasonLabel), findsOneWidget);
    expect(find.text(MembershipStrings.confirm), findsOneWidget);
  });

  testWidgets('shows empty view when no active membership on file', (
    tester,
  ) async {
    whenListen(
      cardCubit,
      const Stream<MembershipCardState>.empty(),
      initialState: const MembershipCardState(
        status: LoadStatus.success,
        membership: null,
      ),
    );

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    expect(find.text(MembershipStrings.noActiveMembership), findsOneWidget);
  });
}
