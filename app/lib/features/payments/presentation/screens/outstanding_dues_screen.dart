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
      body: BlocConsumer<OutstandingDuesCubit, OutstandingDuesState>(
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
          if (state.status == LoadStatus.loading && state.items.isEmpty) {
            return const AppLoading();
          }
          if (state.status == LoadStatus.failure && state.items.isEmpty) {
            return AppErrorView(
              message: state.failure == null
                  ? ''
                  : failureMessage(state.failure!),
              onRetry: () => context.read<OutstandingDuesCubit>().load(),
            );
          }
          final items = state.items;
          if (items.isEmpty) {
            return const AppEmptyView(message: PaymentStrings.noneFound);
          }
          return RefreshIndicator(
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
                  );
        },
      ),
    );
  }
}
