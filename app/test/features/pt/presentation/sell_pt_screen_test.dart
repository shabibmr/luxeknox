import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luxeknox/core/di/injector.dart';
import 'package:luxeknox/core/presentation/load_status.dart';
import 'package:luxeknox/features/payments/domain/entities/payment_method.dart';
import 'package:luxeknox/features/people/domain/entities/person.dart';
import 'package:luxeknox/features/pt/domain/entities/pt_product.dart';
import 'package:luxeknox/features/pt/domain/entities/pt_schedule_grid.dart';
import 'package:luxeknox/features/pt/domain/entities/pt_subscription.dart';
import 'package:luxeknox/features/pt/presentation/cubit/sell_pt_cubit.dart';
import 'package:luxeknox/features/pt/presentation/pt_strings.dart';
import 'package:luxeknox/features/pt/presentation/screens/sell_pt_screen.dart';
import 'package:mocktail/mocktail.dart';

class MockSellPtCubit extends MockCubit<SellPtState> implements SellPtCubit {}

void main() {
  late MockSellPtCubit cubit;

  const single = PtProduct(
    id: 3,
    name: 'PT Monthly 3x',
    code: 'PT3',
    durationDays: 28,
    basePrice: '3000.00',
    isActive: true,
  );
  const couple = PtProduct(
    id: 5,
    name: 'Couple PT 1M',
    code: 'CPT1',
    durationDays: 28,
    basePrice: '6999.00',
    isActive: true,
    packageType: PtPackageType.couple,
  );
  const cash = PaymentMethod(
    id: '1',
    methodName: 'Cash',
    isDigital: false,
    isActive: true,
  );
  const partner = Person(
    id: 99,
    userId: 199,
    membershipNumber: 'M-99',
    firstName: 'Priya',
    lastName: 'Shah',
  );

  final grid = PtScheduleGrid(
    startDate: DateTime(2026, 10, 5),
    endDate: DateTime(2026, 11, 2),
    weekdays: const [1, 3, 5],
    hours: const ['17:00:00'],
    trainers: const [PtGridTrainer(id: 7, name: 'Rina S')],
    cells: const [
      PtGridCell(
        trainerId: 7,
        slotStart: '17:00:00',
        status: PtGridCellStatus.free,
      ),
    ],
  );

  final coupleSub = PtSubscription(
    id: 900,
    memberId: 42,
    ptProductId: 5,
    trainerId: 7,
    startDate: DateTime(2026, 10, 5),
    endDate: DateTime(2026, 11, 2),
    weekdays: const [1, 3, 5],
    slotStart: '17:00:00',
    status: PtSubscriptionStatus.scheduled,
    rowVersion: 1,
    productName: 'Couple PT 1M',
    sessionsPerWeek: 3,
    trainerName: 'Rina S',
    slotLabel: '17:00-18:00',
    packageType: PtPackageType.couple,
    partnerSubscriptionId: 901,
    partnerMemberId: 99,
    partnerMemberName: 'Priya Shah',
  );

  SellPtState baseState({
    PtProduct? product,
    Person? partnerPerson,
    SellPtPartnerCheck? partnerCheck,
    PtSubscription? replanning,
    bool slotChosen = false,
  }) {
    final p = product ?? single;
    return SellPtState(
      status: LoadStatus.success,
      memberId: 42,
      memberName: 'Alex',
      products: const [single, couple],
      paymentMethods: const [cash],
      paymentMethodId: '1',
      product: p,
      startDate: DateTime(2026, 10, 5),
      weekdays: const [1, 3, 5],
      gridStatus: LoadStatus.success,
      grid: grid,
      trainerId: slotChosen ? 7 : null,
      slotStart: slotChosen ? '17:00:00' : null,
      partner: partnerPerson,
      partnerCheck: partnerCheck,
      replanning: replanning,
    );
  }

  setUpAll(() {
    registerFallbackValue(coupleSub);
    registerFallbackValue(const <PtProduct>[]);
  });

  setUp(() {
    cubit = MockSellPtCubit();
    when(() => cubit.init(any(), memberName: any(named: 'memberName')))
        .thenAnswer((_) async {});
    when(
      () => cubit.initReplan(
        any(),
        any(),
        memberName: any(named: 'memberName'),
      ),
    ).thenAnswer((_) async {});
    getIt.registerFactory<SellPtCubit>(() => cubit);
  });

  tearDown(() => getIt.reset());

  Widget wrapScreen({
    PtSubscription? replanning,
    List<PtProduct>? products,
  }) {
    return MaterialApp(
      home: SellPtScreen(
        memberId: 42,
        memberName: 'Alex',
        replanning: replanning,
        products: products,
      ),
    );
  }

  testWidgets('hides partner picker for a single package', (tester) async {
    whenListen(
      cubit,
      const Stream<SellPtState>.empty(),
      initialState: baseState(product: single),
    );

    await tester.pumpWidget(wrapScreen());
    await tester.pump();

    expect(find.text(PtStrings.partnerLabel), findsNothing);
  });

  testWidgets('shows partner picker for a couple package', (tester) async {
    whenListen(
      cubit,
      const Stream<SellPtState>.empty(),
      initialState: baseState(product: couple),
    );

    await tester.pumpWidget(wrapScreen());
    await tester.pump();

    expect(find.text(PtStrings.partnerLabel), findsOneWidget);
  });

  testWidgets('blocked partner disables submit', (tester) async {
    whenListen(
      cubit,
      const Stream<SellPtState>.empty(),
      initialState: baseState(
        product: couple,
        partnerPerson: partner,
        partnerCheck: SellPtPartnerCheckBlocked(
          PtStrings.partnerHasOpenPt('Priya Shah', '03 Nov'),
        ),
        slotChosen: true,
      ),
    );

    await tester.binding.setSurfaceSize(const Size(800, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(wrapScreen());
    await tester.pump();

    expect(
      find.text(PtStrings.partnerHasOpenPt('Priya Shah', '03 Nov')),
      findsOneWidget,
    );
    final button = tester.widget<FilledButton>(find.byType(FilledButton));
    expect(button.onPressed, isNull);
  });

  testWidgets('summary shows couple total note', (tester) async {
    whenListen(
      cubit,
      const Stream<SellPtState>.empty(),
      initialState: baseState(
        product: couple,
        partnerPerson: partner,
        partnerCheck: const SellPtPartnerCheckOk(),
        slotChosen: true,
      ),
    );

    await tester.binding.setSurfaceSize(const Size(800, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(wrapScreen());
    await tester.pump();

    expect(find.text(PtStrings.coupleTotalNote), findsOneWidget);
    expect(find.text('6999.00'), findsWidgets);
  });

  testWidgets('replan of a couple shows the shared-change note', (tester) async {
    whenListen(
      cubit,
      const Stream<SellPtState>.empty(),
      initialState: baseState(
        product: couple,
        replanning: coupleSub,
        slotChosen: true,
      ),
    );

    await tester.pumpWidget(
      wrapScreen(replanning: coupleSub, products: const [couple]),
    );
    await tester.pump();

    expect(find.text(PtStrings.replanCoupleNote), findsOneWidget);
  });
}
