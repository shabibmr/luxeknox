import 'package:api_client/api_client.dart' as api;
import 'package:built_collection/built_collection.dart';

import '../../domain/entities/account.dart';
import '../../domain/entities/accounting_period.dart';
import '../../domain/entities/accounting_reports.dart';
import '../../domain/entities/debit_note.dart';
import '../../domain/entities/expense_voucher.dart';
import '../../domain/entities/item.dart';
import '../../domain/entities/journal.dart';
import '../../domain/entities/payment_voucher.dart';
import '../../domain/entities/purchase_bill.dart';
import '../../domain/entities/tax_code.dart';
import '../../domain/entities/vendor.dart';

// Accounts
extension AccountModelMapper on api.Account {
  Account toDomain() {
    return Account(
      id: id.toString(),
      code: code,
      name: name,
      type: accountType.name,
      isControl: isControl,
      isBank: isBank,
      isActive: isActive,
      description: controlRole,
      rowVersion: 1,
    );
  }
}

api.AccountCreate toAccountCreate({
  required String code,
  required String name,
  required String accountType,
  String? parentId,
  bool? isActive,
  bool? isBank,
  bool? isControl,
  String? controlRole,
}) {
  return api.AccountCreate(
    (b) => b
      ..code = code
      ..name = name
      ..accountType = api.AccountType.valueOf(accountType)
      ..parentId = parentId == null ? null : int.tryParse(parentId)
      ..isActive = isActive
      ..isBank = isBank
      ..isControl = isControl
      ..controlRole = controlRole,
  );
}

api.AccountUpdate toAccountUpdate({
  String? name,
  String? parentId,
  bool? isActive,
  bool? isBank,
}) {
  return api.AccountUpdate(
    (b) => b
      ..name = name
      ..parentId = parentId == null ? null : int.tryParse(parentId)
      ..isActive = isActive
      ..isBank = isBank,
  );
}

// Journals
extension JournalLineModelMapper on api.JournalLine {
  JournalLine toDomain() {
    return JournalLine(
      id: id.toString(),
      journalId: journalEntryId.toString(),
      accountId: accountId.toString(),
      accountCode: null,
      accountName: null,
      debit: debit,
      credit: credit,
      description: memo,
    );
  }
}

extension JournalModelMapper on api.Journal {
  Journal toDomain() {
    return Journal(
      id: id.toString(),
      journalNumber: journalNumber,
      entryDate: entryDate.toDateTime(),
      sourceType: sourceType,
      sourceId: sourceId.toString(),
      memo: memo,
      status: 'posted',
      reversesJournalId: reversesJournalId?.toString(),
      isClosing: false,
      isOpening: sourceType == 'opening_balance',
      rowVersion: rowVersion,
      lines: lines.map((l) => l.toDomain()).toList(),
    );
  }
}

api.JournalCreate toJournalCreate({
  required DateTime entryDate,
  required String sourceType,
  String? memo,
  required List<JournalLine> lines,
}) {
  return api.JournalCreate(
    (b) => b
      ..entryDate = entryDate.toDate()
      ..sourceType = api.JournalCreateSourceTypeEnum.valueOf(sourceType)
      ..memo = memo
      ..lines = ListBuilder<api.JournalLineWrite>(
        lines.map(
          (l) => api.JournalLineWrite(
            (lb) => lb
              ..accountId = int.parse(l.accountId)
              ..debit = l.debit
              ..credit = l.credit
              ..memo = l.description,
          ),
        ),
      ),
  );
}

api.JournalReverse toJournalReverse({
  DateTime? entryDate,
  String? memo,
}) {
  return api.JournalReverse(
    (b) => b
      ..entryDate = entryDate?.toDate()
      ..memo = memo,
  );
}

// Fiscal Years & Periods
extension FiscalYearModelMapper on api.FiscalYear {
  FiscalYear toDomain() {
    return FiscalYear(
      id: id.toString(),
      name: label,
      startDate: startsOn.toDateTime(),
      endDate: endsOn.toDateTime(),
      isClosed: false,
    );
  }
}

extension DraftDocumentCountsModelMapper on api.DraftDocumentCounts {
  DraftDocumentCounts toDomain() {
    return DraftDocumentCounts(
      billsCount: purchaseBills,
      expensesCount: expenseVouchers,
      paymentVouchersCount: paymentVouchers,
      debitNotesCount: debitNotes,
    );
  }
}

