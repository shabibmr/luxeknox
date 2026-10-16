import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/features/accounting/domain/entities/go_live.dart';
import 'package:luxeknox/features/accounting/domain/repositories/accounting_repository.dart';
import 'package:luxeknox/features/accounting/domain/usecases/map_payment_method_account_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockAccountingRepository extends Mock implements AccountingRepository {}

void main() {
  late MockAccountingRepository repository;
  late MapPaymentMethodAccountUseCase useCase;

  setUp(() {
    repository = MockAccountingRepository();
    useCase = MapPaymentMethodAccountUseCase(repository);
  });

  const tMapping = GoLivePaymentMethodMapping(
    id: 1,
    methodName: 'Cash',
    isActive: true,
    isDigital: false,
    accountId: 10,
    accountName: 'Cash on Hand',
  );

  test('should delegate to repository.mapPaymentMethodAccount', () async {
    when(
      () => repository.mapPaymentMethodAccount(
        paymentMethodId: 1,
        accountId: 10,
      ),
    ).thenAnswer((_) async => const Right(tMapping));

    final result = await useCase(
      const MapPaymentMethodAccountParams(
        paymentMethodId: 1,
        accountId: 10,
      ),
    );

    expect(result, const Right(tMapping));
    verify(
      () => repository.mapPaymentMethodAccount(
        paymentMethodId: 1,
        accountId: 10,
      ),
    ).called(1);
  });

  test('should allow unmapping account with accountId: null', () async {
    const tUnmapped = GoLivePaymentMethodMapping(
      id: 1,
      methodName: 'Cash',
      isActive: true,
      isDigital: false,
      accountId: null,
      accountName: null,
    );

    when(
      () => repository.mapPaymentMethodAccount(
        paymentMethodId: 1,
        accountId: null,
      ),
    ).thenAnswer((_) async => const Right(tUnmapped));

    final result = await useCase(
      const MapPaymentMethodAccountParams(
        paymentMethodId: 1,
        accountId: null,
      ),
    );

    expect(result, const Right(tUnmapped));
    verify(
      () => repository.mapPaymentMethodAccount(
        paymentMethodId: 1,
        accountId: null,
      ),
    ).called(1);
  });

  test('should return Failure when repository fails', () async {
    when(
      () => repository.mapPaymentMethodAccount(
        paymentMethodId: any(named: 'paymentMethodId'),
        accountId: any(named: 'accountId'),
      ),
    ).thenAnswer((_) async => const Left(NetworkFailure()));

    final result = await useCase(
      const MapPaymentMethodAccountParams(
        paymentMethodId: 1,
        accountId: 10,
      ),
    );

    expect(result, const Left(NetworkFailure()));
  });
}
