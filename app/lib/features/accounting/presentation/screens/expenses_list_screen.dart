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
import '../../domain/usecases/get_expenses_usecase.dart';
import '../accounting_strings.dart';
import '../cubit/expenses_cubit.dart';

class ExpensesListScreen extends StatelessWidget {
  const ExpensesListScreen({
    super.key,
    this.cubit,
  });

  final ExpensesCubit? cubit;

  @override
  Widget build(BuildContext context) {
    if (cubit != null) {
      if (cubit!.state.status == LoadStatus.initial) {
        cubit!.load();
      }
      return BlocProvider<ExpensesCubit>.value(
        value: cubit!,
        child: const _ExpensesListBody(),
      );
    }
    return BlocProvider<ExpensesCubit>(
      create: (_) => getIt.isRegistered<ExpensesCubit>()
          ? (getIt<ExpensesCubit>()..load())
          : (ExpensesCubit(getIt<GetExpensesUseCase>())..load()),
      child: const _ExpensesListBody(),
    );
  }
}

class _ExpensesListBody extends StatefulWidget {
  const _ExpensesListBody();

  @override
  State<_ExpensesListBody> createState() => _ExpensesListBodyState();
}

class _ExpensesListBodyState extends State<_ExpensesListBody> {
  static String _formatDate(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  Future<void> _pickDateRange(BuildContext context, ExpensesState state) async {
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
      context.read<ExpensesCubit>().filterByDateRange(picked.start, picked.end);
    }
  }

  @override
  Widget build(BuildContext context) {
    final canWrite = context.can('accounting.expenses_write');

    return Scaffold(
      appBar: AppBar(
        title: const Text(AccountingStrings.expensesTitle),
        actions: [
          IconButton(
            tooltip: AccountingStrings.refresh,
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<ExpensesCubit>().load(),
          ),
          if (canWrite)
            IconButton(
              key: const Key('appbar_create_expense_button'),
              tooltip: AccountingStrings.createExpenseTitle,
              icon: const Icon(Icons.add),
              onPressed: () =>
                  context.push(Routes.adminAccountingExpensesCreate),
            ),
        ],
      ),
      floatingActionButton: canWrite
          ? FloatingActionButton.extended(
              key: const Key('create_expense_button'),
              onPressed: () =>
                  context.push(Routes.adminAccountingExpensesCreate),
              icon: const Icon(Icons.add),
              label: const Text(AccountingStrings.createExpenseTitle),
            )
          : null,
      body: BlocConsumer<ExpensesCubit, ExpensesState>(
        listenWhen: (previous, next) =>
            next.status == LoadStatus.failure &&
            next.failure != previous.failure &&
            next.expenses.isNotEmpty,
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
                                .read<ExpensesCubit>()
                                .filterByStatus(null),
                          ),
                          const SizedBox(width: 8),
                          FilterChip(
                            key: const Key('status_chip_draft'),
                            label: const Text(AccountingStrings.statusDraft),
                            selected: state.statusFilter == 'draft',
                            onSelected: (_) => context
                                .read<ExpensesCubit>()
                                .filterByStatus('draft'),
                          ),
                          const SizedBox(width: 8),
                          FilterChip(
                            key: const Key('status_chip_posted'),
                            label: const Text(AccountingStrings.statusPosted),
                            selected: state.statusFilter == 'posted',
                            onSelected: (_) => context
                                .read<ExpensesCubit>()
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
                                    .read<ExpensesCubit>()
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
                                  .read<ExpensesCubit>()
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

  Widget _buildListArea(BuildContext context, ExpensesState state) {
    if (state.status == LoadStatus.loading && state.expenses.isEmpty) {
      return const AppLoading();
    }

    if (state.status == LoadStatus.failure && state.expenses.isEmpty) {
      return AppErrorView(
        message:
            state.failure == null ? '' : failureMessage(state.failure!),
        onRetry: () => context.read<ExpensesCubit>().load(),
      );
    }

    if (state.expenses.isEmpty) {
      return RefreshIndicator(
        onRefresh: () => context.read<ExpensesCubit>().load(),
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
      onRefresh: () => context.read<ExpensesCubit>().load(),
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 80, top: 4),
        itemCount: state.expenses.length + (state.hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= state.expenses.length) {
            context.read<ExpensesCubit>().loadMore();
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          final expense = state.expenses[index];
          return _ExpenseCard(expense: expense);
        },
      ),
    );
  }
}

class _ExpenseCard extends StatelessWidget {
  const _ExpenseCard({required this.expense});

  final ExpenseVoucher expense;

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
    final payeeText = expense.memo?.trim().isNotEmpty == true
        ? expense.memo!
        : (expense.vendorId != null && expense.vendorId!.isNotEmpty
            ? 'Vendor #${expense.vendorId}'
            : 'Expense');

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.push(
          Routes.adminAccountingExpenseById(expense.id),
          extra: expense,
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
                          expense.voucherNumber,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'monospace',
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatDate(expense.expenseDate),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          payeeText,
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
                        AccountingStrings.formatMoney(expense.totalAmount),
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      AppStatusChip(
                        label: expense.status,
                        color: _statusColor(expense.status),
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
