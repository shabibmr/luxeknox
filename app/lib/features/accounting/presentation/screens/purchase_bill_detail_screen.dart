import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/extensions/capability_extension.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../core/widgets/app_empty_view.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../../core/widgets/app_status_chip.dart';
import '../../domain/entities/purchase_bill.dart';
import '../accounting_strings.dart';
import '../cubit/purchase_bill_detail_cubit.dart';

class PurchaseBillDetailScreen extends StatelessWidget {
  const PurchaseBillDetailScreen({
    super.key,
    required this.billId,
    this.initialBill,
    this.cubit,
  });

  final String billId;
  final PurchaseBill? initialBill;
  final PurchaseBillDetailCubit? cubit;

  @override
  Widget build(BuildContext context) {
    if (!context.can('accounting.read')) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(AccountingStrings.billDetailTitle),
        ),
        body: const Center(
          child: Text(AccountingStrings.noPermission),
        ),
      );
    }

    final contentView = _PurchaseBillDetailView(billId: billId);

    if (cubit != null) {
      if (initialBill != null &&
          cubit!.state.bill == null &&
          cubit!.state.status == LoadStatus.initial) {
        cubit!.setBill(initialBill!);
      }
      return BlocProvider<PurchaseBillDetailCubit>.value(
        value: cubit!,
        child: contentView,
      );
    }

    return BlocProvider<PurchaseBillDetailCubit>(
      create: (_) {
        final c = getIt<PurchaseBillDetailCubit>();
        if (initialBill != null) {
          c.setBill(initialBill!);
        } else {
          c.load(billId);
        }
        return c;
      },
      child: contentView,
    );
  }
}

class _PurchaseBillDetailView extends StatelessWidget {
  const _PurchaseBillDetailView({required this.billId});

  final String billId;

