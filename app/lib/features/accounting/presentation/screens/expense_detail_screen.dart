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
import '../../domain/entities/expense_voucher.dart';
import '../../domain/usecases/get_expense_usecase.dart';
import '../../domain/usecases/post_expense_usecase.dart';
import '../../../../core/widgets/app_currency_text.dart';
import '../accounting_strings.dart';
import '../cubit/expense_detail_cubit.dart';

class ExpenseDetailScreen extends StatelessWidget {
  const ExpenseDetailScreen({
    super.key,
    required this.expenseId,
    this.initialExpense,
    this.cubit,
  });

  final String expenseId;
  final ExpenseVoucher? initialExpense;
  final ExpenseDetailCubit? cubit;

  @override
  Widget build(BuildContext context) {
    if (!context.can('accounting.read')) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(AccountingStrings.expenseDetailTitle),
        ),
        body: const Center(
          child: Text(AccountingStrings.noPermission),
        ),
      );
    }

    final contentView = _ExpenseDetailView(expenseId: expenseId);

    if (cubit != null) {
      if (initialExpense != null &&
          cubit!.state.expense == null &&
          cubit!.state.status == LoadStatus.initial) {
        cubit!.setExpense(initialExpense!);
      }
      return BlocProvider<ExpenseDetailCubit>.value(
        value: cubit!,
        child: contentView,
      );
    }

    return BlocProvider<ExpenseDetailCubit>(
      create: (_) {
        final c = getIt.isRegistered<ExpenseDetailCubit>()
            ? getIt<ExpenseDetailCubit>()
            : ExpenseDetailCubit(
                getIt<GetExpenseUseCase>(),
                getIt<PostExpenseUseCase>(),
              );
        if (initialExpense != null) {
          c.setExpense(initialExpense!);
        } else {
          c.load(expenseId);
        }
        return c;
      },
      child: contentView,
    );
  }
}

class _ExpenseDetailView extends StatelessWidget {
  const _ExpenseDetailView({required this.expenseId});

  final String expenseId;

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
        title: const Text(AccountingStrings.postExpense),
        content: const Text(AccountingStrings.postExpenseConfirm),
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
      context.read<ExpenseDetailCubit>().post();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ExpenseDetailCubit, ExpenseDetailState>(
      listenWhen: (previous, next) =>
          (next.postSuccess != null &&
              previous.postSuccess != next.postSuccess) ||
          (next.failure != null && previous.failure != next.failure),
      listener: (context, state) {
        if (state.postSuccess != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(AccountingStrings.expensePostedSuccess),
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
        final expense = state.expense;
        final canWrite = context.can('accounting.expenses_write');
        final isDraft = expense?.status.toLowerCase() == 'draft';
        final canPost = expense != null && isDraft && canWrite;

        return Scaffold(
          appBar: AppBar(
            title: const Text(AccountingStrings.expenseDetailTitle),
            actions: [
              if (canPost)
                TextButton(
                  key: const Key('post_expense_button'),
                  onPressed: state.isPosting
                      ? null
                      : () => _showPostDialog(context),
                  child: state.isPosting
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text(AccountingStrings.postExpense),
                ),
            ],
          ),
          body: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, ExpenseDetailState state) {
    if (state.status == LoadStatus.loading && state.expense == null) {
      return const AppLoading();
    }

    if (state.status == LoadStatus.failure && state.expense == null) {
      return AppErrorView(
        message:
            state.failure == null ? '' : failureMessage(state.failure!),
        onRetry: () => context.read<ExpenseDetailCubit>().load(expenseId),
      );
    }

    if (state.expense == null) {
      if (state.status == LoadStatus.initial) {
        return const AppLoading();
      }
      return const AppEmptyView(message: AccountingStrings.noneFound);
    }

    final expense = state.expense!;
    return RefreshIndicator(
      onRefresh: () => context.read<ExpenseDetailCubit>().load(expenseId),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeaderCard(context, expense),
            _buildLinesSection(context, expense),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard(BuildContext context, ExpenseVoucher expense) {
    final theme = Theme.of(context);
    final payeeText = expense.memo?.trim().isNotEmpty == true
        ? expense.memo!
        : (expense.vendorId != null && expense.vendorId!.isNotEmpty
            ? 'Vendor #${expense.vendorId}'
            : '-');

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
                    expense.voucherNumber,
                    key: const Key('expense_number_text'),
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
                AppStatusChip(
                  key: const Key('expense_status_chip'),
                  label: _statusLabel(expense.status),
                  color: _statusColor(expense.status),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (expense.journalEntryId != null &&
                expense.journalEntryId!.isNotEmpty) ...[
              InkWell(
                key: const Key('journal_entry_badge'),
                onTap: () {
                  context.push(
                    Routes.adminAccountingJournalById(expense.journalEntryId!),
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
                        '${AccountingStrings.journalNumberLabel}: ${expense.journalEntryId}',
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
                  '${AccountingStrings.expenseDateLabel}: ',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  _formatDate(expense.expenseDate),
                  key: const Key('expense_date_text'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.person_outline, size: 16, color: Colors.grey),
                const SizedBox(width: 6),
                const Text(
                  '${AccountingStrings.payeeLabel}: ',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  payeeText,
                  key: const Key('expense_payee_text'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.account_balance, size: 16, color: Colors.grey),
                const SizedBox(width: 6),
                const Text(
                  '${AccountingStrings.paidFromAccountLabel}: ',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  expense.bankAccountId != null &&
                          expense.bankAccountId!.isNotEmpty
                      ? 'Account #${expense.bankAccountId}'
                      : 'Credit (Unpaid)',
                  key: const Key('paid_from_account_text'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLinesSection(BuildContext context, ExpenseVoucher expense) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Line Items (${expense.lines.length})',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            if (expense.lines.isNotEmpty)
              Table(
                columnWidths: const {
                  0: FlexColumnWidth(3),
                  1: FlexColumnWidth(3),
                  2: FlexColumnWidth(2),
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
                          'Account',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        child: Text(
                          AccountingStrings.descriptionLabel,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        child: Text(
                          AccountingStrings.amountLabel,
                          textAlign: TextAlign.right,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  ...expense.lines.map(
                    (line) => TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 8),
                          child: Text(line.accountId ?? "-"),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 8),
                          child: Text(line.description ?? '-'),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 8),
                          child: AppCurrencyText(
                            line.amount,
                            textAlign: TextAlign.end,
                            style: const TextStyle(fontFamily: 'monospace'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            else
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text('No lines recorded.'),
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
                  expense.totalAmount,
                  key: const Key('expense_total_amount'),
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