extension AccountingPeriodModelMapper on api.AccountingPeriod {
  AccountingPeriod toDomain() {
    return AccountingPeriod(
      id: id.toString(),
      fiscalYearId: fiscalYearId.toString(),
      periodNumber: 1,
      name: '${startsOn.toString()} - ${endsOn.toString()}',
      startDate: startsOn.toDateTime(),
      endDate: endsOn.toDateTime(),
      isLocked: status == api.AccountingPeriodStatusEnum.locked,
      lockedAt: closedAt,
      lockedByUserId: closedByUserId?.toString(),
      draftCounts: draftDocumentCounts?.toDomain(),
    );
  }
}

// Vendors
extension VendorModelMapper on api.Vendor {
  Vendor toDomain() {
    return Vendor(
      id: id.toString(),
      name: name,
      taxNumber: gstin,
      contactEmail: email,
      phone: phone,
      address: null,
      isActive: isActive,
      rowVersion: 1,
    );
  }
}

api.VendorWrite toVendorWrite({
  required String name,
  String? phone,
  String? email,
  String? gstin,
  bool? isActive,
}) {
  return api.VendorWrite(
    (b) => b
      ..name = name
      ..phone = phone
      ..email = email
      ..gstin = gstin
      ..isActive = isActive,
  );
}

api.VendorUpdate toVendorUpdate({
  String? name,
  String? phone,
  String? email,
  String? gstin,
  bool? isActive,
}) {
  return api.VendorUpdate(
    (b) => b
      ..name = name
      ..phone = phone
      ..email = email
      ..gstin = gstin
      ..isActive = isActive,
  );
}

// Purchase Bills
extension PurchaseBillLineModelMapper on api.PurchaseBillLine {
  PurchaseBillLine toDomain() {
    return PurchaseBillLine(
      id: id.toString(),
      billId: purchaseBillId.toString(),
      accountId: accountId.toString(),
      itemId: itemId?.toString(),
      description: description,
      quantity: quantity,
      unitPrice: rate,
      amount: netAmount,
      taxCodeId: taxCodeId?.toString(),
      taxAmount: taxAmount,
    );
  }
}

extension PurchaseBillModelMapper on api.PurchaseBill {
  PurchaseBill toDomain() {
    return PurchaseBill(
      id: id.toString(),
      billNumber: billNumber,
      vendorId: vendorId.toString(),
      vendorName: null,
      billDate: billDate.toDateTime(),
      dueDate: dueDate?.toDateTime(),
      subtotal: subtotal,
      taxAmount: taxAmount,
      totalAmount: totalAmount,
      status: status.name,
      allocatedAmount: '0.00',
      journalEntryId: journalEntryId?.toString(),
      rowVersion: rowVersion,
      lines: lines.map((l) => l.toDomain()).toList(),
    );
  }
}

api.PurchaseBillCreate toPurchaseBillCreate({
  required String vendorId,
  required DateTime billDate,
  DateTime? dueDate,
  required List<PurchaseBillLine> lines,
}) {
  return api.PurchaseBillCreate(
    (b) => b
      ..vendorId = int.parse(vendorId)
      ..billDate = billDate.toDate()
      ..dueDate = dueDate?.toDate()
      ..lines = ListBuilder<api.PurchaseBillLineWrite>(
        lines.map(
          (l) => api.PurchaseBillLineWrite(
            (lb) => lb
              ..itemId = l.itemId == null ? null : int.tryParse(l.itemId!)
              ..accountId = int.parse(l.accountId)
              ..description = l.description
              ..quantity = l.quantity
              ..rate = l.unitPrice
              ..taxCodeId = l.taxCodeId == null ? null : int.tryParse(l.taxCodeId!),
          ),
        ),
      ),
  );
}

api.PurchaseBillUpdate toPurchaseBillUpdate({
  String? vendorId,
  DateTime? billDate,
  DateTime? dueDate,
  List<PurchaseBillLine>? lines,
}) {
  return api.PurchaseBillUpdate(
    (b) => b
      ..vendorId = vendorId == null ? null : int.tryParse(vendorId)
      ..billDate = billDate?.toDate()
      ..dueDate = dueDate?.toDate()
      ..lines = lines == null
          ? null
          : ListBuilder<api.PurchaseBillLineWrite>(
              lines.map(
                (l) => api.PurchaseBillLineWrite(
                  (lb) => lb
                    ..itemId = l.itemId == null ? null : int.tryParse(l.itemId!)
                    ..accountId = int.parse(l.accountId)
                    ..description = l.description
                    ..quantity = l.quantity
                    ..rate = l.unitPrice
                    ..taxCodeId = l.taxCodeId == null ? null : int.tryParse(l.taxCodeId!),
                ),
              ),
            ),
  );
}

