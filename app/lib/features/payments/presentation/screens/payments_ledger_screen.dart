import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/presentation/load_status.dart';
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
              buildWhen: (previous, next) => previous.filter != next.filter,
              builder: (context, state) {
                final filter = state.filter;
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
            child: BlocConsumer<PaymentsLedgerCubit, PaymentsLedgerState>(
              listenWhen: (previous, next) =>
                  next.status == LoadStatus.failure &&
                  next.failure != previous.failure &&
                  next.items.isNotEmpty,
              listener: (context, state) {
                final failure = state.failure;
                if (failure == null) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(failureMessage(failure))),
                );
              },
              builder: (context, state) {
                if (state.status == LoadStatus.loading &&
                    state.items.isEmpty) {
                  return const AppLoading();
                }
                if (state.status == LoadStatus.failure &&
                    state.items.isEmpty) {
                  return AppErrorView(
                    message: state.failure == null
                        ? ''
                        : failureMessage(state.failure!),
                    onRetry: () => context.read<PaymentsLedgerCubit>().load(),
                  );
                }
                final items = state.items;
                if (items.isEmpty) {
                  return const AppEmptyView(message: PaymentStrings.noneFound);
                }
                return RefreshIndicator(
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
                        );
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
