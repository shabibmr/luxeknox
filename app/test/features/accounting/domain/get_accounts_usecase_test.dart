import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/core/pagination/cursor_page.dart';
import 'package:luxeknox/features/accounting/domain/entities/account.dart';
import 'package:luxeknox/features/accounting/domain/repositories/accounting_repository.dart';
import 'package:luxeknox/features/accounting/domain/usecases/get_accounts_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockAccountingRepository extends Mock implements AccountingRepository {}

void main() {
  late MockAccountingRepository repository;
  late GetAccountsUseCase useCase;

  setUp(() {
    repository = MockAccountingRepository();
    useCase = GetAccountsUseCase(repository);
  });

  const tAccount = Account(
    id: '1',
    name: 'Cash on Hand',
    type: 'asset',
    isBank: true,
    isActive: true,
  );

  const tPage = CursorPage<Account>(
    items: [tAccount],
    nextCursor: 'cursor_2',
    hasMore: true,
  );

  test('should delegate to repository.getAccounts with provided params', () async {
    when(
      () => repository.getAccounts(
        limit: 20,
        offset: 0,
        accountType: 'asset',
        isActive: true,
        search: 'Cash',
      ),
    ).thenAnswer((_) async => const Right(tPage));

    const params = GetAccountsParams(
      limit: 20,
      offset: 0,
      accountType: 'asset',
      isActive: true,
      search: 'Cash',
    );

    final result = await useCase(params);

    expect(result, const Right(tPage));
    verify(
      () => repository.getAccounts(
        limit: 20,
        offset: 0,
        accountType: 'asset',
        isActive: true,
        search: 'Cash',
      ),
    ).called(1);
  });

  test('should return Failure when repository returns Left(Failure)', () async {
    when(
      () => repository.getAccounts(
        limit: any(named: 'limit'),
        offset: any(named: 'offset'),
        accountType: any(named: 'accountType'),
        isActive: any(named: 'isActive'),
        search: any(named: 'search'),
      ),
    ).thenAnswer((_) async => const Left(NetworkFailure()));

    const params = GetAccountsParams();
    final result = await useCase(params);

    expect(result, const Left(NetworkFailure()));
    verify(
      () => repository.getAccounts(
        limit: null,
        offset: null,
        accountType: null,
        isActive: null,
        search: null,
      ),
    ).called(1);
  });
}
