import 'package:app/core/error/failures.dart';
import 'package:app/core/presentation/load_status.dart';
import 'package:app/core/usecase/usecase.dart';
import 'package:app/features/payments/domain/entities/payment_method.dart';
import 'package:app/features/payments/domain/usecases/create_payment_method_usecase.dart';
import 'package:app/features/payments/domain/usecases/get_payment_methods_usecase.dart';
import 'package:app/features/payments/presentation/cubit/payment_methods_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockGetMethods extends Mock implements GetPaymentMethodsUseCase {}

class _MockCreateMethod extends Mock implements CreatePaymentMethodUseCase {}

void main() {
  late _MockGetMethods getMethods;
  late _MockCreateMethod createMethod;

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

  setUp(() {
    getMethods = _MockGetMethods();
    createMethod = _MockCreateMethod();
    registerFallbackValue(const NoParams());
    registerFallbackValue(
      const CreatePaymentMethodParams(methodName: 'x'),
    );
  });

  blocTest<PaymentMethodsCubit, PaymentMethodsState>(
    'loads payment methods',
    build: () {
      when(() => getMethods(any())).thenAnswer(
        (_) async => const Right([cash]),
      );
      return PaymentMethodsCubit(getMethods, createMethod);
    },
    act: (cubit) => cubit.load(),
    expect: () => [
      isA<PaymentMethodsState>().having(
        (s) => s.status,
        'status',
        LoadStatus.loading,
      ),
      isA<PaymentMethodsState>()
          .having((s) => s.status, 'status', LoadStatus.success)
          .having(
            (s) => s.items.map((m) => m.id).toList(),
            'ids',
            ['1'],
          ),
    ],
  );

  blocTest<PaymentMethodsCubit, PaymentMethodsState>(
    'createMethod success reloads list',
    build: () {
      var loadCount = 0;
      when(() => getMethods(any())).thenAnswer((_) async {
        loadCount += 1;
        if (loadCount == 1) return const Right([cash]);
        return const Right([cash, card]);
      });
      when(() => createMethod(any())).thenAnswer((_) async => const Right(card));
      return PaymentMethodsCubit(getMethods, createMethod);
    },
    act: (cubit) async {
      await cubit.load();
      await cubit.createMethod('Card', isDigital: true, isActive: true);
    },
    expect: () => [
      isA<PaymentMethodsState>().having(
        (s) => s.status,
        'status',
        LoadStatus.loading,
      ),
      isA<PaymentMethodsState>()
          .having((s) => s.status, 'status', LoadStatus.success)
          .having((s) => s.items.length, 'len', 1),
      isA<PaymentMethodsState>().having((s) => s.creating, 'creating', true),
      isA<PaymentMethodsState>()
          .having((s) => s.status, 'status', LoadStatus.loading)
          .having((s) => s.items.length, 'len', 1),
      isA<PaymentMethodsState>()
          .having((s) => s.status, 'status', LoadStatus.success)
          .having(
            (s) => s.items.map((m) => m.methodName).toList(),
            'names',
            ['Cash', 'Card'],
          ),
    ],
    verify: (_) {
      final captured = verify(() => createMethod(captureAny())).captured;
      expect(captured, hasLength(1));
      final params = captured.single as CreatePaymentMethodParams;
      expect(params.methodName, 'Card');
      expect(params.isDigital, isTrue);
      expect(params.isActive, isTrue);
    },
  );

  blocTest<PaymentMethodsCubit, PaymentMethodsState>(
    'createMethod failure keeps list and surfaces message',
    build: () {
      when(() => getMethods(any())).thenAnswer(
        (_) async => const Right([cash]),
      );
      when(() => createMethod(any())).thenAnswer(
        (_) async => const Left(NetworkFailure()),
      );
      return PaymentMethodsCubit(getMethods, createMethod);
    },
    act: (cubit) async {
      await cubit.load();
      await cubit.createMethod('Bad');
    },
    expect: () => [
      isA<PaymentMethodsState>().having(
        (s) => s.status,
        'status',
        LoadStatus.loading,
      ),
      isA<PaymentMethodsState>()
          .having((s) => s.status, 'status', LoadStatus.success)
          .having((s) => s.failure, 'failure', isNull),
      isA<PaymentMethodsState>().having((s) => s.creating, 'creating', true),
      isA<PaymentMethodsState>()
          .having((s) => s.status, 'status', LoadStatus.success)
          .having((s) => s.items.length, 'len', 1)
          .having((s) => s.failure, 'failure', isA<NetworkFailure>())
          .having((s) => s.creating, 'creating', false),
    ],
  );
}
