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
import '../../domain/entities/journal.dart';
import '../accounting_strings.dart';
import '../cubit/journals_cubit.dart';

class JournalsListScreen extends StatelessWidget {
  const JournalsListScreen({
    super.key,
    this.cubit,
    this.initialPaymentId,
  });

  final JournalsCubit? cubit;
  final String? initialPaymentId;

  @override
  Widget build(BuildContext context) {
    if (cubit != null) {
      if (cubit!.state.status == LoadStatus.initial) {
        cubit!.load(paymentId: initialPaymentId);
      }
      return BlocProvider<JournalsCubit>.value(
        value: cubit!,
        child: _JournalsListBody(initialPaymentId: initialPaymentId),
      );
    }
    return BlocProvider<JournalsCubit>(
      create: (_) => getIt<JournalsCubit>()..load(paymentId: initialPaymentId),
      child: _JournalsListBody(initialPaymentId: initialPaymentId),
    );
  }
}

class _JournalsListBody extends StatefulWidget {
  const _JournalsListBody({this.initialPaymentId});

  final String? initialPaymentId;

  @override
  State<_JournalsListBody> createState() => _JournalsListBodyState();
}

class _JournalsListBodyState extends State<_JournalsListBody> {
  static const List<String> _sourceTypes = [
    'manual',
    'sales_invoice',
    'sales_receipt',
    'opening_balance',
    'bill',
    'expense',
    'payment_voucher',
  ];

  static String _formatDate(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  Future<void> _pickDateRange(BuildContext context, JournalsState state) async {
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
      context.read<JournalsCubit>().filterByDateRange(picked.start, picked.end);
    }
  }

