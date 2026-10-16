import 'package:api_client/api_client.dart' as api;
import 'package:built_collection/built_collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/features/accounting/data/datasources/accounting_remote_datasource.dart';
import 'package:luxeknox/features/accounting/data/repositories/accounting_repository_impl.dart';
import 'package:mocktail/mocktail.dart';

class MockAccountingRemoteDataSource extends Mock
    implements AccountingRemoteDataSource {}

void main() {
  late MockAccountingRemoteDataSource mockDataSource;
  late AccountingRepositoryImpl repository;

  final tDate = api.Date(2026, 1, 1);
  final req = RequestOptions(path: '/accounting');

  final tApiAccount = api.Account((b) {
    b
      ..id = 1
      ..name = 'Cash on Hand'
      ..accountType = api.AccountType.asset
      ..isActive = true
      ..isBank = true
      ..isControl = false
      ..controlRole = 'cash'
      ..createdAt = DateTime.utc(2026, 1, 1)
      ..updatedAt = DateTime.utc(2026, 1, 1);
  });

  final tAccountPage = api.AccountPage((b) {
    b
      ..data.replace([tApiAccount])
      ..meta.limit = 20
      ..meta.offset = 0
      ..meta.total = 1
      ..meta.hasMore = false;
  });

  setUpAll(() {
    registerFallbackValue(
      api.AccountCreate((b) => b
        ..name = 'Cash'
        ..accountType = api.AccountType.asset),
    );
    registerFallbackValue(api.AccountUpdate((b) => b..name = 'Updated'));
    registerFallbackValue(
      api.JournalCreate((b) => b
        ..entryDate = api.Date(2026, 1, 1)
        ..sourceType = api.JournalCreateSourceTypeEnum.manual
        ..lines.replace([])),
    );
    registerFallbackValue(
      api.JournalReverse((b) => b
        ..entryDate = api.Date(2026, 1, 1)
        ..memo = 'Mistake'),
    );
    registerFallbackValue(api.Date(2026, 1, 1));
  });

  setUp(() {
    mockDataSource = MockAccountingRemoteDataSource();
    repository = AccountingRepositoryImpl(mockDataSource);
  });

  group('Accounts', () {
    test('getAccounts returns mapped CursorPage on success', () async {
      when(
        () => mockDataSource.listAccounts(
          limit: any(named: 'limit'),
          offset: any(named: 'offset'),
          accountType: any(named: 'accountType'),
          isActive: any(named: 'isActive'),
          search: any(named: 'search'),
        ),
      ).thenAnswer((_) async => tAccountPage);

      final result = await repository.getAccounts(
        limit: 20,
        offset: 0,
        accountType: 'asset',
        isActive: true,
        search: 'Cash',
      );

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('expected right, got $failure'),
        (page) {
          expect(page.items.length, 1);
          final acc = page.items.first;
          expect(acc.id, '1');
          expect(acc.name, 'Cash on Hand');
          expect(acc.type, 'asset');
          expect(acc.isBank, isTrue);
          expect(acc.isActive, isTrue);
        },
      );
    });

    test('getAccounts returns Failure when datasource throws', () async {
      when(
        () => mockDataSource.listAccounts(
          limit: any(named: 'limit'),
          offset: any(named: 'offset'),
          accountType: any(named: 'accountType'),
          isActive: any(named: 'isActive'),
          search: any(named: 'search'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: req,
          type: DioExceptionType.connectionError,
        ),
      );

      final result = await repository.getAccounts();

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure, isA<NetworkFailure>()),
        (_) => fail('expected failure'),
      );
    });

    test('getAccount with non-integer id returns Left(NotFoundFailure)', () async {
      final result = await repository.getAccount('invalid-id');
      expect(result, const Left(NotFoundFailure()));
      verifyZeroInteractions(mockDataSource);
    });

    test('getAccount returns mapped Account on success', () async {
      when(() => mockDataSource.getAccount(1)).thenAnswer((_) async => tApiAccount);

      final result = await repository.getAccount('1');

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('expected right'),
        (account) {
          expect(account.id, '1');
          expect(account.name, 'Cash on Hand');
        },
      );
      verify(() => mockDataSource.getAccount(1)).called(1);
    });

    test('createAccount calls datasource and returns mapped Account', () async {
      when(() => mockDataSource.createAccount(any()))
          .thenAnswer((_) async => tApiAccount);

      final result = await repository.createAccount(
        name: 'Cash on Hand',
        accountType: 'asset',
        isBank: true,
      );

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('expected right'),
        (account) => expect(account.name, 'Cash on Hand'),
      );
    });

    test('updateAccount with non-integer id returns NotFoundFailure', () async {
      final result = await repository.updateAccount(
        id: 'bad',
        name: 'Updated',
      );
      expect(result, const Left(NotFoundFailure()));
    });

    test('updateAccount forwards params and returns mapped Account', () async {
      when(
        () => mockDataSource.updateAccount(
          id: 1,
          accountUpdate: any(named: 'accountUpdate'),
        ),
      ).thenAnswer((_) async => tApiAccount);

      final result = await repository.updateAccount(
        id: '1',
        name: 'Cash on Hand',
      );

      expect(result.isRight(), isTrue);
      verify(
        () => mockDataSource.updateAccount(
          id: 1,
          accountUpdate: any(named: 'accountUpdate'),
        ),
      ).called(1);
    });
  });

  group('Journals', () {
    final tJournal = api.Journal((b) {
      b
        ..id = 10
        ..journalNumber = 'J-10'
        ..entryDate = tDate
        ..accountingPeriodId = 1
        ..sourceType = 'manual'
        ..sourceId = 1
        ..postedAt = DateTime.utc(2026, 1, 1)
        ..lines.replace([])
        ..rowVersion = 1;
    });

    test('getJournals returns CursorPage<Journal>', () async {
      final tJournalPage = api.JournalPage((b) {
        b
          ..data.replace([tJournal])
          ..meta.limit = 20
          ..meta.offset = 0
          ..meta.total = 1
          ..meta.hasMore = false;
      });

      when(
        () => mockDataSource.listJournals(
          limit: any(named: 'limit'),
          offset: any(named: 'offset'),
          from: any(named: 'from'),
          to: any(named: 'to'),
          sourceType: any(named: 'sourceType'),
          paymentId: any(named: 'paymentId'),
        ),
      ).thenAnswer((_) async => tJournalPage);

      final result = await repository.getJournals(limit: 20);

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('expected right'),
        (page) {
          expect(page.items.length, 1);
          expect(page.items.first.journalNumber, 'J-10');
        },
      );
    });

    test('getJournal with non-integer id returns NotFoundFailure', () async {
      final result = await repository.getJournal('not-an-int');
      expect(result, const Left(NotFoundFailure()));
    });

    test('getJournal returns mapped Journal', () async {
      when(() => mockDataSource.getJournal(10)).thenAnswer((_) async => tJournal);

      final result = await repository.getJournal('10');

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('expected right'),
        (journal) => expect(journal.id, '10'),
      );
    });
  });

  group('Fiscal Periods', () {
    final tPeriod = api.AccountingPeriod((b) {
      b
        ..id = 3
        ..fiscalYearId = 1
        ..startsOn = tDate
        ..endsOn = tDate
        ..status = api.AccountingPeriodStatusEnum.open;
    });

    test('getAccountingPeriods returns List<AccountingPeriod>', () async {
      when(
        () => mockDataSource.listAccountingPeriods(
          fiscalYearId: any(named: 'fiscalYearId'),
          status: any(named: 'status'),
        ),
      ).thenAnswer((_) async => BuiltList([tPeriod]));

      final result = await repository.getAccountingPeriods();

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('expected right'),
        (periods) {
          expect(periods.length, 1);
          expect(periods.first.id, '3');
          expect(periods.first.isLocked, isFalse);
        },
      );
    });

    test('lockAccountingPeriod locks period and returns updated period', () async {
      final tLocked = tPeriod.rebuild((b) => b..status = api.AccountingPeriodStatusEnum.locked);
      when(() => mockDataSource.lockAccountingPeriod(3))
          .thenAnswer((_) async => tLocked);

      final result = await repository.lockAccountingPeriod('3');

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('expected right'),
        (period) => expect(period.isLocked, isTrue),
      );
    });

    test('unlockAccountingPeriod unlocks period', () async {
      when(() => mockDataSource.unlockAccountingPeriod(3))
          .thenAnswer((_) async => tPeriod);

      final result = await repository.unlockAccountingPeriod('3');

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('expected right'),
        (period) => expect(period.isLocked, isFalse),
      );
    });
  });

  group('Reports', () {
    test('getOpenItems returns mapped OpenItemsReport', () async {
      final tReport = api.OpenItemsReport((b) {
        b
          ..kind = api.OpenItemsReportKindEnum.ar
          ..totalOpenAmount = '1500.00'
          ..arItems.replace([])
          ..apItems.replace([]);
      });

      when(() => mockDataSource.getOpenItems('ar'))
          .thenAnswer((_) async => tReport);

      final result = await repository.getOpenItems(kind: 'ar');

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('expected right'),
        (report) {
          expect(report.kind, 'ar');
          expect(report.totalOpenAmount, '1500.00');
        },
      );
    });

    test('getTrialBalance returns mapped TrialBalanceReport', () async {
      final tReport = api.TrialBalanceReport((b) {
        b
          ..to = tDate
          ..totalDebit = '1000.00'
          ..totalCredit = '1000.00'
          ..accounts.replace([]);
      });

      when(
        () => mockDataSource.getTrialBalance(
          from: any(named: 'from'),
          to: any(named: 'to'),
        ),
      ).thenAnswer((_) async => tReport);

      final result = await repository.getTrialBalance(
        to: DateTime.utc(2026, 1, 1),
      );

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('expected right'),
        (report) {
          expect(report.totalDebit, '1000.00');
          expect(report.totalCredit, '1000.00');
        },
      );
    });

    test('getDayBook maps debit and credit totals from API', () async {
      final tReport = api.DayBookReport((b) {
        b
          ..date = tDate
          ..totalDebit = '250.00'
          ..totalCredit = '250.00'
          ..journals.replace([]);
      });

      when(
        () => mockDataSource.getDayBook(date: any(named: 'date')),
      ).thenAnswer((_) async => tReport);

      final result = await repository.getDayBook(date: DateTime.utc(2026, 1, 1));

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('expected right'),
        (report) {
          expect(report.totalDebit, '250.00');
          expect(report.totalCredit, '250.00');
        },
      );
    });

    test('getBalanceSheet maps liabilities-and-equity total from API', () async {
      final tReport = api.BalanceSheetReport((b) {
        b
          ..asOf = tDate
          ..fiscalYearStart = tDate
          ..totalAssets = '500.00'
          ..totalLiabilities = '200.00'
          ..totalEquity = '300.00'
          ..currentYearEarnings = '50.00'
          ..totalLiabilitiesAndEquity = '500.00'
          ..assetAccounts.replace([])
          ..liabilityAccounts.replace([])
          ..equityAccounts.replace([]);
      });

      when(
        () => mockDataSource.getBalanceSheet(asOf: any(named: 'asOf')),
      ).thenAnswer((_) async => tReport);

      final result =
          await repository.getBalanceSheet(asOf: DateTime.utc(2026, 1, 1));

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('expected right'),
        (report) {
          expect(report.totalAssets, '500.00');
          expect(report.totalLiabilitiesAndEquity, '500.00');
          expect(report.currentYearEarnings, '50.00');
        },
      );
    });

    test('getGstSummary maps output components and net payable from API',
        () async {
      final tReport = api.GstSummaryReport((b) {
        b
          ..from = tDate
          ..to = tDate
          ..totalTaxableValue = '100.00'
          ..outputCgst = '9.00'
          ..outputSgst = '9.00'
          ..outputIgst = '0.00'
          ..totalOutputTax = '18.00'
          ..inputTaxCredit = '5.00'
          ..netPayable = '13.00'
          ..taxCodes.replace([]);
      });

      when(
        () => mockDataSource.getGstSummary(
          from: any(named: 'from'),
          to: any(named: 'to'),
        ),
      ).thenAnswer((_) async => tReport);

      final result = await repository.getGstSummary(
        from: DateTime.utc(2026, 1, 1),
        to: DateTime.utc(2026, 1, 1),
      );

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('expected right'),
        (report) {
          expect(report.outputCgst, '9.00');
          expect(report.outputSgst, '9.00');
          expect(report.outputIgst, '0.00');
          expect(report.totalOutputTax, '18.00');
          expect(report.totalInputTax, '5.00');
          expect(report.netTaxPayable, '13.00');
        },
      );
    });
  });
}
