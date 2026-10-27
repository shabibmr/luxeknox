import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/widgets/app_currency_text.dart';
import '../../../../core/widgets/app_empty_view.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../domain/entities/accounting_reports.dart';
import '../accounting_strings.dart';
import '../cubit/accounting_reports_cubit.dart';

class AccountingReportsScreen extends StatelessWidget {
  const AccountingReportsScreen({super.key, this.cubit});

  final AccountingReportsCubit? cubit;

  @override
  Widget build(BuildContext context) {
    if (cubit != null) {
      if (cubit!.state.status == LoadStatus.initial) {
        cubit!.load();
      }
      return BlocProvider<AccountingReportsCubit>.value(
        value: cubit!,
        child: const _AccountingReportsBody(),
      );
    }
    return BlocProvider<AccountingReportsCubit>(
      create: (_) => getIt<AccountingReportsCubit>()..load(),
      child: const _AccountingReportsBody(),
    );
  }
}

class _AccountingReportsBody extends StatelessWidget {
  const _AccountingReportsBody();

  static String _formatDate(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  static bool _usesDateRange(AccountingReportType type) {
    return type == AccountingReportType.trialBalance ||
        type == AccountingReportType.profitAndLoss ||
        type == AccountingReportType.gstSummary;
  }

  static String _titleFor(AccountingReportType type) {
    switch (type) {
      case AccountingReportType.trialBalance:
        return AccountingStrings.trialBalanceTitle;
      case AccountingReportType.profitAndLoss:
        return AccountingStrings.profitAndLossTitle;
      case AccountingReportType.balanceSheet:
        return AccountingStrings.balanceSheetTitle;
      case AccountingReportType.dayBook:
        return AccountingStrings.dayBookTitle;
      case AccountingReportType.gstSummary:
        return AccountingStrings.gstSummaryTitle;
    }
  }

  static bool _hasLoadedReport(AccountingReportsState state) {
    switch (state.selectedReportType) {
      case AccountingReportType.trialBalance:
        return state.trialBalance != null;
      case AccountingReportType.profitAndLoss:
        return state.profitAndLoss != null;
      case AccountingReportType.balanceSheet:
        return state.balanceSheet != null;
      case AccountingReportType.dayBook:
        return state.dayBook != null;
      case AccountingReportType.gstSummary:
        return state.gstSummary != null;
    }
  }

  static bool _hasReportRows(AccountingReportsState state) {
    switch (state.selectedReportType) {
      case AccountingReportType.trialBalance:
        return state.trialBalance?.accounts.isNotEmpty ?? false;
      case AccountingReportType.profitAndLoss:
        final report = state.profitAndLoss;
        if (report == null) return false;
        return report.incomeAccounts.isNotEmpty ||
            report.expenseAccounts.isNotEmpty;
      case AccountingReportType.balanceSheet:
        final report = state.balanceSheet;
        if (report == null) return false;
        return report.assetAccounts.isNotEmpty ||
            report.liabilityAccounts.isNotEmpty ||
            report.equityAccounts.isNotEmpty;
      case AccountingReportType.dayBook:
        return state.dayBook?.journals.isNotEmpty ?? false;
      case AccountingReportType.gstSummary:
        return state.gstSummary?.codeSummaries.isNotEmpty ?? false;
    }
  }

  Future<void> _pickDateRange(
    BuildContext context,
    AccountingReportsState state,
  ) async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDateRange: DateTimeRange(
        start: state.fromDate ?? DateTime(now.year, 1, 1),
        end: state.toDate ?? now,
      ),
    );
    if (!context.mounted || picked == null) return;
    await context.read<AccountingReportsCubit>().setDateRange(
      from: picked.start,
      to: picked.end,
    );
  }

  Future<void> _pickSingleDate(
    BuildContext context,
    AccountingReportsState state, {
    required String helpText,
  }) async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDate: state.toDate ?? DateTime.now(),
      helpText: helpText,
    );
    if (!context.mounted || picked == null) return;
    await context.read<AccountingReportsCubit>().setDateRange(
      from: state.fromDate,
      to: picked,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AccountingStrings.reportsTitle),
        actions: [
          IconButton(
            tooltip: AccountingStrings.refresh,
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<AccountingReportsCubit>().load(),
          ),
        ],
      ),
      body: BlocConsumer<AccountingReportsCubit, AccountingReportsState>(
        listenWhen: (previous, next) =>
            next.status == LoadStatus.failure &&
            next.failure != previous.failure &&
            _hasLoadedReport(next),
        listener: (context, state) {
          final failure = state.failure;
          if (failure == null) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(failureMessage(failure))),
          );
        },
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _ReportTypeChips(state: state),
              _DateControls(
                state: state,
                usesDateRange: _usesDateRange(state.selectedReportType),
                formatDate: _formatDate,
                onPickRange: () => _pickDateRange(context, state),
                onPickSingle: () => _pickSingleDate(
                  context,
                  state,
                  helpText: state.selectedReportType ==
                          AccountingReportType.balanceSheet
                      ? AccountingStrings.asOfDateLabel
                      : AccountingStrings.dateLabel,
                ),
              ),
              Expanded(child: _ReportBody(state: state)),
            ],
          );
        },
      ),
    );
  }
}