  static String _formatDate(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  static String _formatAmount(dynamic value) {
    if (value is num) {
      return AccountingStrings.formatAmount(value);
    }
    final s = value.toString();
    if (s.isEmpty) return '\$0.00';
    if (s.startsWith('\$')) return s;
    final n = num.tryParse(s);
    if (n != null) {
      return AccountingStrings.formatAmount(n);
    }
    return AccountingStrings.formatMoney(s);
  }

  static Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'posted':
        return Colors.green;
      case 'draft':
        return Colors.amber;
      case 'void':
        return Colors.red;
      case 'paid':
        return Colors.teal;
      case 'partial':
        return Colors.blue;
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
      case 'paid':
        return AccountingStrings.statusPaid;
      case 'partial':
        return AccountingStrings.statusPartial;
      default:
        if (status.isEmpty) return status;
        return status[0].toUpperCase() + status.substring(1).toLowerCase();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PurchaseBillDetailCubit, PurchaseBillDetailState>(
      listenWhen: (previous, next) =>
          (next.postSuccess != null &&
              previous.postSuccess != next.postSuccess) ||
          (next.failure != null && previous.failure != next.failure),
      listener: (context, state) {
        if (state.postSuccess != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(AccountingStrings.billPostedSuccess),
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
        final bill = state.bill;
        final canWrite = context.can('accounting.purchases_write');
        final isDraft = bill != null && bill.status.toLowerCase() == 'draft';
        final canPost = isDraft && canWrite;

        return Scaffold(
          appBar: AppBar(
            title: const Text(AccountingStrings.billDetailTitle),
            actions: [
              if (canPost)
                TextButton(
                  key: const Key('post_bill_button'),
                  onPressed: state.isPosting
                      ? null
                      : () => context.read<PurchaseBillDetailCubit>().post(),
                  child: state.isPosting
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text(AccountingStrings.post),
                ),
              IconButton(
                tooltip: AccountingStrings.refresh,
                icon: const Icon(Icons.refresh),
                onPressed: () =>
                    context.read<PurchaseBillDetailCubit>().load(billId),
              ),
            ],
          ),
          body: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, PurchaseBillDetailState state) {
    if (state.status == LoadStatus.loading && state.bill == null) {
      return const AppLoading();
    }

    if (state.status == LoadStatus.failure && state.bill == null) {
      return AppErrorView(
        message: state.failure == null ? '' : failureMessage(state.failure!),
        onRetry: () => context.read<PurchaseBillDetailCubit>().load(billId),
      );
    }

    if (state.bill == null) {
      if (state.status == LoadStatus.initial) {
        return const AppLoading();
      }
      return const AppEmptyView(message: AccountingStrings.noneFound);
    }

    final bill = state.bill!;
    return RefreshIndicator(
      onRefresh: () => context.read<PurchaseBillDetailCubit>().load(billId),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeaderCard(context, bill),
            _buildLineItemsSection(context, bill),
            _buildTotalsCard(context, bill),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard(BuildContext context, PurchaseBill bill) {
    final theme = Theme.of(context);
    final vendorName = (bill.vendorName != null && bill.vendorName!.isNotEmpty)
        ? bill.vendorName!
        : bill.vendorId;

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
                    bill.billNumber,
                    key: const Key('bill_number_text'),
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
                AppStatusChip(
                  key: const Key('bill_status_chip'),
                  label: _statusLabel(bill.status),
                  color: _statusColor(bill.status),
                ),
              ],
            ),
            const Divider(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        AccountingStrings.vendorLabel,
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        vendorName,
                        key: const Key('vendor_text'),
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        AccountingStrings.billDateLabel,
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _formatDate(bill.billDate),
                        key: const Key('bill_date_text'),
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                if (bill.dueDate != null)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          AccountingStrings.dueDateLabel,
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _formatDate(bill.dueDate!),
                          key: const Key('due_date_text'),
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                // CRITICAL ACC-095: Display Journal Number when posted / populated
                if (bill.journalEntryId != null &&
                    bill.journalEntryId!.isNotEmpty)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          AccountingStrings.journalNumberLabel,
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          bill.journalEntryId!,
                          key: const Key('journal_entry_id_text'),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'monospace',
                            color: theme.colorScheme.primary,
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
    );
  }

  Widget _buildLineItemsSection(BuildContext context, PurchaseBill bill) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Line Items (${bill.lines.length})',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 16,
                headingRowHeight: 40,
                columns: const [
                  DataColumn(
                    label: Text(
                      AccountingStrings.descriptionLabel,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Account',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      AccountingStrings.quantityLabel,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    numeric: true,
                  ),
                  DataColumn(
                    label: Text(
                      AccountingStrings.rateLabel,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    numeric: true,
                  ),
                  DataColumn(
                    label: Text(
                      'Net',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    numeric: true,
                  ),
                  DataColumn(
                    label: Text(
                      AccountingStrings.taxAmountLabel,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    numeric: true,
                  ),
                ],
                rows: [
                  for (var i = 0; i < bill.lines.length; i++)
                    _buildLineDataRow(bill.lines[i], i),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  DataRow _buildLineDataRow(PurchaseBillLine line, int index) {
    return DataRow(
      cells: [
        DataCell(
          Text(line.description != null && line.description!.isNotEmpty
              ? line.description!
              : '-'),
        ),
        DataCell(
          Text(
            line.accountId,
            style: const TextStyle(fontFamily: 'monospace'),
          ),
        ),
        DataCell(Text(line.quantity)),
        DataCell(Text(_formatAmount(line.unitPrice))),
        DataCell(Text(_formatAmount(line.amount))),
        DataCell(Text(_formatAmount(line.taxAmount ?? '0.00'))),
      ],
    );
  }

  Widget _buildTotalsCard(BuildContext context, PurchaseBill bill) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  AccountingStrings.subtotalLabel,
                  style: TextStyle(fontSize: 14),
                ),
                Text(
                  _formatAmount(bill.subtotal),
                  key: const Key('subtotal_amount'),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  AccountingStrings.taxAmountLabel,
                  style: TextStyle(fontSize: 14),
                ),
                Text(
                  _formatAmount(bill.taxAmount),
                  key: const Key('tax_amount'),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  AccountingStrings.totalAmountLabel,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _formatAmount(bill.totalAmount),
                  key: const Key('total_amount'),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
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
