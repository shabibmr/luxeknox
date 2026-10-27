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
import '../../domain/entities/fund_transfer.dart';
import '../../../../core/widgets/app_currency_text.dart';
import '../accounting_strings.dart';
import '../cubit/fund_transfer_detail_cubit.dart';

class FundTransferDetailScreen extends StatelessWidget {
  const FundTransferDetailScreen({
    super.key,
    required this.transferId,
    this.initialTransfer,
    this.cubit,
  });

  final String transferId;
  final FundTransfer? initialTransfer;
  final FundTransferDetailCubit? cubit;

  @override
  Widget build(BuildContext context) {
    if (!context.can('accounting.read')) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(AccountingStrings.transferDetailTitle),
        ),
        body: const Center(
          child: Text(AccountingStrings.noPermission),
        ),
      );
    }

    final contentView = _FundTransferDetailView(transferId: transferId);

    if (cubit != null) {
      if (initialTransfer != null &&
          cubit!.state.transfer == null &&
          cubit!.state.status == LoadStatus.initial) {
        cubit!.setTransfer(initialTransfer!);
      } else if (cubit!.state.transfer == null &&
          cubit!.state.status == LoadStatus.initial) {
        cubit!.load(transferId);
      }
      return BlocProvider<FundTransferDetailCubit>.value(
        value: cubit!,
        child: contentView,
      );
    }

    return BlocProvider<FundTransferDetailCubit>(
      create: (_) {
        final c = getIt<FundTransferDetailCubit>();
        if (initialTransfer != null) {
          c.setTransfer(initialTransfer!);
        } else {
          c.load(transferId);
        }
        return c;
      },
      child: contentView,
    );
  }
}

class _FundTransferDetailView extends StatelessWidget {
  const _FundTransferDetailView({required this.transferId});

  final String transferId;

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
        return Colors.orange;
      case 'void':
        return Colors.red;
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

