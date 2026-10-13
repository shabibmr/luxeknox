import 'package:api_client/api_client.dart' as api;
import 'package:built_collection/built_collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luxeknox/features/accounting/data/datasources/accounting_remote_datasource.dart';
import 'package:mocktail/mocktail.dart';

class MockACCTApi extends Mock implements api.ACCTApi {}

void main() {
  late MockACCTApi mockAcctApi;
  late AccountingRemoteDataSourceImpl dataSource;

  final tDate = api.Date(2026, 1, 1);
  final req = RequestOptions(path: '/accounting');

  setUpAll(() {
    registerFallbackValue(
      api.AccountCreate((b) => b
        ..code = '1000'
        ..name = 'Cash'
        ..accountType = api.AccountType.asset),
    );
    registerFallbackValue(
      api.AccountUpdate((b) => b..name = 'Updated'),
    );
    registerFallbackValue(
      api.JournalCreate((b) => b
        ..entryDate = api.Date(2026, 1, 1)
        ..sourceType = api.JournalCreateSourceTypeEnum.manual
        ..lines.replace([])),
    );
    registerFallbackValue(
      api.JournalReverse((b) => b
        ..entryDate = api.Date(2026, 1, 1)
        ..memo = 'Error'),
    );
    registerFallbackValue(
      api.VendorWrite((b) => b..name = 'Vendor 1'),
    );
    registerFallbackValue(
      api.VendorUpdate((b) => b..name = 'Vendor 1 Updated'),
    );
    registerFallbackValue(
      api.PurchaseBillCreate((b) => b
        ..vendorId = 1
        ..billDate = api.Date(2026, 1, 1)
        ..lines.replace([])),
    );
    registerFallbackValue(
      api.PurchaseBillUpdate((b) => b..vendorId = 2),
    );
    registerFallbackValue(
      api.ExpenseCreate((b) => b
        ..expenseDate = api.Date(2026, 1, 1)
        ..paidFromAccountId = 1
        ..lines.replace([])),
    );
    registerFallbackValue(
      api.ExpenseUpdate((b) => b..payeeName = 'Updated'),
    );
    registerFallbackValue(
      api.PaymentVoucherCreate((b) => b
        ..paymentDate = api.Date(2026, 1, 1)
        ..bankAccountId = 1
        ..totalAmount = '100.00'
        ..allocations.replace([])),
    );
    registerFallbackValue(
      api.PaymentVoucherUpdate((b) => b..totalAmount = '150.00'),
    );
    registerFallbackValue(
      api.DebitNoteCreate((b) => b
        ..purchaseBillId = 1
        ..debitNoteDate = api.Date(2026, 1, 1)
        ..subtotal = '50.00'),
    );
    registerFallbackValue(
      api.TaxCodeCreate((b) => b
        ..code = 'GST18'
        ..name = 'GST 18%'
        ..ratePercent = '18.00'
        ..components.replace([])),
    );
    registerFallbackValue(
      api.TaxCodeUpdate((b) => b..name = 'Updated GST'),
    );
    registerFallbackValue(
      api.ItemCreate((b) => b
        ..name = 'Product'
        ..itemKind = api.ItemKind.goods
        ..incomeAccountId = 1
        ..expenseAccountId = 2),
    );
    registerFallbackValue(
      api.ItemUpdate((b) => b..name = 'Updated Product'),
    );
    registerFallbackValue(api.Date(2026, 1, 1));
  });

  setUp(() {
    mockAcctApi = MockACCTApi();
    dataSource = AccountingRemoteDataSourceImpl(mockAcctApi);
  });

  group('Accounts', () {
    test('listAccounts forwards parameters to ACCTApi and returns data', () async {
      final tPage = api.AccountPage((b) {
        b
          ..data.replace([])
          ..meta.limit = 10
          ..meta.offset = 0
          ..meta.total = 0
          ..meta.hasMore = false;
      });

      when(
        () => mockAcctApi.listAccounts(
          limit: 10,
          offset: 0,
          accountType: api.AccountType.asset,
          isActive: true,
          search: 'cash',
        ),
      ).thenAnswer((_) async => Response(requestOptions: req, data: tPage));

      final result = await dataSource.listAccounts(
        limit: 10,
        offset: 0,
        accountType: api.AccountType.asset,
        isActive: true,
        search: 'cash',
      );

      expect(result, tPage);
      verify(
        () => mockAcctApi.listAccounts(
          limit: 10,
          offset: 0,
          accountType: api.AccountType.asset,
          isActive: true,
          search: 'cash',
        ),
      ).called(1);
    });

    test('getAccount forwards id to ACCTApi and returns data', () async {
      final tAccount = api.Account((b) {
        b
          ..id = 1
          ..code = '1000'
          ..name = 'Cash'
          ..accountType = api.AccountType.asset
          ..isActive = true
          ..isBank = true
          ..isControl = false
          ..createdAt = DateTime.utc(2026, 1, 1)
          ..updatedAt = DateTime.utc(2026, 1, 1);
      });

      when(() => mockAcctApi.getAccount(id: 1)).thenAnswer(
        (_) async => Response(requestOptions: req, data: tAccount),
      );

      final result = await dataSource.getAccount(1);

      expect(result, tAccount);
      verify(() => mockAcctApi.getAccount(id: 1)).called(1);
    });

    test('createAccount forwards AccountCreate and returns data', () async {
      final tCreate = api.AccountCreate((b) => b
        ..code = '1000'
        ..name = 'Cash'
        ..accountType = api.AccountType.asset);

      final tAccount = api.Account((b) {
        b
          ..id = 1
          ..code = '1000'
          ..name = 'Cash'
          ..accountType = api.AccountType.asset
          ..isActive = true
          ..isBank = true
          ..isControl = false
          ..createdAt = DateTime.utc(2026, 1, 1)
          ..updatedAt = DateTime.utc(2026, 1, 1);
      });

      when(() => mockAcctApi.createAccount(accountCreate: any(named: 'accountCreate')))
          .thenAnswer((_) async => Response(requestOptions: req, data: tAccount));

      final result = await dataSource.createAccount(tCreate);

      expect(result, tAccount);
      verify(() => mockAcctApi.createAccount(accountCreate: tCreate)).called(1);
    });

    test('updateAccount forwards id & AccountUpdate and returns data', () async {
      final tUpdate = api.AccountUpdate((b) => b..name = 'Cash New');
      final tAccount = api.Account((b) {
        b
          ..id = 1
          ..code = '1000'
          ..name = 'Cash New'
          ..accountType = api.AccountType.asset
          ..isActive = true
          ..isBank = true
          ..isControl = false
          ..createdAt = DateTime.utc(2026, 1, 1)
          ..updatedAt = DateTime.utc(2026, 1, 1);
      });

      when(
        () => mockAcctApi.updateAccount(
          id: 1,
          accountUpdate: any(named: 'accountUpdate'),
        ),
      ).thenAnswer((_) async => Response(requestOptions: req, data: tAccount));

      final result = await dataSource.updateAccount(id: 1, accountUpdate: tUpdate);

      expect(result, tAccount);
      verify(() => mockAcctApi.updateAccount(id: 1, accountUpdate: tUpdate)).called(1);
    });
  });

  group('Journals', () {
    test('listJournals forwards params and returns JournalPage', () async {
      final tPage = api.JournalPage((b) {
        b
          ..data.replace([])
          ..meta.limit = 20
          ..meta.offset = 0
          ..meta.total = 0
          ..meta.hasMore = false;
      });

      when(
        () => mockAcctApi.listJournals(
          limit: 20,
          offset: 0,
          from: tDate,
          to: tDate,
          sourceType: 'manual',
          paymentId: 5,
        ),
      ).thenAnswer((_) async => Response(requestOptions: req, data: tPage));

      final result = await dataSource.listJournals(
        limit: 20,
        offset: 0,
        from: tDate,
        to: tDate,
        sourceType: 'manual',
        paymentId: 5,
      );

      expect(result, tPage);
      verify(
        () => mockAcctApi.listJournals(
          limit: 20,
          offset: 0,
          from: tDate,
          to: tDate,
          sourceType: 'manual',
          paymentId: 5,
        ),
      ).called(1);
    });

    test('getJournal forwards id and returns data', () async {
      final tJournal = api.Journal((b) {
        b
          ..id = 1
          ..journalNumber = 'J1'
          ..entryDate = tDate
          ..accountingPeriodId = 1
          ..sourceType = 'manual'
          ..sourceId = 1
          ..postedAt = DateTime.utc(2026, 1, 1)
          ..lines.replace([])
          ..rowVersion = 1;
      });

      when(() => mockAcctApi.getJournal(id: 1)).thenAnswer(
        (_) async => Response(requestOptions: req, data: tJournal),
      );

      final result = await dataSource.getJournal(1);
      expect(result, tJournal);
    });

    test('createJournal forwards create payload and idempotency key', () async {
      final tCreate = api.JournalCreate((b) => b
        ..entryDate = tDate
        ..sourceType = api.JournalCreateSourceTypeEnum.manual
        ..lines.replace([]));

      final tJournal = api.Journal((b) {
        b
          ..id = 1
          ..journalNumber = 'J1'
          ..entryDate = tDate
          ..accountingPeriodId = 1
          ..sourceType = 'manual'
          ..sourceId = 1
          ..postedAt = DateTime.utc(2026, 1, 1)
          ..lines.replace([])
          ..rowVersion = 1;
      });

      when(
        () => mockAcctApi.createJournal(
          journalCreate: any(named: 'journalCreate'),
          idempotencyKey: 'key-123',
        ),
      ).thenAnswer((_) async => Response(requestOptions: req, data: tJournal));

      final result = await dataSource.createJournal(
        journalCreate: tCreate,
        idempotencyKey: 'key-123',
      );

      expect(result, tJournal);
      verify(
        () => mockAcctApi.createJournal(
          journalCreate: tCreate,
          idempotencyKey: 'key-123',
        ),
      ).called(1);
    });

    test('reverseJournal forwards reverse payload and idempotency key', () async {
      final tReverse = api.JournalReverse((b) => b
        ..entryDate = tDate
        ..memo = 'Mistake');

      final tJournal = api.Journal((b) {
        b
          ..id = 2
          ..journalNumber = 'J2'
          ..entryDate = tDate
          ..accountingPeriodId = 1
          ..sourceType = 'manual'
          ..sourceId = 1
          ..postedAt = DateTime.utc(2026, 1, 1)
          ..lines.replace([])
          ..rowVersion = 1;
      });

      when(
        () => mockAcctApi.reverseJournal(
          id: 1,
          journalReverse: any(named: 'journalReverse'),
          idempotencyKey: 'key-rev',
        ),
      ).thenAnswer((_) async => Response(requestOptions: req, data: tJournal));

      final result = await dataSource.reverseJournal(
        id: 1,
        journalReverse: tReverse,
        idempotencyKey: 'key-rev',
      );

      expect(result, tJournal);
      verify(
        () => mockAcctApi.reverseJournal(
          id: 1,
          journalReverse: tReverse,
          idempotencyKey: 'key-rev',
        ),
      ).called(1);
    });
  });

  group('Fiscal Years & Periods', () {
    test('listFiscalYears returns BuiltList<FiscalYear>', () async {
      final tList = BuiltList<api.FiscalYear>([]);

      when(() => mockAcctApi.listFiscalYears()).thenAnswer(
        (_) async => Response(requestOptions: req, data: tList),
      );

      final result = await dataSource.listFiscalYears();
      expect(result, tList);
    });

    test('listAccountingPeriods returns BuiltList<AccountingPeriod>', () async {
      final tList = BuiltList<api.AccountingPeriod>([]);

      when(
        () => mockAcctApi.listAccountingPeriods(
          fiscalYearId: 1,
          status: 'open',
        ),
      ).thenAnswer((_) async => Response(requestOptions: req, data: tList));

      final result = await dataSource.listAccountingPeriods(
        fiscalYearId: 1,
        status: 'open',
      );

      expect(result, tList);
      verify(
        () => mockAcctApi.listAccountingPeriods(
          fiscalYearId: 1,
          status: 'open',
        ),
      ).called(1);
    });

    test('lockAccountingPeriod calls ACCTApi.lockAccountingPeriod', () async {
      final tPeriod = api.AccountingPeriod((b) {
        b
          ..id = 1
          ..fiscalYearId = 1
          ..startsOn = tDate
          ..endsOn = tDate
          ..status = api.AccountingPeriodStatusEnum.locked;
      });

      when(() => mockAcctApi.lockAccountingPeriod(id: 1)).thenAnswer(
        (_) async => Response(requestOptions: req, data: tPeriod),
      );

      final result = await dataSource.lockAccountingPeriod(1);
      expect(result, tPeriod);
    });

    test('unlockAccountingPeriod calls ACCTApi.unlockAccountingPeriod', () async {
      final tPeriod = api.AccountingPeriod((b) {
        b
          ..id = 1
          ..fiscalYearId = 1
          ..startsOn = tDate
          ..endsOn = tDate
          ..status = api.AccountingPeriodStatusEnum.open;
      });

      when(() => mockAcctApi.unlockAccountingPeriod(id: 1)).thenAnswer(
        (_) async => Response(requestOptions: req, data: tPeriod),
      );

      final result = await dataSource.unlockAccountingPeriod(1);
      expect(result, tPeriod);
    });
  });

  group('Reports', () {
    test('getOpenItems calls ACCTApi.getOpenItems', () async {
      final tReport = api.OpenItemsReport((b) {
        b
          ..kind = api.OpenItemsReportKindEnum.ar
          ..totalOpenAmount = '1000.00'
          ..arItems.replace([])
          ..apItems.replace([]);
      });

      when(() => mockAcctApi.getOpenItems(kind: 'ar')).thenAnswer(
        (_) async => Response(requestOptions: req, data: tReport),
      );

      final result = await dataSource.getOpenItems('ar');
      expect(result, tReport);
      verify(() => mockAcctApi.getOpenItems(kind: 'ar')).called(1);
    });

    test('getTrialBalance calls ACCTApi.getTrialBalance', () async {
      final tReport = api.TrialBalanceReport((b) {
        b
          ..to = tDate
          ..totalDebit = '100.00'
          ..totalCredit = '100.00'
          ..accounts.replace([]);
      });

      when(() => mockAcctApi.getTrialBalance(from: tDate, to: tDate)).thenAnswer(
        (_) async => Response(requestOptions: req, data: tReport),
      );

      final result = await dataSource.getTrialBalance(from: tDate, to: tDate);
      expect(result, tReport);
    });

    test('getProfitAndLoss calls ACCTApi.getProfitAndLoss', () async {
      final tReport = api.ProfitAndLossReport((b) {
        b
          ..from = tDate
          ..to = tDate
          ..totalIncome = '200.00'
          ..totalExpense = '150.00'
          ..netProfit = '50.00'
          ..incomeAccounts.replace([])
          ..expenseAccounts.replace([]);
      });

      when(() => mockAcctApi.getProfitAndLoss(from: tDate, to: tDate)).thenAnswer(
        (_) async => Response(requestOptions: req, data: tReport),
      );

      final result = await dataSource.getProfitAndLoss(from: tDate, to: tDate);
      expect(result, tReport);
    });

    test('getBalanceSheet calls ACCTApi.getBalanceSheet', () async {
      final tReport = api.BalanceSheetReport((b) {
        b
          ..asOf = tDate
          ..fiscalYearStart = tDate
          ..totalAssets = '500.00'
          ..totalLiabilities = '300.00'
          ..totalEquity = '200.00'
          ..currentYearEarnings = '50.00'
          ..totalLiabilitiesAndEquity = '500.00'
          ..assetAccounts.replace([])
          ..liabilityAccounts.replace([])
          ..equityAccounts.replace([]);
      });

      when(() => mockAcctApi.getBalanceSheet(asOf: tDate)).thenAnswer(
        (_) async => Response(requestOptions: req, data: tReport),
      );

      final result = await dataSource.getBalanceSheet(asOf: tDate);
      expect(result, tReport);
    });

    test('getDayBook calls ACCTApi.getDayBook', () async {
      final tReport = api.DayBookReport((b) {
        b
          ..date = tDate
          ..totalDebit = '100.00'
          ..totalCredit = '100.00'
          ..journals.replace([]);
      });

      when(() => mockAcctApi.getDayBook(date: tDate)).thenAnswer(
        (_) async => Response(requestOptions: req, data: tReport),
      );

      final result = await dataSource.getDayBook(date: tDate);
      expect(result, tReport);
    });

    test('getGstSummary calls ACCTApi.getGstSummary', () async {
      final tReport = api.GstSummaryReport((b) {
        b
          ..from = tDate
          ..to = tDate
          ..totalTaxableValue = '100.00'
          ..outputCgst = '9.00'
          ..outputSgst = '9.00'
          ..outputIgst = '0.00'
          ..totalOutputTax = '18.00'
          ..inputTaxCredit = '9.00'
          ..netPayable = '9.00'
          ..taxCodes.replace([]);
      });

      when(() => mockAcctApi.getGstSummary(from: tDate, to: tDate)).thenAnswer(
        (_) async => Response(requestOptions: req, data: tReport),
      );

      final result = await dataSource.getGstSummary(from: tDate, to: tDate);
      expect(result, tReport);
    });

    test('getUnearnedPreview calls ACCTApi.getUnearnedPreview', () async {
      final tResponse = api.UnearnedPreviewResponse((b) {
        b
          ..goLiveDate = tDate
          ..items.replace([])
          ..totals.unearnedMembershipTotal = '100.00'
          ..totals.unearnedPtTotal = '50.00'
          ..totals.combinedTotal = '150.00';
      });

      when(() => mockAcctApi.getUnearnedPreview(goLiveDate: tDate)).thenAnswer(
        (_) async => Response(requestOptions: req, data: tResponse),
      );

      final result = await dataSource.getUnearnedPreview(goLiveDate: tDate);
      expect(result, tResponse);
    });
  });

  group('Error unwrapping', () {
    test('throws DioException when response data is null', () async {
      when(() => mockAcctApi.getAccount(id: 99)).thenAnswer(
        (_) async => Response<api.Account>(
          requestOptions: req,
          data: null,
          statusCode: 200,
        ),
      );

      expect(
        () => dataSource.getAccount(99),
        throwsA(isA<DioException>()),
      );
    });
  });
}