class _ReportTypeChips extends StatelessWidget {
  const _ReportTypeChips({required this.state});

  final AccountingReportsState state;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Row(
        children: [
          for (final type in AccountingReportType.values) ...[
            if (type != AccountingReportType.values.first)
              const SizedBox(width: 8),
            FilterChip(
              key: Key('report_type_chip_${type.name}'),
              label: Text(_AccountingReportsBody._titleFor(type)),
              selected: state.selectedReportType == type,
              onSelected: (_) => context
                  .read<AccountingReportsCubit>()
                  .selectReportType(type),
            ),
          ],
        ],
      ),
    );
  }
}

class _DateControls extends StatelessWidget {
  const _DateControls({
    required this.state,
    required this.usesDateRange,
    required this.formatDate,
    required this.onPickRange,
    required this.onPickSingle,
  });

  final AccountingReportsState state;
  final bool usesDateRange;
  final String Function(DateTime) formatDate;
  final VoidCallback onPickRange;
  final VoidCallback onPickSingle;

  @override
  Widget build(BuildContext context) {
    final to = state.toDate ?? DateTime.now();
    final from = state.fromDate ?? DateTime(to.year, 1, 1);

    final label = usesDateRange
        ? '${formatDate(from)} - ${formatDate(to)}'
        : state.selectedReportType == AccountingReportType.balanceSheet
            ? '${AccountingStrings.asOfDateLabel}: ${formatDate(to)}'
            : '${AccountingStrings.dateLabel}: ${formatDate(to)}';

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          InputChip(
            key: const Key('report_date_filter_chip'),
            avatar: const Icon(Icons.calendar_today, size: 16),
            label: Text(label),
            selected: true,
            onPressed: usesDateRange ? onPickRange : onPickSingle,
          ),
          FilledButton.tonalIcon(
            key: const Key('generate_report_button'),
            onPressed: () => context.read<AccountingReportsCubit>().load(),
            icon: const Icon(Icons.play_arrow, size: 18),
            label: const Text(AccountingStrings.generateReport),
          ),
        ],
      ),
    );
  }
}

class _ReportBody extends StatelessWidget {
  const _ReportBody({required this.state});

  final AccountingReportsState state;

  @override
  Widget build(BuildContext context) {
    final hasLoadedReport = _AccountingReportsBody._hasLoadedReport(state);
    final hasRows = _AccountingReportsBody._hasReportRows(state);

    if (state.status == LoadStatus.loading && !hasLoadedReport) {
      return const AppLoading();
    }

    if (state.status == LoadStatus.failure && !hasLoadedReport) {
      return AppErrorView(
        message: state.failure == null ? '' : failureMessage(state.failure!),
        onRetry: () => context.read<AccountingReportsCubit>().load(),
      );
    }

    if (state.status == LoadStatus.initial && !hasLoadedReport) {
      return const AppLoading();
    }

    if (!hasLoadedReport) {
      return const AppEmptyView(message: AccountingStrings.noReportData);
    }

    return RefreshIndicator(
      onRefresh: () => context.read<AccountingReportsCubit>().load(),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        children: [
          Text(
            _AccountingReportsBody._titleFor(state.selectedReportType),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          _ReportTotalsCard(state: state),
          const SizedBox(height: 16),
          if (!hasRows)
            const AppEmptyView(message: AccountingStrings.noReportData)
          else
            _ReportDetail(state: state),
        ],
      ),
    );
  }
}

