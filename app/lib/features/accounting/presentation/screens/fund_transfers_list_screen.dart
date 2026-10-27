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
import '../../domain/entities/fund_transfer.dart';
import '../../../../core/widgets/app_currency_text.dart';
import '../accounting_strings.dart';
import '../cubit/fund_transfers_cubit.dart';
import 'fund_transfer_detail_screen.dart';
import 'fund_transfer_form_screen.dart';

class FundTransfersListScreen extends StatelessWidget {
  const FundTransfersListScreen({
    super.key,
    this.cubit,
  });

  final FundTransfersCubit? cubit;

  @override
  Widget build(BuildContext context) {
    if (!context.can('accounting.read')) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(AccountingStrings.transfersTitle),
        ),
        body: const Center(
          child: Text(AccountingStrings.noPermission),
        ),
      );
    }

    if (cubit != null) {
      if (cubit!.state.status == LoadStatus.initial) {
        cubit!.load();
      }
      return BlocProvider<FundTransfersCubit>.value(
        value: cubit!,
        child: const _FundTransfersListView(),
      );
    }

    return BlocProvider<FundTransfersCubit>(
      create: (_) => getIt<FundTransfersCubit>()..load(),
      child: const _FundTransfersListView(),
    );
  }
}

class _FundTransfersListView extends StatefulWidget {
  const _FundTransfersListView();

  @override
  State<_FundTransfersListView> createState() => _FundTransfersListViewState();
}

class _FundTransfersListViewState extends State<_FundTransfersListView> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
        return Colors.orange;
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
      case 'draft':
        return AccountingStrings.statusDraft;
      case 'void':
        return AccountingStrings.statusVoid;
      default:
        if (status.isEmpty) return status;
        return status[0].toUpperCase() + status.substring(1).toLowerCase();
    }
  }

  void _openCreateTransfer(BuildContext context) async {
    final result = await Navigator.of(context).push<FundTransfer?>(
      MaterialPageRoute(
        builder: (_) => const FundTransferFormScreen(),
      ),
    );

    if (result != null && context.mounted) {
      context.read<FundTransfersCubit>().load();
    }
  }

  void _openDetail(BuildContext context, FundTransfer transfer) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => FundTransferDetailScreen(
          transferId: transfer.id,
          initialTransfer: transfer,
        ),
      ),
    );

    if (context.mounted) {
      context.read<FundTransfersCubit>().load();
    }
  }

  @override
  Widget build(BuildContext context) {
    final canWrite = context.can('accounting.payments_write');

    return Scaffold(
      appBar: AppBar(
        title: const Text(AccountingStrings.transfersTitle),
        actions: [
          IconButton(
            tooltip: AccountingStrings.refresh,
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<FundTransfersCubit>().load(),
          ),
        ],
      ),
      floatingActionButton: canWrite
          ? FloatingActionButton(
              key: const Key('create_transfer_fab'),
              tooltip: AccountingStrings.createTransferTitle,
              onPressed: () => _openCreateTransfer(context),
              child: const Icon(Icons.add),
            )
          : null,
      body: BlocConsumer<FundTransfersCubit, FundTransfersState>(
        listenWhen: (previous, current) =>
            previous.failure != current.failure && current.failure != null,
        listener: (context, state) {
          if (state.failure != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(failureMessage(state.failure!)),
              ),
            );
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              _buildFiltersBar(context, state),
              Expanded(
                child: _buildBody(context, state),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFiltersBar(BuildContext context, FundTransfersState state) {
    final cubit = context.read<FundTransfersCubit>();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Column(
        children: [
          TextField(
            key: const Key('transfer_search_field'),
            controller: _searchController,
            decoration: InputDecoration(
              hintText: AccountingStrings.searchTransfers,
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        cubit.searchTransfers('');
                      },
                    )
                  : null,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onChanged: (q) => cubit.searchTransfers(q),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                FilterChip(
                  key: const Key('filter_all_transfers_chip'),
                  label: const Text(AccountingStrings.allStatuses),
                  selected: state.statusFilter == null,
                  onSelected: (selected) {
                    if (selected) {
                      cubit.filterByStatus(null);
                    }
                  },
                ),
                const SizedBox(width: 8),
                FilterChip(
                  key: const Key('filter_draft_transfers_chip'),
                  label: const Text(AccountingStrings.statusDraft),
                  selected: state.statusFilter == 'draft',
                  onSelected: (selected) {
                    cubit.filterByStatus(selected ? 'draft' : null);
                  },
                ),
                const SizedBox(width: 8),
                FilterChip(
                  key: const Key('filter_posted_transfers_chip'),
                  label: const Text(AccountingStrings.statusPosted),
                  selected: state.statusFilter == 'posted',
                  onSelected: (selected) {
                    cubit.filterByStatus(selected ? 'posted' : null);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, FundTransfersState state) {
    if (state.status == LoadStatus.loading && state.transfers.isEmpty) {
      return const AppLoading();
    }

    if (state.status == LoadStatus.failure && state.transfers.isEmpty) {
      return AppErrorView(
        message: state.failure == null ? '' : failureMessage(state.failure!),
        onRetry: () => context.read<FundTransfersCubit>().load(),
      );
    }

    if (state.transfers.isEmpty) {
      return const AppEmptyView(message: AccountingStrings.noneFound);
    }

    return RefreshIndicator(
      onRefresh: () => context.read<FundTransfersCubit>().load(),
      child: NotificationListener<ScrollNotification>(
        onNotification: (scrollInfo) {
          if (scrollInfo.metrics.pixels >=
              scrollInfo.metrics.maxScrollExtent - 200) {
            context.read<FundTransfersCubit>().loadNextPage();
          }
          return false;
        },
        child: ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          itemCount: state.transfers.length + (state.hasReachedMax ? 0 : 1),
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            if (index >= state.transfers.length) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: AppLoading()),
              );
            }

            final transfer = state.transfers[index];
            return _buildTransferCard(context, transfer);
          },
        ),
      ),
    );
  }

  Widget _buildTransferCard(BuildContext context, FundTransfer transfer) {
    final theme = Theme.of(context);

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => _openDetail(context, transfer),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    transfer.transferNumber,
                    key: Key('transfer_number_${transfer.id}'),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'monospace',
                    ),
                  ),
                  AppStatusChip(
                    key: Key('transfer_status_chip_${transfer.id}'),
                    label: _statusLabel(transfer.status),
                    color: _statusColor(transfer.status),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    _formatDate(transfer.transferDate),
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${AccountingStrings.fromAccountLabel}: #${transfer.fromAccountId}  →  ${AccountingStrings.toAccountLabel}: #${transfer.toAccountId}',
                      key: Key('transfer_accounts_${transfer.id}'),
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppCurrencyText(
                    transfer.amount,
                    key: Key('transfer_amount_${transfer.id}'),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  if (transfer.hasFee)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          '${AccountingStrings.feeAmountLabel}: ',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        AppCurrencyText(
                          transfer.feeAmount,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
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
