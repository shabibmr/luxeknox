import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:go_router/go_router.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/widgets/app_empty_view.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../../core/widgets/app_status_chip.dart';
import '../../domain/entities/account.dart';
import '../../domain/entities/accounting_period.dart';
import '../../domain/entities/accounting_reports.dart';
import '../accounting_strings.dart';
import '../cubit/accounting_home_cubit.dart';

class AccountingHomeScreen extends StatelessWidget {
  const AccountingHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AccountingHomeCubit>()..load(),
      child: const _AccountingHomeBody(),
    );
  }
}

class _AccountingHomeBody extends StatelessWidget {
  const _AccountingHomeBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AccountingStrings.homeTitle),
        actions: [
          IconButton(
            tooltip: AccountingStrings.refresh,
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<AccountingHomeCubit>().load(),
          ),
        ],
      ),
      body: BlocConsumer<AccountingHomeCubit, AccountingHomeState>(
        listenWhen: (previous, next) =>
            next.status == LoadStatus.failure &&
            next.failure != previous.failure &&
            (next.openAr != null ||
                next.openAp != null ||
                next.bankAndCashAccounts.isNotEmpty ||
                next.currentPeriod != null),
        listener: (context, state) {
          final failure = state.failure;
          if (failure == null) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(failureMessage(failure))),
          );
        },
        builder: (context, state) {
          final hasData = state.openAr != null ||
              state.openAp != null ||
              state.bankAndCashAccounts.isNotEmpty ||
              state.currentPeriod != null;

          if (state.status == LoadStatus.loading && !hasData) {
            return const AppLoading();
          }

          if (state.status == LoadStatus.failure && !hasData) {
            return AppErrorView(
              message: state.failure == null
                  ? ''
                  : failureMessage(state.failure!),
              onRetry: () => context.read<AccountingHomeCubit>().load(),
            );
          }

          if (!hasData) {
            return const AppEmptyView(message: AccountingStrings.noneFound);
          }

          return RefreshIndicator(
            onRefresh: () => context.read<AccountingHomeCubit>().load(),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              children: [
                _CurrentPeriodSection(period: state.currentPeriod),
                const SizedBox(height: 16),
                _OpenItemsSummarySection(
                  openAr: state.openAr,
                  openAp: state.openAp,
                ),
                const SizedBox(height: 16),
                _BankAndCashSection(accounts: state.bankAndCashAccounts),
                const SizedBox(height: 16),
                const _QuickActionsSection(),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _CurrentPeriodSection extends StatelessWidget {
  const _CurrentPeriodSection({this.period});

  final AccountingPeriod? period;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentPeriod = period;
    final draftCounts = currentPeriod?.draftCounts;
    final hasDraftDocuments = draftCounts != null &&
        (draftCounts.billsCount > 0 ||
            draftCounts.expensesCount > 0 ||
            draftCounts.paymentVouchersCount > 0 ||
            draftCounts.debitNotesCount > 0);

    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AccountingStrings.currentPeriod,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                if (currentPeriod != null)
                  AppStatusChip(
                    label: currentPeriod.isLocked
                        ? AccountingStrings.periodLockedBadge
                        : AccountingStrings.periodOpenBadge,
                    color: currentPeriod.isLocked
                        ? theme.colorScheme.error
                        : Colors.green,
                  ),
              ],
            ),
            const SizedBox(height: 8),
            if (currentPeriod == null)
              Text(
                AccountingStrings.noPeriodActive,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.outline,
                ),
              )
            else ...[
              Text(
                currentPeriod.name,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${currentPeriod.startDate.toIso8601String().substring(0, 10)} '
                '– ${currentPeriod.endDate.toIso8601String().substring(0, 10)}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              if (hasDraftDocuments) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.amber.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.warning_amber_rounded,
                        color: Colors.amber,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          AccountingStrings.draftDocumentsWarning,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

class _OpenItemsSummarySection extends StatelessWidget {
  const _OpenItemsSummarySection({this.openAr, this.openAp});

  final OpenItemsReport? openAr;
  final OpenItemsReport? openAp;

  @override
  Widget build(BuildContext context) {
    final ar = openAr;
    final ap = openAp;

    return Row(
      children: [
        Expanded(
          child: _MetricCard(
            title: AccountingStrings.openReceivables,
            amount: ar != null
                ? AccountingStrings.formatMoney(ar.totalOpenAmount)
                : '\$0.00',
            subtitle: ar != null
                ? AccountingStrings.openItemsCount(ar.items.length)
                : '0 items',
            color: Colors.teal,
            icon: Icons.call_received,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _MetricCard(
            title: AccountingStrings.openPayables,
            amount: ap != null
                ? AccountingStrings.formatMoney(ap.totalOpenAmount)
                : '\$0.00',
            subtitle: ap != null
                ? AccountingStrings.openItemsCount(ap.items.length)
                : '0 items',
            color: Colors.deepOrange,
            icon: Icons.call_made,
          ),
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.title,
    required this.amount,
    required this.subtitle,
    required this.color,
    required this.icon,
  });

  final String title;
  final String amount;
  final String subtitle;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                Icon(icon, size: 18, color: color),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              amount,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BankAndCashSection extends StatelessWidget {
  const _BankAndCashSection({required this.accounts});

  final List<Account> accounts;

  bool _isCash(Account account) {
    return account.name.toLowerCase().contains('cash') || account.code == '1000';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AccountingStrings.cashAndBank,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        if (accounts.isEmpty)
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: theme.colorScheme.outlineVariant),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                AccountingStrings.noBankAccounts,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.outline,
                ),
              ),
            ),
          )
        else
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: theme.colorScheme.outlineVariant),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: accounts.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final account = accounts[index];
                final isCash = _isCash(account);
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor:
                        theme.colorScheme.primaryContainer,
                    child: Icon(
                      isCash ? Icons.payments_outlined : Icons.account_balance,
                      color: theme.colorScheme.onPrimaryContainer,
                      size: 20,
                    ),
                  ),
                  title: Text(account.name),
                  subtitle: Text(account.code),
                  trailing: AppStatusChip(
                    label: account.isActive
                        ? AccountingStrings.activeBadge
                        : AccountingStrings.inactiveBadge,
                    color: account.isActive ? Colors.green : Colors.grey,
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}

class _QuickActionsSection extends StatelessWidget {
  const _QuickActionsSection();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AccountingStrings.quickActions,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ActionChip(
              avatar: const Icon(Icons.account_tree_outlined, size: 18),
              label: const Text(AccountingStrings.viewAllAccounts),
              onPressed: () => context.go(Routes.adminAccountingAccounts),
            ),
            ActionChip(
              avatar: const Icon(Icons.receipt_long_outlined, size: 18),
              label: const Text(AccountingStrings.viewAllJournals),
              onPressed: () {},
            ),
            ActionChip(
              avatar: const Icon(Icons.bar_chart_outlined, size: 18),
              label: const Text(AccountingStrings.viewReports),
              onPressed: () {},
            ),
            ActionChip(
              avatar: const Icon(Icons.calendar_month_outlined, size: 18),
              label: const Text(AccountingStrings.managePeriods),
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }
}