class _ReportDetail extends StatelessWidget {
  const _ReportDetail({required this.state});

  final AccountingReportsState state;

  @override
  Widget build(BuildContext context) {
    switch (state.selectedReportType) {
      case AccountingReportType.trialBalance:
        return _TrialBalanceTable(report: state.trialBalance!);
      case AccountingReportType.profitAndLoss:
        return _ProfitAndLossTable(report: state.profitAndLoss!);
      case AccountingReportType.balanceSheet:
        return _BalanceSheetTable(report: state.balanceSheet!);
      case AccountingReportType.dayBook:
        return _DayBookList(report: state.dayBook!);
      case AccountingReportType.gstSummary:
        return _GstSummaryTable(report: state.gstSummary!);
    }
  }
}

class _ReportTotalsCard extends StatelessWidget {
  const _ReportTotalsCard({required this.state});

  final AccountingReportsState state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final rows = _rowsFor(state);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AccountingStrings.reportTotalsTitle,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            for (var i = 0; i < rows.length; i++) ...[
              if (i > 0) const SizedBox(height: 8),
              _TotalRow(label: rows[i].$1, value: rows[i].$2),
            ],
          ],
        ),
      ),
    );
  }

  List<(String, String)> _rowsFor(AccountingReportsState state) {
    switch (state.selectedReportType) {
      case AccountingReportType.trialBalance:
        final report = state.trialBalance;
        if (report == null) return const [];
        return [
          (AccountingStrings.totalDebit, report.totalDebit),
          (AccountingStrings.totalCredit, report.totalCredit),
        ];
      case AccountingReportType.profitAndLoss:
        final report = state.profitAndLoss;
        if (report == null) return const [];
        return [
          (AccountingStrings.totalIncome, report.totalIncome),
          (AccountingStrings.totalExpense, report.totalExpense),
          (AccountingStrings.netProfit, report.netProfit),
        ];
      case AccountingReportType.balanceSheet:
        final report = state.balanceSheet;
        if (report == null) return const [];
        return [
          (AccountingStrings.totalAssets, report.totalAssets),
          (AccountingStrings.totalLiabilities, report.totalLiabilities),
          (AccountingStrings.currentYearEarnings, report.currentYearEarnings),
          (AccountingStrings.totalEquity, report.totalEquity),
          (
            AccountingStrings.totalLiabilitiesAndEquity,
            report.totalLiabilitiesAndEquity,
          ),
        ];
      case AccountingReportType.dayBook:
        final report = state.dayBook;
        if (report == null) return const [];
        return [
          (AccountingStrings.totalDebit, report.totalDebit),
          (AccountingStrings.totalCredit, report.totalCredit),
        ];
      case AccountingReportType.gstSummary:
        final report = state.gstSummary;
        if (report == null) return const [];
        return [
          (AccountingStrings.taxableValue, report.totalTaxableValue),
          (AccountingStrings.outputCgst, report.outputCgst),
          (AccountingStrings.outputSgst, report.outputSgst),
          (AccountingStrings.outputIgst, report.outputIgst),
          (AccountingStrings.outputTax, report.totalOutputTax),
          (AccountingStrings.inputTax, report.totalInputTax),
          (AccountingStrings.netGstPayable, report.netTaxPayable),
        ];
    }
  }
}

class _TotalRow extends StatelessWidget {
  const _TotalRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: Text(label, style: theme.textTheme.bodyMedium),
        ),
        AppCurrencyText(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _MoneyText extends StatelessWidget {
  const _MoneyText(this.value, {this.bold = false});

  final String value;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodyMedium;
    return AppCurrencyText(
      value,
      textAlign: TextAlign.end,
      style: bold ? style?.copyWith(fontWeight: FontWeight.w700) : style,
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}

class _AccountAmountHeader extends StatelessWidget {
  const _AccountAmountHeader();

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w600,
        );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(AccountingStrings.nameLabel, style: style)),
          SizedBox(
            width: 104,
            child: Text(
              AccountingStrings.amountLabel,
              textAlign: TextAlign.end,
              style: style,
            ),
          ),
        ],
      ),
    );
  }
}

