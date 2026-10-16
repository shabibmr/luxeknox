import 'package:api_client/api_client.dart' as api;
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/error/map_thrown.dart';
import '../../../../core/pagination/cursor_page.dart';
import '../../domain/entities/account.dart';
import '../../domain/entities/accounting_period.dart';
import '../../domain/entities/accounting_reports.dart';
import '../../domain/entities/debit_note.dart';
import '../../domain/entities/expense_voucher.dart';
import '../../domain/entities/fund_transfer.dart';
import '../../domain/entities/go_live.dart';
import '../../domain/entities/item.dart';
import '../../domain/entities/journal.dart';
import '../../domain/entities/payment_voucher.dart';
import '../../domain/entities/purchase_bill.dart';
import '../../domain/entities/tax_code.dart';
import '../../domain/entities/vendor.dart';
import '../../domain/repositories/accounting_repository.dart';
import '../datasources/accounting_remote_datasource.dart';
import '../models/accounting_mappers.dart';

@LazySingleton(as: AccountingRepository)
class AccountingRepositoryImpl implements AccountingRepository {
  AccountingRepositoryImpl(this._remoteDataSource);

  final AccountingRemoteDataSource _remoteDataSource;

  int? _parseId(String id) => int.tryParse(id);

  // Accounts
  @override
  Future<Either<Failure, CursorPage<Account>>> getAccounts({
    int? limit,
    int? offset,
    String? accountType,
    bool? isActive,
    String? search,
  }) async {
    try {
      final page = await _remoteDataSource.listAccounts(
        limit: limit,
        offset: offset,
        accountType:
            accountType == null ? null : api.AccountType.valueOf(accountType),
        isActive: isActive,
        search: search,
      );
      return Right(
        CursorPage<Account>(
          items: page.data.map((a) => a.toDomain()).toList(),
          nextCursor: page.meta.nextCursor,
          hasMore: page.meta.hasMore,
        ),
      );
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Account>> getAccount(String id) async {
    final intId = _parseId(id);
    if (intId == null) return const Left(NotFoundFailure());
    try {
      final model = await _remoteDataSource.getAccount(intId);
      return Right(model.toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Account>> createAccount({
    String? code,
    required String name,
    required String accountType,
    String? parentId,
    bool? isActive,
    bool? isBank,
    bool? isControl,
    String? controlRole,
  }) async {
    try {
      final created = await _remoteDataSource.createAccount(
        toAccountCreate(
          code: code,
          name: name,
          accountType: accountType,
          parentId: parentId,
          isActive: isActive,
          isBank: isBank,
          isControl: isControl,
          controlRole: controlRole,
        ),
      );
      return Right(created.toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Account>> updateAccount({
    required String id,
    String? name,
    String? parentId,
    bool? isActive,
    bool? isBank,
  }) async {
    final intId = _parseId(id);
    if (intId == null) return const Left(NotFoundFailure());
    try {
      final updated = await _remoteDataSource.updateAccount(
        id: intId,
        accountUpdate: toAccountUpdate(
          name: name,
          parentId: parentId,
          isActive: isActive,
          isBank: isBank,
        ),
      );
      return Right(updated.toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  // Journals
  @override
  Future<Either<Failure, CursorPage<Journal>>> getJournals({
    int? limit,
    int? offset,
    DateTime? from,
    DateTime? to,
    String? sourceType,
    String? paymentId,
  }) async {
    try {
      final page = await _remoteDataSource.listJournals(
        limit: limit,
        offset: offset,
        from: from?.toDate(),
        to: to?.toDate(),
        sourceType: sourceType,
        paymentId: paymentId == null ? null : int.tryParse(paymentId),
      );
      return Right(
        CursorPage<Journal>(
          items: page.data.map((j) => j.toDomain()).toList(),
          nextCursor: page.meta.nextCursor,
          hasMore: page.meta.hasMore,
        ),
      );
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Journal>> getJournal(String id) async {
    final intId = _parseId(id);
    if (intId == null) return const Left(NotFoundFailure());
    try {
      final model = await _remoteDataSource.getJournal(intId);
      return Right(model.toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Journal>> createJournal({
    required DateTime entryDate,
    required String sourceType,
    String? memo,
    required List<JournalLine> lines,
    String? idempotencyKey,
  }) async {
    try {
      final created = await _remoteDataSource.createJournal(
        journalCreate: toJournalCreate(
          entryDate: entryDate,
          sourceType: sourceType,
          memo: memo,
          lines: lines,
        ),
        idempotencyKey: idempotencyKey,
      );
      return Right(created.toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Journal>> reverseJournal({
    required String id,
    DateTime? entryDate,
    String? memo,
    String? idempotencyKey,
  }) async {
    final intId = _parseId(id);
    if (intId == null) return const Left(NotFoundFailure());
    try {
      final reversed = await _remoteDataSource.reverseJournal(
        id: intId,
        journalReverse: toJournalReverse(
          entryDate: entryDate,
          memo: memo,
        ),
        idempotencyKey: idempotencyKey,
      );
      return Right(reversed.toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  // Fiscal Years & Periods
  @override
  Future<Either<Failure, List<FiscalYear>>> getFiscalYears() async {
    try {
      final list = await _remoteDataSource.listFiscalYears();
      return Right(list.map((fy) => fy.toDomain()).toList());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<AccountingPeriod>>> getAccountingPeriods({
    String? fiscalYearId,
    String? status,
  }) async {
    try {
      final list = await _remoteDataSource.listAccountingPeriods(
        fiscalYearId: fiscalYearId == null ? null : int.tryParse(fiscalYearId),
        status: status,
      );
      return Right(list.map((ap) => ap.toDomain()).toList());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, AccountingPeriod>> lockAccountingPeriod(String id) async {
    final intId = _parseId(id);
    if (intId == null) return const Left(NotFoundFailure());
    try {
      final period = await _remoteDataSource.lockAccountingPeriod(intId);
      return Right(period.toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, AccountingPeriod>> unlockAccountingPeriod(String id) async {
    final intId = _parseId(id);
    if (intId == null) return const Left(NotFoundFailure());
    try {
      final period = await _remoteDataSource.unlockAccountingPeriod(intId);
      return Right(period.toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  // Vendors
  @override
  Future<Either<Failure, CursorPage<Vendor>>> getVendors({
    int? limit,
    int? offset,
    bool? isActive,
    String? search,
  }) async {
    try {
      final page = await _remoteDataSource.listVendors(
        limit: limit,
        offset: offset,
        isActive: isActive,
        search: search,
      );
      return Right(
        CursorPage<Vendor>(
          items: page.data.map((v) => v.toDomain()).toList(),
          nextCursor: page.meta.nextCursor,
          hasMore: page.meta.hasMore,
        ),
      );
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Vendor>> getVendor(String id) async {
    final intId = _parseId(id);
    if (intId == null) return const Left(NotFoundFailure());
    try {
      final model = await _remoteDataSource.getVendor(intId);
      return Right(model.toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Vendor>> createVendor({
    required String name,
    String? phone,
    String? email,
    String? gstin,
    bool? isActive,
  }) async {
    try {
      final created = await _remoteDataSource.createVendor(
        toVendorWrite(
          name: name,
          phone: phone,
          email: email,
          gstin: gstin,
          isActive: isActive,
        ),
      );
      return Right(created.toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Vendor>> updateVendor({
    required String id,
    String? name,
    String? phone,
    String? email,
    String? gstin,
    bool? isActive,
  }) async {
    final intId = _parseId(id);
    if (intId == null) return const Left(NotFoundFailure());
    try {
      final updated = await _remoteDataSource.updateVendor(
        id: intId,
        vendorUpdate: toVendorUpdate(
          name: name,
          phone: phone,
          email: email,
          gstin: gstin,
          isActive: isActive,
        ),
      );
      return Right(updated.toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  // Purchase Bills
  @override
  Future<Either<Failure, CursorPage<PurchaseBill>>> getPurchaseBills({
    int? limit,
    int? offset,
    String? status,
    String? vendorId,
    DateTime? from,
    DateTime? to,
    String? search,
  }) async {
    try {
      final page = await _remoteDataSource.listPurchaseBills(
        limit: limit,
        offset: offset,
        status: status == null
            ? null
            : api.PurchaseBillStatus.valueOf(status),
        vendorId: vendorId == null ? null : int.tryParse(vendorId),
        from: from?.toDate(),
        to: to?.toDate(),
        search: search,
      );
      return Right(
        CursorPage<PurchaseBill>(
          items: page.data.map((b) => b.toDomain()).toList(),
          nextCursor: page.meta.nextCursor,
          hasMore: page.meta.hasMore,
        ),
      );
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, PurchaseBill>> getPurchaseBill(String id) async {
    final intId = _parseId(id);
    if (intId == null) return const Left(NotFoundFailure());
    try {
      final model = await _remoteDataSource.getPurchaseBill(intId);
      return Right(model.toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, PurchaseBill>> createPurchaseBill({
    required String vendorId,
    required DateTime billDate,
    DateTime? dueDate,
    required List<PurchaseBillLine> lines,
    String? idempotencyKey,
  }) async {
    try {
      final created = await _remoteDataSource.createPurchaseBill(
        purchaseBillCreate: toPurchaseBillCreate(
          vendorId: vendorId,
          billDate: billDate,
          dueDate: dueDate,
          lines: lines,
        ),
        idempotencyKey: idempotencyKey,
      );
      return Right(created.toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  // Expenses
  @override
  Future<Either<Failure, CursorPage<ExpenseVoucher>>> getExpenses({
    int? limit,
    int? offset,
    String? status,
    String? vendorId,
    DateTime? from,
    DateTime? to,
    String? search,
  }) async {
    try {
      final page = await _remoteDataSource.listExpenses(
        limit: limit,
        offset: offset,
        status:
            status == null ? null : api.ExpenseStatus.valueOf(status),
        vendorId: vendorId == null ? null : int.tryParse(vendorId),
        from: from?.toDate(),
        to: to?.toDate(),
        search: search,
      );
      return Right(
        CursorPage<ExpenseVoucher>(
          items: page.data.map((ev) => ev.toDomain()).toList(),
          nextCursor: page.meta.nextCursor,
          hasMore: page.meta.hasMore,
        ),
      );
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, ExpenseVoucher>> getExpense(String id) async {
    final intId = _parseId(id);
    if (intId == null) return const Left(NotFoundFailure());
    try {
      final model = await _remoteDataSource.getExpense(intId);
      return Right(model.toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, ExpenseVoucher>> createExpense({
    required DateTime expenseDate,
    String? paidFromAccountId,
    String? vendorId,
    String? payeeName,
    required List<PurchaseBillLine> lines,
    String? idempotencyKey,
  }) async {
    try {
      final created = await _remoteDataSource.createExpense(
        expenseCreate: toExpenseCreate(
          expenseDate: expenseDate,
          paidFromAccountId: paidFromAccountId,
          vendorId: vendorId,
          payeeName: payeeName,
          lines: lines,
        ),
        idempotencyKey: idempotencyKey,
      );
      return Right(created.toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, ExpenseVoucher>> updateExpense({
    required String id,
    DateTime? expenseDate,
    String? paidFromAccountId,
    String? vendorId,
    String? payeeName,
    List<PurchaseBillLine>? lines,
  }) async {
    final intId = _parseId(id);
    if (intId == null) return const Left(NotFoundFailure());
    try {
      final updated = await _remoteDataSource.updateExpense(
        id: intId,
        expenseUpdate: toExpenseUpdate(
          expenseDate: expenseDate,
          paidFromAccountId: paidFromAccountId,
          vendorId: vendorId,
          payeeName: payeeName,
          lines: lines,
        ),
      );
      return Right(updated.toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, ExpenseVoucher>> postExpense(String id) async {
    final intId = _parseId(id);
    if (intId == null) return const Left(NotFoundFailure());
    try {
      final posted = await _remoteDataSource.postExpense(intId);
      return Right(posted.toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  // Payment Vouchers
  @override
  Future<Either<Failure, CursorPage<PaymentVoucher>>> getPaymentVouchers({
    int? limit,
    int? offset,
    String? status,
    String? bankAccountId,
    DateTime? from,
    DateTime? to,
    String? search,
  }) async {
    try {
      final page = await _remoteDataSource.listPaymentVouchers(
        limit: limit,
        offset: offset,
        status: status,
        bankAccountId:
            bankAccountId == null ? null : int.tryParse(bankAccountId),
        from: from?.toDate(),
        to: to?.toDate(),
        search: search,
      );
      return Right(
        CursorPage<PaymentVoucher>(
          items: page.data.map((pv) => pv.toDomain()).toList(),
          nextCursor: page.meta.nextCursor,
          hasMore: page.meta.hasMore,
        ),
      );
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, PaymentVoucher>> getPaymentVoucher(String id) async {
    final intId = _parseId(id);
    if (intId == null) return const Left(NotFoundFailure());
    try {
      final model = await _remoteDataSource.getPaymentVoucher(intId);
      return Right(model.toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, PaymentVoucher>> createPaymentVoucher({
    required DateTime paymentDate,
    required String bankAccountId,
    required String totalAmount,
    String? memo,
    required List<Map<String, dynamic>> allocations,
    String? idempotencyKey,
  }) async {
    try {
      final created = await _remoteDataSource.createPaymentVoucher(
        paymentVoucherCreate: toPaymentVoucherCreate(
          paymentDate: paymentDate,
          bankAccountId: bankAccountId,
          totalAmount: totalAmount,
          memo: memo,
          allocations: allocations,
        ),
        idempotencyKey: idempotencyKey,
      );
      return Right(created.toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, PaymentVoucher>> updatePaymentVoucher({
    required String id,
    DateTime? paymentDate,
    String? bankAccountId,
    String? totalAmount,
    String? memo,
    List<Map<String, dynamic>>? allocations,
  }) async {
    final intId = _parseId(id);
    if (intId == null) return const Left(NotFoundFailure());
    try {
      final updated = await _remoteDataSource.updatePaymentVoucher(
        id: intId,
        paymentVoucherUpdate: toPaymentVoucherUpdate(
          paymentDate: paymentDate,
          bankAccountId: bankAccountId,
          totalAmount: totalAmount,
          memo: memo,
          allocations: allocations,
        ),
      );
      return Right(updated.toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, PaymentVoucher>> postPaymentVoucher(String id) async {
    final intId = _parseId(id);
    if (intId == null) return const Left(NotFoundFailure());
    try {
      final posted = await _remoteDataSource.postPaymentVoucher(intId);
      return Right(posted.toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  // Fund Transfers
  @override
  Future<Either<Failure, CursorPage<FundTransfer>>> getFundTransfers({
    int? limit,
    int? offset,
    String? status,
    String? accountId,
    DateTime? from,
    DateTime? to,
    String? search,
  }) async {
    try {
      final page = await _remoteDataSource.listFundTransfers(
        limit: limit,
        offset: offset,
        status: status,
        accountId: accountId == null ? null : int.tryParse(accountId),
        from: from?.toDate(),
        to: to?.toDate(),
        search: search,
      );
      return Right(
        CursorPage<FundTransfer>(
          items: page.data.map((ft) => ft.toDomain()).toList(),
          nextCursor: page.meta.nextCursor,
          hasMore: page.meta.hasMore,
        ),
      );
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, FundTransfer>> getFundTransfer(String id) async {
    final intId = _parseId(id);
    if (intId == null) return const Left(NotFoundFailure());
    try {
      final model = await _remoteDataSource.getFundTransfer(intId);
      return Right(model.toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, FundTransfer>> createFundTransfer({
    required DateTime transferDate,
    required String fromAccountId,
    required String toAccountId,
    required String amount,
    String? feeAmount,
    String? feeAccountId,
    String? memo,
    String? idempotencyKey,
  }) async {
    try {
      final created = await _remoteDataSource.createFundTransfer(
        fundTransferCreate: toFundTransferCreate(
          transferDate: transferDate,
          fromAccountId: fromAccountId,
          toAccountId: toAccountId,
          amount: amount,
          feeAmount: feeAmount,
          feeAccountId: feeAccountId,
          memo: memo,
        ),
        idempotencyKey: idempotencyKey,
      );
      return Right(created.toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, FundTransfer>> updateFundTransfer({
    required String id,
    DateTime? transferDate,
    String? fromAccountId,
    String? toAccountId,
    String? amount,
    String? feeAmount,
    String? feeAccountId,
    String? memo,
  }) async {
    final intId = _parseId(id);
    if (intId == null) return const Left(NotFoundFailure());
    try {
      final updated = await _remoteDataSource.updateFundTransfer(
        id: intId,
        fundTransferUpdate: toFundTransferUpdate(
          transferDate: transferDate,
          fromAccountId: fromAccountId,
          toAccountId: toAccountId,
          amount: amount,
          feeAmount: feeAmount,
          feeAccountId: feeAccountId,
          memo: memo,
        ),
      );
      return Right(updated.toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, FundTransfer>> postFundTransfer(String id) async {
    final intId = _parseId(id);
    if (intId == null) return const Left(NotFoundFailure());
    try {
      final posted = await _remoteDataSource.postFundTransfer(intId);
      return Right(posted.toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  // Debit Notes
  @override
  Future<Either<Failure, CursorPage<DebitNote>>> getDebitNotes({
    int? limit,
    int? offset,
    String? status,
    String? purchaseBillId,
    DateTime? from,
    DateTime? to,
    String? search,
  }) async {
    try {
      final page = await _remoteDataSource.listDebitNotes(
        limit: limit,
        offset: offset,
        status: status == null
            ? null
            : api.DebitNoteStatus.valueOf(status),
        purchaseBillId:
            purchaseBillId == null ? null : int.tryParse(purchaseBillId),
        from: from?.toDate(),
        to: to?.toDate(),
        search: search,
      );
      return Right(
        CursorPage<DebitNote>(
          items: page.data.map((dn) => dn.toDomain()).toList(),
          nextCursor: page.meta.nextCursor,
          hasMore: page.meta.hasMore,
        ),
      );
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, DebitNote>> getDebitNote(String id) async {
    final intId = _parseId(id);
    if (intId == null) return const Left(NotFoundFailure());
    try {
      final model = await _remoteDataSource.getDebitNote(intId);
      return Right(model.toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, DebitNote>> createDebitNote({
    required String purchaseBillId,
    required DateTime debitNoteDate,
    String? reason,
    required String subtotal,
    String? taxAmount,
    String? idempotencyKey,
  }) async {
    try {
      final created = await _remoteDataSource.createDebitNote(
        debitNoteCreate: toDebitNoteCreate(
          purchaseBillId: purchaseBillId,
          debitNoteDate: debitNoteDate,
          reason: reason,
          subtotal: subtotal,
          taxAmount: taxAmount,
        ),
        idempotencyKey: idempotencyKey,
      );
      return Right(created.toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, DebitNote>> postDebitNote(String id) async {
    final intId = _parseId(id);
    if (intId == null) return const Left(NotFoundFailure());
    try {
      final posted = await _remoteDataSource.postDebitNote(intId);
      return Right(posted.toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  // Tax Codes
  @override
  Future<Either<Failure, CursorPage<TaxCode>>> getTaxCodes({
    int? limit,
    int? offset,
    bool? isActive,
  }) async {
    try {
      final page = await _remoteDataSource.listTaxCodes(
        limit: limit,
        offset: offset,
        isActive: isActive,
      );
      return Right(
        CursorPage<TaxCode>(
          items: page.data.map((tc) => tc.toDomain()).toList(),
          nextCursor: page.meta.nextCursor,
          hasMore: page.meta.hasMore,
        ),
      );
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, TaxCode>> getTaxCode(String id) async {
    final intId = _parseId(id);
    if (intId == null) return const Left(NotFoundFailure());
    try {
      final model = await _remoteDataSource.getTaxCode(intId);
      return Right(model.toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, TaxCode>> createTaxCode({
    required String name,
    required String code,
    required String ratePercent,
    bool? isActive,
    List<TaxComponent>? components,
  }) async {
    try {
      final created = await _remoteDataSource.createTaxCode(
        toTaxCodeCreate(
          name: name,
          code: code,
          ratePercent: ratePercent,
          isActive: isActive,
          components: components,
        ),
      );
      return Right(created.toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, TaxCode>> updateTaxCode({
    required String id,
    String? name,
    String? ratePercent,
    bool? isActive,
    List<TaxComponent>? components,
  }) async {
    final intId = _parseId(id);
    if (intId == null) return const Left(NotFoundFailure());
    try {
      final updated = await _remoteDataSource.updateTaxCode(
        id: intId,
        taxCodeUpdate: toTaxCodeUpdate(
          name: name,
          ratePercent: ratePercent,
          isActive: isActive,
          components: components,
        ),
      );
      return Right(updated.toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  // Items
  @override
  Future<Either<Failure, CursorPage<Item>>> getItems({
    int? limit,
    int? offset,
    String? kind,
    bool? isActive,
    String? search,
  }) async {
    try {
      final page = await _remoteDataSource.listItems(
        limit: limit,
        offset: offset,
        itemKind: kind == null ? null : api.ItemKind.valueOf(kind),
        isActive: isActive,
        search: search,
      );
      return Right(
        CursorPage<Item>(
          items: page.data.map((i) => i.toDomain()).toList(),
          nextCursor: page.meta.nextCursor,
          hasMore: page.meta.hasMore,
        ),
      );
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Item>> getItem(String id) async {
    final intId = _parseId(id);
    if (intId == null) return const Left(NotFoundFailure());
    try {
      final model = await _remoteDataSource.getItem(intId);
      return Right(model.toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Item>> createItem({
    required String name,
    required String kind,
    required String incomeAccountId,
    required String expenseAccountId,
    String? defaultTaxCodeId,
    bool? isActive,
    bool? inventoryTracked,
  }) async {
    try {
      final created = await _remoteDataSource.createItem(
        toItemCreate(
          name: name,
          kind: kind,
          incomeAccountId: incomeAccountId,
          expenseAccountId: expenseAccountId,
          defaultTaxCodeId: defaultTaxCodeId,
          isActive: isActive,
          inventoryTracked: inventoryTracked,
        ),
      );
      return Right(created.toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Item>> updateItem({
    required String id,
    String? name,
    String? incomeAccountId,
    String? expenseAccountId,
    String? defaultTaxCodeId,
    bool? isActive,
    bool? inventoryTracked,
  }) async {
    final intId = _parseId(id);
    if (intId == null) return const Left(NotFoundFailure());
    try {
      final updated = await _remoteDataSource.updateItem(
        id: intId,
        itemUpdate: toItemUpdate(
          name: name,
          incomeAccountId: incomeAccountId,
          expenseAccountId: expenseAccountId,
          defaultTaxCodeId: defaultTaxCodeId,
          isActive: isActive,
          inventoryTracked: inventoryTracked,
        ),
      );
      return Right(updated.toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  // Reports
  @override
  Future<Either<Failure, TrialBalanceReport>> getTrialBalance({
    DateTime? from,
    required DateTime to,
  }) async {
    try {
      final report = await _remoteDataSource.getTrialBalance(
        from: from?.toDate(),
        to: to.toDate(),
      );
      return Right(report.toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, ProfitAndLossReport>> getProfitAndLoss({
    required DateTime from,
    required DateTime to,
  }) async {
    try {
      final report = await _remoteDataSource.getProfitAndLoss(
        from: from.toDate(),
        to: to.toDate(),
      );
      return Right(report.toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, BalanceSheetReport>> getBalanceSheet({
    required DateTime asOf,
  }) async {
    try {
      final report = await _remoteDataSource.getBalanceSheet(
        asOf: asOf.toDate(),
      );
      return Right(report.toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, DayBookReport>> getDayBook({
    required DateTime date,
  }) async {
    try {
      final report = await _remoteDataSource.getDayBook(
        date: date.toDate(),
      );
      return Right(report.toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, OpenItemsReport>> getOpenItems({
    required String kind,
  }) async {
    try {
      final report = await _remoteDataSource.getOpenItems(kind);
      return Right(report.toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, GstSummaryReport>> getGstSummary({
    required DateTime from,
    required DateTime to,
  }) async {
    try {
      final report = await _remoteDataSource.getGstSummary(
        from: from.toDate(),
        to: to.toDate(),
      );
      return Right(report.toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, UnearnedPreviewReport>> getUnearnedPreview({
    DateTime? goLiveDate,
  }) async {
    try {
      final report = await _remoteDataSource.getUnearnedPreview(
        goLiveDate: goLiveDate?.toDate(),
      );
      return Right(report.toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  // Go-Live
  @override
  Future<Either<Failure, GoLiveChecklist>> getGoLiveChecklist({
    DateTime? goLiveDate,
  }) async {
    try {
      final json = await _remoteDataSource.getGoLiveChecklist(
        goLiveDate: goLiveDate?.toDate(),
      );
      return Right(goLiveChecklistFromJson(json));
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, GoLivePaymentMethodMapping>> mapPaymentMethodAccount({
    required int paymentMethodId,
    required int? accountId,
  }) async {
    try {
      final json = await _remoteDataSource.mapPaymentMethodAccount(
        paymentMethodId: paymentMethodId,
        accountId: accountId,
      );
      return Right(goLivePaymentMethodMappingFromJson(json));
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, bool>> enablePosting({
    DateTime? goLiveDate,
  }) async {
    try {
      final result = await _remoteDataSource.enablePosting(
        goLiveDate: goLiveDate?.toDate(),
      );
      return Right(result);
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }
}
