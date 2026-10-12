import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:luxeknox/core/di/injector.dart';
import 'package:luxeknox/core/presentation/load_status.dart';
import 'package:luxeknox/features/membership/domain/entities/membership_product.dart';
import 'package:luxeknox/features/membership/domain/entities/membership_replacement_preview.dart';
import 'package:luxeknox/features/membership/domain/entities/membership_status.dart';
import 'package:luxeknox/features/membership/presentation/bloc/create_membership_bloc.dart';
import 'package:luxeknox/features/membership/presentation/membership_strings.dart';
import 'package:luxeknox/features/membership/presentation/screens/create_membership_screen.dart';
import 'package:luxeknox/features/payments/domain/entities/payment_method.dart';
import 'package:luxeknox/features/people/domain/entities/profile_summary.dart';
import 'package:mocktail/mocktail.dart';

class MockCreateMembershipBloc
    extends MockBloc<CreateMembershipEvent, CreateMembershipState>
    implements CreateMembershipBloc {}

void main() {
  late MockCreateMembershipBloc bloc;

  const gold = MembershipProduct(
    id: '10',
    name: 'Gold',
    code: 'GOLD',
    durationDays: 30,
    basePrice: '1299.00',
    isActive: true,
  );
  const couple = MembershipProduct(
    id: '20',
    name: 'Couple Monthly',
    code: 'CPL-M',
    durationDays: 30,
    basePrice: '2000.00',
    isActive: true,
    packageType: MembershipPackageType.couple,
  );
  const cash = PaymentMethod(
    id: '1',
    methodName: 'Cash',
    isDigital: false,
    isActive: true,
  );
  const partner = ProfileSummary(
    id: 200,
    fullName: 'Priya',
    membershipNumber: 'M-200',
  );
  final replacement = MembershipReplacementPreview(
    membershipId: '77',
    productName: 'Monthly',
    status: MembershipStatus.active,
    endDate: DateTime(2026, 11, 3),
    remainingDays: 22,
    isCouple: false,
    suggestedCredit: '733.33',
  );
  final coupleBlocked = MembershipReplacementPreview(
    membershipId: '88',
    productName: 'Couple Annual',
    status: MembershipStatus.active,
    endDate: DateTime(2026, 12, 1),
    remainingDays: 50,
    isCouple: true,
    suggestedCredit: '0.00',
  );

  CreateMembershipState singleState() => const CreateMembershipState(
    status: LoadStatus.success,
    products: [gold, couple],
    paymentMethods: [cash],
    selectedMemberId: '100',
    selectedProductId: '10',
    selectedPaymentMethodId: '1',
  );

  CreateMembershipState coupleState({
    ProfileSummary? selectedPartner,
    MembershipReplacementPreview? partnerReplacement,
    bool replaceConfirmed = false,
    String? discountAmount,
    String? fieldError,
  }) => CreateMembershipState(
    status: LoadStatus.success,
    products: const [gold, couple],
    paymentMethods: const [cash],
    selectedMemberId: '100',
    selectedProductId: '20',
    selectedPaymentMethodId: '1',
    startDate: DateTime(2026, 10, 12),
    selectedPartner: selectedPartner,
    partnerReplacement: partnerReplacement,
    replaceConfirmed: replaceConfirmed,
    discountAmount: discountAmount,
    fieldError: fieldError,
  );

  setUp(() {
    bloc = MockCreateMembershipBloc();
    getIt.registerFactory<CreateMembershipBloc>(() => bloc);
  });

  tearDown(() => getIt.reset());

  Widget wrapScreen({String memberId = '100'}) {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) =>
              CreateMembershipScreen(memberId: memberId),
        ),
      ],
    );
    return MaterialApp.router(routerConfig: router);
  }

  testWidgets('shows payment method dropdown on assign membership', (
    tester,
  ) async {
    whenListen(
      bloc,
      const Stream<CreateMembershipState>.empty(),
      initialState: const CreateMembershipState(
        status: LoadStatus.success,
        products: [gold],
        paymentMethods: [cash],
        selectedMemberId: '100',
        selectedPaymentMethodId: '1',
      ),
    );

    await tester.pumpWidget(wrapScreen());
    await tester.pump();

    expect(find.text(MembershipStrings.paymentMethodLabel), findsOneWidget);
    expect(find.text('Cash'), findsOneWidget);
  });

  testWidgets('shows empty payment methods message', (tester) async {
    whenListen(
      bloc,
      const Stream<CreateMembershipState>.empty(),
      initialState: const CreateMembershipState(
        status: LoadStatus.success,
        products: [gold],
        selectedMemberId: '100',
      ),
    );

    await tester.pumpWidget(wrapScreen());
    await tester.pump();

    expect(find.text(MembershipStrings.noPaymentMethods), findsOneWidget);
  });

  testWidgets('hides partner picker for a single package', (tester) async {
    whenListen(
      bloc,
      const Stream<CreateMembershipState>.empty(),
      initialState: singleState(),
    );

    await tester.pumpWidget(wrapScreen());
    await tester.pump();

    expect(find.text(MembershipStrings.partnerLabel), findsNothing);
  });

  testWidgets('shows partner picker for a couple package', (tester) async {
    whenListen(
      bloc,
      const Stream<CreateMembershipState>.empty(),
      initialState: coupleState(),
    );

    await tester.pumpWidget(wrapScreen());
    await tester.pump();

    expect(find.text(MembershipStrings.partnerLabel), findsOneWidget);
  });

  testWidgets('shows submit error when no partner is picked', (tester) async {
    whenListen(
      bloc,
      const Stream<CreateMembershipState>.empty(),
      initialState: coupleState(
        fieldError: 'Select a partner for the couple package',
      ),
    );

    await tester.binding.setSurfaceSize(const Size(800, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(wrapScreen());
    await tester.pump();

    expect(
      find.text('Select a partner for the couple package'),
      findsOneWidget,
    );
  });

  testWidgets('replace dialog Confirm keeps the partner', (tester) async {
    final controller = StreamController<CreateMembershipState>();
    addTearDown(controller.close);

    whenListen(
      bloc,
      controller.stream,
      initialState: coupleState(),
    );

    await tester.pumpWidget(wrapScreen());
    await tester.pump();

    controller.add(
      coupleState(
        selectedPartner: partner,
        partnerReplacement: replacement,
        discountAmount: replacement.suggestedCredit,
      ),
    );
    await tester.pump();
    await tester.pump();

    expect(find.text(MembershipStrings.replacePartnerTitle), findsOneWidget);
    expect(
      find.text(
        MembershipStrings.replacePartnerMessage(
          partnerName: 'Priya',
          productName: 'Monthly',
          endDateLabel: '03 Nov',
          remainingDays: 22,
        ),
      ),
      findsOneWidget,
    );

    await tester.tap(find.text(MembershipStrings.confirm));
    await tester.pumpAndSettle();

    verify(
      () => bloc.add(const CreateMembershipReplaceConfirmed(true)),
    ).called(1);
  });

  testWidgets('replace dialog Cancel clears the partner', (tester) async {
    final controller = StreamController<CreateMembershipState>();
    addTearDown(controller.close);

    whenListen(
      bloc,
      controller.stream,
      initialState: coupleState(),
    );

    await tester.pumpWidget(wrapScreen());
    await tester.pump();

    controller.add(
      coupleState(
        selectedPartner: partner,
        partnerReplacement: replacement,
        discountAmount: replacement.suggestedCredit,
      ),
    );
    await tester.pump();
    await tester.pump();

    await tester.tap(find.text(MembershipStrings.cancel));
    await tester.pumpAndSettle();

    verify(
      () => bloc.add(const CreateMembershipReplaceConfirmed(false)),
    ).called(1);
  });

  testWidgets('couple membership preview shows an error dialog', (
    tester,
  ) async {
    final controller = StreamController<CreateMembershipState>();
    addTearDown(controller.close);

    whenListen(
      bloc,
      controller.stream,
      initialState: coupleState(),
    );

    await tester.pumpWidget(wrapScreen());
    await tester.pump();

    controller.add(
      coupleState(
        selectedPartner: partner,
        partnerReplacement: coupleBlocked,
      ),
    );
    await tester.pump();
    await tester.pump();

    expect(
      find.text(MembershipStrings.partnerAlreadyCoupleTitle),
      findsOneWidget,
    );
    expect(find.text(MembershipStrings.partnerAlreadyCouple), findsOneWidget);
    expect(find.text(MembershipStrings.replacePartnerTitle), findsNothing);

    await tester.tap(find.text(MembershipStrings.confirm));
    await tester.pumpAndSettle();

    verify(
      () => bloc.add(const CreateMembershipReplaceConfirmed(false)),
    ).called(1);
  });

  testWidgets('discount field is pre-filled from the preview', (tester) async {
    whenListen(
      bloc,
      const Stream<CreateMembershipState>.empty(),
      initialState: coupleState(
        selectedPartner: partner,
        partnerReplacement: replacement,
        replaceConfirmed: true,
        discountAmount: '733.33',
      ),
    );

    await tester.pumpWidget(wrapScreen());
    await tester.pump();

    expect(
      find.text(MembershipStrings.discountForRemainingDays),
      findsOneWidget,
    );
    expect(find.text('733.33'), findsOneWidget);
    expect(find.text(MembershipStrings.packagePriceLabel), findsOneWidget);
    expect(find.text(MembershipStrings.totalDueLabel), findsOneWidget);
  });
}
