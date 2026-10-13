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
import '../../domain/entities/account.dart';
import '../accounting_strings.dart';
import '../cubit/accounts_cubit.dart';

class ChartOfAccountsScreen extends StatelessWidget {
  const ChartOfAccountsScreen({super.key, this.cubit});

  final AccountsCubit? cubit;

  @override
  Widget build(BuildContext context) {
    if (cubit != null) {
      if (cubit!.state.status == LoadStatus.initial) {
        cubit!.load();
      }
      return BlocProvider<AccountsCubit>.value(
        value: cubit!,
        child: const _ChartOfAccountsBody(),
      );
    }
    return BlocProvider<AccountsCubit>(
      create: (_) => getIt<AccountsCubit>()..load(),
      child: const _ChartOfAccountsBody(),
    );
  }
}

class _ChartOfAccountsBody extends StatefulWidget {
  const _ChartOfAccountsBody();

  @override
  State<_ChartOfAccountsBody> createState() => _ChartOfAccountsBodyState();
}

class _ChartOfAccountsBodyState extends State<_ChartOfAccountsBody> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    final query = value.trim().isEmpty ? null : value.trim();
    context.read<AccountsCubit>().setSearch(query);
  }

  @override
  Widget build(BuildContext context) {
    final canWrite = context.can('accounting.accounts_write');

    return Scaffold(
      appBar: AppBar(
        title: const Text(AccountingStrings.accountsTitle),
        actions: [
          IconButton(
            tooltip: AccountingStrings.refresh,
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<AccountsCubit>().load(),
          ),
          if (canWrite)
            IconButton(
              key: const Key('appbar_create_account_button'),
              tooltip: AccountingStrings.createAccountTitle,
              icon: const Icon(Icons.add),
              onPressed: () =>
                  context.push(Routes.adminAccountingAccountsCreate),
            ),
        ],
      ),
      floatingActionButton: canWrite
          ? FloatingActionButton.extended(
              key: const Key('create_account_button'),
              onPressed: () =>
                  context.push(Routes.adminAccountingAccountsCreate),
              icon: const Icon(Icons.add),
              label: const Text(AccountingStrings.createAccountTitle),
            )
          : null,
      body: BlocConsumer<AccountsCubit, AccountsState>(
        listenWhen: (previous, next) =>
            next.status == LoadStatus.failure &&
            next.failure != previous.failure &&
            next.accounts.isNotEmpty,
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
              // Search bar
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: TextField(
                  key: const Key('search_accounts_field'),
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: AccountingStrings.searchAccounts,
                    prefixIcon: const Icon(Icons.search),
                    isDense: true,
                    border: const OutlineInputBorder(),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 20),
                            onPressed: () {
                              _searchController.clear();
                              context.read<AccountsCubit>().setSearch(null);
                            },
                          )
                        : null,
                  ),
                  onChanged: _onSearchChanged,
                ),
              ),
              // Account Type Filter Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    FilterChip(
                      key: const Key('type_chip_all'),
                      label: const Text('All'),
                      selected: state.accountType == null,
                      onSelected: (_) =>
                          context.read<AccountsCubit>().filterByType(null),
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      key: const Key('type_chip_asset'),
                      label: const Text(AccountingStrings.accountTypeAsset),
                      selected: state.accountType?.toLowerCase() == 'asset',
                      onSelected: (_) =>
                          context.read<AccountsCubit>().filterByType('asset'),
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      key: const Key('type_chip_liability'),
                      label: const Text(AccountingStrings.accountTypeLiability),
                      selected: state.accountType?.toLowerCase() == 'liability',
                      onSelected: (_) =>
                          context.read<AccountsCubit>().filterByType('liability'),
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      key: const Key('type_chip_equity'),
                      label: const Text(AccountingStrings.accountTypeEquity),
                      selected: state.accountType?.toLowerCase() == 'equity',
                      onSelected: (_) =>
                          context.read<AccountsCubit>().filterByType('equity'),
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      key: const Key('type_chip_income'),
                      label: const Text(AccountingStrings.accountTypeIncome),
                      selected: state.accountType?.toLowerCase() == 'income',
                      onSelected: (_) =>
                          context.read<AccountsCubit>().filterByType('income'),
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      key: const Key('type_chip_expense'),
                      label: const Text(AccountingStrings.accountTypeExpense),
                      selected: state.accountType?.toLowerCase() == 'expense',
                      onSelected: (_) =>
                          context.read<AccountsCubit>().filterByType('expense'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              // Status Filter Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    FilterChip(
                      key: const Key('status_chip_all'),
                      label: const Text('All'),
                      selected: state.isActive == null,
                      onSelected: (_) =>
                          context.read<AccountsCubit>().filterByActive(null),
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      key: const Key('status_chip_active'),
                      label: const Text(AccountingStrings.activeBadge),
                      selected: state.isActive == true,
                      onSelected: (_) =>
                          context.read<AccountsCubit>().filterByActive(true),
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      key: const Key('status_chip_inactive'),
                      label: const Text(AccountingStrings.inactiveBadge),
                      selected: state.isActive == false,
                      onSelected: (_) =>
                          context.read<AccountsCubit>().filterByActive(false),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              // Account List Area
              Expanded(
                child: _buildListArea(context, state, canWrite),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildListArea(
    BuildContext context,
    AccountsState state,
    bool canWrite,
  ) {
    if (state.status == LoadStatus.loading && state.accounts.isEmpty) {
      return const AppLoading();
    }

    if (state.status == LoadStatus.failure && state.accounts.isEmpty) {
      return AppErrorView(
        message: state.failure == null
            ? ''
            : failureMessage(state.failure!),
        onRetry: () => context.read<AccountsCubit>().load(),
      );
    }

    if (state.accounts.isEmpty) {
      return RefreshIndicator(
        onRefresh: () => context.read<AccountsCubit>().load(),
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
      onRefresh: () => context.read<AccountsCubit>().load(),
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 80, top: 4),
        itemCount: state.accounts.length,
        itemBuilder: (context, index) {
          final account = state.accounts[index];
          return _AccountCard(
            account: account,
            canWrite: canWrite,
          );
        },
      ),
    );
  }
}

