import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/core/pagination/cursor_page.dart';
import 'package:luxeknox/core/presentation/load_status.dart';
import 'package:luxeknox/core/usecase/usecase.dart';
import 'package:luxeknox/features/membership/domain/entities/membership.dart';
import 'package:luxeknox/features/membership/domain/entities/membership_product.dart';
import 'package:luxeknox/features/membership/domain/entities/membership_replacement_preview.dart';
import 'package:luxeknox/features/membership/domain/entities/membership_status.dart';
import 'package:luxeknox/features/membership/domain/usecases/create_membership_usecase.dart';
import 'package:luxeknox/features/membership/domain/usecases/get_membership_products_usecase.dart';
import 'package:luxeknox/features/membership/domain/usecases/get_replacement_preview_usecase.dart';
import 'package:luxeknox/features/membership/presentation/bloc/create_membership_bloc.dart';
import 'package:luxeknox/features/payments/domain/entities/payment_method.dart';
import 'package:luxeknox/features/payments/domain/usecases/get_payment_methods_usecase.dart';
import 'package:luxeknox/features/people/domain/entities/profile_summary.dart';
import 'package:mocktail/mocktail.dart';

class MockCreateMembership extends Mock implements CreateMembershipUseCase {}

class MockGetProducts extends Mock implements GetMembershipProductsUseCase {}

class MockGetPaymentMethods extends Mock implements GetPaymentMethodsUseCase {}

class MockGetReplacementPreview extends Mock
    implements GetReplacementPreviewUseCase {}

