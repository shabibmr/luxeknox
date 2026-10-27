import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../core/widgets/app_currency_text.dart';
import '../../../../core/widgets/app_empty_view.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../accounting/domain/entities/item.dart';
import '../counter_sale_strings.dart';
import '../cubit/counter_sale_cubit.dart';

/// Front-desk Counter Sale catalog: search and a grid of sellable items.
class CounterSaleScreen extends StatelessWidget {
  const CounterSaleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<CounterSaleCubit>()..load(),
      child: const _CounterSaleView(),
    );
  }
}

class _CounterSaleView extends StatelessWidget {
  const _CounterSaleView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(CounterSaleStrings.title)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              key: const Key('counter_sale_search'),
              decoration: const InputDecoration(
                hintText: CounterSaleStrings.searchHint,
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: context.read<CounterSaleCubit>().search,
            ),
          ),
          Expanded(
            child: BlocBuilder<CounterSaleCubit, CounterSaleState>(
              builder: (context, state) {
                if (state.status == LoadStatus.initial ||
                    (state.status == LoadStatus.loading &&
                        state.items.isEmpty)) {
                  return const AppLoading();
                }
                if (state.status == LoadStatus.failure &&
                    state.items.isEmpty) {
                  return AppErrorView(
                    message: failureMessage(state.failure!),
                    onRetry: context.read<CounterSaleCubit>().load,
                  );
                }
                if (state.items.isEmpty) {
                  final emptyMessage = state.search.isEmpty
                      ? CounterSaleStrings.emptyCatalog
                      : CounterSaleStrings.noItemsMatch;
                  return AppEmptyView(message: emptyMessage);
                }
                final cubit = context.read<CounterSaleCubit>();
                return GridView.builder(
                  key: const Key('counter_sale_grid'),
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.15,
                  ),
                  itemCount: state.items.length,
                  itemBuilder: (context, index) {
                    final item = state.items[index];
                    return _CatalogTile(
                      item: item,
                      unitCharge: cubit.unitChargeFor(item),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CatalogTile extends StatelessWidget {
  const _CatalogTile({required this.item, required this.unitCharge});

  final Item item;
  final String unitCharge;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      key: Key('counter_sale_tile_${item.id}'),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.name,
              key: Key('counter_sale_name_${item.id}'),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleSmall,
            ),
            const Spacer(),
            AppCurrencyText(
              unitCharge,
              key: Key('counter_sale_unit_charge_${item.id}'),
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            if (item.inventoryTracked) ...[
              const SizedBox(height: 4),
              Text(
                '${CounterSaleStrings.onHandLabel}: ${item.qtyOnHand ?? '0.000'}',
                key: Key('counter_sale_on_hand_${item.id}'),
                style: theme.textTheme.bodySmall,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
