import 'package:equatable/equatable.dart';

import 'purchase_bill.dart';

class ExpenseVoucher extends Equatable {
  const ExpenseVoucher({
    required this.id,
    required this.voucherNumber,
    required this.expenseDate,
    this.paymentMethodId,
    this.bankAccountId,
    this.vendorId,
    this.isCreditExpense = false,
    required this.totalAmount,
    required this.taxAmount,
    required this.status,
    this.journalEntryId,
    this.memo,
    this.rowVersion = 1,
    this.lines = const [],
  });

  final String id;
  final String voucherNumber;
  final DateTime expenseDate;
  final String? paymentMethodId;
  final String? bankAccountId;
  final String? vendorId;
  final bool isCreditExpense;
  final String totalAmount;
  final String taxAmount;
  final String status;
  final String? journalEntryId;
  final String? memo;
  final int rowVersion;
  final List<PurchaseBillLine> lines;

  @override
  List<Object?> get props => [
    id,
    voucherNumber,
    expenseDate,
    paymentMethodId,
    bankAccountId,
    vendorId,
    isCreditExpense,
    totalAmount,
    taxAmount,
    status,
    journalEntryId,
    memo,
    rowVersion,
    lines,
  ];
}
