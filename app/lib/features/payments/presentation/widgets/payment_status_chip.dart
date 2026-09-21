import 'package:flutter/material.dart';

import '../../domain/entities/payment_status.dart';
import '../payment_strings.dart';

class PaymentStatusChip extends StatelessWidget {
  const PaymentStatusChip({super.key, required this.status});

  final PaymentStatus status;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final (label, color) = switch (status) {
      PaymentStatus.pending => (PaymentStrings.statusPending, Colors.orange),
      PaymentStatus.partial => (PaymentStrings.statusPartial, Colors.amber),
      PaymentStatus.paid => (PaymentStrings.statusPaid, Colors.green),
      PaymentStatus.refunded => (PaymentStrings.statusRefunded, scheme.error),
    };
    return Chip(
      label: Text(label),
      backgroundColor: color.withValues(alpha: 0.15),
      labelStyle: TextStyle(color: color, fontWeight: FontWeight.w600),
      side: BorderSide.none,
    );
  }
}
