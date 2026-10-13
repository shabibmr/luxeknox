import 'package:equatable/equatable.dart';

class PaymentVoucherAllocation extends Equatable {
  const PaymentVoucherAllocation({
    required this.id,
    required this.paymentVoucherId,
    this.purchaseBillId,
    this.expenseVoucherId,
    required this.amount,
  });

  final String id;
  final String paymentVoucherId;
  final String? purchaseBillId;
  final String? expenseVoucherId;
  final String amount;

  @override
  List<Object?> get props => [
    id,
    paymentVoucherId,
    purchaseBillId,
    expenseVoucherId,
    amount,
  ];
}

class PaymentVoucher extends Equatable {
  const PaymentVoucher({
    required this.id,
    required this.voucherNumber,
    required this.voucherDate,
    required this.vendorId,
    this.paymentMethodId,
    this.bankAccountId,
    required this.amount,
    required this.status,
    this.journalEntryId,
    this.memo,
    this.rowVersion = 1,
    this.allocations = const [],
  });

  final String id;
  final String voucherNumber;
  final DateTime voucherDate;
  final String vendorId;
  final String? paymentMethodId;
  final String? bankAccountId;
  final String amount;
  final String status;
  final String? journalEntryId;
  final String? memo;
  final int rowVersion;
  final List<PaymentVoucherAllocation> allocations;

  @override
  List<Object?> get props => [
    id,
    voucherNumber,
    voucherDate,
    vendorId,
    paymentMethodId,
    bankAccountId,
    amount,
    status,
    journalEntryId,
    memo,
    rowVersion,
    allocations,
  ];
}
