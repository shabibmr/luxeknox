import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/widgets/app_empty_view.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading.dart';
import '../cubit/outstanding_dues_cubit.dart';
import '../payment_strings.dart';
import '../widgets/payment_status_chip.dart';

class OutstandingDuesScreen extends StatelessWidget {
  const OutstandingDuesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<OutstandingDuesCubit>()..load(),
      child: const _OutstandingDuesBody(),
    );
  }
}

class _OutstandingDuesBody extends StatelessWidget {
  const _OutstandingDuesBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(PaymentStrings.outstandingTitle)),
      body: BlocBuilder<OutstandingDuesCubit, OutstandingDuesState>(
        builder: (context, state) {
          return switch (state) {
            OutstandingDuesLoading() => const AppLoading(),
            OutstandingDuesFailure(:final message) => AppErrorView(
              message: message,
              onRetry: () => context.read<OutstandingDuesCubit>().load(),
            ),
            OutstandingDuesLoaded(:final items) => items.isEmpty
                ? const AppEmptyView(message: PaymentStrings.noneFound)
                : RefreshIndicator(
                    onRefresh: () =>
                        context.read<OutstandingDuesCubit>().load(),
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
                          trailing: PaymentStatusChip(status: payment.status),
                          onTap: () => context.go(
                            Routes.adminPaymentById(payment.id),
                          ),
                        );
                      },
                    ),
                  ),
          };
        },
      ),
    );
  }
}
