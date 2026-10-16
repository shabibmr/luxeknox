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
import '../../domain/entities/purchase_bill.dart';
import '../accounting_strings.dart';
import '../cubit/purchase_bills_cubit.dart';

class PurchaseBillsListScreen extends StatelessWidget {
  const PurchaseBillsListScreen({
    super.key,
    this.cubit,
  });

  final PurchaseBillsCubit? cubit;

  @override
  Widget build(BuildContext context) {
    if (cubit != null) {
      if (cubit!.state.status == LoadStatus.initial) {
        cubit!.load();
      }
      return BlocProvider<PurchaseBillsCubit>.value(
        value: cubit!,
        child: const _PurchaseBillsListBody(),
      );
    }

    return BlocProvider<PurchaseBillsCubit>(
      create: (_) => getIt<PurchaseBillsCubit>()..load(),
      child: const _PurchaseBillsListBody(),
    );
  }
}

class _PurchaseBillsListBody extends StatefulWidget {
  const _PurchaseBillsListBody();

  @override
  State<_PurchaseBillsListBody> createState() => _PurchaseBillsListBodyState();
}

class _PurchaseBillsListBodyState extends State<_PurchaseBillsListBody> {
  final TextEditingController _searchController = TextEditingController();

  static const List<String> _statuses = ['draft', 'posted', 'void'];

  static String _formatDate(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  static String _statusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'posted':
        return AccountingStrings.statusPosted;
      case 'draft':
        return AccountingStrings.statusDraft;
      case 'void':
        return AccountingStrings.statusVoid;
      case 'paid':
        return AccountingStrings.statusPaid;
      case 'partial':
        return AccountingStrings.statusPartial;
      default:
        if (status.isEmpty) return status;
        return status[0].toUpperCase() + status.substring(1).toLowerCase();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _pickDateRange(
    BuildContext context,
    PurchaseBillsState state,
  ) async {
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
      context
          .read<PurchaseBillsCubit>()
          .filterByDateRange(picked.start, picked.end);
    }
  }

