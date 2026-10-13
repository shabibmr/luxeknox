import 'package:api_client/api_client.dart' as api;
import 'package:built_collection/built_collection.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

abstract class AccountingRemoteDataSource {
  // Accounts
  Future<api.AccountPage> listAccounts({
    int? limit,
    int? offset,
    api.AccountType? accountType,
    bool? isActive,
    String? search,
  });

  Future<api.Account> getAccount(int id);

  Future<api.Account> createAccount(api.AccountCreate accountCreate);

  Future<api.Account> updateAccount({
    required int id,
    required api.AccountUpdate accountUpdate,
  });

  // Journals
  Future<api.JournalPage> listJournals({
    int? limit,
    int? offset,
    api.Date? from,
    api.Date? to,
    String? sourceType,
    int? paymentId,
  });

  Future<api.Journal> getJournal(int id);

  Future<api.Journal> createJournal({
    required api.JournalCreate journalCreate,
    String? idempotencyKey,
  });

  Future<api.Journal> reverseJournal({
    required int id,
    required api.JournalReverse journalReverse,
    String? idempotencyKey,
  });

  // Fiscal Years & Periods
  Future<BuiltList<api.FiscalYear>> listFiscalYears();

  Future<BuiltList<api.AccountingPeriod>> listAccountingPeriods({
    int? fiscalYearId,
    String? status,
  });

  Future<api.AccountingPeriod> lockAccountingPeriod(int id);

  Future<api.AccountingPeriod> unlockAccountingPeriod(int id);

  // Vendors
  Future<api.VendorPage> listVendors({
    int? limit,
    int? offset,
    bool? isActive,
    String? search,
  });

  Future<api.Vendor> getVendor(int id);

  Future<api.Vendor> createVendor(api.VendorWrite vendorWrite);

  Future<api.Vendor> updateVendor({
    required int id,
    required api.VendorUpdate vendorUpdate,
  });

  // Purchase Bills
  Future<api.PurchaseBillPage> listPurchaseBills({
    int? limit,
    int? offset,
    api.PurchaseBillStatus? status,
    int? vendorId,
    api.Date? from,
    api.Date? to,
    String? search,
  });

  Future<api.PurchaseBill> getPurchaseBill(int id);

  Future<api.PurchaseBill> createPurchaseBill({
    required api.PurchaseBillCreate purchaseBillCreate,
    String? idempotencyKey,
  });

  Future<api.PurchaseBill> updatePurchaseBill({
    required int id,
    required api.PurchaseBillUpdate purchaseBillUpdate,
  });

  Future<api.PurchaseBill> postPurchaseBill(int id);

  // Expenses
  Future<api.ExpenseVoucherPage> listExpenses({
    int? limit,
    int? offset,
    api.ExpenseStatus? status,
    int? vendorId,
    api.Date? from,
    api.Date? to,
    String? search,
  });

  Future<api.ExpenseVoucher> getExpense(int id);

  Future<api.ExpenseVoucher> createExpense({
    required api.ExpenseCreate expenseCreate,
    String? idempotencyKey,
  });

  Future<api.ExpenseVoucher> updateExpense({
    required int id,
    required api.ExpenseUpdate expenseUpdate,
  });

  Future<api.ExpenseVoucher> postExpense(int id);

  // Payment Vouchers
  Future<api.PaymentVoucherPage> listPaymentVouchers({
    int? limit,
    int? offset,
    String? status,
    api.Date? from,
    api.Date? to,
    int? bankAccountId,
    String? search,
  });

  Future<api.PaymentVoucher> getPaymentVoucher(int id);

  Future<api.PaymentVoucher> createPaymentVoucher({
    required api.PaymentVoucherCreate paymentVoucherCreate,
    String? idempotencyKey,
  });

  Future<api.PaymentVoucher> updatePaymentVoucher({
    required int id,
    required api.PaymentVoucherUpdate paymentVoucherUpdate,
  });

  Future<api.PaymentVoucher> postPaymentVoucher(int id);

  // Fund Transfers
  Future<api.FundTransferPage> listFundTransfers({
    int? limit,
    int? offset,
    String? status,
    api.Date? from,
    api.Date? to,
    int? accountId,
    String? search,
  });

  Future<api.FundTransfer> getFundTransfer(int id);

