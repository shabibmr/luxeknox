import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/pagination/cursor_page.dart';
import '../entities/account.dart';
import '../entities/accounting_period.dart';
import '../entities/accounting_reports.dart';
import '../entities/debit_note.dart';
import '../entities/expense_voucher.dart';
import '../entities/item.dart';
import '../entities/journal.dart';
import '../entities/payment_voucher.dart';
import '../entities/purchase_bill.dart';
import '../entities/tax_code.dart';
import '../entities/vendor.dart';

abstract class AccountingRepository {
  // Accounts
  Future<Either<Failure, CursorPage<Account>>> getAccounts({
    int? limit,
    int? offset,
    String? accountType,
    bool? isActive,
    String? search,
  });

  Future<Either<Failure, Account>> getAccount(String id);

  Future<Either<Failure, Account>> createAccount({
    required String code,
    required String name,
    required String accountType,
    String? parentId,
    bool? isActive,
    bool? isBank,
    bool? isControl,
    String? controlRole,
  });

  Future<Either<Failure, Account>> updateAccount({
    required String id,
    String? name,
    String? parentId,
    bool? isActive,
    bool? isBank,
  });

  // Journals
  Future<Either<Failure, CursorPage<Journal>>> getJournals({
    int? limit,
    int? offset,
    DateTime? from,
    DateTime? to,
    String? sourceType,
    String? paymentId,
  });

  Future<Either<Failure, Journal>> getJournal(String id);

  Future<Either<Failure, Journal>> createJournal({
    required DateTime entryDate,
    required String sourceType,
    String? memo,
    required List<JournalLine> lines,
    String? idempotencyKey,
  });

  Future<Either<Failure, Journal>> reverseJournal({
    required String id,
    DateTime? entryDate,
    String? memo,
    String? idempotencyKey,
  });

  // Fiscal Years & Periods
  Future<Either<Failure, List<FiscalYear>>> getFiscalYears();

  Future<Either<Failure, List<AccountingPeriod>>> getAccountingPeriods({
    String? fiscalYearId,
    String? status,
  });

  Future<Either<Failure, AccountingPeriod>> lockAccountingPeriod(String id);

  Future<Either<Failure, AccountingPeriod>> unlockAccountingPeriod(String id);

  // Vendors
  Future<Either<Failure, CursorPage<Vendor>>> getVendors({
    int? limit,
    int? offset,
    bool? isActive,
    String? search,
  });

  Future<Either<Failure, Vendor>> getVendor(String id);

  Future<Either<Failure, Vendor>> createVendor({
    required String name,
    String? phone,
    String? email,
    String? gstin,
    bool? isActive,
  });

  Future<Either<Failure, Vendor>> updateVendor({
    required String id,
    String? name,
    String? phone,
    String? email,
    String? gstin,
    bool? isActive,
  });

  // Purchase Bills
  Future<Either<Failure, CursorPage<PurchaseBill>>> getPurchaseBills({
    int? limit,
    int? offset,
    String? status,
    String? vendorId,
    DateTime? from,
    DateTime? to,
    String? search,
  });

  Future<Either<Failure, PurchaseBill>> getPurchaseBill(String id);

  Future<Either<Failure, PurchaseBill>> createPurchaseBill({
    required String vendorId,
    required DateTime billDate,
    DateTime? dueDate,
    required List<PurchaseBillLine> lines,
    String? idempotencyKey,
  });

  Future<Either<Failure, PurchaseBill>> updatePurchaseBill({
    required String id,
    String? vendorId,
    DateTime? billDate,
    DateTime? dueDate,
    List<PurchaseBillLine>? lines,
  });

  Future<Either<Failure, PurchaseBill>> postPurchaseBill(String id);

  // Expense Vouchers
  Future<Either<Failure, CursorPage<ExpenseVoucher>>> getExpenses({
    int? limit,
    int? offset,
    String? status,
    String? vendorId,
    DateTime? from,
    DateTime? to,
    String? search,
  });

  Future<Either<Failure, ExpenseVoucher>> getExpense(String id);

  Future<Either<Failure, ExpenseVoucher>> createExpense({
    required DateTime expenseDate,
    String? paidFromAccountId,
    String? vendorId,
    String? payeeName,
    required List<PurchaseBillLine> lines,
    String? idempotencyKey,
  });