  @override
  Widget build(BuildContext context) {
    final canWrite = context.can('accounting.purchases_write');

    return Scaffold(
      appBar: AppBar(
        title: const Text(AccountingStrings.billsTitle),
        actions: [
          IconButton(
            tooltip: AccountingStrings.refresh,
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<PurchaseBillsCubit>().load(),
          ),
          if (canWrite)
            IconButton(
              key: const Key('appbar_create_bill_button'),
              tooltip: AccountingStrings.createBillTitle,
              icon: const Icon(Icons.add),
              onPressed: () =>
                  context.push(Routes.adminAccountingBillsCreate),
            ),
        ],
      ),
      floatingActionButton: canWrite
          ? FloatingActionButton.extended(
              key: const Key('create_bill_button'),
              onPressed: () =>
                  context.push(Routes.adminAccountingBillsCreate),
              icon: const Icon(Icons.add),
              label: const Text(AccountingStrings.createBillTitle),
            )
          : null,
      body: BlocConsumer<PurchaseBillsCubit, PurchaseBillsState>(
        listenWhen: (previous, next) =>
            next.status == LoadStatus.failure &&
            next.failure != previous.failure &&
            next.bills.isNotEmpty,
        listener: (context, state) {
          final failure = state.failure;
          if (failure == null) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(failureMessage(failure))),
          );
        },
        builder: (context, state) {
          final hasActiveFilters = state.fromDate != null ||
              state.toDate != null ||
              (state.statusFilter != null && state.statusFilter!.isNotEmpty) ||
              (state.vendorId != null && state.vendorId!.isNotEmpty) ||
              (state.search != null && state.search!.isNotEmpty);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Search Field
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                child: TextField(
                  key: const Key('search_bills_field'),
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: AccountingStrings.searchBills,
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              context.read<PurchaseBillsCubit>().searchBills(null);
                            },
                          )
                        : null,
                    isDense: true,
                    border: const OutlineInputBorder(),
                  ),
                  onSubmitted: (query) {
                    context.read<PurchaseBillsCubit>().searchBills(query);
                  },
                ),
              ),

              // Filter Chips
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
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
                                .read<PurchaseBillsCubit>()
                                .filterByStatus(null),
                          ),
                          for (final status in _statuses) ...[
                            const SizedBox(width: 8),
                            FilterChip(
                              key: Key('status_chip_$status'),
                              label: Text(_statusLabel(status)),
                              selected: state.statusFilter == status,
                              onSelected: (_) => context
                                  .read<PurchaseBillsCubit>()
                                  .filterByStatus(status),
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
                                    .read<PurchaseBillsCubit>()
                                    .filterByDateRange(null, null)
                                : null,
                          ),
                          if (state.vendorId != null &&
                              state.vendorId!.isNotEmpty) ...[
                            const SizedBox(width: 8),
                            InputChip(
                              key: const Key('vendor_filter_chip'),
                              avatar: const Icon(Icons.business, size: 16),
                              label: Text('${AccountingStrings.vendorLabel}: ${state.vendorId}'),
                              onDeleted: () => context
                                  .read<PurchaseBillsCubit>()
                                  .filterByVendor(null),
                            ),
                          ],
                          if (hasActiveFilters) ...[
                            const SizedBox(width: 8),
                            ActionChip(
                              key: const Key('clear_filters_button'),
                              avatar: const Icon(Icons.clear, size: 16),
                              label: const Text(AccountingStrings.clearFilter),
                              onPressed: () {
                                _searchController.clear();
                                context.read<PurchaseBillsCubit>().clearFilters();
                              },
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
    PurchaseBillsState state,
  ) {
    if (state.status == LoadStatus.loading && state.bills.isEmpty) {
      return const AppLoading();
    }

    if (state.status == LoadStatus.failure && state.bills.isEmpty) {
      return AppErrorView(
        message:
            state.failure == null ? '' : failureMessage(state.failure!),
        onRetry: () => context.read<PurchaseBillsCubit>().load(),
      );
    }

    if (state.bills.isEmpty) {
      return RefreshIndicator(
        onRefresh: () => context.read<PurchaseBillsCubit>().load(),
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
      onRefresh: () => context.read<PurchaseBillsCubit>().load(),
      child: NotificationListener<ScrollNotification>(
        onNotification: (scrollInfo) {
          if (scrollInfo.metrics.pixels >=
                  scrollInfo.metrics.maxScrollExtent - 200 &&
              state.hasMore &&
              !state.isLoadingMore) {
            context.read<PurchaseBillsCubit>().loadMore();
          }
          return false;
        },
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 80, top: 4),
          itemCount: state.bills.length + (state.isLoadingMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == state.bills.length) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(),
                ),
              );
            }
            final bill = state.bills[index];
            return _PurchaseBillCard(bill: bill);
          },
        ),
      ),
    );
  }
}

class _PurchaseBillCard extends StatelessWidget {
  const _PurchaseBillCard({required this.bill});

  final PurchaseBill bill;

  static Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'posted':
        return Colors.green;
      case 'draft':
        return Colors.amber;
      case 'void':
        return Colors.red;
      case 'paid':
        return Colors.teal;
      case 'partial':
        return Colors.blue;
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
      case 'paid':
        return AccountingStrings.statusPaid;
      case 'partial':
        return AccountingStrings.statusPartial;
      default:
        if (status.isEmpty) return status;
        return status[0].toUpperCase() + status.substring(1).toLowerCase();
    }
  }

  static String _formatDate(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final vendorDisplayName = (bill.vendorName != null && bill.vendorName!.isNotEmpty)
        ? bill.vendorName!
        : bill.vendorId;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.push(
          Routes.adminAccountingBillById(bill.id),
          extra: bill,
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
                          bill.billNumber,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'monospace',
                            fontSize: 16,
                          ),
                        ),
                        if (bill.supplierInvoiceNo != null &&
                            bill.supplierInvoiceNo!.isNotEmpty)
                          Text(
                            '${AccountingStrings.supplierInvoiceNoLabel} ${bill.supplierInvoiceNo}',
                            style: theme.textTheme.bodySmall,
                          ),
                        const SizedBox(height: 4),
                        Text(
                          vendorDisplayName,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _formatDate(bill.billDate),
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
                        _formatAmount(bill.totalAmount),
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      AppStatusChip(
                        label: _statusLabel(bill.status),
                        color: _statusColor(bill.status),
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
