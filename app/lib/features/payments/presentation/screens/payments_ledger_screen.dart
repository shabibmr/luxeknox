import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/widgets/app_empty_view.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading.dart';
import '../cubit/payments_ledger_cubit.dart';
import '../payment_ledger_role.dart';
import '../payment_strings.dart';
import '../widgets/payment_status_chip.dart';

class PaymentsLedgerScreen extends StatelessWidget {
  const PaymentsLedgerScreen({
    super.key,
    this.memberId,
    required this.role,
  });

  final String? memberId;
  final PaymentsLedgerRole role;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<PaymentsLedgerCubit>()..load(memberId: memberId),
      child: _PaymentsLedgerBody(role: role),
    );
  }
}

class _PaymentsLedgerBody extends StatelessWidget {
  const _PaymentsLedgerBody({required this.role});

  final PaymentsLedgerRole role;

  String get _title => switch (role) {
    PaymentsLedgerRole.admin => PaymentStrings.ledgerTitleAdmin,
    PaymentsLedgerRole.member => PaymentStrings.ledgerTitleMember,
    PaymentsLedgerRole.trainer => PaymentStrings.ledgerTitleTrainer,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        actions: [
          if (role == PaymentsLedgerRole.admin) ...[
            IconButton(
              tooltip: PaymentStrings.outstandingTooltip,
              icon: const Icon(Icons.warning_amber_outlined),
              onPressed: () => context.go(Routes.adminPaymentsOutstanding),
            ),
            IconButton(
              tooltip: PaymentStrings.methodsTooltip,
              icon: const Icon(Icons.credit_card_outlined),
              onPressed: () => context.go(Routes.adminPaymentsMethods),
            ),
          ],
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: BlocBuilder<PaymentsLedgerCubit, PaymentsLedgerState>(
              buildWhen: (p, n) {
                final pf = switch (p) {
                  PaymentsLedgerLoading(:final filter) => filter,
                  PaymentsLedgerLoaded(:final filter) => filter,
                  PaymentsLedgerFailure(:final filter) => filter,
                };
                final nf = switch (n) {
                  PaymentsLedgerLoading(:final filter) => filter,
                  PaymentsLedgerLoaded(:final filter) => filter,
                  PaymentsLedgerFailure(:final filter) => filter,
                };
                return pf != nf;
              },
              builder: (context, state) {
                final filter = switch (state) {
                  PaymentsLedgerLoading(:final filter) => filter,
                  PaymentsLedgerLoaded(:final filter) => filter,
                  PaymentsLedgerFailure(:final filter) => filter,
                };
                return Wrap(
                  spacing: 8,
                  children: [
                    for (final entry in _filters)
                      ChoiceChip(
                        label: Text(entry.$2),
                        selected: filter == entry.$1,
                        onSelected: (_) => context
                            .read<PaymentsLedgerCubit>()
                            .setFilter(entry.$1),
                      ),
                  ],
                );
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<PaymentsLedgerCubit, PaymentsLedgerState>(
              builder: (context, state) {
                return switch (state) {
                  PaymentsLedgerLoading() => const AppLoading(),
                  PaymentsLedgerFailure(:final message) => AppErrorView(
                    message: message,
                    onRetry: () =>
                        context.read<PaymentsLedgerCubit>().load(),
                  ),
                  PaymentsLedgerLoaded(:final items) => items.isEmpty
                      ? const AppEmptyView(message: PaymentStrings.noneFound)
                      : RefreshIndicator(
                          onRefresh: () =>
                              context.read<PaymentsLedgerCubit>().load(),
                          child: ListView.builder(
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              final payment = items[index];
                              return ListTile(
                                title: Text(
                                  PaymentStrings.invoiceSubtitle(
                                    payment.invoiceNumber,
                                  ),
                                ),
                                subtitle: Text(
                                  '${PaymentStrings.memberIdLabel(payment.memberId)} · '
                                  '${PaymentStrings.formatMoney(payment.totalAmount)}',
                                ),
                                trailing: PaymentStatusChip(
                                  status: payment.status,
                                ),
                                onTap: switch (role) {
                                  PaymentsLedgerRole.admin => () => context.go(
                                    Routes.adminPaymentById(payment.id),
                                  ),
                                  PaymentsLedgerRole.member => () =>
                                      context.go(
                                        Routes.memberProfilePaymentById(
                                          payment.id,
                                        ),
                                      ),
                                  PaymentsLedgerRole.trainer => null,
                                },
                              );
                            },
                          ),
                        ),
                };
              },
            ),
          ),
        ],
      ),
    );
  }
}

const _filters = <(PaymentsLedgerFilter, String)>[
  (PaymentsLedgerFilter.all, PaymentStrings.filterAll),
  (PaymentsLedgerFilter.pending, PaymentStrings.filterPending),
  (PaymentsLedgerFilter.partial, PaymentStrings.filterPartial),
  (PaymentsLedgerFilter.paid, PaymentStrings.filterPaid),
  (PaymentsLedgerFilter.refunded, PaymentStrings.filterRefunded),
];