// Expenses
extension ExpenseVoucherModelMapper on api.ExpenseVoucher {
  ExpenseVoucher toDomain() {
    return ExpenseVoucher(
      id: id.toString(),
      voucherNumber: expenseNumber,
      expenseDate: expenseDate.toDateTime(),
      paymentMethodId: null,
      bankAccountId: paidFromAccountId?.toString(),
      vendorId: vendorId?.toString(),
      isCreditExpense: paidFromAccountId == null,
      totalAmount: totalAmount,
      taxAmount: taxAmount,
      status: status.name,
      journalEntryId: journalEntryId?.toString(),
      memo: payeeName,
      rowVersion: rowVersion,
    );
  }
}

api.ExpenseCreate toExpenseCreate({
  required DateTime expenseDate,
  String? paidFromAccountId,
  String? vendorId,
  String? payeeName,
  required List<PurchaseBillLine> lines,
}) {
  return api.ExpenseCreate(
    (b) => b
      ..expenseDate = expenseDate.toDate()
      ..paidFromAccountId =
          paidFromAccountId == null ? null : int.tryParse(paidFromAccountId)
      ..vendorId = vendorId == null ? null : int.tryParse(vendorId)
      ..payeeName = payeeName
      ..lines = ListBuilder<api.ExpenseLineCreate>(
        lines.map(
          (l) => api.ExpenseLineCreate(
            (lb) => lb
              ..accountId = int.parse(l.accountId)
              ..description = l.description
              ..amount = l.amount
              ..taxCodeId =
                  l.taxCodeId == null ? null : int.tryParse(l.taxCodeId!),
          ),
        ),
      ),
  );
}

api.ExpenseUpdate toExpenseUpdate({
  DateTime? expenseDate,
  String? paidFromAccountId,
  String? vendorId,
  String? payeeName,
  List<PurchaseBillLine>? lines,
}) {
  return api.ExpenseUpdate(
    (b) => b
      ..expenseDate = expenseDate?.toDate()
      ..paidFromAccountId =
          paidFromAccountId == null ? null : int.tryParse(paidFromAccountId)
      ..vendorId = vendorId == null ? null : int.tryParse(vendorId)
      ..payeeName = payeeName
      ..lines = lines == null
          ? null
          : ListBuilder<api.ExpenseLineCreate>(
              lines.map(
                (l) => api.ExpenseLineCreate(
                  (lb) => lb
                    ..accountId = int.parse(l.accountId)
                    ..description = l.description
                    ..amount = l.amount
                    ..taxCodeId =
                        l.taxCodeId == null ? null : int.tryParse(l.taxCodeId!),
                ),
              ),
            ),
  );
}

// Payment Vouchers
extension PaymentVoucherModelMapper on api.PaymentVoucher {
  PaymentVoucher toDomain() {
    return PaymentVoucher(
      id: id.toString(),
      voucherNumber: voucherNumber,
      voucherDate: paymentDate.toDateTime(),
      vendorId:
          allocations.isNotEmpty && allocations.first.purchaseBillId != null
              ? allocations.first.purchaseBillId.toString()
              : '',
      paymentMethodId: null,
      bankAccountId: bankAccountId.toString(),
      amount: totalAmount,
      status: status.name,
      journalEntryId: journalEntryId?.toString(),
      memo: memo,
      rowVersion: rowVersion,
    );
  }
}

api.PaymentVoucherCreate toPaymentVoucherCreate({
  required DateTime paymentDate,
  required String bankAccountId,
  required String totalAmount,
  String? memo,
  required List<Map<String, dynamic>> allocations,
}) {
  return api.PaymentVoucherCreate(
    (b) => b
      ..paymentDate = paymentDate.toDate()
      ..bankAccountId = int.parse(bankAccountId)
      ..totalAmount = totalAmount
      ..memo = memo
      ..allocations = ListBuilder<api.PaymentAllocationWrite>(
        allocations.map(
          (a) => api.PaymentAllocationWrite(
            (ab) => ab
              ..purchaseBillId = a['purchaseBillId'] == null
                  ? null
                  : int.tryParse(a['purchaseBillId'].toString())
              ..expenseVoucherId = a['expenseVoucherId'] == null
                  ? null
                  : int.tryParse(a['expenseVoucherId'].toString())
              ..amount = a['amount']?.toString() ?? '0.00',
          ),
        ),
      ),
  );
}

