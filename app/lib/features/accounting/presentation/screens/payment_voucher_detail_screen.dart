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
import '../../domain/usecases/get_payment_voucher_usecase.dart';
import '../../domain/usecases/post_payment_voucher_usecase.dart';
import '../../../../core/widgets/app_currency_text.dart';
import '../accounting_strings.dart';
import '../cubit/payment_voucher_detail_cubit.dart';

class PaymentVoucherDetailScreen extends StatelessWidget {
  const PaymentVoucherDetailScreen({
    super.key,
    required this.voucherId,
    this.initialVoucher,
    this.cubit,
  });

  final String voucherId;
  final PaymentVoucher? initialVoucher;
  final PaymentVoucherDetailCubit? cubit;

  @override
  Widget build(BuildContext context) {
    if (!context.can('accounting.read')) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(AccountingStrings.paymentVoucherDetailTitle),
        ),
        body: const Center(
          child: Text(AccountingStrings.noPermission),
        ),
      );
    }

    final contentView = _PaymentVoucherDetailView(voucherId: voucherId);

    if (cubit != null) {
      if (initialVoucher != null &&
          cubit!.state.voucher == null &&
          cubit!.state.status == LoadStatus.initial) {
        cubit!.setVoucher(initialVoucher!);
      }
      return BlocProvider<PaymentVoucherDetailCubit>.value(
        value: cubit!,
        child: contentView,
      );
    }

    return BlocProvider<PaymentVoucherDetailCubit>(
      create: (_) {
        final c = getIt.isRegistered<PaymentVoucherDetailCubit>()
            ? getIt<PaymentVoucherDetailCubit>()
            : PaymentVoucherDetailCubit(
                getIt<GetPaymentVoucherUseCase>(),
                getIt<PostPaymentVoucherUseCase>(),
              );
        if (initialVoucher != null) {
          c.setVoucher(initialVoucher!);
        } else {
          c.load(voucherId);
        }
        return c;
      },
      child: contentView,
    );
  }
}

class _PaymentVoucherDetailView extends StatelessWidget {
  const _PaymentVoucherDetailView({required this.voucherId});

  final String voucherId;

