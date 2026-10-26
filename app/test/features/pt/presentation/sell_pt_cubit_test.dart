import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/core/presentation/load_status.dart';
import 'package:luxeknox/core/usecase/usecase.dart';
import 'package:luxeknox/features/payments/domain/entities/payment_method.dart';
import 'package:luxeknox/features/payments/domain/usecases/get_payment_methods_usecase.dart';
import 'package:luxeknox/features/people/domain/entities/person.dart';
import 'package:luxeknox/features/pt/domain/entities/pt_payment_preview.dart';
import 'package:luxeknox/features/pt/domain/entities/pt_product.dart';
import 'package:luxeknox/features/pt/domain/entities/pt_schedule_grid.dart';
import 'package:luxeknox/features/pt/domain/entities/pt_subscription.dart';
import 'package:luxeknox/features/pt/domain/repositories/pt_repository.dart';
import 'package:luxeknox/features/pt/domain/usecases/pt_usecases.dart';
import 'package:luxeknox/features/pt/presentation/cubit/sell_pt_cubit.dart';
import 'package:luxeknox/features/pt/presentation/pt_strings.dart';
import 'package:mocktail/mocktail.dart';

class MockGetPtProducts extends Mock implements GetPtProductsUseCase {}

class MockGetPaymentMethods extends Mock implements GetPaymentMethodsUseCase {}

class MockGetGrid extends Mock implements GetPtScheduleGridUseCase {}

class MockPurchase extends Mock implements PurchasePtUseCase {}

class MockReplan extends Mock implements ReplanPtUseCase {}

class MockGetPaymentPreview extends Mock
    implements GetPtPaymentPreviewUseCase {}

class MockGetPtSummary extends Mock implements GetMemberPtSummaryUseCase {}

