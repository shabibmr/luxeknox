import 'package:equatable/equatable.dart';

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
  ];
}
