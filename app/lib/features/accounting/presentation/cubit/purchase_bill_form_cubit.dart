import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/idempotency/idempotency_key.dart';
import '../../../../core/presentation/load_status.dart';
import '../../domain/entities/account.dart';
import '../../domain/entities/item.dart';
import '../../domain/entities/purchase_bill.dart';
import '../../domain/entities/tax_code.dart';
import '../../domain/entities/vendor.dart';
import '../../domain/usecases/create_purchase_bill_usecase.dart';
import '../../domain/usecases/get_accounts_usecase.dart';
import '../../domain/usecases/get_tax_codes_usecase.dart';
import '../../domain/usecases/get_vendors_usecase.dart';
import '../../domain/usecases/post_purchase_bill_usecase.dart';

const Object _sentinel = Object();

class PurchaseBillLineDraft extends Equatable {
  const PurchaseBillLineDraft({
    this.accountId,
    this.accountName,
    this.itemId,
    this.itemName,
    this.uomCode,
    this.uomDecimalPlaces = 3,
    this.inventoryTracked = false,
    this.description = '',
    this.quantity = '1',
    this.rate = '0.00',
    this.taxCodeId,
    this.taxCodeName,
    this.taxRatePercent = 0.0,
  });

  final String? accountId;
  final String? accountName;
  final String? itemId;
  final String? itemName;
  final String? uomCode;

  /// Decimal places the item's UOM allows on quantity (3 when no item).
  final int uomDecimalPlaces;

  /// Tracked lines are routed to the Inventory account by the server.
  final bool inventoryTracked;
  final String description;
  final String quantity;
  final String rate;
  final String? taxCodeId;
  final String? taxCodeName;
  final double taxRatePercent;

  double get qtyNumber => double.tryParse(quantity) ?? 0.0;
  double get rateNumber => double.tryParse(rate) ?? 0.0;
  double get netAmount => qtyNumber * rateNumber;
  double get taxAmount => netAmount * (taxRatePercent / 100.0);
  double get totalAmount => netAmount + taxAmount;

  PurchaseBillLineDraft copyWith({
    Object? accountId = _sentinel,
    Object? accountName = _sentinel,
    Object? itemId = _sentinel,
    Object? itemName = _sentinel,
    Object? uomCode = _sentinel,
    int? uomDecimalPlaces,
    bool? inventoryTracked,
    String? description,
    String? quantity,
    String? rate,
    Object? taxCodeId = _sentinel,
    Object? taxCodeName = _sentinel,
    double? taxRatePercent,
  }) {
    return PurchaseBillLineDraft(
      accountId: identical(accountId, _sentinel)
          ? this.accountId
          : (accountId as String?),
      accountName: identical(accountName, _sentinel)
          ? this.accountName
          : (accountName as String?),
      itemId: identical(itemId, _sentinel) ? this.itemId : (itemId as String?),
      itemName: identical(itemName, _sentinel)
          ? this.itemName
          : (itemName as String?),
      uomCode: identical(uomCode, _sentinel)
          ? this.uomCode
          : (uomCode as String?),
      uomDecimalPlaces: uomDecimalPlaces ?? this.uomDecimalPlaces,
      inventoryTracked: inventoryTracked ?? this.inventoryTracked,
      description: description ?? this.description,
      quantity: quantity ?? this.quantity,
      rate: rate ?? this.rate,
      taxCodeId: identical(taxCodeId, _sentinel)
          ? this.taxCodeId
          : (taxCodeId as String?),
      taxCodeName: identical(taxCodeName, _sentinel)
          ? this.taxCodeName
          : (taxCodeName as String?),
      taxRatePercent: taxRatePercent ?? this.taxRatePercent,
    );
  }

  @override
  List<Object?> get props => [
        accountId,
        accountName,
        itemId,
        itemName,
        uomCode,
        uomDecimalPlaces,
        inventoryTracked,
        description,
        quantity,
        rate,
        taxCodeId,
        taxCodeName,
        taxRatePercent,
      ];
}

