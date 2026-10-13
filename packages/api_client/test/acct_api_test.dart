import 'package:test/test.dart';
import 'package:api_client/api_client.dart';


/// tests for ACCTApi
void main() {
  final instance = ApiClient().getACCTApi();

  group(ACCTApi, () {
    // Create an account
    //
    //Future<Account> createAccount(AccountCreate accountCreate) async
    test('test createAccount', () async {
      // TODO
    });

    // Create a draft debit note
    //
    //Future<DebitNote> createDebitNote(DebitNoteCreate debitNoteCreate, { String idempotencyKey }) async
    test('test createDebitNote', () async {
      // TODO
    });

    // Create an expense voucher
    //
    //Future<ExpenseVoucher> createExpense(ExpenseCreate expenseCreate, { String idempotencyKey }) async
    test('test createExpense', () async {
      // TODO
    });

    // Create item
    //
    //Future<Item> createItem(ItemCreate itemCreate) async
    test('test createItem', () async {
      // TODO
    });

    // Create a manual or opening-balance journal
    //
    //Future<Journal> createJournal(JournalCreate journalCreate, { String idempotencyKey }) async
    test('test createJournal', () async {
      // TODO
    });

    // Create a draft payment voucher
    //
    //Future<PaymentVoucher> createPaymentVoucher(PaymentVoucherCreate paymentVoucherCreate, { String idempotencyKey }) async
    test('test createPaymentVoucher', () async {
      // TODO
    });

    // Create a draft purchase bill
    //
    //Future<PurchaseBill> createPurchaseBill(PurchaseBillCreate purchaseBillCreate, { String idempotencyKey }) async
    test('test createPurchaseBill', () async {
      // TODO
    });

    // Create a tax code
    //
    //Future<TaxCode> createTaxCode(TaxCodeCreate taxCodeCreate) async
    test('test createTaxCode', () async {
      // TODO
    });

    // Create vendor
    //
    //Future<Vendor> createVendor(VendorWrite vendorWrite) async
    test('test createVendor', () async {
      // TODO
    });

    // Account detail
    //
    //Future<Account> getAccount(int id) async
    test('test getAccount', () async {
      // TODO
    });

    // Balance sheet as of a date
    //
    //Future<BalanceSheetReport> getBalanceSheet(Date asOf) async
    test('test getBalanceSheet', () async {
      // TODO
    });

    // Day book for one date
    //
    //Future<DayBookReport> getDayBook(Date date) async
    test('test getDayBook', () async {
      // TODO
    });

    // Get debit note by ID
    //
    //Future<DebitNote> getDebitNote(int id) async
    test('test getDebitNote', () async {
      // TODO
    });

    // Get expense voucher by ID
    //
    //Future<ExpenseVoucher> getExpense(int id) async
    test('test getExpense', () async {
      // TODO
    });

    // GST summary for a date range
    //
    //Future<GstSummaryReport> getGstSummary(Date from, Date to) async
    test('test getGstSummary', () async {
      // TODO
    });

    // Get item by ID
    //
    //Future<Item> getItem(int id) async
    test('test getItem', () async {
      // TODO
    });

    // Journal entry detail
    //
    //Future<Journal> getJournal(int id) async
    test('test getJournal', () async {
      // TODO
    });

    // Open AR or AP items
    //
    //Future<OpenItemsReport> getOpenItems(String kind) async
    test('test getOpenItems', () async {
      // TODO
    });

    // Get payment voucher by ID
    //
    //Future<PaymentVoucher> getPaymentVoucher(int id) async
    test('test getPaymentVoucher', () async {
      // TODO
    });

    // Profit and loss for a date range
    //
    //Future<ProfitAndLossReport> getProfitAndLoss(Date from, Date to) async
    test('test getProfitAndLoss', () async {
      // TODO
    });

    // Get purchase bill by ID
    //
    //Future<PurchaseBill> getPurchaseBill(int id) async
    test('test getPurchaseBill', () async {
      // TODO
    });

    // Tax code detail
    //
    //Future<TaxCode> getTaxCode(int id) async
    test('test getTaxCode', () async {
      // TODO
    });

    // Trial balance for a date range
    //
    //Future<TrialBalanceReport> getTrialBalance(Date to, { Date from }) async
    test('test getTrialBalance', () async {
      // TODO
    });

    // Preview unearned membership and PT revenue for go-live
    //
    //Future<UnearnedPreviewResponse> getUnearnedPreview({ Date goLiveDate }) async
    test('test getUnearnedPreview', () async {
      // TODO
    });

    // Get vendor by ID
    //
    //Future<Vendor> getVendor(int id) async
    test('test getVendor', () async {
      // TODO
    });

    // List accounting periods
    //
    //Future<BuiltList<AccountingPeriod>> listAccountingPeriods({ int fiscalYearId, String status }) async
    test('test listAccountingPeriods', () async {
      // TODO
    });

    // List accounts
    //
    //Future<AccountPage> listAccounts({ int limit, int offset, AccountType accountType, bool isActive, String search }) async
    test('test listAccounts', () async {
      // TODO
    });

    // List debit notes
    //
    //Future<DebitNotePage> listDebitNotes({ int limit, int offset, DebitNoteStatus status, int purchaseBillId, Date from, Date to, String search }) async
    test('test listDebitNotes', () async {
      // TODO
    });

    // List expense vouchers
    //
    //Future<ExpenseVoucherPage> listExpenses({ int limit, int offset, ExpenseStatus status, int vendorId, Date from, Date to, String search }) async
    test('test listExpenses', () async {
      // TODO
    });

    // List all fiscal years
    //
    //Future<BuiltList<FiscalYear>> listFiscalYears() async
    test('test listFiscalYears', () async {
      // TODO
    });

    // List items
    //
    //Future<ItemPage> listItems({ int limit, int offset, ItemKind itemKind, bool isActive, String search }) async
    test('test listItems', () async {
      // TODO
    });

    // List journal entries
    //
    //Future<JournalPage> listJournals({ int limit, int offset, Date from, Date to, String sourceType, int paymentId }) async
    test('test listJournals', () async {
      // TODO
    });

    // List payment vouchers
    //
    //Future<PaymentVoucherPage> listPaymentVouchers({ int limit, int offset, String status, Date from, Date to, int bankAccountId, String search }) async
    test('test listPaymentVouchers', () async {
      // TODO
    });

    // List purchase bills
    //
    //Future<PurchaseBillPage> listPurchaseBills({ int limit, int offset, PurchaseBillStatus status, int vendorId, Date from, Date to, String search }) async
    test('test listPurchaseBills', () async {
      // TODO
    });

    // List tax codes
    //
    //Future<TaxCodePage> listTaxCodes({ int limit, int offset, bool isActive }) async
    test('test listTaxCodes', () async {
      // TODO
    });

    // List vendors
    //
    //Future<VendorPage> listVendors({ int limit, int offset, String search, bool isActive }) async
    test('test listVendors', () async {
      // TODO
    });

    // Lock an accounting period
    //
    //Future<AccountingPeriod> lockAccountingPeriod(int id) async
    test('test lockAccountingPeriod', () async {
      // TODO
    });

    // Post a debit note to the general ledger
    //
    //Future<DebitNote> postDebitNote(int id) async
    test('test postDebitNote', () async {
      // TODO
    });

    // Post an expense voucher to general ledger
    //
    //Future<ExpenseVoucher> postExpense(int id) async
    test('test postExpense', () async {
      // TODO
    });

    // Post a payment voucher to GL
    //
    //Future<PaymentVoucher> postPaymentVoucher(int id) async
    test('test postPaymentVoucher', () async {
      // TODO
    });

    // Post a purchase bill to the general ledger
    //
    //Future<PurchaseBill> postPurchaseBill(int id) async
    test('test postPurchaseBill', () async {
      // TODO
    });

    // Reverse a posted journal
    //
    //Future<Journal> reverseJournal(int id, JournalReverse journalReverse, { String idempotencyKey }) async
    test('test reverseJournal', () async {
      // TODO
    });

    // Unlock an accounting period
    //
    //Future<AccountingPeriod> unlockAccountingPeriod(int id) async
    test('test unlockAccountingPeriod', () async {
      // TODO
    });

    // Update an account
    //
    //Future<Account> updateAccount(int id, AccountUpdate accountUpdate) async
    test('test updateAccount', () async {
      // TODO
    });

    // Update a draft expense voucher
    //
    //Future<ExpenseVoucher> updateExpense(int id, ExpenseUpdate expenseUpdate) async
    test('test updateExpense', () async {
      // TODO
    });

    // Update item
    //
    //Future<Item> updateItem(int id, ItemUpdate itemUpdate) async
    test('test updateItem', () async {
      // TODO
    });

    // Update a draft payment voucher
    //
    //Future<PaymentVoucher> updatePaymentVoucher(int id, PaymentVoucherUpdate paymentVoucherUpdate) async
    test('test updatePaymentVoucher', () async {
      // TODO
    });

    // Update a draft purchase bill
    //
    //Future<PurchaseBill> updatePurchaseBill(int id, PurchaseBillUpdate purchaseBillUpdate) async
    test('test updatePurchaseBill', () async {
      // TODO
    });

    // Update a tax code
    //
    //Future<TaxCode> updateTaxCode(int id, TaxCodeUpdate taxCodeUpdate) async
    test('test updateTaxCode', () async {
      // TODO
    });

    // Update vendor
    //
    //Future<Vendor> updateVendor(int id, VendorUpdate vendorUpdate) async
    test('test updateVendor', () async {
      // TODO
    });

  });
}