api.PaymentVoucherUpdate toPaymentVoucherUpdate({
  DateTime? paymentDate,
  String? bankAccountId,
  String? totalAmount,
  String? memo,
  List<Map<String, dynamic>>? allocations,
}) {
  return api.PaymentVoucherUpdate(
    (b) => b
      ..paymentDate = paymentDate?.toDate()
      ..bankAccountId =
          bankAccountId == null ? null : int.tryParse(bankAccountId)
      ..totalAmount = totalAmount
      ..memo = memo
      ..allocations = allocations == null
          ? null
          : ListBuilder<api.PaymentAllocationWrite>(
              allocations.map(
                (a) => api.PaymentAllocationWrite(
                  (ab) => ab
                    ..purchaseBillId = a['purchaseBillId'] == null
                        ? null
                        : int.tryParse(a['purchaseBillId'].toString())
                    ..expenseVoucherId = a['expenseVoucherId'] == null
                        ? null
                        : int.tryParse(a['expenseVoucherId'].toString())
                    ..amount = a['amount']?.toString() ?? '0.00',
                ),
              ),
            ),
  );
}

// Debit Notes
extension DebitNoteModelMapper on api.DebitNote {
  DebitNote toDomain() {
    return DebitNote(
      id: id.toString(),
      noteNumber: debitNoteNumber,
      noteDate: debitNoteDate.toDateTime(),
      purchaseBillId: purchaseBillId.toString(),
      amount: subtotal,
      taxAmount: taxAmount,
      status: status.name,
      journalEntryId: journalEntryId?.toString(),
      reason: reason,
      rowVersion: rowVersion,
    );
  }
}

api.DebitNoteCreate toDebitNoteCreate({
  required String purchaseBillId,
  required DateTime debitNoteDate,
  String? reason,
  required String subtotal,
  String? taxAmount,
}) {
  return api.DebitNoteCreate(
    (b) => b
      ..purchaseBillId = int.parse(purchaseBillId)
      ..debitNoteDate = debitNoteDate.toDate()
      ..reason = reason
      ..subtotal = subtotal
      ..taxAmount = taxAmount,
  );
}

// Tax Codes
extension TaxCodeComponentModelMapper on api.TaxCodeComponent {
  TaxComponent toDomain() {
    return TaxComponent(
      id: id.toString(),
      taxCodeId: taxCodeId.toString(),
      name: name,
      ratePercent: ratePercent,
      accountId: outputAccountId.toString(),
    );
  }
}

extension TaxCodeModelMapper on api.TaxCode {
  TaxCode toDomain() {
    return TaxCode(
      id: id.toString(),
      code: code,
      name: name,
      ratePercent: ratePercent,
      isActive: isActive,
      components: components.map((c) => c.toDomain()).toList(),
    );
  }
}

api.TaxCodeCreate toTaxCodeCreate({
  required String name,
  required String code,
  required String ratePercent,
  bool? isActive,
  List<TaxComponent>? components,
}) {
  return api.TaxCodeCreate(
    (b) => b
      ..name = name
      ..code = code
      ..ratePercent = ratePercent
      ..isActive = isActive
      ..components = components == null
          ? null
          : ListBuilder<api.TaxCodeComponentWrite>(
              components.map(
                (c) => api.TaxCodeComponentWrite(
                  (cb) => cb
                    ..name = c.name
                    ..ratePercent = c.ratePercent
                    ..outputAccountId = int.parse(c.accountId)
                    ..inputAccountId = int.parse(c.accountId),
                ),
              ),
            ),
  );
}

api.TaxCodeUpdate toTaxCodeUpdate({
  String? name,
  String? ratePercent,
  bool? isActive,
  List<TaxComponent>? components,
}) {
  return api.TaxCodeUpdate(
    (b) => b
      ..name = name
      ..ratePercent = ratePercent
      ..isActive = isActive
      ..components = components == null
          ? null
          : ListBuilder<api.TaxCodeComponentWrite>(
              components.map(
                (c) => api.TaxCodeComponentWrite(
                  (cb) => cb
                    ..name = c.name
                    ..ratePercent = c.ratePercent
                    ..outputAccountId = int.parse(c.accountId)
                    ..inputAccountId = int.parse(c.accountId),
                ),
              ),
            ),
  );
}

