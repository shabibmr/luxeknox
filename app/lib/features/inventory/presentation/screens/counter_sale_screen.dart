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
import '../../../people/domain/usecases/list_members_usecase.dart';
import '../../../people/presentation/widgets/member_picker_sheet.dart';
import '../../domain/qty_compare.dart';
import '../../domain/sale_line.dart';
import '../../domain/sale_line_charge.dart';
import '../cubit/counter_sale_cubit.dart';
import '../inventory_strings.dart';

class CounterSaleScreen extends StatelessWidget {
  const CounterSaleScreen({super.key, this.cubit, this.listMembers});

  final CounterSaleCubit? cubit;

  /// Member picker use case. Production falls back to getIt inside the picker.
  final ListMembersUseCase? listMembers;

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
        child: _CounterSaleView(listMembers: listMembers),
      );
    }

    return BlocProvider<CounterSaleCubit>(
      create: (_) => getIt<CounterSaleCubit>()..load(),
      child: _CounterSaleView(listMembers: listMembers),
    );
  }
}

class _CounterSaleView extends StatefulWidget {
  const _CounterSaleView({this.listMembers});

  final ListMembersUseCase? listMembers;

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
    return BlocBuilder<CounterSaleCubit, CounterSaleState>(
      builder: (context, state) {
        return PopScope(
          canPop: true,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) return;
            context.read<CounterSaleCubit>().discardOpenSale();
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(switch (state.step) {
                CounterSaleStep.buyer => InventoryStrings.buyerStepTitle,
                CounterSaleStep.tender => InventoryStrings.tenderStepTitle,
                CounterSaleStep.success => InventoryStrings.successTitle,
                CounterSaleStep.catalog => InventoryStrings.counterSaleTitle,
              }),
              leading:
                  state.step == CounterSaleStep.buyer ||
                      state.step == CounterSaleStep.tender
                  ? IconButton(
                      key: const Key('counter_sale_back'),
                      tooltip: InventoryStrings.backLabel,
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () =>
                          context.read<CounterSaleCubit>().backToCatalog(),
                    )
                  : null,
              actions: [
                if (state.step == CounterSaleStep.catalog)
                  IconButton(
                    tooltip: 'Refresh',
                    icon: const Icon(Icons.refresh),
                    onPressed: () => context.read<CounterSaleCubit>().load(),
                  ),
              ],
            ),
            body: switch (state.step) {
              CounterSaleStep.catalog => _buildCatalogStep(context, state),
              CounterSaleStep.buyer => _BuyerStep(
                state: state,
                listMembers: widget.listMembers,
              ),
              CounterSaleStep.tender => _TenderBody(state: state),
              CounterSaleStep.success => _SuccessBody(state: state),
            },
          ),
        );
      },
    );
  }

  Widget _buildCatalogStep(BuildContext context, CounterSaleState state) {
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

class _BuyerStep extends StatefulWidget {
  const _BuyerStep({required this.state, this.listMembers});

  final CounterSaleState state;
  final ListMembersUseCase? listMembers;

  @override
  State<_BuyerStep> createState() => _BuyerStepState();
}

class _BuyerStepState extends State<_BuyerStep> {
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.state.buyerName ?? '');
  }

  @override
  void didUpdateWidget(covariant _BuyerStep oldWidget) {
    super.didUpdateWidget(oldWidget);
    final next = widget.state.buyerName ?? '';
    if (_nameController.text != next) {
      _nameController.text = next;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final width = MediaQuery.sizeOf(context).width;

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: width >= 600 ? 560 : width),
        child: ListView(
          key: const Key('counter_sale_buyer'),
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          children: [
            MemberPickerField(
              key: const Key('counter_sale_buyer_member'),
              selectedMember: state.member,
              selectedMemberId: state.memberId?.toString(),
              selectedMemberName: state.member?.fullName,
              listMembers: widget.listMembers,
              labelText: InventoryStrings.buyerMemberLabel,
              hintText: InventoryStrings.buyerMemberHint,
              onChanged: (member) {
                final cubit = context.read<CounterSaleCubit>();
                if (member == null) {
                  cubit.setMember(null);
                  return;
                }
                cubit.setMember(member.id, member: member);
              },
            ),
            const SizedBox(height: 16),
            TextField(
              key: const Key('counter_sale_buyer_name'),
              controller: _nameController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: InventoryStrings.buyerNameLabel,
                hintText: InventoryStrings.buyerNameHint,
                border: OutlineInputBorder(),
              ),
              onChanged: context.read<CounterSaleCubit>().setBuyerName,
            ),
            const SizedBox(height: 24),
            FilledButton(
              key: const Key('counter_sale_buyer_continue'),
              onPressed: () => context.read<CounterSaleCubit>().goToTender(),
              child: const Text(InventoryStrings.continueLabel),
            ),
          ],
        ),
      ),
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
                onPressed: state.canContinue
                    ? () => context.read<CounterSaleCubit>().openBuyer()
                    : null,
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
  const _TrayLine({required this.line, this.showRemove = true});

  final SaleLine line;
  final bool showRemove;

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
    final over =
        item.inventoryTracked &&
        item.qtyOnHand != null &&
        quantityExceeds(line.quantity, item.qtyOnHand!);

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
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: over ? theme.colorScheme.error : null,
                    ),
                  ),
                if (over)
                  Text(
                    InventoryStrings.overOnHandHint,
                    key: Key('counter_sale_line_over_${item.id}'),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.error,
                    ),
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
                context.read<CounterSaleCubit>().setLineQuantity(
                  item.id,
                  value,
                );
              },
            ),
          ),
          if (widget.showRemove)
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