class _AccountCard extends StatelessWidget {
  const _AccountCard({
    required this.account,
    required this.canWrite,
  });

  final Account account;
  final bool canWrite;

  static Color _typeColor(String type) {
    switch (type.toLowerCase()) {
      case 'asset':
        return Colors.blue;
      case 'liability':
        return Colors.orange;
      case 'equity':
        return Colors.purple;
      case 'income':
        return Colors.teal;
      case 'expense':
        return Colors.red;
      default:
        return Colors.blueGrey;
    }
  }

  static String _formatType(String type) {
    if (type.isEmpty) return type;
    return type[0].toUpperCase() + type.substring(1).toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        title: Row(
          children: [
            Text(
              account.code,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'monospace',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                account.name,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 6,
                runSpacing: 4,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  AppStatusChip(
                    label: _formatType(account.type),
                    color: _typeColor(account.type),
                  ),
                  if (account.isBank)
                    const AppStatusChip(
                      icon: Icons.account_balance,
                      label: 'Bank',
                      color: Colors.teal,
                    ),
                  if (account.isControl) ...[
                    const AppStatusChip(
                      icon: Icons.lock_outline,
                      label: 'Control',
                      color: Colors.deepPurple,
                    ),
                    if (account.description != null &&
                        account.description!.isNotEmpty)
                      AppStatusChip(
                        label: account.description!,
                        color: Colors.purple,
                      ),
                  ],
                  AppStatusChip(
                    label: account.isActive
                        ? AccountingStrings.activeBadge
                        : AccountingStrings.inactiveBadge,
                    color: account.isActive ? Colors.green : Colors.grey,
                  ),
                ],
              ),
              if (account.description != null &&
                  account.description!.isNotEmpty &&
                  !account.isControl) ...[
                const SizedBox(height: 4),
                Text(
                  account.description!,
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ],
          ),
        ),
        trailing: canWrite ? const Icon(Icons.chevron_right) : null,
        onTap: canWrite
            ? () =>
                context.push(Routes.adminAccountingAccountEditById(account.id))
            : null,
      ),
    );
  }
}
