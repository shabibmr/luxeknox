import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/extensions/capability_extension.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../domain/entities/item.dart';
import '../accounting_strings.dart';
import '../cubit/item_form_cubit.dart';
import '../widgets/account_picker_sheet.dart';
import '../widgets/item_category_dropdown.dart';
import '../widgets/uom_picker_sheet.dart';

/// Create (itemId null) or edit an item.
class ItemFormScreen extends StatelessWidget {
  const ItemFormScreen({super.key, this.itemId, this.initialItem, this.cubit});

  final int? itemId;
  final Item? initialItem;
  final ItemFormCubit? cubit;

  bool get _isEdit => itemId != null || initialItem != null;

  @override
  Widget build(BuildContext context) {
    final title = _isEdit
        ? AccountingStrings.editItemTitle
        : AccountingStrings.createItemTitle;
    if (!context.can('accounting.accounts_write')) {
      return Scaffold(
        appBar: AppBar(title: Text(title)),
        body: const Center(child: Text(AccountingStrings.noPermission)),
      );
    }
    final provided = cubit;
    if (provided != null) {
      return BlocProvider<ItemFormCubit>.value(
        value: provided,
        child: _ItemFormView(title: title),
      );
    }
    return BlocProvider<ItemFormCubit>(
      create: (_) {
        final c = getIt<ItemFormCubit>()..loadTaxCodes();
        if (_isEdit) {
          c.loadForEdit(initialItem?.id ?? itemId!, initial: initialItem);
        }
        return c;
      },
      child: _ItemFormView(title: title),
    );
  }
}

class _ItemFormView extends StatefulWidget {
  const _ItemFormView({required this.title});

  final String title;

  @override
  State<_ItemFormView> createState() => _ItemFormViewState();
}

class _ItemFormViewState extends State<_ItemFormView> {
  final _name = TextEditingController();
  final _sku = TextEditingController();
  final _hsn = TextEditingController();
  final _saleRate = TextEditingController();
  final _purchaseRate = TextEditingController();
  final _reorder = TextEditingController();
  bool _synced = false;

  @override
  void dispose() {
    for (final c in [_name, _sku, _hsn, _saleRate, _purchaseRate, _reorder]) {
      c.dispose();
    }
    super.dispose();
  }

