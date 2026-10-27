import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/extensions/capability_extension.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../core/router/routes.dart';
import '../../domain/usecases/create_expense_usecase.dart';
import '../../../../core/widgets/app_currency_field.dart';
import '../../../../core/widgets/app_currency_text.dart';
import '../accounting_strings.dart';
import '../cubit/expense_form_cubit.dart';
import '../widgets/account_picker_sheet.dart';

class ExpenseFormScreen extends StatelessWidget {
  const ExpenseFormScreen({
    super.key,
    this.cubit,
  });

  final ExpenseFormCubit? cubit;

  @override
  Widget build(BuildContext context) {
    if (!context.can('accounting.expenses_write')) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(AccountingStrings.createExpenseTitle),
        ),
        body: const Center(
          child: Text(AccountingStrings.noPermission),
        ),
      );
    }

    if (cubit != null) {
      return BlocProvider<ExpenseFormCubit>.value(
        value: cubit!,
        child: const _ExpenseFormView(),
      );
    }

    return BlocProvider<ExpenseFormCubit>(
      create: (_) => getIt.isRegistered<ExpenseFormCubit>()
          ? getIt<ExpenseFormCubit>()
          : ExpenseFormCubit(getIt<CreateExpenseUseCase>()),
      child: const _ExpenseFormView(),
    );
  }
}

class _ExpenseFormView extends StatefulWidget {
  const _ExpenseFormView();

  @override
  State<_ExpenseFormView> createState() => _ExpenseFormViewState();
}

class _ExpenseFormViewState extends State<_ExpenseFormView> {
  final _payeeController = TextEditingController();

  @override
  void dispose() {
    _payeeController.dispose();
    super.dispose();
  }

  static String _formatDate(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ExpenseFormCubit, ExpenseFormState>(
      listenWhen: (previous, current) =>
          previous.status != current.status &&
          (current.status == LoadStatus.success ||
              current.status == LoadStatus.failure),
      listener: (context, state) {
        if (state.status == LoadStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(AccountingStrings.expenseCreatedSuccess),
            ),
          );
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop(state.createdExpense);
          } else if (state.createdExpense != null) {
            try {
              context.pushReplacement(
                Routes.adminAccountingExpenseById(state.createdExpense!.id),
              );
            } catch (_) {}
          }
        } else if (state.status == LoadStatus.failure &&
            state.failure != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(failureMessage(state.failure!)),
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(AccountingStrings.createExpenseTitle),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Expense Date Picker
                InkWell(
                  key: const Key('expense_date_picker'),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: state.expenseDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null && context.mounted) {
                      context.read<ExpenseFormCubit>().setExpenseDate(picked);
                    }
                  },
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: AccountingStrings.expenseDateLabel,
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    child: Text(_formatDate(state.expenseDate)),
                  ),
                ),
                const SizedBox(height: 16),

                // Paid From Account (Bank / Cash) - Optional for credit expense
                AccountPickerField(
                  fieldKey: const Key('paid_from_account_picker'),
                  labelText: AccountingStrings.paidFromAccountLabel,
                  value: state.paidFromAccount,
                  onChanged: (account) {
                    context.read<ExpenseFormCubit>().setPaidFromAccount(account);
                  },
                ),
                const SizedBox(height: 16),

                // Payee / Vendor Name
                TextFormField(
                  key: const Key('payee_name_field'),
                  controller: _payeeController,
                  decoration: InputDecoration(
                    labelText: AccountingStrings.payeeLabel,
                    helperText: state.isCreditExpense
                        ? AccountingStrings.vendorOrPayeeRequired
                        : null,
                  ),
                  onChanged: (val) {
                    context.read<ExpenseFormCubit>().setPayeeName(
                          val.trim().isEmpty ? null : val.trim(),
                        );
                  },
                ),
                const SizedBox(height: 24),

                // Line Items Section Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Expense Lines (${state.lines.length})',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    TextButton.icon(
                      key: const Key('add_line_button'),
                      icon: const Icon(Icons.add),
                      label: const Text(AccountingStrings.addLine),
                      onPressed: () =>
                          context.read<ExpenseFormCubit>().addLine(),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Lines List
                for (int i = 0; i < state.lines.length; i++)
                  _ExpenseLineCard(
                    index: i,
                    line: state.lines[i],
                    canRemove: state.lines.length > 1,
                  ),

                const SizedBox(height: 16),

                // Totals Preview Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              AccountingStrings.subtotalLabel,
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            AppCurrencyText(
                              state.subtotal.toString(),
                              key: const Key('totals_subtotal'),
                              style: const TextStyle(
                                fontFamily: 'monospace',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
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
                              state.totalAmount.toString(),
                              key: const Key('totals_total'),
                              style: const TextStyle(
                                fontFamily: 'monospace',
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Submit Button
                FilledButton(
                  key: const Key('submit_expense_button'),
                  onPressed: state.canSubmit
                      ? () => context.read<ExpenseFormCubit>().submit()
                      : null,
                  child: state.isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text(AccountingStrings.create),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ExpenseLineCard extends StatelessWidget {
  const _ExpenseLineCard({
    required this.index,
    required this.line,
    required this.canRemove,
  });

  final int index;
  final ExpenseFormLineDraft line;
  final bool canRemove;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Text(
                  'Line #${index + 1}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                if (canRemove)
                  IconButton(
                    key: Key('remove_line_button_$index'),
                    icon: const Icon(Icons.delete_outline, size: 20),
                    onPressed: () =>
                        context.read<ExpenseFormCubit>().removeLine(index),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            AccountPickerField(
              fieldKey: Key('line_account_picker_$index'),
              value: line.account,
              onChanged: (acc) {
                context
                    .read<ExpenseFormCubit>()
                    .updateLine(index, account: acc);
              },
            ),
            const SizedBox(height: 8),
            TextFormField(
              key: Key('line_description_field_$index'),
              initialValue: line.description,
              decoration: const InputDecoration(
                labelText: AccountingStrings.descriptionLabel,
              ),
              onChanged: (desc) {
                context
                    .read<ExpenseFormCubit>()
                    .updateLine(index, description: desc);
              },
            ),
            const SizedBox(height: 8),
            AppCurrencyInput(
              key: Key('line_amount_field_$index'),
              initialValue: line.amount,
              label: AccountingStrings.amountLabel,
              onChanged: (amt) {
                context
                    .read<ExpenseFormCubit>()
                    .updateLine(index, amount: amt);
              },
            ),
          ],
        ),
      ),
    );
  }
}