  Future<api.FundTransfer> createFundTransfer({
    required api.FundTransferCreate fundTransferCreate,
    String? idempotencyKey,
  });

  Future<api.FundTransfer> updateFundTransfer({
    required int id,
    required api.FundTransferUpdate fundTransferUpdate,
  });

  Future<api.FundTransfer> postFundTransfer(int id);

  // Debit Notes
  Future<api.DebitNotePage> listDebitNotes({
    int? limit,
    int? offset,
    api.DebitNoteStatus? status,
    int? purchaseBillId,
    api.Date? from,
    api.Date? to,
    String? search,
  });

  Future<api.DebitNote> getDebitNote(int id);

  Future<api.DebitNote> createDebitNote({
    required api.DebitNoteCreate debitNoteCreate,
    String? idempotencyKey,
  });

  Future<api.DebitNote> postDebitNote(int id);

  // Tax Codes
  Future<api.TaxCodePage> listTaxCodes({
    int? limit,
    int? offset,
    bool? isActive,
  });

  Future<api.TaxCode> getTaxCode(int id);

  Future<api.TaxCode> createTaxCode(api.TaxCodeCreate taxCodeCreate);

  Future<api.TaxCode> updateTaxCode({
    required int id,
    required api.TaxCodeUpdate taxCodeUpdate,
  });

  // Items
  Future<api.ItemPage> listItems({
    int? limit,
    int? offset,
    api.ItemKind? itemKind,
    bool? isActive,
    String? search,
  });

  Future<api.Item> getItem(int id);

  Future<api.Item> createItem(api.ItemCreate itemCreate);

  Future<api.Item> updateItem({
    required int id,
    required api.ItemUpdate itemUpdate,
  });

  // Reports
  Future<api.TrialBalanceReport> getTrialBalance({
    api.Date? from,
    required api.Date to,
  });

  Future<api.ProfitAndLossReport> getProfitAndLoss({
    required api.Date from,
    required api.Date to,
  });

  Future<api.BalanceSheetReport> getBalanceSheet({
    required api.Date asOf,
  });

  Future<api.DayBookReport> getDayBook({
    required api.Date date,
  });

  Future<api.OpenItemsReport> getOpenItems(String kind);

  Future<api.GstSummaryReport> getGstSummary({
    required api.Date from,
    required api.Date to,
  });

  Future<api.UnearnedPreviewResponse> getUnearnedPreview({
    api.Date? goLiveDate,
  });
}

@LazySingleton(as: AccountingRemoteDataSource)
class AccountingRemoteDataSourceImpl implements AccountingRemoteDataSource {
  AccountingRemoteDataSourceImpl(this._acctApi);

  final api.ACCTApi _acctApi;

  T _unwrap<T>(Response<T> response) {
    final data = response.data;
    if (data == null) {
      throw DioException(
        requestOptions: response.requestOptions,
        type: DioExceptionType.badResponse,
        response: response,
      );
    }
    return data;
  }

  // Accounts
  @override
  Future<api.AccountPage> listAccounts({
    int? limit,
    int? offset,
    api.AccountType? accountType,
    bool? isActive,
    String? search,
  }) async {
    return _unwrap(
      await _acctApi.listAccounts(
        limit: limit,
        offset: offset,
        accountType: accountType,
        isActive: isActive,
        search: search,
      ),
    );
  }

  @override
  Future<api.Account> getAccount(int id) async {
    return _unwrap(await _acctApi.getAccount(id: id));
  }

  @override
  Future<api.Account> createAccount(api.AccountCreate accountCreate) async {
    return _unwrap(await _acctApi.createAccount(accountCreate: accountCreate));
  }

  @override
  Future<api.Account> updateAccount({
    required int id,
    required api.AccountUpdate accountUpdate,
  }) async {
    return _unwrap(
      await _acctApi.updateAccount(id: id, accountUpdate: accountUpdate),
    );
  }

  // Journals
  @override
  Future<api.JournalPage> listJournals({
    int? limit,
    int? offset,
    api.Date? from,
    api.Date? to,
    String? sourceType,
    int? paymentId,
  }) async {
    return _unwrap(
      await _acctApi.listJournals(
        limit: limit,
        offset: offset,
        from: from,
        to: to,
        sourceType: sourceType,
        paymentId: paymentId,
      ),
    );
  }

  @override
  Future<api.Journal> getJournal(int id) async {
    return _unwrap(await _acctApi.getJournal(id: id));
  }