class _SplitAmountField extends StatefulWidget {
  const _SplitAmountField({
    required this.methodId,
    required this.methodName,
    required this.amount,
  });

  final String methodId;
  final String methodName;
  final String amount;

  @override
  State<_SplitAmountField> createState() => _SplitAmountFieldState();
}

class _SplitAmountFieldState extends State<_SplitAmountField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.amount);
  }

  @override
  void didUpdateWidget(covariant _SplitAmountField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.amount != widget.amount &&
        _controller.text != widget.amount) {
      _controller.text = widget.amount;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        key: Key('counter_sale_split_amount_${widget.methodId}'),
        controller: _controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
        ],
        decoration: InputDecoration(
          labelText: widget.methodName,
          border: const OutlineInputBorder(),
          isDense: true,
        ),
        onChanged: (value) => context
            .read<CounterSaleCubit>()
            .setSplitAmount(widget.methodId, value),
      ),
    );
  }
}

class _TenderBody extends StatelessWidget {
  const _TenderBody({required this.state});

  final CounterSaleState state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (state.paymentMethodsStatus == LoadStatus.loading ||
        state.paymentMethodsStatus == LoadStatus.initial) {
      return const AppLoading();
    }

    if (state.paymentMethodsStatus == LoadStatus.failure) {
      return AppErrorView(
        message: InventoryStrings.paymentMethodsLoadFailed,
        onRetry: () => context.read<CounterSaleCubit>().goToTender(),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            children: [
              Text(
                InventoryStrings.amountDueLabel,
                style: theme.textTheme.titleMedium,
              ),
              const Spacer(),
              AppCurrencyText(
                state.amountDue,
                key: const Key('counter_sale_tender_amount_due'),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        if (state.hasOverOnHandLine)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              InventoryStrings.overOnHandHint,
              key: const Key('counter_sale_over_on_hand'),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ),
        if (state.hasOverOnHandLine)
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 180),
            child: ListView.separated(
              key: const Key('counter_sale_tender_lines'),
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              shrinkWrap: true,
              itemCount: state.lines.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) {
                return _TrayLine(line: state.lines[index], showRemove: false);
              },
            ),
          ),
        if (state.confirmError != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Text(
              state.confirmError!,
              key: const Key('counter_sale_confirm_error'),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ),
        if (state.splitMode) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Row(
              children: [
                Text(
                  InventoryStrings.splitTotalLabel,
                  style: theme.textTheme.titleSmall,
                ),
                const Spacer(),
                AppCurrencyText(
                  state.splitEnteredTotal,
                  key: const Key('counter_sale_split_total'),
                  style: theme.textTheme.titleSmall,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
            child: Row(
              children: [
                Text(
                  InventoryStrings.remainderLabel,
                  style: theme.textTheme.titleMedium,
                ),
                const Spacer(),
                AppCurrencyText(
                  state.splitRemainder,
                  key: const Key('counter_sale_split_remainder'),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: compareMoney(state.splitRemainder, '0.00') == 0
                        ? null
                        : theme.colorScheme.error,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                key: const Key('counter_sale_leave_split'),
                onPressed: () => context.read<CounterSaleCubit>().leaveSplit(),
                child: const Text(InventoryStrings.leaveSplitLabel),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              key: const Key('counter_sale_split_amounts'),
              padding: const EdgeInsets.all(16),
              children: [
                for (final method in state.paymentMethods)
                  _SplitAmountField(
                    methodId: method.id,
                    methodName: method.methodName,
                    amount: state.splitAmounts[method.id] ?? '',
                  ),
              ],
            ),
          ),
        ] else
          Expanded(
            child: state.paymentMethods.isEmpty
                ? const AppEmptyView(
                    key: Key('counter_sale_no_payment_methods'),
                    message: InventoryStrings.noPaymentMethods,
                  )
                : ListView(
                    key: const Key('counter_sale_payment_methods'),
                    padding: const EdgeInsets.all(16),
                    children: [
                      for (final method in state.paymentMethods)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: OutlinedButton(
                            key: Key('counter_sale_method_${method.id}'),
                            style: OutlinedButton.styleFrom(
                              backgroundColor:
                                  state.selectedPaymentMethodId == method.id
                                  ? theme.colorScheme.primaryContainer
                                  : null,
                              minimumSize: const Size.fromHeight(48),
                            ),
                            onPressed: () => context
                                .read<CounterSaleCubit>()
                                .selectPaymentMethod(method.id),
                            child: Text(method.methodName),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: OutlinedButton(
                          key: const Key('counter_sale_split'),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size.fromHeight(48),
                          ),
                          onPressed: () =>
                              context.read<CounterSaleCubit>().openSplit(),
                          child: const Text(InventoryStrings.splitLabel),
                        ),
                      ),
                    ],
                  ),
          ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: FilledButton(
              key: const Key('counter_sale_confirm'),
              onPressed: state.canConfirm && !state.confirming
                  ? () => context.read<CounterSaleCubit>().confirm()
                  : null,
              child: state.confirming
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text(InventoryStrings.confirmLabel),
            ),
          ),
        ),
      ],
    );
  }
}