void main() {
  late MockCreateMembership createMembership;
  late MockGetProducts getProducts;
  late MockGetPaymentMethods getPaymentMethods;
  late MockGetReplacementPreview getReplacementPreview;

  const couple = MembershipProduct(
    id: '20',
    name: 'Couple Monthly',
    code: 'CPL-M',
    durationDays: 30,
    basePrice: '2000.00',
    isActive: true,
    packageType: MembershipPackageType.couple,
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
    endDate: DateTime(2026, 1, 23),
    remainingDays: 22,
    isCouple: false,
    suggestedCredit: '733.33',
  );

  const gold = MembershipProduct(
    id: '10',
    name: 'Gold',
    code: 'GOLD',
    durationDays: 30,
    basePrice: '1299.00',
    isActive: true,
  );
  const cash = PaymentMethod(
    id: '1',
    methodName: 'Cash',
    isDigital: false,
    isActive: true,
  );
  const card = PaymentMethod(
    id: '2',
    methodName: 'Card',
    isDigital: true,
    isActive: true,
  );
  const inactive = PaymentMethod(
    id: '3',
    methodName: 'Old',
    isDigital: false,
    isActive: false,
  );

  final created = Membership(
    id: '55',
    memberId: '100',
    productId: '10',
    startDate: DateTime(2026, 1, 1),
    endDate: DateTime(2026, 1, 31),
    status: MembershipStatus.active,
    rowVersion: 1,
  );

  setUpAll(() {
    registerFallbackValue(const GetMembershipProductsParams());
    registerFallbackValue(const NoParams());
    registerFallbackValue('');
    registerFallbackValue(
      CreateMembershipParams(
        memberId: '100',
        productId: '10',
        startDate: DateTime(2026, 1, 1),
        paymentMethodId: '1',
      ),
    );
  });

  setUp(() {
    createMembership = MockCreateMembership();
    getProducts = MockGetProducts();
    getPaymentMethods = MockGetPaymentMethods();
    getReplacementPreview = MockGetReplacementPreview();
  });

  CreateMembershipBloc bloc() => CreateMembershipBloc(
    createMembership,
    getProducts,
    getPaymentMethods,
    getReplacementPreview,
  );

  void stubPreview(MembershipReplacementPreview? preview) {
    when(
      () => getReplacementPreview(any()),
    ).thenAnswer((_) async => Right(preview));
  }

  /// A couple sale ready to submit, with [overrides] applied on top.
  CreateMembershipState coupleSeed({
    ProfileSummary? selectedPartner = partner,
    MembershipReplacementPreview? partnerReplacement,
    bool replaceConfirmed = false,
    bool checkingPartner = false,
    String? discountAmount,
    String selectedMemberId = '100',
  }) => CreateMembershipState(
    status: LoadStatus.success,
    products: const [gold, couple],
    paymentMethods: const [cash],
    selectedMemberId: selectedMemberId,
    selectedProductId: '20',
    selectedPaymentMethodId: '1',
    startDate: DateTime(2026, 1, 1),
    selectedPartner: selectedPartner,
    partnerReplacement: partnerReplacement,
    replaceConfirmed: replaceConfirmed,
    checkingPartner: checkingPartner,
    discountAmount: discountAmount,
  );

  CreateMembershipParams capturedParams() =>
      verify(() => createMembership(captureAny())).captured.single
          as CreateMembershipParams;

  Matcher fieldError(String message) => isA<CreateMembershipState>().having(
    (s) => s.fieldError,
    'fieldError',
    message,
  );

  void stubCatalog({
    List<MembershipProduct> products = const [gold],
    List<PaymentMethod> methods = const [cash, card, inactive],
  }) {
    when(() => getProducts(any())).thenAnswer(
      (_) async =>
          Right(CursorPage(items: products, nextCursor: null, hasMore: false)),
    );
    when(
      () => getPaymentMethods(any()),
    ).thenAnswer((_) async => Right(methods));
  }

  blocTest<CreateMembershipBloc, CreateMembershipState>(
    'loads active products and payment methods; auto-selects the only method',
    build: () {
      stubCatalog(methods: const [cash, inactive]);
      return bloc();
    },
    act: (b) => b.add(const CreateMembershipStarted(memberId: '100')),
    expect: () => [
      isA<CreateMembershipState>().having(
        (s) => s.status,
        'status',
        LoadStatus.loading,
      ),
      isA<CreateMembershipState>()
          .having((s) => s.status, 'status', LoadStatus.success)
          .having((s) => s.products, 'products', [gold])
          .having((s) => s.paymentMethods, 'methods', [cash])
          .having((s) => s.selectedPaymentMethodId, 'method', '1')
          .having((s) => s.selectedMemberId, 'member', '100'),
    ],
  );

  blocTest<CreateMembershipBloc, CreateMembershipState>(
    'fails the form load when payment methods cannot be fetched',
    build: () {
      when(() => getProducts(any())).thenAnswer(
        (_) async => const Right(
          CursorPage(items: [gold], nextCursor: null, hasMore: false),
        ),
      );
      when(
        () => getPaymentMethods(any()),
      ).thenAnswer((_) async => const Left(UnknownFailure()));
      return bloc();
    },
    act: (b) => b.add(const CreateMembershipStarted()),
    expect: () => [
      isA<CreateMembershipState>().having(
        (s) => s.status,
        'status',
        LoadStatus.loading,
      ),
      isA<CreateMembershipState>()
          .having((s) => s.status, 'status', LoadStatus.failure)
          .having((s) => s.failure, 'failure', isA<UnknownFailure>()),
    ],
  );

  blocTest<CreateMembershipBloc, CreateMembershipState>(
    'requires a payment method before submit',
    build: bloc,
    seed: () => CreateMembershipState(
      status: LoadStatus.success,
      products: const [gold],
      paymentMethods: const [cash, card],
      selectedMemberId: '100',
      selectedProductId: '10',
      startDate: DateTime(2026, 1, 1),
    ),
    act: (b) => b.add(const CreateMembershipSubmitted()),
    expect: () => [
      isA<CreateMembershipState>().having(
        (s) => s.fieldError,
        'fieldError',
        'Select a payment method',
      ),
    ],
    verify: (_) {
      verifyNever(() => createMembership(any()));
    },
  );

  blocTest<CreateMembershipBloc, CreateMembershipState>(
    'submits payment_method_id with the membership',
    build: () {
      when(
        () => createMembership(any()),
      ).thenAnswer((_) async => Right(created));
      return bloc();
    },
    seed: () => CreateMembershipState(
      status: LoadStatus.success,
      products: const [gold],
      paymentMethods: const [cash, card],
      selectedMemberId: '100',
      selectedProductId: '10',
      selectedPaymentMethodId: '2',
      startDate: DateTime(2026, 1, 1),
    ),
    act: (b) => b.add(const CreateMembershipSubmitted()),
    verify: (b) {
      expect(b.state.created?.id, '55');
      final captured =
          verify(() => createMembership(captureAny())).captured.single
              as CreateMembershipParams;
      expect(captured.paymentMethodId, '2');
      expect(captured.memberId, '100');
      expect(captured.productId, '10');
    },
  );

  group('couple package', () {
    blocTest<CreateMembershipBloc, CreateMembershipState>(
      'PartnerSelected without a replacement leaves nothing to confirm',
      build: () {
        stubPreview(null);
        return bloc();
      },
      seed: () => coupleSeed(selectedPartner: null),
      act: (b) => b.add(const CreateMembershipPartnerSelected(partner)),
      expect: () => [
        isA<CreateMembershipState>()
            .having((s) => s.selectedPartner, 'partner', partner)
            .having((s) => s.checkingPartner, 'checking', true),
        isA<CreateMembershipState>()
            .having((s) => s.checkingPartner, 'checking', false)
            .having((s) => s.partnerReplacement, 'preview', isNull)
            .having((s) => s.discountAmount, 'discount', isNull),
      ],
      verify: (_) {
        verify(() => getReplacementPreview('200')).called(1);
      },
    );

    blocTest<CreateMembershipBloc, CreateMembershipState>(
      'PartnerSelected stores the preview and pre-fills the suggested credit',
      build: () {
        stubPreview(replacement);
        return bloc();
      },
      seed: () => coupleSeed(selectedPartner: null),
      act: (b) => b.add(const CreateMembershipPartnerSelected(partner)),
      skip: 1,
      expect: () => [
        isA<CreateMembershipState>()
            .having((s) => s.partnerReplacement, 'preview', replacement)
            .having((s) => s.discountAmount, 'discount', '733.33')
            .having((s) => s.replaceConfirmed, 'confirmed', false)
            .having((s) => s.checkingPartner, 'checking', false),
      ],
    );

    blocTest<CreateMembershipBloc, CreateMembershipState>(
      'PartnerSelected clears the partner when the preview fails',
      build: () {
        when(
          () => getReplacementPreview(any()),
        ).thenAnswer((_) async => const Left(UnknownFailure()));
        return bloc();
      },
      seed: () => coupleSeed(selectedPartner: null),
      act: (b) => b.add(const CreateMembershipPartnerSelected(partner)),
      skip: 1,
      expect: () => [
        isA<CreateMembershipState>()
            .having((s) => s.selectedPartner, 'partner', isNull)
            .having((s) => s.checkingPartner, 'checking', false)
            .having((s) => s.submitError, 'submitError', isNotNull),
      ],
    );

    blocTest<CreateMembershipBloc, CreateMembershipState>(
      'ReplaceConfirmed(true) records the confirmation',
      build: bloc,
      seed: () =>
          coupleSeed(partnerReplacement: replacement, discountAmount: '733.33'),
      act: (b) => b.add(const CreateMembershipReplaceConfirmed(true)),
      expect: () => [
        isA<CreateMembershipState>()
            .having((s) => s.replaceConfirmed, 'confirmed', true)
            .having((s) => s.selectedPartner, 'partner', partner)
            .having((s) => s.discountAmount, 'discount', '733.33'),
      ],
    );

    blocTest<CreateMembershipBloc, CreateMembershipState>(
      'ReplaceConfirmed(false) clears the partner, preview and discount',
      build: bloc,
      seed: () =>
          coupleSeed(partnerReplacement: replacement, discountAmount: '733.33'),
      act: (b) => b.add(const CreateMembershipReplaceConfirmed(false)),
      expect: () => [
        isA<CreateMembershipState>()
            .having((s) => s.selectedPartner, 'partner', isNull)
            .having((s) => s.partnerReplacement, 'preview', isNull)
            .having((s) => s.replaceConfirmed, 'confirmed', false)
            .having((s) => s.discountAmount, 'discount', isNull),
      ],
    );

    blocTest<CreateMembershipBloc, CreateMembershipState>(
      'DiscountChanged stores the trimmed value and clears it when empty',
      build: bloc,
      seed: () => coupleSeed(discountAmount: '10.00'),
      act: (b) => b
        ..add(const CreateMembershipDiscountChanged(' 250.50 '))
        ..add(const CreateMembershipDiscountChanged('')),
      expect: () => [
        isA<CreateMembershipState>().having(
          (s) => s.discountAmount,
          'discount',
          '250.50',
        ),
        isA<CreateMembershipState>().having(
          (s) => s.discountAmount,
          'discount',
          isNull,
        ),
      ],
    );

    blocTest<CreateMembershipBloc, CreateMembershipState>(
      'selecting a single package clears the partner, preview and discount',
      build: bloc,
      seed: () => coupleSeed(
        partnerReplacement: replacement,
        replaceConfirmed: true,
        discountAmount: '733.33',
      ),
      act: (b) => b.add(const CreateMembershipProductSelected('10')),
      expect: () => [
        isA<CreateMembershipState>()
            .having((s) => s.selectedProductId, 'product', '10')
            .having((s) => s.isCoupleSelected, 'isCouple', false)
            .having((s) => s.selectedPartner, 'partner', isNull)
            .having((s) => s.partnerReplacement, 'preview', isNull)
            .having((s) => s.replaceConfirmed, 'confirmed', false)
            .having((s) => s.discountAmount, 'discount', isNull),
      ],
    );

    blocTest<CreateMembershipBloc, CreateMembershipState>(
      'selecting a couple package after a single one starts with no partner',
      build: bloc,
      seed: () => coupleSeed(
        selectedPartner: null,
      ).copyWith(selectedProductId: '10', discountAmount: '5.00'),
      act: (b) => b.add(const CreateMembershipProductSelected('20')),
      expect: () => [
        isA<CreateMembershipState>()
            .having((s) => s.isCoupleSelected, 'isCouple', true)
            .having((s) => s.discountAmount, 'discount', isNull),
      ],
    );

    blocTest<CreateMembershipBloc, CreateMembershipState>(
      'a stale preview for a replaced partner is ignored',
      build: () {
        when(() => getReplacementPreview(any())).thenAnswer((_) async {
          await Future<void>.delayed(const Duration(milliseconds: 10));
          return Right(replacement);
        });
        return bloc();
      },
      seed: () => coupleSeed(selectedPartner: null),
      act: (b) {
        b.add(const CreateMembershipPartnerSelected(partner));
        b.add(const CreateMembershipProductSelected('10'));
      },
      wait: const Duration(milliseconds: 50),
      verify: (b) {
        expect(b.state.selectedPartner, isNull);
        expect(b.state.partnerReplacement, isNull);
      },
    );

    group('submit validation', () {
      blocTest<CreateMembershipBloc, CreateMembershipState>(
        'requires a partner',
        build: bloc,
        seed: () => coupleSeed(selectedPartner: null),
        act: (b) => b.add(const CreateMembershipSubmitted()),
        expect: () => [fieldError('Select a partner for the couple package')],
        verify: (_) => verifyNever(() => createMembership(any())),
      );

      blocTest<CreateMembershipBloc, CreateMembershipState>(
        'rejects the primary member as their own partner',
        build: bloc,
        seed: () => coupleSeed(selectedMemberId: '200'),
        act: (b) => b.add(const CreateMembershipSubmitted()),
        expect: () => [fieldError('Partner must be a different member')],
        verify: (_) => verifyNever(() => createMembership(any())),
      );

      blocTest<CreateMembershipBloc, CreateMembershipState>(
        'waits for the partner check to finish',
        build: bloc,
        seed: () => coupleSeed(checkingPartner: true),
        act: (b) => b.add(const CreateMembershipSubmitted()),
        expect: () => [fieldError("Checking the partner's membership")],
        verify: (_) => verifyNever(() => createMembership(any())),
      );

      blocTest<CreateMembershipBloc, CreateMembershipState>(
        'requires the replacement to be confirmed when a preview exists',
        build: bloc,
        seed: () => coupleSeed(partnerReplacement: replacement),
        act: (b) => b.add(const CreateMembershipSubmitted()),
        expect: () => [
          fieldError("Confirm replacing the partner's current membership"),
        ],
        verify: (_) => verifyNever(() => createMembership(any())),
      );

      blocTest<CreateMembershipBloc, CreateMembershipState>(
        'rejects a partner who is already in a couple membership',
        build: bloc,
        seed: () => coupleSeed(
          partnerReplacement: MembershipReplacementPreview(
            membershipId: '88',
            productName: 'Couple Annual',
            status: MembershipStatus.active,
            endDate: DateTime(2026, 6, 1),
            remainingDays: 100,
            isCouple: true,
            suggestedCredit: '500.00',
          ),
          replaceConfirmed: true,
        ),
        act: (b) => b.add(const CreateMembershipSubmitted()),
        expect: () => [fieldError('Partner already has a couple membership')],
        verify: (_) => verifyNever(() => createMembership(any())),
      );

      for (final bad in ['2000.01', '-1', 'abc', '1e2', '+5', '1.']) {
        blocTest<CreateMembershipBloc, CreateMembershipState>(
          'rejects discount "$bad" outside 0..price',
          build: bloc,
          seed: () => coupleSeed(discountAmount: bad),
          act: (b) => b.add(const CreateMembershipSubmitted()),
          expect: () => [
            fieldError('Discount must be between 0 and the package price'),
          ],
          verify: (_) => verifyNever(() => createMembership(any())),
        );
      }
    });

    group('submit', () {
      blocTest<CreateMembershipBloc, CreateMembershipState>(
        'sends the partner and discount, with no replace flag when nothing is replaced',
        build: () {
          when(
            () => createMembership(any()),
          ).thenAnswer((_) async => Right(created));
          return bloc();
        },
        seed: () => coupleSeed(discountAmount: '0'),
        act: (b) => b.add(const CreateMembershipSubmitted()),
        verify: (b) {
          final p = capturedParams();
          expect(p.productId, '20');
          expect(p.partnerMemberId, '200');
          expect(p.replacePartnerMembership, isNull);
          expect(p.discountAmount, '0');
          expect(b.state.created?.id, '55');
        },
      );

      blocTest<CreateMembershipBloc, CreateMembershipState>(
        'sends replace_partner_membership and the edited discount after confirmation',
        build: () {
          when(
            () => createMembership(any()),
          ).thenAnswer((_) async => Right(created));
          return bloc();
        },
        seed: () => coupleSeed(
          partnerReplacement: replacement,
          replaceConfirmed: true,
          discountAmount: '700.00',
        ),
        act: (b) => b.add(const CreateMembershipSubmitted()),
        verify: (_) {
          final p = capturedParams();
          expect(p.partnerMemberId, '200');
          expect(p.replacePartnerMembership, isTrue);
          expect(p.discountAmount, '700.00');
        },
      );

      blocTest<CreateMembershipBloc, CreateMembershipState>(
        'a single package never sends partner fields',
        build: () {
          when(
            () => createMembership(any()),
          ).thenAnswer((_) async => Right(created));
          return bloc();
        },
        seed: () => coupleSeed(
          partnerReplacement: replacement,
          discountAmount: '700.00',
        ).copyWith(selectedProductId: '10'),
        act: (b) => b.add(const CreateMembershipSubmitted()),
        verify: (_) {
          final p = capturedParams();
          expect(p.partnerMemberId, isNull);
          expect(p.replacePartnerMembership, isNull);
          expect(p.discountAmount, isNull);
        },
      );
    });
  });
}
