import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/extensions/capability_extension.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../core/router/routes.dart';
import '../../domain/entities/account.dart';
import '../../../../core/widgets/app_currency_field.dart';
import '../../../../core/widgets/app_currency_text.dart';
import '../accounting_strings.dart';
import '../cubit/journal_entry_form_cubit.dart';
import '../widgets/account_picker_sheet.dart';

class JournalEntryFormScreen extends StatelessWidget {
  const JournalEntryFormScreen({
    super.key,
    this.cubit,
  });

  final JournalEntryFormCubit? cubit;

  @override
  Widget build(BuildContext context) {
    if (!context.can('accounting.journals_write')) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(AccountingStrings.createJournalTitle),
        ),
        body: const Center(
          child: Text(AccountingStrings.noPermission),
        ),
      );
    }

    if (cubit != null) {
      return BlocProvider<JournalEntryFormCubit>.value(
        value: cubit!,
        child: const _JournalEntryFormView(),
      );
    }

    return BlocProvider<JournalEntryFormCubit>(
      create: (_) => getIt<JournalEntryFormCubit>(),
      child: const _JournalEntryFormView(),
    );
  }
}

class _JournalEntryFormView extends StatelessWidget {
  const _JournalEntryFormView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<JournalEntryFormCubit, JournalEntryFormState>(
      listenWhen: (previous, current) =>
          previous.status != current.status &&
          (current.status == LoadStatus.success ||
              current.status == LoadStatus.failure),
      listener: (context, state) {
        if (state.status == LoadStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(AccountingStrings.journalCreatedSuccess),
            ),
          );
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop(state.createdJournal);
          } else if (state.createdJournal != null) {
            try {
              context.pushReplacement(
                Routes.adminAccountingJournalById(state.createdJournal!.id),
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
            title: const Text(AccountingStrings.createJournalTitle),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
              // Entry Date Picker
              InkWell(
                key: const Key('entry_date_picker'),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: state.entryDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null && context.mounted) {
                    context.read<JournalEntryFormCubit>().setEntryDate(picked);
                  }
                },
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: AccountingStrings.entryDateLabel,
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Text(
                    '${state.entryDate.year}-${state.entryDate.month.toString().padLeft(2, '0')}-${state.entryDate.day.toString().padLeft(2, '0')}',
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Source Type
              DropdownButtonFormField<String>(
                key: const Key('source_type_field'),
                initialValue: state.sourceType,
                decoration: const InputDecoration(
                  labelText: AccountingStrings.sourceTypeLabel,
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'manual',
                    child: Text('Manual'),
                  ),
                  DropdownMenuItem(
                    value: 'opening_balance',
                    child: Text('Opening Balance'),
                  ),
                ],
                onChanged: (val) {
                  if (val != null) {
                    context
                        .read<JournalEntryFormCubit>()
                        .setSourceType(val);
                  }
                },
              ),
              const SizedBox(height: 16),

              // Memo
              TextFormField(
                key: const Key('memo_field'),
                initialValue: state.memo,
                decoration: const InputDecoration(
                  labelText: AccountingStrings.memoLabel,
                ),
                onChanged: (val) {
                  context.read<JournalEntryFormCubit>().setMemo(
                        val.trim().isEmpty ? null : val.trim(),
                      );
                },
              ),
              const SizedBox(height: 24),

              // Lines Section Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Journal Lines (${state.lines.length})',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  OutlinedButton.icon(
                    key: const Key('add_line_button'),
                    icon: const Icon(Icons.add),
                    label: const Text(AccountingStrings.addLine),
                    onPressed: () =>
                        context.read<JournalEntryFormCubit>().addLine(),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Lines
              for (var i = 0; i < state.lines.length; i++)
                _JournalLineItem(
                  key: ValueKey('journal_line_$i'),
                  index: i,
                  line: state.lines[i],
                  canDelete: state.lines.length > 2,
                  onAccountChanged: (account) => context
                      .read<JournalEntryFormCubit>()
                      .updateLine(i, account: account),
                  onDebitChanged: (debit) => context
                      .read<JournalEntryFormCubit>()
                      .updateLine(i, debit: debit),
                  onCreditChanged: (credit) => context
                      .read<JournalEntryFormCubit>()
                      .updateLine(i, credit: credit),
                  onDescriptionChanged: (desc) => context
                      .read<JournalEntryFormCubit>()
                      .updateLine(i, description: desc),
                  onDelete: () =>
                      context.read<JournalEntryFormCubit>().removeLine(i),
                ),
              const SizedBox(height: 16),

              // Balance summary footer / card
              Card(
                key: const Key('balance_summary_card'),
                color: state.isBalanced
                    ? Colors.green.shade50
                    : Colors.amber.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                AccountingStrings.totalDebit,
                                style:
                                    TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                              AppCurrencyText(
                                state.totalDebit.toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                AccountingStrings.totalCredit,
                                style:
                                    TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                              AppCurrencyText(
                                state.totalCredit.toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                AccountingStrings.differenceLabel,
                                style:
                                    TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                              AppCurrencyText(
                                state.difference.toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: state.isBalanced
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Divider(height: 24),
                      if (state.isBalanced)
                        const Row(
                          children: [
                            Icon(Icons.check_circle,
                                color: Colors.green),
                            SizedBox(width: 8),
                            Text(
                              AccountingStrings.balancedStatus,
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        )
                      else
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.error_outline,
                                    color: Colors.red),
                                const SizedBox(width: 8),
                                Row(
                                  children: [
                                    const Text(
                                      'Unbalanced by ',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    AppCurrencyText(
                                      state.difference.toString(),
                                      style: const TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              AccountingStrings.unbalancedEntryError,
                              style:
                                  TextStyle(fontSize: 12, color: Colors.red),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Submit Button
              ElevatedButton(
                key: const Key('submit_journal_button'),
                onPressed: state.canSubmit
                    ? () => context.read<JournalEntryFormCubit>().submit()
                    : null,
                child: state.isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text(AccountingStrings.create),
              ),
            ],
          ),
        ),
      );
      },
    );
  }
}

class _JournalLineItem extends StatefulWidget {
  const _JournalLineItem({
    super.key,
    required this.index,
    required this.line,
    required this.canDelete,
    required this.onAccountChanged,
    required this.onDebitChanged,
    required this.onCreditChanged,
    required this.onDescriptionChanged,
    required this.onDelete,
  });

  final int index;
  final JournalLineDraft line;
  final bool canDelete;
  final ValueChanged<Account?> onAccountChanged;
  final ValueChanged<String> onDebitChanged;
  final ValueChanged<String> onCreditChanged;
  final ValueChanged<String> onDescriptionChanged;
  final VoidCallback onDelete;

  @override
  State<_JournalLineItem> createState() => _JournalLineItemState();
}

class _JournalLineItemState extends State<_JournalLineItem> {
  late final TextEditingController _debitController;
  late final TextEditingController _creditController;
  late final TextEditingController _memoController;

  @override
  void initState() {
    super.initState();
    _debitController = TextEditingController(text: widget.line.debit);
    _creditController = TextEditingController(text: widget.line.credit);
    _memoController = TextEditingController(text: widget.line.description);
  }

  @override
  void didUpdateWidget(covariant _JournalLineItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.line.debit != _debitController.text) {
      _debitController.text = widget.line.debit;
    }
    if (widget.line.credit != _creditController.text) {
      _creditController.text = widget.line.credit;
    }
    if (widget.line.description != _memoController.text) {
      _memoController.text = widget.line.description;
    }
  }

  @override
  void dispose() {
    _debitController.dispose();
    _creditController.dispose();
    _memoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final index = widget.index;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Line #${index + 1}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  key: Key('remove_line_button_$index'),
                  icon: const Icon(Icons.delete_outline),
                  tooltip: AccountingStrings.removeLine,
                  onPressed: widget.canDelete ? widget.onDelete : null,
                ),
              ],
            ),
            const SizedBox(height: 8),
            AccountPickerField(
              key: Key('account_picker_$index'),
              fieldKey: Key('account_picker_field_$index'),
              value: widget.line.account,
              activeOnly: true,
              onChanged: widget.onAccountChanged,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: AppCurrencyField(
                    key: Key('debit_field_$index'),
                    controller: _debitController,
                    label: AccountingStrings.debitLabel,
                    required: false,
                    onChanged: widget.onDebitChanged,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppCurrencyField(
                    key: Key('credit_field_$index'),
                    controller: _creditController,
                    label: AccountingStrings.creditLabel,
                    required: false,
                    onChanged: widget.onCreditChanged,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextFormField(
              key: Key('line_memo_field_$index'),
              controller: _memoController,
              decoration: const InputDecoration(
                labelText: AccountingStrings.descriptionLabel,
                hintText: 'Line description or memo',
              ),
              onChanged: widget.onDescriptionChanged,
            ),
          ],
        ),
      ),
    );
  }
}