class PurchaseBillFormState extends Equatable {
  PurchaseBillFormState({
    this.status = LoadStatus.initial,
    this.vendorId,
    this.vendorName,
    DateTime? billDate,
    this.dueDate,
    this.supplierInvoiceNo = '',
    this.lines = const [PurchaseBillLineDraft()],
    this.availableVendors = const [],
    this.availableAccounts = const [],
    this.availableTaxCodes = const [],
    this.isLoadingDependencies = false,
    this.isSubmitting = false,
    this.failure,
    this.createdBill,
  }) : billDate = billDate ?? _defaultDate();

  static DateTime _defaultDate() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  final LoadStatus status;
  final String? vendorId;
  final String? vendorName;
  final DateTime billDate;
  final DateTime? dueDate;
  final String supplierInvoiceNo;
  final List<PurchaseBillLineDraft> lines;
  final List<Vendor> availableVendors;
  final List<Account> availableAccounts;
  final List<TaxCode> availableTaxCodes;
  final bool isLoadingDependencies;
  final bool isSubmitting;
  final Failure? failure;
  final PurchaseBill? createdBill;

  double get subtotal => lines.fold<double>(
        0.0,
        (sum, line) => sum + line.netAmount,
      );

  double get taxAmount => lines.fold<double>(
        0.0,
        (sum, line) => sum + line.taxAmount,
      );

  double get totalAmount => subtotal + taxAmount;

  bool get hasValidLines {
    if (lines.isEmpty) return false;
    return lines.every((l) {
      if (!l.inventoryTracked &&
          (l.accountId == null || l.accountId!.isEmpty)) {
        return false;
      }
      final q = double.tryParse(l.quantity);
      final r = double.tryParse(l.rate);
      return q != null && q > 0 && r != null && r >= 0;
    });
  }

  bool get canSubmit =>
      !isSubmitting &&
      vendorId != null &&
      vendorId!.isNotEmpty &&
      hasValidLines;

  PurchaseBillFormState copyWith({
    LoadStatus? status,
    Object? vendorId = _sentinel,
    Object? vendorName = _sentinel,
    DateTime? billDate,
    Object? dueDate = _sentinel,
    String? supplierInvoiceNo,
    List<PurchaseBillLineDraft>? lines,
    List<Vendor>? availableVendors,
    List<Account>? availableAccounts,
    List<TaxCode>? availableTaxCodes,
    bool? isLoadingDependencies,
    bool? isSubmitting,
    Object? failure = _sentinel,
    Object? createdBill = _sentinel,
  }) {
    return PurchaseBillFormState(
      status: status ?? this.status,
      vendorId: identical(vendorId, _sentinel)
          ? this.vendorId
          : (vendorId as String?),
      vendorName: identical(vendorName, _sentinel)
          ? this.vendorName
          : (vendorName as String?),
      billDate: billDate ?? this.billDate,
      dueDate: identical(dueDate, _sentinel)
          ? this.dueDate
          : (dueDate as DateTime?),
      supplierInvoiceNo: supplierInvoiceNo ?? this.supplierInvoiceNo,
      lines: lines ?? this.lines,
      availableVendors: availableVendors ?? this.availableVendors,
      availableAccounts: availableAccounts ?? this.availableAccounts,
      availableTaxCodes: availableTaxCodes ?? this.availableTaxCodes,
      isLoadingDependencies:
          isLoadingDependencies ?? this.isLoadingDependencies,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      failure: identical(failure, _sentinel)
          ? this.failure
          : (failure as Failure?),
      createdBill: identical(createdBill, _sentinel)
          ? this.createdBill
          : (createdBill as PurchaseBill?),
    );
  }

  @override
  List<Object?> get props => [
        status,
        vendorId,
        vendorName,
        billDate,
        dueDate,
        supplierInvoiceNo,
        lines,
        availableVendors,
        availableAccounts,
        availableTaxCodes,
        isLoadingDependencies,
        isSubmitting,
        failure,
        createdBill,
      ];
}

@injectable
class PurchaseBillFormCubit extends Cubit<PurchaseBillFormState> {
  PurchaseBillFormCubit(
    this._createPurchaseBill,
    this._postPurchaseBill,
    this._getVendors,
    this._getAccounts,
    this._getTaxCodes,
  ) : super(PurchaseBillFormState());

  final CreatePurchaseBillUseCase _createPurchaseBill;
  final PostPurchaseBillUseCase _postPurchaseBill;
  final GetVendorsUseCase _getVendors;
  final GetAccountsUseCase _getAccounts;
  final GetTaxCodesUseCase _getTaxCodes;