  Future<void> _confirmAndPost(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text(AccountingStrings.postTransfer),
        content: const Text(AccountingStrings.postTransferConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(false),
            child: const Text(AccountingStrings.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(dialogCtx).pop(true),
            child: const Text(AccountingStrings.confirm),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      context.read<FundTransferDetailCubit>().post();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FundTransferDetailCubit, FundTransferDetailState>(
      listenWhen: (previous, current) =>
          (current.postSuccess && !previous.postSuccess) ||
          (current.failure != null && previous.failure != current.failure),
      listener: (context, state) {
        if (state.postSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(AccountingStrings.transferPostedSuccess),
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
        final transfer = state.transfer;
        final canWrite = context.can('accounting.payments_write');
        final canPost = transfer != null && transfer.isDraft && canWrite;

        return Scaffold(
          appBar: AppBar(
            title: const Text(AccountingStrings.transferDetailTitle),
            actions: [
              IconButton(
                tooltip: AccountingStrings.refresh,
                icon: const Icon(Icons.refresh),
                onPressed: () =>
                    context.read<FundTransferDetailCubit>().load(transferId),
              ),
              if (canPost)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: TextButton(
                    key: const Key('post_transfer_appbar_button'),
                    onPressed: state.isPosting
                        ? null
                        : () => _confirmAndPost(context),
                    child: state.isPosting
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text(AccountingStrings.post),
                  ),
                ),
            ],
          ),
          body: _buildBody(context, state, canPost),
        );
      },
    );
  }

  Widget _buildBody(
      BuildContext context, FundTransferDetailState state, bool canPost) {
    if (state.status == LoadStatus.loading && state.transfer == null) {
      return const AppLoading();
    }

    if (state.status == LoadStatus.failure && state.transfer == null) {
      return AppErrorView(
        message: state.failure == null ? '' : failureMessage(state.failure!),
        onRetry: () =>
            context.read<FundTransferDetailCubit>().load(transferId),
      );
    }

    if (state.transfer == null) {
      if (state.status == LoadStatus.initial) {
        return const AppLoading();
      }
      return const AppEmptyView(message: AccountingStrings.noneFound);
    }

    final transfer = state.transfer!;
    final theme = Theme.of(context);

    final double gross = double.tryParse(transfer.amount) ?? 0.0;
    final double fee = double.tryParse(transfer.feeAmount) ?? 0.0;
    final double net = gross - fee;

    return RefreshIndicator(
      onRefresh: () =>
          context.read<FundTransferDetailCubit>().load(transferId),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header card
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          transfer.transferNumber,
                          key: const Key('transfer_number_text'),
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'monospace',
                          ),
                        ),
                        AppStatusChip(
                          key: const Key('transfer_status_chip'),
                          label: _statusLabel(transfer.status),
                          color: _statusColor(transfer.status),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today,
                            size: 16, color: Colors.grey),
                        const SizedBox(width: 8),
                        Text(
                          '${AccountingStrings.transferDateLabel}: ${_formatDate(transfer.transferDate)}',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    if (transfer.memo != null && transfer.memo!.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.notes,
                              size: 16, color: Colors.grey),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '${AccountingStrings.memoLabel}: ${transfer.memo}',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Accounts Routing Card
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Account Transfer Routing',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const Divider(),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                AccountingStrings.fromAccountLabel,
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '#${transfer.fromAccountId}',
                                key: const Key('from_account_text'),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward, color: Colors.grey),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text(
                                AccountingStrings.toAccountLabel,
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '#${transfer.toAccountId}',
                                key: const Key('to_account_text'),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Financial Breakdown Card (CRITICAL ACC-095: FEE LINE)
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Transfer Breakdown',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          AccountingStrings.grossAmountLabel,
                          style: TextStyle(fontSize: 15),
                        ),
                        AppCurrencyText(
                          gross.toString(),
                          key: const Key('gross_amount_text'),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),

                    // CRITICAL ACC-095: FEE LINE when feeAmount > 0
                    if (transfer.hasFee) ...[
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.receipt,
                                  size: 16, color: Colors.orange),
                              const SizedBox(width: 4),
                              const Text(
                                AccountingStrings.feeLineLabel,
                                key: Key('fee_line_label'),
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.orange,
                                ),
                              ),
                              if (transfer.feeAccountId != null)
                                Text(
                                  ' (#${transfer.feeAccountId})',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                            ],
                          ),
                          AppCurrencyText(
                            '-$fee',
                            key: const Key('fee_amount_text'),
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.orange,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            AccountingStrings.netTransferAmountLabel,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          AppCurrencyText(
                            net.toString(),
                            key: const Key('net_amount_text'),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Journal Entry Link (when posted)
            if (transfer.isPosted &&
                transfer.journalEntryId != null &&
                transfer.journalEntryId!.isNotEmpty) ...[
              Card(
                key: const Key('journal_link_card'),
                elevation: 1,
                color: Colors.blue.shade50,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: Colors.blue.shade200),
                ),
                child: ListTile(
                  leading:
                      const Icon(Icons.menu_book, color: Colors.blue),
                  title: const Text(
                    AccountingStrings.journalDetailTitle,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  subtitle: Text(
                    '${AccountingStrings.journalNumberLabel}: ${transfer.journalEntryId}',
                    key: const Key('journal_number_text'),
                  ),
                  trailing: const Icon(Icons.chevron_right, color: Colors.blue),
                  onTap: () {
                    try {
                      context.push(
                        Routes.adminAccountingJournalById(
                            transfer.journalEntryId!),
                      );
                    } catch (_) {}
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Post Button (when draft and has permission)
            if (canPost)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: ElevatedButton.icon(
                  key: const Key('post_transfer_button'),
                  icon: state.isPosting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.check_circle_outline),
                  label: const Text(
                    AccountingStrings.postTransfer,
                    style: TextStyle(fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  onPressed:
                      state.isPosting ? null : () => _confirmAndPost(context),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