  @override
  Future<api.Journal> createJournal({
    required api.JournalCreate journalCreate,
    String? idempotencyKey,
  }) async {
    return _unwrap(
      await _acctApi.createJournal(
        journalCreate: journalCreate,
        idempotencyKey: idempotencyKey,
      ),
    );
  }

  @override
  Future<api.Journal> reverseJournal({
    required int id,
    required api.JournalReverse journalReverse,
    String? idempotencyKey,
  }) async {
    return _unwrap(
      await _acctApi.reverseJournal(
        id: id,
        journalReverse: journalReverse,
        idempotencyKey: idempotencyKey,
      ),
    );
  }

  // Fiscal Years & Periods
  @override
  Future<BuiltList<api.FiscalYear>> listFiscalYears() async {
    return _unwrap(await _acctApi.listFiscalYears());
  }

  @override
  Future<BuiltList<api.AccountingPeriod>> listAccountingPeriods({
    int? fiscalYearId,
    String? status,
  }) async {
    return _unwrap(
      await _acctApi.listAccountingPeriods(
        fiscalYearId: fiscalYearId,
        status: status,
      ),
    );
  }

  @override
  Future<api.AccountingPeriod> lockAccountingPeriod(int id) async {
    return _unwrap(await _acctApi.lockAccountingPeriod(id: id));
  }

  @override
  Future<api.AccountingPeriod> unlockAccountingPeriod(int id) async {
    return _unwrap(await _acctApi.unlockAccountingPeriod(id: id));
  }

  // Vendors
  @override
  Future<api.VendorPage> listVendors({
    int? limit,
    int? offset,
    bool? isActive,
    String? search,
  }) async {
    return _unwrap(
      await _acctApi.listVendors(
        limit: limit,
        offset: offset,
        isActive: isActive,
        search: search,
      ),
    );
  }

  @override
  Future<api.Vendor> getVendor(int id) async {
    return _unwrap(await _acctApi.getVendor(id: id));
  }

  @override
  Future<api.Vendor> createVendor(api.VendorWrite vendorWrite) async {
    return _unwrap(await _acctApi.createVendor(vendorWrite: vendorWrite));
  }

  @override
  Future<api.Vendor> updateVendor({
    required int id,
    required api.VendorUpdate vendorUpdate,
  }) async {
    return _unwrap(
      await _acctApi.updateVendor(id: id, vendorUpdate: vendorUpdate),
    );
  }

  // Purchase Bills
  @override
  Future<api.PurchaseBillPage> listPurchaseBills({
    int? limit,
    int? offset,
    api.PurchaseBillStatus? status,
    int? vendorId,
    api.Date? from,
    api.Date? to,
    String? search,
  }) async {
    return _unwrap(
      await _acctApi.listPurchaseBills(
        limit: limit,
        offset: offset,
        status: status,
        vendorId: vendorId,
        from: from,
        to: to,
        search: search,
      ),
    );
  }

  @override
  Future<api.PurchaseBill> getPurchaseBill(int id) async {
    return _unwrap(await _acctApi.getPurchaseBill(id: id));
  }

  @override
  Future<api.PurchaseBill> createPurchaseBill({
    required api.PurchaseBillCreate purchaseBillCreate,
    String? idempotencyKey,
  }) async {
    return _unwrap(
      await _acctApi.createPurchaseBill(
        purchaseBillCreate: purchaseBillCreate,
        idempotencyKey: idempotencyKey,
      ),
    );
  }

  @override
  Future<api.PurchaseBill> updatePurchaseBill({
    required int id,
    required api.PurchaseBillUpdate purchaseBillUpdate,
  }) async {
    return _unwrap(
      await _acctApi.updatePurchaseBill(
        id: id,
        purchaseBillUpdate: purchaseBillUpdate,
      ),
    );
  }

  @override
  Future<api.PurchaseBill> postPurchaseBill(int id) async {
    return _unwrap(await _acctApi.postPurchaseBill(id: id));
  }

  // Expenses
  @override
  Future<api.ExpenseVoucherPage> listExpenses({
    int? limit,
    int? offset,
    api.ExpenseStatus? status,
    int? vendorId,
    api.Date? from,
    api.Date? to,
    String? search,
  }) async {
    return _unwrap(
      await _acctApi.listExpenses(
        limit: limit,
        offset: offset,
        status: status,
        vendorId: vendorId,
        from: from,
        to: to,
        search: search,
      ),
    );
  }

