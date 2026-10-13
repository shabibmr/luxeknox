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
import '../../domain/entities/journal.dart';
import '../accounting_strings.dart';
import '../cubit/journal_detail_cubit.dart';

class JournalDetailScreen extends StatelessWidget {
  const JournalDetailScreen({
    super.key,
    required this.journalId,
    this.initialJournal,
    this.cubit,
  });

  final String journalId;
  final Journal? initialJournal;
  final JournalDetailCubit? cubit;

  @override
  Widget build(BuildContext context) {
    if (!context.can('accounting.read')) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(AccountingStrings.journalDetailTitle),
        ),
        body: const Center(
          child: Text(AccountingStrings.noPermission),
        ),
      );
    }

    final contentView = _JournalDetailView(journalId: journalId);

    if (cubit != null) {
      if (initialJournal != null &&
          cubit!.state.journal == null &&
          cubit!.state.status == LoadStatus.initial) {
        cubit!.setJournal(initialJournal!);
      }
      return BlocProvider<JournalDetailCubit>.value(
        value: cubit!,
        child: contentView,
      );
    }

    return BlocProvider<JournalDetailCubit>(
      create: (_) {
        final c = getIt<JournalDetailCubit>();
        if (initialJournal != null) {
          c.setJournal(initialJournal!);
        } else {
          c.load(journalId);
        }
        return c;
      },
      child: contentView,
    );
  }
}

class _JournalDetailView extends StatelessWidget {
  const _JournalDetailView({required this.journalId});

