import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/widgets/app_empty_view.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../domain/entities/payment.dart';
import '../cubit/payment_detail_cubit.dart';
import '../payment_strings.dart';
import '../widgets/payment_status_chip.dart';

class PaymentDetailScreen extends StatelessWidget {
  const PaymentDetailScreen({super.key, required this.paymentId});

  final String paymentId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<PaymentDetailCubit>()..load(paymentId),
      child: _PaymentDetailBody(paymentId: paymentId),
    );
  }
}

class _PaymentDetailBody extends StatelessWidget {
  const _PaymentDetailBody({required this.paymentId});

  final String paymentId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(PaymentStrings.detailTitle)),
      body: BlocBuilder<PaymentDetailCubit, PaymentDetailState>(
        builder: (context, state) {
          return switch (state) {
            PaymentDetailLoading() => const AppLoading(),
            PaymentDetailFailure(:final message) => AppErrorView(
              message: message,
              onRetry: () =>
                  context.read<PaymentDetailCubit>().load(paymentId),
            ),
            PaymentDetailLoaded(:final payment) => _PaymentDetailContent(
              payment: payment,
            ),
          };
        },
      ),
    );
  }
}

class _PaymentDetailContent extends StatelessWidget {
  const _PaymentDetailContent({required this.payment});

  final Payment payment;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                PaymentStrings.invoiceSubtitle(payment.invoiceNumber),
                style: theme.textTheme.headlineSmall,
              ),
            ),
            PaymentStatusChip(status: payment.status),
          ],
        ),
        const SizedBox(height: 16),
        _AmountRow(
          label: PaymentStrings.subtotalLabel,
          amount: payment.subtotal,
        ),
        _AmountRow(label: PaymentStrings.taxLabel, amount: payment.taxAmount),
        _AmountRow(
          label: PaymentStrings.discountLabel,
          amount: payment.discountAmount,
        ),
        _AmountRow(
          label: PaymentStrings.totalLabel,
          amount: payment.totalAmount,
          emphasize: true,
        ),
        _AmountRow(
          label: PaymentStrings.amountPaidLabel,
          amount: payment.amountPaid,
        ),
        const Divider(height: 32),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text(PaymentStrings.memberLabel),
          subtitle: Text(PaymentStrings.memberIdLabel(payment.memberId)),
        ),
        if (payment.membershipId != null)
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text(PaymentStrings.membershipLabel),
            subtitle: Text('#${payment.membershipId}'),
          ),
        if (payment.transactionReference != null)
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text(PaymentStrings.referenceLabel),
            subtitle: Text(payment.transactionReference!),
          ),
        if (payment.paymentDate != null)
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text(PaymentStrings.paymentDateLabel),
            subtitle: Text(payment.paymentDate!.toUtc().toIso8601String()),
          ),
        const SizedBox(height: 8),
        Text(PaymentStrings.historyTitle, style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        if (payment.histories.isEmpty)
          const AppEmptyView(message: PaymentStrings.noHistory)
        else
          for (final entry in payment.histories)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(PaymentStrings.historyActionLabel(entry.action)),
              subtitle: Text(
                [
                  PaymentStrings.formatMoney(entry.amount),
                  entry.timestamp.toUtc().toIso8601String(),
                  if (entry.notes != null && entry.notes!.isNotEmpty)
                    entry.notes!,
                ].join(' · '),
              ),
            ),
      ],
    );
  }
}

class _AmountRow extends StatelessWidget {
  const _AmountRow({
    required this.label,
    required this.amount,
    this.emphasize = false,
  });

  final String label;
  final String amount;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    final style = emphasize
        ? Theme.of(context).textTheme.titleMedium
        : Theme.of(context).textTheme.bodyLarge;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(label, style: style)),
          Text(PaymentStrings.formatMoney(amount), style: style),
        ],
      ),
    );
  }
}