  @override
  Future<api.ExpenseVoucher> getExpense(int id) async {
    return _unwrap(await _acctApi.getExpense(id: id));
  }

  @override
  Future<api.ExpenseVoucher> createExpense({
    required api.ExpenseCreate expenseCreate,
    String? idempotencyKey,
  }) async {
    return _unwrap(
      await _acctApi.createExpense(
        expenseCreate: expenseCreate,
        idempotencyKey: idempotencyKey,
      ),
    );
  }

  @override
  Future<api.ExpenseVoucher> updateExpense({
    required int id,
    required api.ExpenseUpdate expenseUpdate,
  }) async {
    return _unwrap(
      await _acctApi.updateExpense(
        id: id,
        expenseUpdate: expenseUpdate,
      ),
    );
  }

  @override
  Future<api.ExpenseVoucher> postExpense(int id) async {
    return _unwrap(await _acctApi.postExpense(id: id));
  }

  // Payment Vouchers
  @override
  Future<api.PaymentVoucherPage> listPaymentVouchers({
    int? limit,
    int? offset,
    String? status,
    api.Date? from,
    api.Date? to,
    int? bankAccountId,
    String? search,
  }) async {
    return _unwrap(
      await _acctApi.listPaymentVouchers(
        limit: limit,
        offset: offset,
        status: status,
        from: from,
        to: to,
        bankAccountId: bankAccountId,
        search: search,
      ),
    );
  }

  @override
  Future<api.PaymentVoucher> getPaymentVoucher(int id) async {
    return _unwrap(await _acctApi.getPaymentVoucher(id: id));
  }

  @override
  Future<api.PaymentVoucher> createPaymentVoucher({
    required api.PaymentVoucherCreate paymentVoucherCreate,
    String? idempotencyKey,
  }) async {
    return _unwrap(
      await _acctApi.createPaymentVoucher(
        paymentVoucherCreate: paymentVoucherCreate,
        idempotencyKey: idempotencyKey,
      ),
    );
  }

  @override
  Future<api.PaymentVoucher> updatePaymentVoucher({
    required int id,
    required api.PaymentVoucherUpdate paymentVoucherUpdate,
  }) async {
    return _unwrap(
      await _acctApi.updatePaymentVoucher(
        id: id,
        paymentVoucherUpdate: paymentVoucherUpdate,
      ),
    );
  }

  @override
  Future<api.PaymentVoucher> postPaymentVoucher(int id) async {
    return _unwrap(await _acctApi.postPaymentVoucher(id: id));
  }

  // Fund Transfers
  @override
  Future<api.FundTransferPage> listFundTransfers({
    int? limit,
    int? offset,
    String? status,
    api.Date? from,
    api.Date? to,
    int? accountId,
    String? search,
  }) async {
    return _unwrap(
      await _acctApi.listFundTransfers(
        limit: limit,
        offset: offset,
        status: status,
        from: from,
        to: to,
        accountId: accountId,
        search: search,
      ),
    );
  }

  @override
  Future<api.FundTransfer> getFundTransfer(int id) async {
    return _unwrap(await _acctApi.getFundTransfer(id: id));
  }

  @override
  Future<api.FundTransfer> createFundTransfer({
    required api.FundTransferCreate fundTransferCreate,
    String? idempotencyKey,
  }) async {
    return _unwrap(
      await _acctApi.createFundTransfer(
        fundTransferCreate: fundTransferCreate,
        idempotencyKey: idempotencyKey,
      ),
    );
  }

  @override
  Future<api.FundTransfer> updateFundTransfer({
    required int id,
    required api.FundTransferUpdate fundTransferUpdate,
  }) async {
    return _unwrap(
      await _acctApi.updateFundTransfer(
        id: id,
        fundTransferUpdate: fundTransferUpdate,
      ),
    );
  }

  @override
  Future<api.FundTransfer> postFundTransfer(int id) async {
    return _unwrap(await _acctApi.postFundTransfer(id: id));
  }

