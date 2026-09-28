import 'package:equatable/equatable.dart';

import 'payment_history_entry.dart';
import 'payment_status.dart';

/// Invoice / payment ledger row. Money fields are decimal strings (FR-API-005)
/// — never parse to double for display.
class Payment extends Equatable {
  const Payment({
    required this.id,
    required this.invoiceNumber,
    required this.memberId,
    this.membershipId,
    this.paymentMethodId,
    required this.subtotal,
    required this.taxAmount,
    required this.discountAmount,
    required this.totalAmount,
    required this.amountPaid,
    required this.status,
    this.transactionReference,
    this.cashierUserId,
    this.paymentDate,
    required this.rowVersion,
    this.histories = const [],
  });

  final String id;
  final String invoiceNumber;
  final String memberId;
  final String? membershipId;
  final String? paymentMethodId;
  final String subtotal;
  final String taxAmount;
  final String discountAmount;
  final String totalAmount;
  final String amountPaid;
  final PaymentStatus status;
  final String? transactionReference;
  final String? cashierUserId;
  final DateTime? paymentDate;
  final int rowVersion;
  final List<PaymentHistoryEntry> histories;

  @override
  List<Object?> get props => [
    id,
    invoiceNumber,
    memberId,
    membershipId,
    paymentMethodId,
    subtotal,
    taxAmount,
    discountAmount,
    totalAmount,
    amountPaid,
    status,
    transactionReference,
    cashierUserId,
    paymentDate,
    rowVersion,
    histories,
  ];
}
