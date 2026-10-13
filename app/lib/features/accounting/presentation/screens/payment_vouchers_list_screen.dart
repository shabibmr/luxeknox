import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/extensions/capability_extension.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/widgets/app_empty_view.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../../core/widgets/app_status_chip.dart';
import '../../domain/entities/payment_voucher.dart';
import '../../domain/usecases/get_payment_vouchers_usecase.dart';
import '../accounting_strings.dart';
import '../cubit/payment_vouchers_cubit.dart';

class PaymentVouchersListScreen extends StatelessWidget {
  const PaymentVouchersListScreen({
    super.key,
    this.cubit,
  });

  final PaymentVouchersCubit? cubit;

  @override
  Widget build(BuildContext context) {
    if (cubit != null) {
      if (cubit!.state.status == LoadStatus.initial) {
        cubit!.load();
      }
      return BlocProvider<PaymentVouchersCubit>.value(
        value: cubit!,
        child: const _PaymentVouchersListBody(),
      );
    }
    return BlocProvider<PaymentVouchersCubit>(
      create: (_) => getIt.isRegistered<PaymentVouchersCubit>()
          ? (getIt<PaymentVouchersCubit>()..load())
          : (PaymentVouchersCubit(getIt<GetPaymentVouchersUseCase>())..load()),
      child: const _PaymentVouchersListBody(),
    );
  }
}

class _PaymentVouchersListBody extends StatefulWidget {
  const _PaymentVouchersListBody();

  @override
  State<_PaymentVouchersListBody> createState() =>
      _PaymentVouchersListBodyState();
}