  final String journalId;

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
      case 'reversed':
        return Colors.orange;
      case 'draft':
        return Colors.grey;
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
      case 'reversed':
        return AccountingStrings.statusReversed;
      case 'draft':
        return AccountingStrings.statusDraft;
      case 'void':
        return AccountingStrings.statusVoid;
      default:
        if (status.isEmpty) return status;
        return status[0].toUpperCase() + status.substring(1).toLowerCase();
    }
  }

  Future<void> _showReverseDialog(BuildContext context) async {
    final result = await showDialog<_ReverseDialogResult>(
      context: context,
      builder: (dialogContext) => const _ReverseJournalDialog(),
    );

    if (result != null && context.mounted) {
      context.read<JournalDetailCubit>().reverse(
            entryDate: result.entryDate,
            memo: result.memo,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<JournalDetailCubit, JournalDetailState>(
      listenWhen: (previous, next) =>
          (next.reversalSuccess != null &&
              previous.reversalSuccess != next.reversalSuccess) ||
          (next.failure != null && previous.failure != next.failure),
      listener: (context, state) {
        if (state.reversalSuccess != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(AccountingStrings.journalReversedSuccess),
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
        final journal = state.journal;
        final canWrite = context.can('accounting.journals_write');
        final canReverse = journal != null &&
            journal.status.toLowerCase() != 'reversed' &&
            canWrite;

        return Scaffold(
          appBar: AppBar(
            title: const Text(AccountingStrings.journalDetailTitle),
            actions: [
              if (canReverse)
                TextButton(
                  key: const Key('reverse_journal_button'),
                  onPressed: state.isReversing
                      ? null
                      : () => _showReverseDialog(context),
                  child: state.isReversing
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text(AccountingStrings.reverse),
                ),
            ],
          ),
          body: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, JournalDetailState state) {
    if (state.status == LoadStatus.loading && state.journal == null) {
      return const AppLoading();
    }

    if (state.status == LoadStatus.failure && state.journal == null) {
      return AppErrorView(
        message: state.failure == null ? '' : failureMessage(state.failure!),
        onRetry: () => context.read<JournalDetailCubit>().load(journalId),
      );
    }

    if (state.journal == null) {
      if (state.status == LoadStatus.initial) {
        return const AppLoading();
      }
      return const AppEmptyView(message: AccountingStrings.noneFound);
    }

    final journal = state.journal!;
    return RefreshIndicator(
      onRefresh: () => context.read<JournalDetailCubit>().load(journalId),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeaderCard(context, journal),
            _buildLinesSection(context, journal),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard(BuildContext context, Journal journal) {
    final theme = Theme.of(context);
    final entryDateFormatted = _formatDate(journal.entryDate);

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
                    journal.journalNumber,
                    key: const Key('journal_number_text'),
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
                AppStatusChip(
                  key: const Key('journal_status_chip'),
                  label: _statusLabel(journal.status),
                  color: _statusColor(journal.status),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: [
                if (journal.isOpening)
                  const AppStatusChip(
                    key: Key('opening_badge'),
                    label: AccountingStrings.openingBadge,
                    color: Colors.blue,
                  ),
                if (journal.isClosing)
                  const AppStatusChip(
                    key: Key('closing_badge'),
                    label: AccountingStrings.closingBadge,
                    color: Colors.purple,
                  ),
                if (journal.reversesJournalId != null &&
                    journal.reversesJournalId!.isNotEmpty)
                  Container(
                    key: const Key('reverses_journal_badge'),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.orange.shade300),
                    ),
                    child: Text(
                      'Reverses Journal ID: ${journal.reversesJournalId}',
                      style: TextStyle(
                        color: Colors.orange.shade900,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                const SizedBox(width: 6),
                const Text(
                  '${AccountingStrings.entryDateLabel}: ',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  entryDateFormatted,
                  key: const Key('entry_date_text'),
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
            if (journal.sourceType != null &&
                journal.sourceType!.isNotEmpty) ...[
              const SizedBox(height: 6),
              Row(
                children: [
                  const Text(
                    '${AccountingStrings.sourceTypeLabel}: ',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text(journal.sourceType!),
                ],
              ),
            ],
            if (journal.sourceId != null && journal.sourceId!.isNotEmpty) ...[
              const SizedBox(height: 6),
              Row(
                children: [
                  const Text(
                    '${AccountingStrings.sourceIdLabel}: ',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text(journal.sourceId!),
                ],
              ),
            ],
            if (journal.memo != null && journal.memo!.isNotEmpty) ...[
              const SizedBox(height: 6),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '${AccountingStrings.memoLabel}: ',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Expanded(
                    child: Text(journal.memo!),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLinesSection(BuildContext context, Journal journal) {
    final theme = Theme.of(context);

    double totalDebit = 0.0;
    double totalCredit = 0.0;
    for (final line in journal.lines) {
      totalDebit += double.tryParse(line.debit) ?? 0.0;
      totalCredit += double.tryParse(line.credit) ?? 0.0;
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Lines (${journal.lines.length})',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Table(
              columnWidths: const {
                0: FlexColumnWidth(3),
                1: FlexColumnWidth(2),
                2: FlexColumnWidth(2),
                3: FlexColumnWidth(2),
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
                          EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                      child: Text(
                        'Account',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                      child: Text(
                        AccountingStrings.descriptionLabel,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                      child: Text(
                        AccountingStrings.debitLabel,
                        textAlign: TextAlign.right,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                      child: Text(
                        AccountingStrings.creditLabel,
                        textAlign: TextAlign.right,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                ...journal.lines.map((line) {
                  return TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 10,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (line.accountCode != null)
                              Text(
                                line.accountCode!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'monospace',
                                  fontSize: 13,
                                ),
                              ),
                            Text(
                              line.accountName ?? line.accountId,
                              style: theme.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 10,
                        ),
                        child: Text(
                          line.description ?? '-',
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 10,
                        ),
                        child: Text(
                          _formatAmount(line.debit),
                          textAlign: TextAlign.right,
                          style: const TextStyle(fontFamily: 'monospace'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 10,
                        ),
                        child: Text(
                          _formatAmount(line.credit),
                          textAlign: TextAlign.right,
                          style: const TextStyle(fontFamily: 'monospace'),
                        ),
                      ),
                    ],
                  );
                }),
              ],
            ),
            const Divider(height: 24),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          AccountingStrings.totalDebit,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          AccountingStrings.formatAmount(totalDebit),
                          key: const Key('total_debit_amount'),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          AccountingStrings.totalCredit,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          AccountingStrings.formatAmount(totalCredit),
                          key: const Key('total_credit_amount'),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReverseDialogResult {
  const _ReverseDialogResult({
    this.entryDate,
    this.memo,
  });

  final DateTime? entryDate;
  final String? memo;
}

class _ReverseJournalDialog extends StatefulWidget {
  const _ReverseJournalDialog();

  @override
  State<_ReverseJournalDialog> createState() => _ReverseJournalDialogState();
}

class _ReverseJournalDialogState extends State<_ReverseJournalDialog> {
  DateTime? _selectedDate;
  late final TextEditingController _memoController;

  @override
  void initState() {
    super.initState();
    _memoController = TextEditingController();
  }

  @override
  void dispose() {
    _memoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(AccountingStrings.reverseJournalTitle),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(AccountingStrings.reverseJournalConfirm),
            const SizedBox(height: 16),
            InkWell(
              key: const Key('reversal_date_picker'),
              onTap: () async {
                final now = DateTime.now();
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate ?? now,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  setState(() {
                    _selectedDate = picked;
                  });
                }
              },
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: AccountingStrings.reversalDateLabel,
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                child: Text(
                  _selectedDate != null
                      ? _JournalDetailView._formatDate(_selectedDate!)
                      : 'Select date',
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              key: const Key('reversal_memo_field'),
              controller: _memoController,
              decoration: const InputDecoration(
                labelText: AccountingStrings.reversalMemoLabel,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          key: const Key('reversal_cancel_button'),
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(AccountingStrings.cancel),
        ),
        TextButton(
          key: const Key('reversal_confirm_button'),
          onPressed: () {
            final memo = _memoController.text.trim();
            Navigator.of(context).pop(
              _ReverseDialogResult(
                entryDate: _selectedDate,
                memo: memo.isEmpty ? null : memo,
              ),
            );
          },
          child: const Text(AccountingStrings.confirm),
        ),
      ],
    );
  }
}