  Future<void> loadDependencies() async {
    emit(state.copyWith(isLoadingDependencies: true));

    final vendorsResult =
        await _getVendors(const GetVendorsParams(limit: 100, isActive: true));
    final accountsResult =
        await _getAccounts(const GetAccountsParams(limit: 100, isActive: true));
    final taxCodesResult =
        await _getTaxCodes(const GetTaxCodesParams(limit: 100, isActive: true));

    final vendors = vendorsResult.fold((_) => <Vendor>[], (p) => p.items);
    final accounts = accountsResult.fold((_) => <Account>[], (p) => p.items);
    final taxCodes = taxCodesResult.fold((_) => <TaxCode>[], (p) => p.items);

    emit(
      state.copyWith(
        availableVendors: vendors,
        availableAccounts: accounts,
        availableTaxCodes: taxCodes,
        isLoadingDependencies: false,
      ),
    );
  }

  void setVendor(String vendorId, [String? vendorName]) {
    emit(state.copyWith(vendorId: vendorId, vendorName: vendorName));
  }

  void setBillDate(DateTime date) {
    emit(state.copyWith(billDate: date));
  }

  void setDueDate(DateTime? date) {
    emit(state.copyWith(dueDate: date));
  }

  void setSupplierInvoiceNo(String value) {
    emit(state.copyWith(supplierInvoiceNo: value));
  }

  void addLine() {
    emit(
      state.copyWith(
        lines: [...state.lines, const PurchaseBillLineDraft()],
      ),
    );
  }

  void removeLine(int index) {
    if (state.lines.length <= 1) return;
    if (index < 0 || index >= state.lines.length) return;
    final updated = List<PurchaseBillLineDraft>.from(state.lines)..removeAt(index);
    emit(state.copyWith(lines: updated));
  }

  void updateLine(
    int index, {
    Object? accountId = _sentinel,
    Object? accountName = _sentinel,
    Object? itemId = _sentinel,
    Object? itemName = _sentinel,
    Object? uomCode = _sentinel,
    int? uomDecimalPlaces,
    bool? inventoryTracked,
    String? description,
    String? quantity,
    String? rate,
    Object? taxCodeId = _sentinel,
    Object? taxCodeName = _sentinel,
    double? taxRatePercent,
  }) {
    if (index < 0 || index >= state.lines.length) return;
    final current = state.lines[index];

    final updatedLine = current.copyWith(
      accountId: accountId,
      accountName: accountName,
      itemId: itemId,
      itemName: itemName,
      uomCode: uomCode,
      uomDecimalPlaces: uomDecimalPlaces,
      inventoryTracked: inventoryTracked,
      description: description,
      quantity: quantity,
      rate: rate,
      taxCodeId: taxCodeId,
      taxCodeName: taxCodeName,
      taxRatePercent: taxRatePercent,
    );

    final updatedLines = List<PurchaseBillLineDraft>.from(state.lines);
    updatedLines[index] = updatedLine;
    emit(state.copyWith(lines: updatedLines));
  }

  void setLineAccount(int index, Account? account) {
    updateLine(
      index,
      accountId: account?.id,
      accountName: account?.name,
    );
  }

  void setLineTaxCode(int index, TaxCode? taxCode) {
    final rate = taxCode == null
        ? 0.0
        : (double.tryParse(taxCode.ratePercent) ?? 0.0);
    updateLine(
      index,
      taxCodeId: taxCode?.id,
      taxCodeName: taxCode?.name,
      taxRatePercent: rate,
    );
  }

  /// Applies an item pick to a line: UOM, tracked flag and the item's
  /// purchase rate, tax code and (for untracked items) expense account.
  /// Passing null clears the item and goes back to a plain account line.
  void setLineItem(int index, Item? item) {
    if (index < 0 || index >= state.lines.length) return;
    if (item == null) {
      updateLine(
        index,
        itemId: null,
        itemName: null,
        uomCode: null,
        uomDecimalPlaces: 3,
        inventoryTracked: false,
      );
      return;
    }

    final taxCode = _findTaxCode(item.taxCodeId?.toString());
    final account = item.inventoryTracked
        ? null
        : _findAccount(item.expenseAccountId.toString());
    final places = item.uomDecimalPlaces;
    final current = state.lines[index];

    updateLine(
      index,
      itemId: item.id.toString(),
      itemName: item.name,
      uomCode: item.uomCode,
      uomDecimalPlaces: places,
      inventoryTracked: item.inventoryTracked,
      rate: item.purchaseRate ?? current.rate,
      quantity: _clampQuantity(current.quantity, places),
      accountId: account?.id,
      accountName: account?.name,
      taxCodeId: taxCode?.id,
      taxCodeName: taxCode?.name,
      taxRatePercent:
          taxCode == null ? 0.0 : (double.tryParse(taxCode.ratePercent) ?? 0.0),
    );
  }

