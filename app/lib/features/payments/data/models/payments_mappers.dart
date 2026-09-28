import 'package:api_client/api_client.dart' as api;

import '../../domain/entities/payment.dart';
import '../../domain/entities/payment_history_entry.dart';
import '../../domain/entities/payment_method.dart';
import '../../domain/entities/payment_status.dart';

PaymentStatus paymentStatusToDomain(api.PaymentStatus status) {
  return switch (status.name) {
    'pending' => PaymentStatus.pending,
    'partial' => PaymentStatus.partial,
    'paid' => PaymentStatus.paid,
    'refunded' => PaymentStatus.refunded,
    _ => PaymentStatus.pending,
  };
}

String paymentStatusToApi(PaymentStatus status) => status.name;

PaymentHistoryAction paymentHistoryActionToDomain(
  api.PaymentHistoryActionEnum action,
) {
  return switch (action.name) {
    'paymentReceived' => PaymentHistoryAction.paymentReceived,
    'refunded' => PaymentHistoryAction.refunded,
    'adjusted' => PaymentHistoryAction.adjusted,
    _ => PaymentHistoryAction.paymentReceived,
  };
}

extension PaymentModelMapper on api.Payment {
  Payment toDomain() {
    return Payment(
      id: id.toString(),
      invoiceNumber: invoiceNumber,
      memberId: memberId.toString(),
      membershipId: membershipId?.toString(),
      paymentMethodId: paymentMethodId?.toString(),
      subtotal: subtotal,
      taxAmount: taxAmount,
      discountAmount: discountAmount,
      totalAmount: totalAmount,
      amountPaid: amountPaid,
      status: paymentStatusToDomain(status),
      transactionReference: transactionReference,
      cashierUserId: cashierUserId?.toString(),
      paymentDate: paymentDate,
      rowVersion: rowVersion,
      histories: histories?.map((h) => h.toDomain()).toList() ?? const [],
    );
  }
}

extension PaymentHistoryModelMapper on api.PaymentHistory {
  PaymentHistoryEntry toDomain() {
    return PaymentHistoryEntry(
      id: id.toString(),
      paymentId: paymentId.toString(),
      paymentMethodId: paymentMethodId?.toString(),
      action: paymentHistoryActionToDomain(action),
      amount: amount,
      notes: notes,
      timestamp: timestamp,
    );
  }
}

extension PaymentMethodModelMapper on api.PaymentMethod {
  PaymentMethod toDomain() {
    return PaymentMethod(
      id: id.toString(),
      methodName: methodName,
      isDigital: isDigital ?? false,
      isActive: isActive,
    );
  }
}

api.PaymentMethodWrite toPaymentMethodWrite({
  required String methodName,
  bool? isDigital,
  bool? isActive,
}) {
  return api.PaymentMethodWrite(
    (b) => b
      ..methodName = methodName
      ..isDigital = isDigital
      ..isActive = isActive,
  );
}
