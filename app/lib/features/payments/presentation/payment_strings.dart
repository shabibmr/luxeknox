import '../domain/entities/payment_status.dart';

class PaymentStrings {
  PaymentStrings._();

  static const String ledgerTitleAdmin = 'Payments';
  static const String ledgerTitleMember = 'Payments & Invoices';
  static const String ledgerTitleTrainer = 'Member payments';
  static const String outstandingTitle = 'Outstanding dues';
  static const String detailTitle = 'Payment detail';
  static const String methodsTitle = 'Payment methods';

  static const String outstandingTooltip = 'Outstanding dues';
  static const String methodsTooltip = 'Payment methods';
  static const String addMethodTooltip = 'Add payment method';

  static const String noneFound = 'Nothing here yet.';
  static const String retry = 'Retry';
  static const String cancel = 'Cancel';
  static const String save = 'Save';
  static const String create = 'Create';

  static const String filterAll = 'All';
  static const String filterPending = 'Pending';
  static const String filterPartial = 'Partial';
  static const String filterPaid = 'Paid';
  static const String filterRefunded = 'Refunded';

  static const String statusPending = 'Pending';
  static const String statusPartial = 'Partial';
  static const String statusPaid = 'Paid';
  static const String statusRefunded = 'Refunded';

  static const String invoiceLabel = 'Invoice';
  static const String memberLabel = 'Member';
  static const String membershipLabel = 'Membership';
  static const String subtotalLabel = 'Subtotal';
  static const String taxLabel = 'Tax';
  static const String discountLabel = 'Discount';
  static const String totalLabel = 'Total';
  static const String amountPaidLabel = 'Amount paid';
  static const String referenceLabel = 'Reference';
  static const String paymentDateLabel = 'Payment date';
  static const String historyTitle = 'History';
  static const String noHistory = 'No history entries.';

  static const String actionPaymentReceived = 'Payment received';
  static const String actionRefunded = 'Refunded';
  static const String actionAdjusted = 'Adjusted';

  static const String methodNameLabel = 'Method name';
  static const String methodNameRequired = 'Method name is required';
  static const String isDigitalLabel = 'Digital method';
  static const String isActiveLabel = 'Active';
  static const String digitalBadge = 'Digital';
  static const String inactiveBadge = 'Inactive';
  static const String createMethodTitle = 'Add payment method';
  static const String noPermission = 'You do not have permission to do this.';

  static String formatMoney(String amount) => '\$$amount';

  static String invoiceSubtitle(String invoiceNumber) => '#$invoiceNumber';

  static String memberIdLabel(String memberId) => 'Member #$memberId';

  static String statusLabel(PaymentStatus status) => switch (status) {
    PaymentStatus.pending => statusPending,
    PaymentStatus.partial => statusPartial,
    PaymentStatus.paid => statusPaid,
    PaymentStatus.refunded => statusRefunded,
  };

  static String historyActionLabel(PaymentHistoryAction action) =>
      switch (action) {
        PaymentHistoryAction.paymentReceived => actionPaymentReceived,
        PaymentHistoryAction.refunded => actionRefunded,
        PaymentHistoryAction.adjusted => actionAdjusted,
      };
}