  TaxCode? _findTaxCode(String? id) {
    if (id == null) return null;
    for (final t in state.availableTaxCodes) {
      if (t.id == id) return t;
    }
    return null;
  }

  Account? _findAccount(String id) {
    for (final a in state.availableAccounts) {
      if (a.id == id) return a;
    }
    return null;
  }

  /// Trims [value] to [places] decimals (0 drops the fraction).
  static String _clampQuantity(String value, int places) {
    final dot = value.indexOf('.');
    if (dot < 0) return value;
    if (places <= 0) return value.substring(0, dot);
    final end = dot + 1 + places;
    return end >= value.length ? value : value.substring(0, end);
  }

  /// Creates the bill as a draft. Returns true when the draft exists.
  Future<bool> saveDraft() => _save(post: false);

  /// Creates the draft, then posts it with its own idempotency key. If the
  /// post fails (for example a locked period) the draft is kept, and the next
  /// call posts that draft instead of creating a second one.
  Future<bool> saveAndPost() => _save(post: true);

  String? _createKey;
  String? _postKey;

  Future<bool> _save({required bool post}) async {
    if (!state.canSubmit) return false;

    emit(
      state.copyWith(
        status: LoadStatus.loading,
        isSubmitting: true,
        failure: null,
      ),
    );

    var bill = state.createdBill;
    if (bill == null) {
      _createKey ??= newIdempotencyKey();
      final created = await _createPurchaseBill(
        CreatePurchaseBillParams(
          vendorId: state.vendorId!,
          billDate: state.billDate,
          dueDate: state.dueDate,
          supplierInvoiceNo: state.supplierInvoiceNo.trim().isEmpty
              ? null
              : state.supplierInvoiceNo.trim(),
          lines: _mapLines(),
          draft: true,
          idempotencyKey: _createKey,
        ),
      );
      final createdBill = created.fold<PurchaseBill?>((failure) {
        _emitFailure(failure);
        return null;
      }, (b) => b);
      if (createdBill == null) return false;
      bill = createdBill;
      _createKey = null;
      emit(state.copyWith(createdBill: bill));
    }

    if (!post) {
      _emitSuccess(bill);
      return true;
    }

    _postKey ??= newIdempotencyKey();
    final posted = await _postPurchaseBill(
      PostPurchaseBillParams(id: bill.id, idempotencyKey: _postKey),
    );
    return posted.fold(
      (failure) {
        _emitFailure(failure);
        return false;
      },
      (b) {
        _postKey = null;
        _emitSuccess(b);
        return true;
      },
    );
  }

  List<PurchaseBillLine> _mapLines() {
    return state.lines.map((l) {
      return PurchaseBillLine(
        id: '',
        billId: '',
        accountId: l.inventoryTracked ? null : l.accountId,
        itemId: l.itemId,
        description: l.description.trim().isEmpty ? null : l.description.trim(),
        quantity: l.quantity.trim().isEmpty ? '1' : l.quantity.trim(),
        unitPrice: l.rate.trim().isEmpty ? '0' : l.rate.trim(),
        amount: l.netAmount.toStringAsFixed(2),
        taxCodeId: l.taxCodeId,
        taxAmount: l.taxAmount.toStringAsFixed(2),
      );
    }).toList();
  }

  void _emitFailure(Failure failure) {
    emit(
      state.copyWith(
        status: LoadStatus.failure,
        failure: failure,
        isSubmitting: false,
      ),
    );
  }

  void _emitSuccess(PurchaseBill bill) {
    emit(
      state.copyWith(
        status: LoadStatus.success,
        createdBill: bill,
        isSubmitting: false,
        failure: null,
      ),
    );
  }
}