  /// Copies the loaded item into the text controllers once (edit mode).
  void _sync(ItemFormState s) {
    if (_synced || !s.isEdit) return;
    _synced = true;
    _name.text = s.name;
    _sku.text = s.sku;
    _hsn.text = s.hsnSac;
    _saleRate.text = s.saleRate;
    _purchaseRate.text = s.purchaseRate;
    _reorder.text = s.reorderLevel;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ItemFormCubit, ItemFormState>(
      listenWhen: (p, c) => p.savedItem != c.savedItem && c.savedItem != null,
      listener: (context, state) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text(AccountingStrings.itemSavedSnack)));
        context.go(
          Routes.adminAccountingItemById(state.savedItem!.id.toString()),
          extra: state.savedItem,
        );
      },
      builder: (context, state) {
        _sync(state);
        if (state.loading) {
          return Scaffold(
            appBar: AppBar(title: Text(widget.title)),
            body: const AppLoading(),
          );
        }
        final cubit = context.read<ItemFormCubit>();
        final err = state.errors;
        return Scaffold(
          appBar: AppBar(title: Text(widget.title)),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (state.failure != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      failureMessage(state.failure!),
                      key: const Key('item_form_error'),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                _section(context, AccountingStrings.itemSectionBasics),
                SegmentedButton<String>(
                  key: const Key('item_kind_segments'),
                  segments: const [
                    ButtonSegment(
                      value: 'goods',
                      label: Text(AccountingStrings.itemKindGoods),
                    ),
                    ButtonSegment(
                      value: 'service',
                      label: Text(AccountingStrings.itemKindService),
                    ),
                  ],
                  selected: {state.kind},
                  onSelectionChanged: state.kindLocked
                      ? null
                      : (v) => cubit.kindChanged(v.first),
                ),
                const SizedBox(height: 16),
                _field(
                  const Key('item_name_field'),
                  _name,
                  '${AccountingStrings.itemNameLabel} *',
                  cubit.nameChanged,
                  err['name'],
                ),
                _field(
                  const Key('item_sku_field'),
                  _sku,
                  AccountingStrings.itemSkuLabel,
                  cubit.skuChanged,
                  err['sku'],
                ),
                _field(
                  const Key('item_hsn_field'),
                  _hsn,
                  AccountingStrings.itemHsnSacLabel,
                  cubit.hsnSacChanged,
                  err['hsnSac'],
                ),
                ItemCategoryDropdown(
                  value: state.categoryId,
                  onChanged: (c) => cubit.categoryChanged(c?.id),
                ),
                const SizedBox(height: 16),
                UomPickerField(
                  value: state.uom,
                  enabled: !state.uomLocked,
                  errorText: err['uom'],
                  onChanged: cubit.uomChanged,
                ),
                const SizedBox(height: 16),
                _section(context, AccountingStrings.itemSectionPricing),
                _field(
                  const Key('item_sale_rate_field'),
                  _saleRate,
                  AccountingStrings.itemSaleRateLabel,
                  cubit.saleRateChanged,
                  err['saleRate'],
                  number: true,
                ),
                _field(
                  const Key('item_purchase_rate_field'),
                  _purchaseRate,
                  AccountingStrings.itemPurchaseRateLabel,
                  cubit.purchaseRateChanged,
                  err['purchaseRate'],
                  number: true,
                ),
                DropdownButtonFormField<int?>(
                  key: const Key('item_tax_code_dropdown'),
                  initialValue:
                      state.taxCodes.any((t) => int.tryParse(t.id) == state.taxCodeId)
                      ? state.taxCodeId
                      : null,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    labelText: AccountingStrings.itemTaxCodeLabel,
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    const DropdownMenuItem<int?>(
                      value: null,
                      child: Text(AccountingStrings.itemNoTaxCode),
                    ),
                    for (final t in state.taxCodes)
                      DropdownMenuItem<int?>(
                        value: int.tryParse(t.id),
                        child: Text('${t.code} · ${t.name}'),
                      ),
                  ],
                  onChanged: cubit.taxCodeChanged,
                ),
                const SizedBox(height: 16),
                _section(context, AccountingStrings.itemSectionAccounting),
                AccountPickerField(
                  fieldKey: const Key('item_income_account_field'),
                  value: state.incomeAccount,
                  labelText: AccountingStrings.itemIncomeAccountLabel,
                  errorText: err['incomeAccount'],
                  allowClear: false,
                  onChanged: cubit.incomeAccountChanged,
                ),
                const SizedBox(height: 16),
                AccountPickerField(
                  fieldKey: const Key('item_expense_account_field'),
                  value: state.expenseAccount,
                  labelText: AccountingStrings.itemExpenseAccountLabel,
                  errorText: err['expenseAccount'],
                  allowClear: false,
                  onChanged: cubit.expenseAccountChanged,
                ),
                const SizedBox(height: 16),
                _section(context, AccountingStrings.itemSectionInventory),
                SwitchListTile(
                  key: const Key('item_tracked_switch'),
                  contentPadding: EdgeInsets.zero,
                  title: const Text(AccountingStrings.itemTrackedLabel),
                  subtitle: state.trackingLocked
                      ? const Text(AccountingStrings.itemTrackingLocked)
                      : null,
                  value: state.inventoryTracked,
                  onChanged: state.trackingLocked ? null : cubit.trackingChanged,
                ),
                if (state.inventoryTracked) ...[
                  AccountPickerField(
                    fieldKey: const Key('item_inventory_account_field'),
                    value: state.inventoryAccount,
                    labelText: AccountingStrings.itemInventoryAccountLabel,
                    errorText: err['inventoryAccount'],
                    allowClear: false,
                    enabled: !state.trackingLocked,
                    onChanged: cubit.inventoryAccountChanged,
                  ),
                  const SizedBox(height: 16),
                  AccountPickerField(
                    fieldKey: const Key('item_cogs_account_field'),
                    value: state.cogsAccount,
                    labelText: AccountingStrings.itemCogsAccountLabel,
                    errorText: err['cogsAccount'],
                    allowClear: false,
                    enabled: !state.trackingLocked,
                    onChanged: cubit.cogsAccountChanged,
                  ),
                  const SizedBox(height: 16),
                  _field(
                    const Key('item_reorder_field'),
                    _reorder,
                    AccountingStrings.itemReorderLevelLabel,
                    cubit.reorderLevelChanged,
                    err['reorderLevel'],
                    number: true,
                  ),
                ],
                SwitchListTile(
                  key: const Key('item_active_switch'),
                  contentPadding: EdgeInsets.zero,
                  title: const Text(AccountingStrings.isActiveLabel),
                  value: state.isActive,
                  onChanged: cubit.isActiveChanged,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  key: const Key('item_save_button'),
                  onPressed: state.canSubmit ? () => cubit.submit() : null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: state.isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text(
                          AccountingStrings.save,
                          style: TextStyle(fontSize: 16),
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _section(BuildContext context, String text) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Text(text, style: Theme.of(context).textTheme.titleMedium),
  );

  Widget _field(
    Key key,
    TextEditingController controller,
    String label,
    ValueChanged<String> onChanged,
    String? error, {
    bool number = false,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: TextFormField(
      key: key,
      controller: controller,
      keyboardType: number
          ? const TextInputType.numberWithOptions(decimal: true)
          : null,
      decoration: InputDecoration(
        labelText: label,
        errorText: error,
        border: const OutlineInputBorder(),
      ),
      onChanged: onChanged,
    ),
  );
}