void main() {
  late MockGetPtProducts getProducts;
  late MockGetPaymentMethods getPaymentMethods;
  late MockGetGrid getGrid;
  late MockPurchase purchase;
  late MockReplan replan;
  late MockGetPtSummary getPtSummary;

  const product = PtProduct(
    id: 3,
    name: 'PT Monthly 3x',
    code: 'PT3',
    durationDays: 28,
    basePrice: '3000.00',
    isActive: true,
  );
  const coupleProduct = PtProduct(
    id: 5,
    name: 'Couple PT 1M',
    code: 'CPT1',
    durationDays: 28,
    basePrice: '6999.00',
    isActive: true,
    packageType: PtPackageType.couple,
  );
  const archived = PtProduct(
    id: 4,
    name: 'Old',
    code: 'OLD',
    durationDays: 28,
    basePrice: '1000.00',
    isActive: false,
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
    hours: const ['17:00:00', '18:00:00'],
    trainers: const [PtGridTrainer(id: 7, name: 'Rina S')],
    cells: const [
      PtGridCell(
        trainerId: 7,
        slotStart: '17:00:00',
        status: PtGridCellStatus.free,
      ),
      PtGridCell(
        trainerId: 7,
        slotStart: '18:00:00',
        status: PtGridCellStatus.occupied,
        occupiedBy: 'Other',
      ),
    ],
  );

  final sold = PtSubscription(
    id: 900,
    memberId: 42,
    ptProductId: 3,
    trainerId: 7,
    startDate: DateTime(2026, 10, 5),
    endDate: DateTime(2026, 11, 2),
    weekdays: const [1, 3, 5],
    slotStart: '17:00:00',
    status: PtSubscriptionStatus.scheduled,
    rowVersion: 1,
    productName: 'PT Monthly 3x',
    sessionsPerWeek: 3,
    trainerName: 'Rina S',
    slotLabel: '17:00-18:00',
  );

  setUpAll(() {
    registerFallbackValue(const NoParams());
    registerFallbackValue(
      GetPtScheduleGridParams(
        memberId: 0,
        ptProductId: 0,
        startDate: DateTime(2026),
        weekdays: const [],
      ),
    );
    registerFallbackValue(
      ReplanPtParams(
        subscription: sold,
        trainerId: 0,
        weekdays: const [],
        slotStart: '',
        effectiveDate: DateTime(2026),
      ),
    );
    registerFallbackValue(
      PurchasePtParams(
        memberId: 0,
        ptProductId: 0,
        trainerId: 0,
        startDate: DateTime(2026),
        weekdays: const [],
        slotStart: '',
        payment: const PtPayment(paymentMethodId: 0),
      ),
    );
  });

  setUp(() {
    getProducts = MockGetPtProducts();
    getPaymentMethods = MockGetPaymentMethods();
    getGrid = MockGetGrid();
    purchase = MockPurchase();
    replan = MockReplan();
    getPtSummary = MockGetPtSummary();
    when(
      () => getProducts(any()),
    ).thenAnswer((_) async => const Right([product, coupleProduct, archived]));
    when(
      () => getPaymentMethods(any()),
    ).thenAnswer((_) async => const Right([cash]));
    when(() => getGrid(any())).thenAnswer((_) async => Right(grid));
    when(() => purchase(any())).thenAnswer((_) async => Right(sold));
    when(
      () => getPtSummary(any()),
    ).thenAnswer((_) async => const Right(MemberPtSummary()));
  });

  SellPtCubit build() => SellPtCubit(
    getProducts,
    getPaymentMethods,
    getGrid,
    purchase,
    replan,
    null,
    getPtSummary,
  );

  test(
    'init offers only active packages and preselects the only payment method',
    () async {
      final cubit = build();
      await cubit.init(42);
      expect(cubit.state.status, LoadStatus.success);
      expect(cubit.state.products, [product, coupleProduct]);
      expect(cubit.state.paymentMethodId, '1');
    },
  );

  test(
    'weekdays are chosen freely per member and the grid loads once at least one day is picked',
    () async {
      final cubit = build();
      await cubit.init(42);
      cubit.selectProduct(product);
      cubit.setStartDate(DateTime(2026, 10, 5));
      cubit.toggleWeekday(1);
      await Future<void>.delayed(Duration.zero);
      expect(cubit.state.grid, grid);

      cubit.toggleWeekday(3);
      cubit.toggleWeekday(5);
      cubit.toggleWeekday(6); // a 4th day is accepted — no package-fixed cap
      await Future<void>.delayed(Duration.zero);

      expect(cubit.state.weekdays, [1, 3, 5, 6]);
      final params =
          verify(() => getGrid(captureAny())).captured.last
              as GetPtScheduleGridParams;
      expect(params.weekdays, [1, 3, 5, 6]);
      expect(params.memberId, 42);
    },
  );

  test('occupied cells cannot be selected; free cells can', () async {
    final cubit = build();
    await cubit.init(42);
    cubit
      ..selectProduct(product)
      ..setStartDate(DateTime(2026, 10, 5))
      ..toggleWeekday(1)
      ..toggleWeekday(3)
      ..toggleWeekday(5);
    await Future<void>.delayed(Duration.zero);

    cubit.selectSlot(7, '18:00:00');
    expect(cubit.state.slotChosen, isFalse);

    cubit.selectSlot(7, '17:00:00');
    expect(cubit.state.trainerId, 7);
    expect(cubit.state.canSubmit, isTrue);
  });

  test(
    'a discount fetches the server totals; an invalid one clears them',
    () async {
      final getPreview = MockGetPaymentPreview();
      registerFallbackValue(const GetPtPaymentPreviewParams(ptProductId: 0));
      when(() => getPreview(any())).thenAnswer(
        (_) async => const Right(
          PtPaymentPreview(
            subtotal: '3000.00',
            discount: '100.00',
            tax: '522.00',
            total: '3422.00',
          ),
        ),
      );
      final cubit = SellPtCubit(
        getProducts,
        getPaymentMethods,
        getGrid,
        purchase,
        replan,
        null,
        getPtSummary,
        getPreview,
      );
      addTearDown(cubit.close);
      await cubit.init(42);
      cubit.selectProduct(product);
      await Future<void>.delayed(Duration.zero);
      verify(
        () => getPreview(GetPtPaymentPreviewParams(ptProductId: product.id)),
      ).called(1);

      cubit.setDiscount('100.00');
      expect(cubit.state.preview, isNull);
      await Future<void>.delayed(const Duration(milliseconds: 400));
      expect(cubit.state.preview?.total, '3422.00');
      verify(
        () => getPreview(
          GetPtPaymentPreviewParams(
            ptProductId: product.id,
            discountAmount: '100.00',
          ),
        ),
      ).called(1);

      cubit.setDiscount('3000.01');
      await Future<void>.delayed(const Duration(milliseconds: 400));
      expect(cubit.state.preview, isNull);
    },
  );

  test('canSubmit refuses an out-of-range discount on a sale', () async {
    final cubit = build();
    await cubit.init(42);
    cubit
      ..selectProduct(product) // 3000.00
      ..setStartDate(DateTime(2026, 10, 5))
      ..toggleWeekday(1)
      ..toggleWeekday(3)
      ..toggleWeekday(5);
    await Future<void>.delayed(Duration.zero);
    cubit.selectSlot(7, '17:00:00');
    expect(cubit.state.canSubmit, isTrue);

    cubit.setDiscount('3000.01');
    expect(cubit.state.canSubmit, isFalse);

    cubit.setDiscount('-1');
    expect(cubit.state.canSubmit, isFalse);

    cubit.setDiscount('10.123');
    expect(cubit.state.canSubmit, isFalse);

    cubit.setDiscount('100.00');
    expect(cubit.state.canSubmit, isTrue);

    cubit.setDiscount('3000.00');
    expect(cubit.state.canSubmit, isTrue);
  });

  test(
    'submit sends the purchase with payment and exposes the result',
    () async {
      final cubit = build();
      await cubit.init(42);
      cubit
        ..selectProduct(product)
        ..setStartDate(DateTime(2026, 10, 5))
        ..toggleWeekday(1)
        ..toggleWeekday(3)
        ..toggleWeekday(5);
      await Future<void>.delayed(Duration.zero);
      cubit
        ..selectSlot(7, '17:00:00')
        ..setDiscount('100.00')
        ..setPaymentDate(DateTime(2026, 10, 1, 15, 30));

      await cubit.submit();

      final p =
          verify(() => purchase(captureAny())).captured.single
              as PurchasePtParams;
      expect(p.trainerId, 7);
      expect(p.slotStart, '17:00:00');
      expect(p.payment.paymentMethodId, 1);
      expect(p.payment.discountAmount, '100.00');
      expect(p.payment.paymentDate, DateTime(2026, 10, 1));
      expect(cubit.state.result, sold);
    },
  );

  test('a backdated payment date moves the start date with it', () async {
    final cubit = build();
    await cubit.init(42);
    cubit.selectProduct(product);

    cubit.setPaymentDate(DateTime(2026, 9, 6, 15, 30));

    expect(cubit.state.paymentDate, DateTime(2026, 9, 6));
    expect(cubit.state.startDate, DateTime(2026, 9, 6));
  });

  test('changing the package clears a chosen slot', () async {
    final cubit = build();
    await cubit.init(42);
    cubit
      ..selectProduct(product)
      ..setStartDate(DateTime(2026, 10, 5))
      ..toggleWeekday(1)
      ..toggleWeekday(3)
      ..toggleWeekday(5);
    await Future<void>.delayed(Duration.zero);
    cubit.selectSlot(7, '17:00:00');

    cubit.setStartDate(DateTime(2026, 10, 12));
    expect(cubit.state.slotChosen, isFalse);
  });

  void pickThreeDays(SellPtCubit cubit) => cubit
    ..selectProduct(product)
    ..setStartDate(DateTime(2026, 10, 5))
    ..toggleWeekday(1)
    ..toggleWeekday(3)
    ..toggleWeekday(5);

  test('a stale grid response is discarded', () async {
    final slow = Completer<Either<Failure, PtScheduleGrid>>();
    final other = PtScheduleGrid(
      startDate: DateTime(2026, 10, 12),
      endDate: DateTime(2026, 11, 9),
      weekdays: const [1, 3, 5],
      hours: const ['17:00:00'],
      trainers: const [PtGridTrainer(id: 8, name: 'Other T')],
      cells: const [],
    );
    var calls = 0;
    when(() => getGrid(any())).thenAnswer((_) {
      calls++;
      return calls == 1 ? slow.future : Future.value(Right(other));
    });
    final cubit = build();
    await cubit.init(42);
    pickThreeDays(cubit); // request 1 (slow)
    cubit.setStartDate(DateTime(2026, 10, 12)); // request 2 (fast)
    await Future<void>.delayed(Duration.zero);
    slow.complete(Right(grid)); // old response lands last
    await Future<void>.delayed(Duration.zero);

    expect(cubit.state.grid, other);
  });

  test('replan loads the product when the caller passed none', () async {
    final cubit = build();
    await cubit.initReplan(sold, const []);

    expect(cubit.state.status, LoadStatus.success);
    expect(cubit.state.product, product);
    verify(() => getProducts(any())).called(1);
  });

  test('replan fails visibly when the product cannot be found', () async {
    when(
      () => getProducts(any()),
    ).thenAnswer((_) async => const Right(<PtProduct>[]));
    final cubit = build();
    await cubit.initReplan(sold, const []);

    expect(cubit.state.status, LoadStatus.failure);
    expect(cubit.state.failure, isA<NotFoundFailure>());
  });

  test('retry after a failed replan init re-runs the replan init', () async {
    when(
      () => getProducts(any()),
    ).thenAnswer((_) async => const Left(NetworkFailure()));
    final cubit = build();
    await cubit.initReplan(sold, const []);
    expect(cubit.state.failure, isA<NetworkFailure>());

    when(
      () => getProducts(any()),
    ).thenAnswer((_) async => const Right([product]));
    await cubit.retry();
    expect(cubit.state.status, LoadStatus.success);
    expect(cubit.state.isReplan, isTrue);
  });

  test('a replan with nothing changed cannot be submitted', () async {
    final cubit = build();
    await cubit.initReplan(sold, const [product]);
    expect(cubit.state.slotChosen, isTrue);
    expect(cubit.state.canSubmit, isFalse);

    cubit.selectSlot(7, '17:00:00'); // same slot
    expect(cubit.state.canSubmit, isFalse);

    cubit.setStartDate(DateTime(2026, 10, 12)); // clears the slot
    expect(cubit.state.canSubmit, isFalse);
  });

  test('a replan with a different hour can be submitted', () async {
    final moved = PtScheduleGrid(
      startDate: DateTime(2026, 10, 5),
      endDate: DateTime(2026, 11, 2),
      weekdays: const [1, 3, 5],
      hours: const ['18:00:00'],
      trainers: const [PtGridTrainer(id: 7, name: 'Rina S')],
      cells: const [
        PtGridCell(
          trainerId: 7,
          slotStart: '18:00:00',
          status: PtGridCellStatus.free,
        ),
      ],
    );
    when(() => getGrid(any())).thenAnswer((_) async => Right(moved));
    final cubit = build();
    await cubit.initReplan(sold, const [product]);
    cubit.selectSlot(7, '18:00:00');

    expect(cubit.state.canSubmit, isTrue);
  });

  group('purchase idempotency key', () {
    Future<SellPtCubit> ready() async {
      final cubit = build();
      await cubit.init(42);
      pickThreeDays(cubit);
      await Future<void>.delayed(Duration.zero);
      cubit.selectSlot(7, '17:00:00');
      return cubit;
    }

    List<String?> keys() => verify(
      () => purchase(captureAny()),
    ).captured.cast<PurchasePtParams>().map((p) => p.idempotencyKey).toList();

    test('a retry of the same sale reuses the key', () async {
      when(
        () => purchase(any()),
      ).thenAnswer((_) async => const Left(NetworkFailure()));
      final cubit = await ready();
      await cubit.submit();
      await cubit.submit();

      final sent = keys();
      expect(sent, hasLength(2));
      expect(sent.first, isNotNull);
      expect(sent.first, sent.last);
    });

    test('a changed sale mints a new key', () async {
      when(
        () => purchase(any()),
      ).thenAnswer((_) async => const Left(NetworkFailure()));
      final cubit = await ready();
      await cubit.submit();
      cubit.setDiscount('50.00');
      await cubit.submit();

      final sent = keys();
      expect(sent.first, isNot(sent.last));
    });
  });

  test('a successful grid reload clears an earlier grid failure', () async {
    var first = true;
    when(() => getGrid(any())).thenAnswer((_) async {
      if (first) {
        first = false;
        return const Left(NetworkFailure());
      }
      return Right(grid);
    });
    final cubit = build();
    await cubit.init(42);
    cubit
      ..selectProduct(product)
      ..setStartDate(DateTime(2026, 10, 5))
      ..toggleWeekday(1);
    await Future<void>.delayed(Duration.zero);
    expect(cubit.state.failure, isA<NetworkFailure>());

    await cubit.loadGrid();
    expect(cubit.state.failure, isNull);
  });

  test('a payment-methods load failure is surfaced, not hidden', () async {
    when(
      () => getPaymentMethods(any()),
    ).thenAnswer((_) async => const Left(NetworkFailure()));
    final cubit = build();
    await cubit.init(42);

    expect(cubit.state.status, LoadStatus.failure);
    expect(cubit.state.failure, isA<NetworkFailure>());
  });

  test('submitting a replan sends the subscription and new slot', () async {
    final moved = PtScheduleGrid(
      startDate: DateTime(2026, 10, 5),
      endDate: DateTime(2026, 11, 2),
      weekdays: const [1, 3, 5],
      hours: const ['18:00:00'],
      trainers: const [PtGridTrainer(id: 7, name: 'Rina S')],
      cells: const [
        PtGridCell(
          trainerId: 7,
          slotStart: '18:00:00',
          status: PtGridCellStatus.free,
        ),
      ],
    );
    when(() => getGrid(any())).thenAnswer((_) async => Right(moved));
    when(() => replan(any())).thenAnswer((_) async => Right(sold));
    final cubit = build();
    await cubit.initReplan(sold, const [product]);
    cubit
      ..selectSlot(7, '18:00:00')
      ..setReason('moved shifts');
    await cubit.submit();

    final p =
        verify(() => replan(captureAny())).captured.single as ReplanPtParams;
    expect(p.subscription, sold);
    expect(p.slotStart, '18:00:00');
    expect(p.reason, 'moved shifts');
    expect(cubit.state.result, sold);
  });

  group('couple package', () {
    Future<SellPtCubit> readyCouple({Person? withPartner}) async {
      final cubit = build();
      await cubit.init(42);
      cubit
        ..selectProduct(coupleProduct)
        ..setStartDate(DateTime(2026, 10, 5))
        ..toggleWeekday(1)
        ..toggleWeekday(3)
        ..toggleWeekday(5);
      await Future<void>.delayed(Duration.zero);
      if (withPartner != null) {
        await cubit.selectPartner(withPartner);
        await Future<void>.delayed(Duration.zero);
      }
      return cubit;
    }

    test('couple product without a partner cannot be submitted', () async {
      final cubit = await readyCouple();
      cubit.selectSlot(7, '17:00:00');
      expect(cubit.state.isCoupleSelected, isTrue);
      expect(cubit.state.canSubmit, isFalse);
    });

    test('eligible partner enables submit and is sent on purchase', () async {
      final cubit = await readyCouple(withPartner: partner);
      expect(cubit.state.partnerCheck, isA<SellPtPartnerCheckOk>());
      cubit.selectSlot(7, '17:00:00');
      expect(cubit.state.canSubmit, isTrue);

      await cubit.submit();
      final p =
          verify(() => purchase(captureAny())).captured.single
              as PurchasePtParams;
      expect(p.partnerMemberId, 99);
    });

    test('grid params include partnerMemberId when a partner is set', () async {
      final cubit = await readyCouple(withPartner: partner);
      final params =
          verify(() => getGrid(captureAny())).captured.last
              as GetPtScheduleGridParams;
      expect(params.partnerMemberId, 99);
      expect(cubit.state.partner?.id, 99);
    });

    test('open PT on the partner blocks the sale', () async {
      when(() => getPtSummary(any())).thenAnswer(
        (_) async => Right(
          MemberPtSummary(
            current: PtSubscription(
              id: 1,
              memberId: 99,
              ptProductId: 3,
              trainerId: 7,
              startDate: DateTime(2026, 9, 1),
              endDate: DateTime(2026, 11, 3),
              weekdays: const [1],
              slotStart: '17:00:00',
              status: PtSubscriptionStatus.active,
              rowVersion: 1,
              productName: 'PT Monthly 3x',
              sessionsPerWeek: 1,
              trainerName: 'Rina S',
              slotLabel: '17:00-18:00',
            ),
          ),
        ),
      );
      final cubit = await readyCouple(withPartner: partner);
      final check = cubit.state.partnerCheck;
      expect(check, isA<SellPtPartnerCheckBlocked>());
      expect(
        (check as SellPtPartnerCheckBlocked).message,
        PtStrings.partnerHasOpenPt('Priya Shah', '03 Nov'),
      );
      cubit.selectSlot(7, '17:00:00');
      expect(cubit.state.canSubmit, isFalse);
    });

    test(
      'a partner with no membership is not blocked (PT bundles one)',
      () async {
        final cubit = await readyCouple(withPartner: partner);
        expect(cubit.state.partnerCheck, isA<SellPtPartnerCheckOk>());
      },
    );

    test('selecting a single package clears the partner', () async {
      final cubit = await readyCouple(withPartner: partner);
      expect(cubit.state.partner, isNotNull);

      cubit.selectProduct(product);
      expect(cubit.state.partner, isNull);
      expect(cubit.state.partnerCheck, isNull);
      expect(cubit.state.isCoupleSelected, isFalse);
    });

    test('changing the partner mints a new purchase idempotency key', () async {
      when(
        () => purchase(any()),
      ).thenAnswer((_) async => const Left(NetworkFailure()));
      final cubit = await readyCouple(withPartner: partner);
      cubit.selectSlot(7, '17:00:00');
      await cubit.submit();

      const other = Person(
        id: 100,
        userId: 200,
        membershipNumber: 'M-100',
        firstName: 'Omar',
        lastName: 'Ali',
      );
      await cubit.selectPartner(other);
      await Future<void>.delayed(Duration.zero);
      cubit.selectSlot(7, '17:00:00');
      await cubit.submit();

      final keys = verify(
        () => purchase(captureAny()),
      ).captured.cast<PurchasePtParams>().map((p) => p.idempotencyKey).toList();
      expect(keys, hasLength(2));
      expect(keys.first, isNot(keys.last));
    });
  });
}