class _PaymentVouchersListBodyState extends State<_PaymentVouchersListBody> {
  static String _formatDate(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  Future<void> _pickDateRange(
      BuildContext context, PaymentVouchersState state) async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDateRange: (state.fromDate != null && state.toDate != null)
          ? DateTimeRange(start: state.fromDate!, end: state.toDate!)
          : null,
    );
    if (!context.mounted) return;
    if (picked != null) {
      context
          .read<PaymentVouchersCubit>()
          .filterByDateRange(picked.start, picked.end);
    }
  }

  @override
  Widget build(BuildContext context) {
    final canWrite = context.can('accounting.payments_write');

    return Scaffold(
      appBar: AppBar(
        title: const Text(AccountingStrings.paymentVouchersTitle),
        actions: [
          IconButton(
            tooltip: AccountingStrings.refresh,
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<PaymentVouchersCubit>().load(),
          ),
          if (canWrite)
            IconButton(
              key: const Key('appbar_create_voucher_button'),
              tooltip: AccountingStrings.createPaymentVoucherTitle,
              icon: const Icon(Icons.add),
              onPressed: () =>
                  context.push(Routes.adminAccountingPaymentVouchersCreate),
            ),
        ],
      ),
      floatingActionButton: canWrite
          ? FloatingActionButton.extended(
              key: const Key('create_voucher_button'),
              onPressed: () =>
                  context.push(Routes.adminAccountingPaymentVouchersCreate),
              icon: const Icon(Icons.add),
              label: const Text(AccountingStrings.createPaymentVoucherTitle),
            )
          : null,
      body: BlocConsumer<PaymentVouchersCubit, PaymentVouchersState>(
        listenWhen: (previous, next) =>
            next.status == LoadStatus.failure &&
            next.failure != previous.failure &&
            next.vouchers.isNotEmpty,
        listener: (context, state) {
          final failure = state.failure;
          if (failure == null) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(failureMessage(failure))),
          );
        },
        builder: (context, state) {
          final hasActiveFilters = state.statusFilter != null ||
              state.fromDate != null ||
              state.toDate != null ||
              (state.search != null && state.search!.isNotEmpty);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          FilterChip(
                            key: const Key('status_chip_all'),
                            label: const Text('All'),
                            selected: state.statusFilter == null ||
                                state.statusFilter!.isEmpty,
                            onSelected: (_) => context
                                .read<PaymentVouchersCubit>()
                                .filterByStatus(null),
                          ),
                          const SizedBox(width: 8),
                          FilterChip(
                            key: const Key('status_chip_draft'),
                            label: const Text(AccountingStrings.statusDraft),
                            selected: state.statusFilter == 'draft',
                            onSelected: (_) => context
                                .read<PaymentVouchersCubit>()
                                .filterByStatus('draft'),
                          ),
                          const SizedBox(width: 8),
                          FilterChip(
                            key: const Key('status_chip_posted'),
                            label: const Text(AccountingStrings.statusPosted),
                            selected: state.statusFilter == 'posted',
                            onSelected: (_) => context
                                .read<PaymentVouchersCubit>()
                                .filterByStatus('posted'),
                          ),
                          const SizedBox(width: 8),
                          InputChip(
                            key: const Key('date_range_filter_chip'),
                            avatar: const Icon(Icons.calendar_today, size: 16),
                            label: Text(
                              (state.fromDate != null && state.toDate != null)
                                  ? '${_formatDate(state.fromDate!)} - ${_formatDate(state.toDate!)}'
                                  : AccountingStrings.filterByDateRange,
                            ),
                            selected:
                                state.fromDate != null && state.toDate != null,
                            onPressed: () => _pickDateRange(context, state),
                            onDeleted: (state.fromDate != null ||
                                    state.toDate != null)
                                ? () => context
                                    .read<PaymentVouchersCubit>()
                                    .filterByDateRange(null, null)
                                : null,
                          ),
                          if (hasActiveFilters) ...[
                            const SizedBox(width: 8),
                            ActionChip(
                              key: const Key('clear_filters_button'),
                              avatar: const Icon(Icons.clear, size: 16),
                              label:
                                  const Text(AccountingStrings.clearFilter),
                              onPressed: () => context
                                  .read<PaymentVouchersCubit>()
                                  .clearFilters(),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: _buildListArea(context, state),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildListArea(BuildContext context, PaymentVouchersState state) {
    if (state.status == LoadStatus.loading && state.vouchers.isEmpty) {
      return const AppLoading();
    }

    if (state.status == LoadStatus.failure && state.vouchers.isEmpty) {
      return AppErrorView(
        message:
            state.failure == null ? '' : failureMessage(state.failure!),
        onRetry: () => context.read<PaymentVouchersCubit>().load(),
      );
    }

    if (state.vouchers.isEmpty) {
      return RefreshIndicator(
        onRefresh: () => context.read<PaymentVouchersCubit>().load(),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            SizedBox(height: 60),
            AppEmptyView(message: AccountingStrings.noneFound),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => context.read<PaymentVouchersCubit>().load(),
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 80, top: 4),
        itemCount: state.vouchers.length + (state.hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= state.vouchers.length) {
            context.read<PaymentVouchersCubit>().loadMore();
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          final voucher = state.vouchers[index];
          return _PaymentVoucherCard(voucher: voucher);
        },
      ),
    );
  }
}

class _PaymentVoucherCard extends StatelessWidget {
  const _PaymentVoucherCard({required this.voucher});

  final PaymentVoucher voucher;

  static Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'posted':
        return Colors.green;
      case 'draft':
        return Colors.amber;
      case 'void':
        return Colors.grey;
      default:
        return Colors.blueGrey;
    }
  }

  static String _formatDate(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bankText = voucher.bankAccountId != null &&
            voucher.bankAccountId!.isNotEmpty
        ? 'Bank Account #${voucher.bankAccountId}'
        : '-';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.push(
          Routes.adminAccountingPaymentVoucherById(voucher.id),
          extra: voucher,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          voucher.voucherNumber,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'monospace',
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatDate(voucher.voucherDate),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          bankText,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        AccountingStrings.formatMoney(voucher.amount),
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      AppStatusChip(
                        label: voucher.status,
                        color: _statusColor(voucher.status),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
