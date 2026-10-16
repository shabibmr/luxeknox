import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/extensions/capability_extension.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../domain/entities/item.dart';
import '../../domain/usecases/get_accounts_usecase.dart';
import '../../domain/usecases/get_tax_codes_usecase.dart';
import '../accounting_strings.dart';
import '../cubit/item_detail_cubit.dart';

class ItemDetailScreen extends StatelessWidget {
  const ItemDetailScreen({
    super.key,
    required this.itemId,
    this.initialItem,
    this.cubit,
    this.getAccounts,
    this.getTaxCodes,
  });

  final int itemId;
  final Item? initialItem;

  /// Injectable for tests; defaults to the DI container.
  final ItemDetailCubit? cubit;
  final GetAccountsUseCase? getAccounts;
  final GetTaxCodesUseCase? getTaxCodes;

  @override
  Widget build(BuildContext context) {
    if (!context.can('inventory.read')) {
      return Scaffold(
        appBar: AppBar(title: const Text(AccountingStrings.itemDetailTitle)),
        body: const Center(child: Text(AccountingStrings.noPermission)),
      );
    }

    final view = _ItemDetailView(
      itemId: itemId,
      getAccounts: getAccounts ?? getIt<GetAccountsUseCase>(),
      getTaxCodes: getTaxCodes ?? getIt<GetTaxCodesUseCase>(),
    );

    if (cubit != null) {
      return BlocProvider<ItemDetailCubit>.value(value: cubit!, child: view);
    }
    return BlocProvider<ItemDetailCubit>(
      create: (_) =>
          getIt<ItemDetailCubit>()..load(itemId, initialItem: initialItem),
      child: view,
    );
  }
}

class _ItemDetailView extends StatefulWidget {
  const _ItemDetailView({
    required this.itemId,
    required this.getAccounts,
    required this.getTaxCodes,
  });

  final int itemId;
  final GetAccountsUseCase getAccounts;
  final GetTaxCodesUseCase getTaxCodes;

  @override
  State<_ItemDetailView> createState() => _ItemDetailViewState();
}

class _ItemDetailViewState extends State<_ItemDetailView> {
  Map<String, String> _accountNames = const {};
  Map<String, String> _taxCodeNames = const {};

  @override
  void initState() {
    super.initState();
    _loadNames();
  }

  /// Best effort: on failure the screen falls back to a dash for names.
  Future<void> _loadNames() async {
    final accounts = await widget.getAccounts(
      const GetAccountsParams(limit: 500),
    );
    final taxCodes = await widget.getTaxCodes(
      const GetTaxCodesParams(limit: 500),
    );
    if (!mounted) return;
    setState(() {
      accounts.fold((_) {}, (page) {
        _accountNames = {for (final a in page.items) a.id: a.name};
      });
      taxCodes.fold((_) {}, (page) {
        _taxCodeNames = {for (final t in page.items) t.id: t.name};
      });
    });
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

  static String _orDash(String? value) =>
      (value == null || value.trim().isEmpty)
      ? AccountingStrings.itemEmDash
      : value;

  String _account(int? id) =>
      id == null ? AccountingStrings.itemEmDash : _orDash(_accountNames['$id']);

  String _taxCode(int? id) =>
      id == null ? AccountingStrings.itemEmDash : _orDash(_taxCodeNames['$id']);

  static String _yesNo(bool v) =>
      v ? AccountingStrings.itemYes : AccountingStrings.itemNo;

  @override
  Widget build(BuildContext context) {
    final canEdit = context.can('accounting.accounts_write');

    return BlocBuilder<ItemDetailCubit, ItemDetailState>(
      builder: (context, state) {
        final item = state.item;
        return Scaffold(
          appBar: AppBar(
            title: const Text(AccountingStrings.itemDetailTitle),
            actions: [
              if (canEdit && item != null)
                IconButton(
                  tooltip: AccountingStrings.itemEditAction,
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () => context.push(
                    Routes.adminAccountingItemEditById('${item.id}'),
                  ),
                ),
            ],
          ),
          body: _body(context, state),
        );
      },
    );
  }

  Widget _body(BuildContext context, ItemDetailState state) {
    final item = state.item;
    if (item == null) {
      if (state.status == LoadStatus.failure) {
        return AppErrorView(
          message: failureMessage(state.failure!),
          onRetry: () => context.read<ItemDetailCubit>().load(widget.itemId),
        );
      }
      return const AppLoading();
    }

    return RefreshIndicator(
      onRefresh: () =>
          context.read<ItemDetailCubit>().load(widget.itemId, initialItem: item),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (state.status == LoadStatus.failure)
            MaterialBanner(
              content: Text(
                state.failure == null
                    ? AccountingStrings.itemRefreshFailed
                    : failureMessage(state.failure!),
              ),
              actions: [
                TextButton(
                  onPressed: () => context.read<ItemDetailCubit>().load(
                    widget.itemId,
                    initialItem: item,
                  ),
                  child: const Text(AccountingStrings.retry),
                ),
              ],
            ),
          _Section(
            title: AccountingStrings.itemSectionBasics,
            rows: [
              _Row(AccountingStrings.itemNameLabel, item.name),
              _Row(AccountingStrings.itemSkuLabel, _orDash(item.sku)),
              _Row(AccountingStrings.itemHsnSacLabel, _orDash(item.hsnSac)),
              _Row(AccountingStrings.itemKindLabel, _kindLabel(item.kind)),
              _Row(
                AccountingStrings.itemCategoryLabel,
                _orDash(item.categoryName),
              ),
              _Row(AccountingStrings.itemUomLabel, _orDash(item.uomCode)),
              _Row(
                AccountingStrings.statusLabel,
                item.isActive
                    ? AccountingStrings.itemActive
                    : AccountingStrings.itemInactive,
              ),
            ],
          ),
          _Section(
            title: AccountingStrings.itemSectionPricing,
            rows: [
              _Row(AccountingStrings.itemSaleRateLabel, _orDash(item.saleRate)),
              _Row(
                AccountingStrings.itemPurchaseRateLabel,
                _orDash(item.purchaseRate),
              ),
              _Row(AccountingStrings.itemTaxCodeLabel, _taxCode(item.taxCodeId)),
            ],
          ),
          _Section(
            title: AccountingStrings.itemSectionAccounting,
            rows: [
              _Row(
                AccountingStrings.itemIncomeAccountLabel,
                _account(item.incomeAccountId),
              ),
              _Row(
                AccountingStrings.itemExpenseAccountLabel,
                _account(item.expenseAccountId),
              ),
              if (item.inventoryTracked) ...[
                _Row(
                  AccountingStrings.itemInventoryAccountLabel,
                  _account(item.inventoryAccountId),
                ),
                _Row(
                  AccountingStrings.itemCogsAccountLabel,
                  _account(item.cogsAccountId),
                ),
              ],
            ],
          ),
          _Section(
            title: AccountingStrings.itemSectionInventory,
            rows: [
              _Row(
                AccountingStrings.itemTrackedLabel,
                _yesNo(item.inventoryTracked),
              ),
              _Row(
                AccountingStrings.itemReorderLevelLabel,
                _orDash(item.reorderLevel),
              ),
              _Row(
                AccountingStrings.itemHasMovementsLabel,
                _yesNo(item.hasMovements),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Row {
  const _Row(this.label, this.value);

  final String label;
  final String value;
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.rows});

  final String title;
  final List<_Row> rows;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            for (final row in rows)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        row.label,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(row.value, style: theme.textTheme.bodyMedium),
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