  @override
  Widget build(BuildContext context) {
    final canWrite = context.can('accounting.journals_write');

    return Scaffold(
      appBar: AppBar(
        title: const Text(AccountingStrings.journalsTitle),
        actions: [
          IconButton(
            tooltip: AccountingStrings.refresh,
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<JournalsCubit>().load(),
          ),
          if (canWrite)
            IconButton(
              key: const Key('appbar_create_journal_button'),
              tooltip: AccountingStrings.createJournalTitle,
              icon: const Icon(Icons.add),
              onPressed: () =>
                  context.push(Routes.adminAccountingJournalsCreate),
            ),
        ],
      ),
      floatingActionButton: canWrite
          ? FloatingActionButton.extended(
              key: const Key('create_journal_button'),
              onPressed: () =>
                  context.push(Routes.adminAccountingJournalsCreate),
              icon: const Icon(Icons.add),
              label: const Text(AccountingStrings.createJournalTitle),
            )
          : null,
      body: BlocConsumer<JournalsCubit, JournalsState>(
        listenWhen: (previous, next) =>
            next.status == LoadStatus.failure &&
            next.failure != previous.failure &&
            next.journals.isNotEmpty,
        listener: (context, state) {
          final failure = state.failure;
          if (failure == null) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(failureMessage(failure))),
          );
        },
        builder: (context, state) {
          final activePaymentId = state.paymentId ??
              (state.status == LoadStatus.initial ? widget.initialPaymentId : null);

          final hasActiveFilters = state.fromDate != null ||
              state.toDate != null ||
              (state.sourceType != null && state.sourceType!.isNotEmpty) ||
              (activePaymentId != null && activePaymentId.isNotEmpty);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Filters Section
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
                                    .read<JournalsCubit>()
                                    .filterByDateRange(null, null)
                                : null,
                          ),
                          if (activePaymentId != null &&
                              activePaymentId.isNotEmpty) ...[
                            const SizedBox(width: 8),
                            InputChip(
                              key: const Key('payment_id_filter_chip'),
                              avatar: const Icon(Icons.payment, size: 16),
                              label: Text(
                                  '${AccountingStrings.filterByPaymentId}: $activePaymentId'),
                              onDeleted: () => context
                                  .read<JournalsCubit>()
                                  .filterByPaymentId(null),
                            ),
                          ],
                          if (hasActiveFilters) ...[
                            const SizedBox(width: 8),
                            ActionChip(
                              key: const Key('clear_filters_button'),
                              avatar: const Icon(Icons.clear, size: 16),
                              label:
                                  const Text(AccountingStrings.clearFilter),
                              onPressed: () => context
                                  .read<JournalsCubit>()
                                  .clearFilters(),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          FilterChip(
                            key: const Key('source_chip_all'),
                            label: const Text('All'),
                            selected: state.sourceType == null ||
                                state.sourceType!.isEmpty,
                            onSelected: (_) => context
                                .read<JournalsCubit>()
                                .filterBySourceType(null),
                          ),
                          for (final type in _sourceTypes) ...[
                            const SizedBox(width: 8),
                            FilterChip(
                              key: Key('source_chip_$type'),
                              label: Text(type),
                              selected: state.sourceType == type,
                              onSelected: (_) => context
                                  .read<JournalsCubit>()
                                  .filterBySourceType(type),
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

  Widget _buildListArea(
    BuildContext context,
    JournalsState state,
  ) {
    if (state.status == LoadStatus.loading && state.journals.isEmpty) {
      return const AppLoading();
    }

    if (state.status == LoadStatus.failure && state.journals.isEmpty) {
      return AppErrorView(
        message: state.failure == null
            ? ''
            : failureMessage(state.failure!),
        onRetry: () => context.read<JournalsCubit>().load(),
      );
    }

    if (state.journals.isEmpty) {
      return RefreshIndicator(
        onRefresh: () => context.read<JournalsCubit>().load(),
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
      onRefresh: () => context.read<JournalsCubit>().load(),
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 80, top: 4),
        itemCount: state.journals.length,
        itemBuilder: (context, index) {
          final journal = state.journals[index];
          return _JournalCard(journal: journal);
        },
      ),
    );
  }
}

class _JournalCard extends StatelessWidget {
  const _JournalCard({required this.journal});

  final Journal journal;

  static Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'posted':
        return Colors.green;
      case 'draft':
        return Colors.amber;
      case 'reversed':
        return Colors.purple;
      case 'void':
        return Colors.grey;
      default:
        return Colors.blueGrey;
    }
  }

  static Color _sourceColor(String? sourceType) {
    switch (sourceType?.toLowerCase()) {
      case 'manual':
        return Colors.blue;
      case 'opening_balance':
        return Colors.teal;
      case 'sales_invoice':
        return Colors.indigo;
      case 'sales_receipt':
        return Colors.cyan;
      case 'bill':
        return Colors.orange;
      case 'expense':
        return Colors.deepOrange;
      case 'payment_voucher':
        return Colors.deepPurple;
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
    final isReversed = journal.status.toLowerCase() == 'reversed' ||
        (journal.reversesJournalId != null &&
            journal.reversesJournalId!.isNotEmpty);

    double totalDebit = 0;
    for (final line in journal.lines) {
      totalDebit += double.tryParse(line.debit) ?? 0.0;
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.push(
          Routes.adminAccountingJournalById(journal.id),
          extra: journal,
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
                          journal.journalNumber,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'monospace',
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatDate(journal.entryDate),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (totalDebit > 0)
                        Text(
                          AccountingStrings.formatAmount(totalDebit),
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      Text(
                        '${journal.lines.length} line${journal.lines.length == 1 ? '' : 's'}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 4,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  AppStatusChip(
                    label: journal.status,
                    color: _statusColor(journal.status),
                  ),
                  if (journal.sourceType != null &&
                      journal.sourceType!.isNotEmpty)
                    AppStatusChip(
                      label: journal.sourceType!,
                      color: _sourceColor(journal.sourceType),
                    ),
                  if (isReversed)
                    const AppStatusChip(
                      icon: Icons.undo,
                      label: AccountingStrings.statusReversed,
                      color: Colors.red,
                    ),
                  if (journal.isOpening)
                    const AppStatusChip(
                      icon: Icons.start,
                      label: AccountingStrings.openingBadge,
                      color: Colors.teal,
                    ),
                  if (journal.isClosing)
                    const AppStatusChip(
                      icon: Icons.lock_clock,
                      label: AccountingStrings.closingBadge,
                      color: Colors.deepPurple,
                    ),
                ],
              ),
              if (journal.memo != null && journal.memo!.trim().isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  journal.memo!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