  static String _formatDate(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

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

  static String _statusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'posted':
        return AccountingStrings.statusPosted;
      case 'draft':
        return AccountingStrings.statusDraft;
      case 'void':
        return AccountingStrings.statusVoid;
      default:
        if (status.isEmpty) return status;
        return status[0].toUpperCase() + status.substring(1).toLowerCase();
    }
  }

  Future<void> _showPostDialog(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text(AccountingStrings.postVoucher),
        content: const Text(AccountingStrings.postVoucherConfirm),
        actions: [
          TextButton(
            key: const Key('post_cancel_button'),
            onPressed: () => Navigator.of(dialogCtx).pop(false),
            child: const Text(AccountingStrings.cancel),
          ),
          TextButton(
            key: const Key('post_confirm_button'),
            onPressed: () => Navigator.of(dialogCtx).pop(true),
            child: const Text(AccountingStrings.confirm),
          ),
        ],
      ),
    );

    if (confirm == true && context.mounted) {
      context.read<PaymentVoucherDetailCubit>().post();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PaymentVoucherDetailCubit, PaymentVoucherDetailState>(
      listenWhen: (previous, next) =>
          (next.postSuccess != null &&
              previous.postSuccess != next.postSuccess) ||
          (next.failure != null && previous.failure != next.failure),
      listener: (context, state) {
        if (state.postSuccess != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(AccountingStrings.voucherPostedSuccess),
            ),
          );
        } else if (state.failure != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(failureMessage(state.failure!)),
            ),
          );
        }
      },
      builder: (context, state) {
        final voucher = state.voucher;
        final canWrite = context.can('accounting.payments_write');
        final isDraft = voucher?.status.toLowerCase() == 'draft';
        final canPost = voucher != null && isDraft && canWrite;

        return Scaffold(
          appBar: AppBar(
            title: const Text(AccountingStrings.paymentVoucherDetailTitle),
            actions: [
              if (canPost)
                TextButton(
                  key: const Key('post_voucher_button'),
                  onPressed: state.isPosting
                      ? null
                      : () => _showPostDialog(context),
                  child: state.isPosting
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text(AccountingStrings.postVoucher),
                ),
            ],
          ),
          body: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, PaymentVoucherDetailState state) {
    if (state.status == LoadStatus.loading && state.voucher == null) {
      return const AppLoading();
    }

    if (state.status == LoadStatus.failure && state.voucher == null) {
      return AppErrorView(
        message:
            state.failure == null ? '' : failureMessage(state.failure!),
        onRetry: () =>
            context.read<PaymentVoucherDetailCubit>().load(voucherId),
      );
    }

    if (state.voucher == null) {
      if (state.status == LoadStatus.initial) {
        return const AppLoading();
      }
      return const AppEmptyView(message: AccountingStrings.noneFound);
    }

    final voucher = state.voucher!;
    return RefreshIndicator(
      onRefresh: () =>
          context.read<PaymentVoucherDetailCubit>().load(voucherId),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeaderCard(context, voucher),
            _buildAllocationsSection(context, voucher),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard(BuildContext context, PaymentVoucher voucher) {
    final theme = Theme.of(context);
    final bankText = voucher.bankAccountId != null &&
            voucher.bankAccountId!.isNotEmpty
        ? 'Account #${voucher.bankAccountId}'
        : '-';

    return Card(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    voucher.voucherNumber,
                    key: const Key('voucher_number_text'),
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
                AppStatusChip(
                  key: const Key('voucher_status_chip'),
                  label: _statusLabel(voucher.status),
                  color: _statusColor(voucher.status),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (voucher.journalEntryId != null &&
                voucher.journalEntryId!.isNotEmpty) ...[
              InkWell(
                key: const Key('journal_entry_badge'),
                onTap: () {
                  context.push(
                    Routes.adminAccountingJournalById(voucher.journalEntryId!),
                  );
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.blue.shade300),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.receipt_long, size: 16, color: Colors.blue),
                      const SizedBox(width: 6),
                      Text(
                        '${AccountingStrings.journalNumberLabel}: ${voucher.journalEntryId}',
                        key: const Key('journal_number_text'),
                        style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                const SizedBox(width: 6),
                const Text(
                  '${AccountingStrings.paymentDateLabel}: ',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  _formatDate(voucher.voucherDate),
                  key: const Key('voucher_date_text'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.account_balance, size: 16, color: Colors.grey),
                const SizedBox(width: 6),
                const Text(
                  '${AccountingStrings.bankAccountLabel}: ',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  bankText,
                  key: const Key('voucher_bank_text'),
                ),
              ],
            ),
            if (voucher.memo != null && voucher.memo!.trim().isNotEmpty) ...[
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.notes, size: 16, color: Colors.grey),
                  const SizedBox(width: 6),
                  const Text(
                    '${AccountingStrings.memoLabel}: ',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Expanded(
                    child: Text(
                      voucher.memo!,
                      key: const Key('voucher_memo_text'),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAllocationsSection(
      BuildContext context, PaymentVoucher voucher) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '${AccountingStrings.allocationsLabel} (${voucher.allocations.length})',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            if (voucher.allocations.isNotEmpty)
              Table(
                columnWidths: const {
                  0: FlexColumnWidth(4),
                  1: FlexColumnWidth(2),
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  TableRow(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest
                          .withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    children: const [
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        child: Text(
                          'Target (Bill / Expense)',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        child: Text(
                          AccountingStrings.allocationAmountLabel,
                          textAlign: TextAlign.right,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  ...voucher.allocations.map(
                    (alloc) {
                      final targetLabel = alloc.purchaseBillId != null
                          ? 'Bill #${alloc.purchaseBillId}'
                          : (alloc.expenseVoucherId != null
                              ? 'Expense #${alloc.expenseVoucherId}'
                              : 'Allocation #${alloc.id}');
                      return TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 8),
                            child: Text(targetLabel),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 8),
                            child: AppCurrencyText(
                              alloc.amount,
                              textAlign: TextAlign.end,
                              style: const TextStyle(fontFamily: 'monospace'),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              )
            else
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text('No allocations recorded.'),
              ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  AccountingStrings.totalAmountLabel,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                AppCurrencyText(
                  voucher.amount,
                  key: const Key('voucher_total_amount'),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
