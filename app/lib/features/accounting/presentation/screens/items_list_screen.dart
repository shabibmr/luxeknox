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
import '../../domain/entities/item.dart';
import '../accounting_strings.dart';
import '../cubit/items_cubit.dart';

class ItemsListScreen extends StatelessWidget {
  const ItemsListScreen({
    super.key,
    this.cubit,
  });

  final ItemsCubit? cubit;

  @override
  Widget build(BuildContext context) {
    if (!context.can('inventory.read')) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(AccountingStrings.itemsTitle),
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
      return BlocProvider<ItemsCubit>.value(
        value: cubit!,
        child: const _ItemsListView(),
      );
    }

    return BlocProvider<ItemsCubit>(
      create: (_) => getIt<ItemsCubit>()..load(),
      child: const _ItemsListView(),
    );
  }
}

class _ItemsListView extends StatefulWidget {
  const _ItemsListView();

  @override
  State<_ItemsListView> createState() => _ItemsListViewState();
}

class _ItemsListViewState extends State<_ItemsListView> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  static String _kindLabel(String kind) {
    switch (kind) {
      case 'goods':
        return AccountingStrings.itemKindGoods;
      case 'service':
        return AccountingStrings.itemKindService;
      default:
        return kind;
    }
  }

  @override
  Widget build(BuildContext context) {
    final canWrite = context.can('accounting.accounts_write');

    return Scaffold(
      appBar: AppBar(
        title: const Text(AccountingStrings.itemsTitle),
        actions: [
          IconButton(
            tooltip: AccountingStrings.refresh,
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<ItemsCubit>().load(),
          ),
        ],
      ),
      floatingActionButton: canWrite
          ? FloatingActionButton(
              key: const Key('create_item_fab'),
              tooltip: AccountingStrings.createItemTitle,
              onPressed: () =>
                  context.push(Routes.adminAccountingItemsCreate),
              child: const Icon(Icons.add),
            )
          : null,
      body: BlocConsumer<ItemsCubit, ItemsState>(
        listenWhen: (previous, current) =>
            previous.failure != current.failure && current.failure != null,
        listener: (context, state) {
          if (state.failure != null && state.items.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(failureMessage(state.failure!))),
            );
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              _buildFiltersBar(context, state),
              Expanded(child: _buildBody(context, state)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFiltersBar(BuildContext context, ItemsState state) {
    final cubit = context.read<ItemsCubit>();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Column(
        children: [
          TextField(
            key: const Key('item_list_search_field'),
            controller: _searchController,
            decoration: InputDecoration(
              hintText: AccountingStrings.searchItems,
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        cubit.searchItems('');
                        setState(() {});
                      },
                    )
                  : null,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onChanged: (query) {
              setState(() {});
              cubit.searchItems(query);
            },
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                FilterChip(
                  key: const Key('filter_all_kinds_chip'),
                  label: const Text(AccountingStrings.allKinds),
                  selected: state.kind == null,
                  onSelected: (selected) {
                    if (selected) cubit.filterByKind(null);
                  },
                ),
                const SizedBox(width: 8),
                FilterChip(
                  key: const Key('filter_goods_chip'),
                  label: const Text(AccountingStrings.itemKindGoods),
                  selected: state.kind == 'goods',
                  onSelected: (selected) {
                    cubit.filterByKind(selected ? 'goods' : null);
                  },
                ),
                const SizedBox(width: 8),
                FilterChip(
                  key: const Key('filter_service_chip'),
                  label: const Text(AccountingStrings.itemKindService),
                  selected: state.kind == 'service',
                  onSelected: (selected) {
                    cubit.filterByKind(selected ? 'service' : null);
                  },
                ),
                const SizedBox(width: 8),
                FilterChip(
                  key: const Key('filter_all_active_chip'),
                  label: const Text(AccountingStrings.allStatuses),
                  selected: state.isActive == null,
                  onSelected: (selected) {
                    if (selected) cubit.filterByActive(null);
                  },
                ),
                const SizedBox(width: 8),
                FilterChip(
                  key: const Key('filter_active_chip'),
                  label: const Text(AccountingStrings.activeBadge),
                  selected: state.isActive == true,
                  onSelected: (selected) {
                    cubit.filterByActive(selected ? true : null);
                  },
                ),
                const SizedBox(width: 8),
                FilterChip(
                  key: const Key('filter_inactive_chip'),
                  label: const Text(AccountingStrings.inactiveBadge),
                  selected: state.isActive == false,
                  onSelected: (selected) {
                    cubit.filterByActive(selected ? false : null);
                  },
                ),
                const SizedBox(width: 8),
                FilterChip(
                  key: const Key('filter_all_tracked_chip'),
                  label: const Text(AccountingStrings.allTypes),
                  selected: state.inventoryTracked == null,
                  onSelected: (selected) {
                    if (selected) cubit.filterByTracked(null);
                  },
                ),
                const SizedBox(width: 8),
                FilterChip(
                  key: const Key('filter_tracked_chip'),
                  label: const Text(AccountingStrings.trackedOnly),
                  selected: state.inventoryTracked == true,
                  onSelected: (selected) {
                    cubit.filterByTracked(selected ? true : null);
                  },
                ),
                const SizedBox(width: 8),
                FilterChip(
                  key: const Key('filter_untracked_chip'),
                  label: const Text(AccountingStrings.untrackedOnly),
                  selected: state.inventoryTracked == false,
                  onSelected: (selected) {
                    cubit.filterByTracked(selected ? false : null);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, ItemsState state) {
    if (state.status == LoadStatus.loading && state.items.isEmpty) {
      return const AppLoading();
    }

    if (state.status == LoadStatus.failure && state.items.isEmpty) {
      return AppErrorView(
        message: state.failure == null ? '' : failureMessage(state.failure!),
        onRetry: () => context.read<ItemsCubit>().load(),
      );
    }

    if (state.items.isEmpty) {
      return const AppEmptyView(message: AccountingStrings.noneFound);
    }

    return RefreshIndicator(
      onRefresh: () => context.read<ItemsCubit>().load(),
      child: NotificationListener<ScrollNotification>(
        onNotification: (scrollInfo) {
          if (scrollInfo.metrics.pixels >=
              scrollInfo.metrics.maxScrollExtent - 200) {
            context.read<ItemsCubit>().loadMore();
          }
          return false;
        },
        child: ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          itemCount: state.items.length + (state.hasMore ? 1 : 0),
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            if (index >= state.items.length) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: AppLoading()),
              );
            }

            return _buildItemCard(context, state.items[index]);
          },
        ),
      ),
    );
  }

  Widget _buildItemCard(BuildContext context, Item item) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        key: Key('item_row_${item.id}'),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          item.name,
          key: Key('item_name_${item.id}'),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (item.sku != null && item.sku!.isNotEmpty)
                Text(
                  item.sku!,
                  key: Key('item_sku_${item.id}'),
                  style: const TextStyle(fontSize: 13),
                ),
              const SizedBox(height: 4),
              Wrap(
                spacing: 6,
                runSpacing: 4,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  AppStatusChip(
                    key: Key('item_kind_chip_${item.id}'),
                    label: _kindLabel(item.kind),
                    color: Colors.blueGrey,
                  ),
                  Text(
                    item.uomCode,
                    key: Key('item_uom_${item.id}'),
                    style: const TextStyle(fontSize: 13),
                  ),
                  if (item.saleRate != null && item.saleRate!.isNotEmpty)
                    Text(
                      item.saleRate!,
                      key: Key('item_sale_rate_${item.id}'),
                      style: const TextStyle(fontSize: 13),
                    ),
                  if (item.inventoryTracked)
                    AppStatusChip(
                      key: Key('item_tracked_badge_${item.id}'),
                      label: AccountingStrings.trackedBadge,
                      color: Colors.teal,
                    ),
                  if (!item.isActive)
                    AppStatusChip(
                      key: Key('item_inactive_badge_${item.id}'),
                      label: AccountingStrings.inactiveBadge,
                      color: Colors.grey,
                    ),
                ],
              ),
            ],
          ),
        ),
        onTap: () => context.push(
          Routes.adminAccountingItemById('${item.id}'),
          extra: item,
        ),
      ),
    );
  }
}
