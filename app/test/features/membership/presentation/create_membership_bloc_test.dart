import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/core/pagination/cursor_page.dart';
import 'package:luxeknox/core/presentation/load_status.dart';
import 'package:luxeknox/core/usecase/usecase.dart';
import 'package:luxeknox/features/membership/domain/entities/membership.dart';
import 'package:luxeknox/features/membership/domain/entities/membership_product.dart';
import 'package:luxeknox/features/membership/domain/entities/membership_status.dart';
import 'package:luxeknox/features/membership/domain/usecases/create_membership_usecase.dart';
import 'package:luxeknox/features/membership/domain/usecases/get_membership_products_usecase.dart';
import 'package:luxeknox/features/membership/presentation/bloc/create_membership_bloc.dart';
import 'package:luxeknox/features/payments/domain/entities/payment_method.dart';
import 'package:luxeknox/features/payments/domain/usecases/get_payment_methods_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockCreateMembership extends Mock implements CreateMembershipUseCase {}

class MockGetProducts extends Mock implements GetMembershipProductsUseCase {}

class MockGetPaymentMethods extends Mock implements GetPaymentMethodsUseCase {}

void main() {
  late MockCreateMembership createMembership;
  late MockGetProducts getProducts;
  late MockGetPaymentMethods getPaymentMethods;

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
  });

  CreateMembershipBloc bloc() => CreateMembershipBloc(
    createMembership,
    getProducts,
    getPaymentMethods,
  );

  void stubCatalog({
    List<MembershipProduct> products = const [gold],
    List<PaymentMethod> methods = const [cash, card, inactive],
  }) {
    when(() => getProducts(any())).thenAnswer(
      (_) async => Right(
        CursorPage(items: products, nextCursor: null, hasMore: false),
      ),
    );
    when(() => getPaymentMethods(any())).thenAnswer((_) async => Right(methods));
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
}
