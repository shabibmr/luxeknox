import 'package:equatable/equatable.dart';

import 'payment_status.dart';

class PaymentHistoryEntry extends Equatable {
  const PaymentHistoryEntry({
    required this.id,
    required this.paymentId,
    this.paymentMethodId,
    required this.action,
    required this.amount,
    this.notes,
    required this.timestamp,
  });

  final String id;
  final String paymentId;
  final String? paymentMethodId;
  final PaymentHistoryAction action;
  final String amount;
  final String? notes;
  final DateTime timestamp;

  @override
  List<Object?> get props => [
    id,
    paymentId,
    paymentMethodId,
    action,
    amount,
    notes,
    timestamp,
  ];
}