class _SuccessBody extends StatelessWidget {
  const _SuccessBody({required this.state});

  final CounterSaleState state;

  @override
  Widget build(BuildContext context) {
    final sale = state.postedSale;
    final theme = Theme.of(context);
    if (sale == null) {
      return const AppEmptyView(message: InventoryStrings.successTitle);
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            InventoryStrings.saleNumberLabel,
            style: theme.textTheme.labelLarge,
          ),
          Text(
            sale.saleNumber,
            key: const Key('counter_sale_posted_number'),
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                InventoryStrings.amountDueLabel,
                style: theme.textTheme.titleMedium,
              ),
              const Spacer(),
              AppCurrencyText(
                sale.totalAmount,
                key: const Key('counter_sale_posted_amount'),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          for (final tender in sale.tenders)
            ListTile(
              key: Key('counter_sale_posted_tender_${tender.paymentMethodId}'),
              contentPadding: EdgeInsets.zero,
              title: Text(tender.paymentMethodName),
              trailing: AppCurrencyText(tender.amount),
            ),
          const Spacer(),
          FilledButton(
            key: const Key('counter_sale_new_sale'),
            onPressed: () => context.read<CounterSaleCubit>().startNewSale(),
            child: const Text(InventoryStrings.newSaleLabel),
          ),
        ],
      ),
    );
  }
}