class _AccountAmountRow extends StatelessWidget {
  const _AccountAmountRow({
    required this.name,
    required this.amount,
    this.bold = false,
  });

  final String name;
  final String amount;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontWeight: bold ? FontWeight.w700 : FontWeight.normal,
        );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Text(name, style: style)),
          SizedBox(
            width: 104,
            child: _MoneyText(amount, bold: bold),
          ),
        ],
      ),
    );
  }
}

class _TrialBalanceTable extends StatelessWidget {
  const _TrialBalanceTable({required this.report});

  final TrialBalanceReport report;

  @override
  Widget build(BuildContext context) {
    final headerStyle = Theme.of(context).textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w600,
        );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Expanded(
                    child: Text(AccountingStrings.nameLabel, style: headerStyle),
                  ),
                  SizedBox(
                    width: 96,
                    child: Text(
                      AccountingStrings.debitLabel,
                      textAlign: TextAlign.end,
                      style: headerStyle,
                    ),
                  ),
                  SizedBox(
                    width: 96,
                    child: Text(
                      AccountingStrings.creditLabel,
                      textAlign: TextAlign.end,
                      style: headerStyle,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            for (final account in report.accounts)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: Text(account.accountName)),
                    SizedBox(
                      width: 96,
                      child: _MoneyText(account.debit),
                    ),
                    SizedBox(
                      width: 96,
                      child: _MoneyText(account.credit),
                    ),
                  ],
                ),
              ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      AccountingStrings.reportTotalsTitle,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ),
                  SizedBox(
                    width: 96,
                    child: _MoneyText(report.totalDebit, bold: true),
                  ),
                  SizedBox(
                    width: 96,
                    child: _MoneyText(report.totalCredit, bold: true),
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

class _ProfitAndLossTable extends StatelessWidget {
  const _ProfitAndLossTable({required this.report});

  final ProfitAndLossReport report;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const _SectionTitle(AccountingStrings.incomeSectionTitle),
                const _AccountAmountHeader(),
                const Divider(height: 1),
                for (final account in report.incomeAccounts)
                  _AccountAmountRow(
                    name: account.accountName,
                    amount: account.amount,
                  ),
                const Divider(height: 1),
                _AccountAmountRow(
                  name: AccountingStrings.totalIncome,
                  amount: report.totalIncome,
                  bold: true,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const _SectionTitle(AccountingStrings.expenseSectionTitle),
                const _AccountAmountHeader(),
                const Divider(height: 1),
                for (final account in report.expenseAccounts)
                  _AccountAmountRow(
                    name: account.accountName,
                    amount: account.amount,
                  ),
                const Divider(height: 1),
                _AccountAmountRow(
                  name: AccountingStrings.totalExpense,
                  amount: report.totalExpense,
                  bold: true,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: _TotalRow(
              label: AccountingStrings.netProfit,
              value: report.netProfit,
            ),
          ),
        ),
      ],
    );
  }
}

class _BalanceSheetTable extends StatelessWidget {
  const _BalanceSheetTable({required this.report});

  final BalanceSheetReport report;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '${AccountingStrings.fiscalYearStartLabel}: '
          '${_AccountingReportsBody._formatDate(report.fiscalYearStart)}',
          style: theme.textTheme.bodySmall,
        ),
        const SizedBox(height: 8),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const _SectionTitle(AccountingStrings.assetsSectionTitle),
                const _AccountAmountHeader(),
                const Divider(height: 1),
                for (final account in report.assetAccounts)
                  _AccountAmountRow(
                    name: account.accountName,
                    amount: account.amount,
                  ),
                const Divider(height: 1),
                _AccountAmountRow(
                  name: AccountingStrings.totalAssets,
                  amount: report.totalAssets,
                  bold: true,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const _SectionTitle(AccountingStrings.liabilitiesSectionTitle),
                const _AccountAmountHeader(),
                const Divider(height: 1),
                for (final account in report.liabilityAccounts)
                  _AccountAmountRow(
                    name: account.accountName,
                    amount: account.amount,
                  ),
                const Divider(height: 1),
                _AccountAmountRow(
                  name: AccountingStrings.totalLiabilities,
                  amount: report.totalLiabilities,
                  bold: true,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const _SectionTitle(AccountingStrings.equitySectionTitle),
                const _AccountAmountHeader(),
                const Divider(height: 1),
                for (final account in report.equityAccounts)
                  _AccountAmountRow(
                    name: account.accountName,
                    amount: account.amount,
                  ),
                _AccountAmountRow(
                  name: AccountingStrings.currentYearEarnings,
                  amount: report.currentYearEarnings,
                ),
                const Divider(height: 1),
                _AccountAmountRow(
                  name: AccountingStrings.totalEquity,
                  amount: report.totalEquity,
                  bold: true,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: _TotalRow(
              label: AccountingStrings.totalLiabilitiesAndEquity,
              value: report.totalLiabilitiesAndEquity,
            ),
          ),
        ),
      ],
    );
  }
}