// Items
extension ItemModelMapper on api.Item {
  Item toDomain() {
    return Item(
      id: id.toString(),
      name: name,
      code: '',
      kind: itemKind.name,
      incomeAccountId: incomeAccountId.toString(),
      expenseAccountId: expenseAccountId.toString(),
      defaultTaxCodeId: taxCodeId?.toString(),
      isActive: isActive,
      rowVersion: 1,
    );
  }
}

api.ItemCreate toItemCreate({
  required String name,
  required String kind,
  required String incomeAccountId,
  required String expenseAccountId,
  String? defaultTaxCodeId,
  bool? isActive,
  bool? inventoryTracked,
}) {
  return api.ItemCreate(
    (b) => b
      ..name = name
      ..itemKind = api.ItemKind.valueOf(kind)
      ..incomeAccountId = int.parse(incomeAccountId)
      ..expenseAccountId = int.parse(expenseAccountId)
      ..taxCodeId =
          defaultTaxCodeId == null ? null : int.tryParse(defaultTaxCodeId)
      ..isActive = isActive
      ..inventoryTracked = inventoryTracked,
  );
}

api.ItemUpdate toItemUpdate({
  String? name,
  String? incomeAccountId,
  String? expenseAccountId,
  String? defaultTaxCodeId,
  bool? isActive,
  bool? inventoryTracked,
}) {
  return api.ItemUpdate(
    (b) => b
      ..name = name
      ..incomeAccountId =
          incomeAccountId == null ? null : int.tryParse(incomeAccountId)
      ..expenseAccountId =
          expenseAccountId == null ? null : int.tryParse(expenseAccountId)
      ..taxCodeId =
          defaultTaxCodeId == null ? null : int.tryParse(defaultTaxCodeId)
      ..isActive = isActive
      ..inventoryTracked = inventoryTracked,
  );
}

// Reports
extension TrialBalanceAccountModelMapper on api.TrialBalanceAccount {
  TrialBalanceAccountItem toDomain() {
    return TrialBalanceAccountItem(
      accountId: accountId.toString(),
      accountCode: accountCode,
      accountName: accountName,
      debit: debit,
      credit: credit,
    );
  }
}

extension TrialBalanceReportModelMapper on api.TrialBalanceReport {
  TrialBalanceReport toDomain() {
    return TrialBalanceReport(
      fromDate: from?.toDateTime(),
      toDate: to.toDateTime(),
      totalDebit: totalDebit,
      totalCredit: totalCredit,
      accounts: accounts.map((a) => a.toDomain()).toList(),
    );
  }
}

extension ProfitAndLossAccountModelMapper on api.ProfitAndLossAccount {
  ReportAccountItem toDomain() {
    return ReportAccountItem(
      accountId: accountId.toString(),
      accountCode: accountCode,
      accountName: accountName,
      amount: amount,
    );
  }
}

extension ProfitAndLossReportModelMapper on api.ProfitAndLossReport {
  ProfitAndLossReport toDomain() {
    return ProfitAndLossReport(
      fromDate: from.toDateTime(),
      toDate: to.toDateTime(),
      totalIncome: totalIncome,
      totalExpense: totalExpense,
      netProfit: netProfit,
      incomeAccounts: incomeAccounts.map((a) => a.toDomain()).toList(),
      expenseAccounts: expenseAccounts.map((a) => a.toDomain()).toList(),
    );
  }
}

extension BalanceSheetAccountModelMapper on api.BalanceSheetAccount {
  ReportAccountItem toDomain() {
    return ReportAccountItem(
      accountId: accountId.toString(),
      accountCode: accountCode,
      accountName: accountName,
      amount: amount,
    );
  }
}

extension BalanceSheetReportModelMapper on api.BalanceSheetReport {
  BalanceSheetReport toDomain() {
    return BalanceSheetReport(
      asOfDate: asOf.toDateTime(),
      totalAssets: totalAssets,
      totalLiabilities: totalLiabilities,
      totalEquity: totalEquity,
      currentYearEarnings: currentYearEarnings,
      assetAccounts: assetAccounts.map((a) => a.toDomain()).toList(),
      liabilityAccounts: liabilityAccounts.map((a) => a.toDomain()).toList(),
      equityAccounts: equityAccounts.map((a) => a.toDomain()).toList(),
    );
  }
}