  Future<Either<Failure, ExpenseVoucher>> updateExpense({
    required String id,
    DateTime? expenseDate,
    String? paidFromAccountId,
    String? vendorId,
    String? payeeName,
    List<PurchaseBillLine>? lines,
  });

  Future<Either<Failure, ExpenseVoucher>> postExpense(String id);

  // Payment Vouchers
  Future<Either<Failure, CursorPage<PaymentVoucher>>> getPaymentVouchers({
    int? limit,
    int? offset,
    String? status,
    String? bankAccountId,
    DateTime? from,
    DateTime? to,
    String? search,
  });

  Future<Either<Failure, PaymentVoucher>> getPaymentVoucher(String id);

  Future<Either<Failure, PaymentVoucher>> createPaymentVoucher({
    required DateTime paymentDate,
    required String bankAccountId,
    required String totalAmount,
    String? memo,
    required List<Map<String, dynamic>> allocations,
    String? idempotencyKey,
  });

  Future<Either<Failure, PaymentVoucher>> updatePaymentVoucher({
    required String id,
    DateTime? paymentDate,
    String? bankAccountId,
    String? totalAmount,
    String? memo,
    List<Map<String, dynamic>>? allocations,
  });

  Future<Either<Failure, PaymentVoucher>> postPaymentVoucher(String id);

  // Debit Notes
  Future<Either<Failure, CursorPage<DebitNote>>> getDebitNotes({
    int? limit,
    int? offset,
    String? status,
    String? purchaseBillId,
    DateTime? from,
    DateTime? to,
    String? search,
  });

  Future<Either<Failure, DebitNote>> getDebitNote(String id);

  Future<Either<Failure, DebitNote>> createDebitNote({
    required String purchaseBillId,
    required DateTime debitNoteDate,
    String? reason,
    required String subtotal,
    String? taxAmount,
    String? idempotencyKey,
  });

  Future<Either<Failure, DebitNote>> postDebitNote(String id);

  // Tax Codes
  Future<Either<Failure, CursorPage<TaxCode>>> getTaxCodes({
    int? limit,
    int? offset,
    bool? isActive,
  });

  Future<Either<Failure, TaxCode>> getTaxCode(String id);

  Future<Either<Failure, TaxCode>> createTaxCode({
    required String name,
    required String code,
    required String ratePercent,
    bool? isActive,
    List<TaxComponent>? components,
  });

  Future<Either<Failure, TaxCode>> updateTaxCode({
    required String id,
    String? name,
    String? ratePercent,
    bool? isActive,
    List<TaxComponent>? components,
  });

  // Items
  Future<Either<Failure, CursorPage<Item>>> getItems({
    int? limit,
    int? offset,
    String? kind,
    bool? isActive,
    String? search,
  });

  Future<Either<Failure, Item>> getItem(String id);

  Future<Either<Failure, Item>> createItem({
    required String name,
    required String kind,
    required String incomeAccountId,
    required String expenseAccountId,
    String? defaultTaxCodeId,
    bool? isActive,
    bool? inventoryTracked,
  });

  Future<Either<Failure, Item>> updateItem({
    required String id,
    String? name,
    String? incomeAccountId,
    String? expenseAccountId,
    String? defaultTaxCodeId,
    bool? isActive,
    bool? inventoryTracked,
  });

  // Reports
  Future<Either<Failure, TrialBalanceReport>> getTrialBalance({
    DateTime? from,
    required DateTime to,
  });

  Future<Either<Failure, ProfitAndLossReport>> getProfitAndLoss({
    required DateTime from,
    required DateTime to,
  });

  Future<Either<Failure, BalanceSheetReport>> getBalanceSheet({
    required DateTime asOf,
  });

  Future<Either<Failure, DayBookReport>> getDayBook({
    required DateTime date,
  });

  Future<Either<Failure, OpenItemsReport>> getOpenItems({
    required String kind,
  });

  Future<Either<Failure, GstSummaryReport>> getGstSummary({
    required DateTime from,
    required DateTime to,
  });

  Future<Either<Failure, UnearnedPreviewReport>> getUnearnedPreview({
    DateTime? goLiveDate,
  });
}