class _DayBookList extends StatelessWidget {
  const _DayBookList({required this.report});

  final DayBookReport report;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final journal in report.journals) ...[
          _DayBookJournalCard(journal: journal),
          const SizedBox(height: 8),
        ],
      ],
    );
  }
}

class _DayBookJournalCard extends StatelessWidget {
  const _DayBookJournalCard({required this.journal});

  final DayBookJournalItem journal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final headerStyle = theme.textTheme.labelMedium?.copyWith(
      fontWeight: FontWeight.w600,
    );

    return Card(
      child: InkWell(
        onTap: () => context.push(
          Routes.adminAccountingJournalById(journal.journalId),
        ),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      journal.journalNumber,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    _AccountingReportsBody._formatDate(journal.date),
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.chevron_right,
                    color: theme.colorScheme.outline,
                  ),
                ],
              ),
              if (journal.memo != null && journal.memo!.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(journal.memo!, style: theme.textTheme.bodySmall),
              ],
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text(AccountingStrings.nameLabel, style: headerStyle),
                  ),
                  SizedBox(
                    width: 88,
                    child: Text(
                      AccountingStrings.debitLabel,
                      textAlign: TextAlign.end,
                      style: headerStyle,
                    ),
                  ),
                  SizedBox(
                    width: 88,
                    child: Text(
                      AccountingStrings.creditLabel,
                      textAlign: TextAlign.end,
                      style: headerStyle,
                    ),
                  ),
                ],
              ),
              const Divider(height: 12),
              for (final line in journal.lines)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: Text(line.accountName)),
                      SizedBox(width: 88, child: _MoneyText(line.debit)),
                      SizedBox(width: 88, child: _MoneyText(line.credit)),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GstSummaryTable extends StatelessWidget {
  const _GstSummaryTable({required this.report});

  final GstSummaryReport report;

  @override
  Widget build(BuildContext context) {
    final headerStyle = Theme.of(context).textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w600,
        );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final summary in report.codeSummaries) ...[
              Text(
                summary.taxCodeName,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                '${AccountingStrings.ratePercentLabel}: ${summary.ratePercent}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      AccountingStrings.taxableValue,
                      style: headerStyle,
                    ),
                  ),
                  _MoneyText(summary.taxableValue),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Expanded(
                    child: Text(AccountingStrings.cgstLabel, style: headerStyle),
                  ),
                  _MoneyText(summary.cgstAmount),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Expanded(
                    child: Text(AccountingStrings.sgstLabel, style: headerStyle),
                  ),
                  _MoneyText(summary.sgstAmount),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Expanded(
                    child: Text(AccountingStrings.igstLabel, style: headerStyle),
                  ),
                  _MoneyText(summary.igstAmount),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      AccountingStrings.totalTaxLabel,
                      style: headerStyle,
                    ),
                  ),
                  _MoneyText(summary.totalTax, bold: true),
                ],
              ),
              const Divider(height: 24),
            ],
            _TotalRow(
              label: AccountingStrings.taxableValue,
              value: report.totalTaxableValue,
            ),
            const SizedBox(height: 8),
            _TotalRow(
              label: AccountingStrings.outputTax,
              value: report.totalOutputTax,
            ),
            const SizedBox(height: 8),
            _TotalRow(
              label: AccountingStrings.inputTax,
              value: report.totalInputTax,
            ),
            const SizedBox(height: 8),
            _TotalRow(
              label: AccountingStrings.netGstPayable,
              value: report.netTaxPayable,
            ),
          ],
        ),
      ),
    );
  }
}