extension DayBookLineModelMapper on api.DayBookLine {
  DayBookLineItem toDomain() {
    return DayBookLineItem(
      id: id.toString(),
      accountId: accountId.toString(),
      accountCode: accountCode,
      accountName: accountName,
      debit: debit,
      credit: credit,
      memo: memo,
    );
  }
}

extension DayBookJournalModelMapper on api.DayBookJournal {
  DayBookJournalItem toDomain() {
    return DayBookJournalItem(
      journalId: id.toString(),
      journalNumber: journalNumber,
      date: entryDate.toDateTime(),
      memo: memo,
      lines: lines.map((l) => l.toDomain()).toList(),
    );
  }
}

extension DayBookReportModelMapper on api.DayBookReport {
  DayBookReport toDomain() {
    return DayBookReport(
      date: date.toDateTime(),
      journals: journals.map((j) => j.toDomain()).toList(),
    );
  }
}

extension OpenApItemModelMapper on api.OpenApItem {
  OpenItemEntry toDomain() {
    return OpenItemEntry(
      documentId: purchaseBillId.toString(),
      documentNumber: billNumber,
      partyName: vendorId.toString(),
      date: billDate.toDateTime(),
      totalAmount: totalAmount,
      openAmount: openAmount,
      kind: 'ap',
    );
  }
}

extension OpenArItemModelMapper on api.OpenArItem {
  OpenItemEntry toDomain() {
    return OpenItemEntry(
      documentId: paymentId.toString(),
      documentNumber: invoiceNumber,
      partyName: memberId.toString(),
      date: invoiceDate.toDateTime(),
      totalAmount: totalAmount,
      openAmount: openAmount,
      kind: 'ar',
    );
  }
}

extension OpenItemsReportModelMapper on api.OpenItemsReport {
  OpenItemsReport toDomain() {
    final List<OpenItemEntry> allItems = [];
    if (arItems != null) {
      allItems.addAll(arItems!.map((item) => item.toDomain()));
    }
    if (apItems != null) {
      allItems.addAll(apItems!.map((item) => item.toDomain()));
    }
    return OpenItemsReport(
      kind: kind.name,
      totalOpenAmount: totalOpenAmount,
      items: allItems,
    );
  }
}

extension GstTaxCodeSummaryModelMapper on api.GstTaxCodeSummary {
  GstTaxCodeSummary toDomain() {
    return GstTaxCodeSummary(
      taxCodeId: taxCodeId.toString(),
      taxCodeName: taxCodeName,
      ratePercent: ratePercent,
      taxableValue: taxableValue,
      cgstAmount: cgstAmount,
      sgstAmount: sgstAmount,
      igstAmount: igstAmount,
      totalTax: totalTax,
    );
  }
}

extension GstSummaryReportModelMapper on api.GstSummaryReport {
  GstSummaryReport toDomain() {
    return GstSummaryReport(
      fromDate: from.toDateTime(),
      toDate: to.toDateTime(),
      totalTaxableValue: totalTaxableValue,
      totalOutputTax: totalOutputTax,
      totalInputTax: inputTaxCredit,
      netTaxPayable: netPayable,
      codeSummaries: taxCodes.map((tc) => tc.toDomain()).toList(),
    );
  }
}

extension UnearnedPreviewItemModelMapper on api.UnearnedPreviewItem {
  UnearnedPreviewReportItem toDomain() {
    return UnearnedPreviewReportItem(
      kind: kind.name,
      sourceId: sourceId.toString(),
      paymentId: paymentId.toString(),
      memberId: memberId.toString(),
      startsOn: startsOn.toDateTime(),
      endsOn: endsOn.toDateTime(),
      unearnedAccountId: unearnedAccountId.toString(),
      incomeAccountId: incomeAccountId.toString(),
      accountCode: accountCode,
      totalNet: totalNet,
      unexpiredAmount: unexpiredAmount,
    );
  }
}

extension UnearnedPreviewResponseModelMapper on api.UnearnedPreviewResponse {
  UnearnedPreviewReport toDomain() {
    return UnearnedPreviewReport(
      asOfDate: goLiveDate.toDateTime(),
      totalMembershipUnearned: totals.unearnedMembershipTotal,
      totalPtUnearned: totals.unearnedPtTotal,
      totalUnearned: totals.combinedTotal,
      items: items.map((i) => i.toDomain()).toList(),
    );
  }
}