  // Debit Notes
  @override
  Future<api.DebitNotePage> listDebitNotes({
    int? limit,
    int? offset,
    api.DebitNoteStatus? status,
    int? purchaseBillId,
    api.Date? from,
    api.Date? to,
    String? search,
  }) async {
    return _unwrap(
      await _acctApi.listDebitNotes(
        limit: limit,
        offset: offset,
        status: status,
        purchaseBillId: purchaseBillId,
        from: from,
        to: to,
        search: search,
      ),
    );
  }

  @override
  Future<api.DebitNote> getDebitNote(int id) async {
    return _unwrap(await _acctApi.getDebitNote(id: id));
  }

  @override
  Future<api.DebitNote> createDebitNote({
    required api.DebitNoteCreate debitNoteCreate,
    String? idempotencyKey,
  }) async {
    return _unwrap(
      await _acctApi.createDebitNote(
        debitNoteCreate: debitNoteCreate,
        idempotencyKey: idempotencyKey,
      ),
    );
  }

  @override
  Future<api.DebitNote> postDebitNote(int id) async {
    return _unwrap(await _acctApi.postDebitNote(id: id));
  }

  // Tax Codes
  @override
  Future<api.TaxCodePage> listTaxCodes({
    int? limit,
    int? offset,
    bool? isActive,
  }) async {
    return _unwrap(
      await _acctApi.listTaxCodes(
        limit: limit,
        offset: offset,
        isActive: isActive,
      ),
    );
  }

  @override
  Future<api.TaxCode> getTaxCode(int id) async {
    return _unwrap(await _acctApi.getTaxCode(id: id));
  }

  @override
  Future<api.TaxCode> createTaxCode(api.TaxCodeCreate taxCodeCreate) async {
    return _unwrap(await _acctApi.createTaxCode(taxCodeCreate: taxCodeCreate));
  }

  @override
  Future<api.TaxCode> updateTaxCode({
    required int id,
    required api.TaxCodeUpdate taxCodeUpdate,
  }) async {
    return _unwrap(
      await _acctApi.updateTaxCode(id: id, taxCodeUpdate: taxCodeUpdate),
    );
  }

  // Items
  @override
  Future<api.ItemPage> listItems({
    int? limit,
    int? offset,
    api.ItemKind? itemKind,
    bool? isActive,
    String? search,
  }) async {
    return _unwrap(
      await _acctApi.listItems(
        limit: limit,
        offset: offset,
        itemKind: itemKind,
        isActive: isActive,
        search: search,
      ),
    );
  }

  @override
  Future<api.Item> getItem(int id) async {
    return _unwrap(await _acctApi.getItem(id: id));
  }

  @override
  Future<api.Item> createItem(api.ItemCreate itemCreate) async {
    return _unwrap(await _acctApi.createItem(itemCreate: itemCreate));
  }

  @override
  Future<api.Item> updateItem({
    required int id,
    required api.ItemUpdate itemUpdate,
  }) async {
    return _unwrap(await _acctApi.updateItem(id: id, itemUpdate: itemUpdate));
  }

  // Reports
  @override
  Future<api.TrialBalanceReport> getTrialBalance({
    api.Date? from,
    required api.Date to,
  }) async {
    return _unwrap(await _acctApi.getTrialBalance(to: to, from: from));
  }

  @override
  Future<api.ProfitAndLossReport> getProfitAndLoss({
    required api.Date from,
    required api.Date to,
  }) async {
    return _unwrap(await _acctApi.getProfitAndLoss(from: from, to: to));
  }

  @override
  Future<api.BalanceSheetReport> getBalanceSheet({
    required api.Date asOf,
  }) async {
    return _unwrap(await _acctApi.getBalanceSheet(asOf: asOf));
  }

  @override
  Future<api.DayBookReport> getDayBook({
    required api.Date date,
  }) async {
    return _unwrap(await _acctApi.getDayBook(date: date));
  }

  @override
  Future<api.OpenItemsReport> getOpenItems(String kind) async {
    return _unwrap(await _acctApi.getOpenItems(kind: kind));
  }

  @override
  Future<api.GstSummaryReport> getGstSummary({
    required api.Date from,
    required api.Date to,
  }) async {
    return _unwrap(await _acctApi.getGstSummary(from: from, to: to));
  }

  @override
  Future<api.UnearnedPreviewResponse> getUnearnedPreview({
    api.Date? goLiveDate,
  }) async {
    return _unwrap(await _acctApi.getUnearnedPreview(goLiveDate: goLiveDate));
  }
}
