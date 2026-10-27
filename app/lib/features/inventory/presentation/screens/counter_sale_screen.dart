import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/extensions/capability_extension.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../core/widgets/app_currency_text.dart';
import '../../../../core/widgets/app_empty_view.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../accounting/domain/entities/item.dart';
import '../../domain/sale_line.dart';
import '../../domain/sale_line_charge.dart';
import '../cubit/counter_sale_cubit.dart';
import '../inventory_strings.dart';

class CounterSaleScreen extends StatelessWidget {
  const CounterSaleScreen({super.key, this.cubit});

  final CounterSaleCubit? cubit;

  @override
  Widget build(BuildContext context) {
    if (!context.can('inventory.sales_write')) {
      return Scaffold(
        appBar: AppBar(title: const Text(InventoryStrings.counterSaleTitle)),
        body: const Center(child: Text(InventoryStrings.noPermission)),
      );
    }

    if (cubit != null) {
      if (cubit!.state.status == LoadStatus.initial) {
        cubit!.load();
      }
      return BlocProvider<CounterSaleCubit>.value(
        value: cubit!,
        child: const _CounterSaleView(),
      );
    }

    return BlocProvider<CounterSaleCubit>(
      create: (_) => getIt<CounterSaleCubit>()..load(),
      child: const _CounterSaleView(),
    );
  }
}

class _CounterSaleView extends StatefulWidget {
  const _CounterSaleView();

  @override
  State<_CounterSaleView> createState() => _CounterSaleViewState();
}

class _CounterSaleViewState extends State<_CounterSaleView> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(InventoryStrings.counterSaleTitle),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<CounterSaleCubit>().load(),
          ),
        ],
      ),
      body: BlocBuilder<CounterSaleCubit, CounterSaleState>(
        builder: (context, state) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: TextField(
                  key: const Key('counter_sale_search'),
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: InventoryStrings.searchHint,
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              context.read<CounterSaleCubit>().searchCatalog('');
                              setState(() {});
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: (value) {
                    context.read<CounterSaleCubit>().searchCatalog(value);
                    setState(() {});
                  },
                ),
              ),
              Expanded(child: _buildCatalog(context, state)),
              _SaleTray(state: state),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCatalog(BuildContext context, CounterSaleState state) {
    if (state.status == LoadStatus.loading ||
        state.status == LoadStatus.initial) {
      return const AppLoading();
    }
    if (state.status == LoadStatus.failure && state.catalog.isEmpty) {
      return AppErrorView(
        message: InventoryStrings.loadFailed,
        onRetry: () => context.read<CounterSaleCubit>().load(),
      );
    }
    if (state.catalog.isEmpty) {
      final searching = state.search != null && state.search!.trim().isNotEmpty;
      return AppEmptyView(
        message: searching
            ? InventoryStrings.nothingMatched
            : InventoryStrings.noSellableItems,
      );
    }

    return GridView.builder(
      key: const Key('counter_sale_grid'),
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 1.35,
      ),
      itemCount: state.catalog.length,
      itemBuilder: (context, index) {
        final item = state.catalog[index];
        return _CatalogTile(
          item: item,
          onTap: () => context.read<CounterSaleCubit>().tapItem(item),
        );
      },
    );
  }
}

class _CatalogTile extends StatelessWidget {
  const _CatalogTile({required this.item, required this.onTap});

  final Item item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final charge = unitCharge(
      saleRate: item.saleRate ?? '0.00',
      taxRatePercent: item.taxRatePercent,
    );
    final theme = Theme.of(context);

    return Card(
      key: Key('counter_sale_tile_${item.id}'),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleSmall,
              ),
              const Spacer(),
              AppCurrencyText(
                charge,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (item.inventoryTracked && item.qtyOnHand != null) ...[
                const SizedBox(height: 4),
                Text(
                  InventoryStrings.onHand(item.qtyOnHand!),
                  key: Key('counter_sale_tile_on_hand_${item.id}'),
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _SaleTray extends StatelessWidget {
  const _SaleTray({required this.state});

  final CounterSaleState state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottom = MediaQuery.paddingOf(context).bottom;

    return Material(
      elevation: 8,
      color: theme.colorScheme.surfaceContainerHigh,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 12, 16, 12 + bottom * 0.25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (state.lines.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    InventoryStrings.emptyTrayHint,
                    key: const Key('counter_sale_tray_empty'),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                )
              else
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 220),
                  child: ListView.separated(
                    key: const Key('counter_sale_tray_lines'),
                    shrinkWrap: true,
                    itemCount: state.lines.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      return _TrayLine(line: state.lines[index]);
                    },
                  ),
                ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    InventoryStrings.amountDueLabel,
                    style: theme.textTheme.titleMedium,
                  ),
                  const Spacer(),
                  AppCurrencyText(
                    state.amountDue,
                    key: const Key('counter_sale_amount_due'),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              FilledButton(
                key: const Key('counter_sale_continue'),
                onPressed: state.canContinue ? () {} : null,
                child: const Text(InventoryStrings.continueLabel),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TrayLine extends StatefulWidget {
  const _TrayLine({required this.line});

  final SaleLine line;

  @override
  State<_TrayLine> createState() => _TrayLineState();
}

class _TrayLineState extends State<_TrayLine> {
  late final TextEditingController _qtyController;

  @override
  void initState() {
    super.initState();
    _qtyController = TextEditingController(text: widget.line.quantity);
  }

  @override
  void didUpdateWidget(covariant _TrayLine oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.line.quantity != widget.line.quantity &&
        _qtyController.text != widget.line.quantity) {
      _qtyController.text = widget.line.quantity;
    }
  }

  @override
  void dispose() {
    _qtyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final line = widget.line;
    final item = line.item;
    final places = item.uomDecimalPlaces;
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name, style: theme.textTheme.titleSmall),
                if (item.inventoryTracked && item.qtyOnHand != null)
                  Text(
                    InventoryStrings.onHand(item.qtyOnHand!),
                    key: Key('counter_sale_line_on_hand_${item.id}'),
                    style: theme.textTheme.bodySmall,
                  ),
                AppCurrencyText(
                  line.charge,
                  key: Key('counter_sale_line_charge_${item.id}'),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 72,
            child: TextField(
              key: Key('counter_sale_line_qty_${item.id}'),
              controller: _qtyController,
              keyboardType: places <= 0
                  ? TextInputType.number
                  : const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                if (places <= 0)
                  FilteringTextInputFormatter.digitsOnly
                else
                  FilteringTextInputFormatter.allow(
                    RegExp('^\\d*\\.?\\d{0,$places}'),
                  ),
              ],
              decoration: const InputDecoration(
                labelText: InventoryStrings.quantityLabel,
                isDense: true,
              ),
              onChanged: (value) {
                context.read<CounterSaleCubit>().setLineQuantity(item.id, value);
              },
            ),
          ),
          IconButton(
            key: Key('counter_sale_line_remove_${item.id}'),
            tooltip: InventoryStrings.removeLine,
            onPressed: () =>
                context.read<CounterSaleCubit>().removeLine(item.id),
            icon: const Icon(Icons.close),
          ),
        ],
      ),
    );
  }
}
