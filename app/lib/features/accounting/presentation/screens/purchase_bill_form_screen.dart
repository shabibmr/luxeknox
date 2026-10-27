import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/extensions/capability_extension.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../core/router/routes.dart';
import '../../domain/entities/account.dart';
import '../../domain/entities/item.dart';
import '../../domain/entities/tax_code.dart';
import '../../domain/entities/vendor.dart';
import '../../../../core/widgets/app_currency_field.dart';
import '../../../../core/widgets/app_currency_text.dart';
import '../accounting_strings.dart';
import '../cubit/purchase_bill_form_cubit.dart';
import '../widgets/account_picker_sheet.dart';
import '../widgets/item_search_field.dart';
import '../widgets/vendor_picker_sheet.dart';

class PurchaseBillFormScreen extends StatelessWidget {
  const PurchaseBillFormScreen({
    super.key,
    this.cubit,
  });

  final PurchaseBillFormCubit? cubit;

  @override
  Widget build(BuildContext context) {
    if (!context.can('accounting.purchases_write')) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(AccountingStrings.createBillTitle),
        ),
        body: const Center(
          child: Text(AccountingStrings.noPermission),
        ),
      );
    }

    if (cubit != null) {
      return BlocProvider<PurchaseBillFormCubit>.value(
        value: cubit!,
        child: const _PurchaseBillFormView(),
      );
    }

    return BlocProvider<PurchaseBillFormCubit>(
      create: (_) => getIt<PurchaseBillFormCubit>()..loadDependencies(),
      child: const _PurchaseBillFormView(),
    );
  }
}

class _PurchaseBillFormView extends StatelessWidget {
  const _PurchaseBillFormView();

  static String _formatDate(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PurchaseBillFormCubit, PurchaseBillFormState>(
      listenWhen: (previous, current) =>
          previous.status != current.status &&
          (current.status == LoadStatus.success ||
              current.status == LoadStatus.failure),
      listener: (context, state) {
        if (state.status == LoadStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.createdBill?.status == 'posted'
                    ? AccountingStrings.billPostedSuccess
                    : AccountingStrings.billDraftSavedSuccess,
              ),
            ),
          );
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop(state.createdBill);
          } else if (state.createdBill != null) {
            try {
              context.pushReplacement(
                Routes.adminAccountingBillById(state.createdBill!.id),
              );
            } catch (_) {}
          }
        } else if (state.status == LoadStatus.failure && state.failure != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(failureMessage(state.failure!)),
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(AccountingStrings.createBillTitle),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                VendorPickerField(
                  fieldKey: const Key('vendor_picker_field'),
                  value: (state.vendorId == null || state.vendorId!.isEmpty)
                      ? null
                      : Vendor(
                          id: state.vendorId!,
                          name: state.vendorName ?? state.vendorId!,
                        ),
                  onChanged: (vendor) {
                    final cubit = context.read<PurchaseBillFormCubit>();
                    if (vendor == null) {
                      cubit.setVendor('', null);
                    } else {
                      cubit.setVendor(vendor.id, vendor.name);
                    }
                  },
                ),
                const SizedBox(height: 16),

                TextFormField(
                  key: const Key('supplier_invoice_no_field'),
                  initialValue: state.supplierInvoiceNo,
                  decoration: const InputDecoration(
                    labelText: AccountingStrings.supplierInvoiceNoLabel,
                    prefixIcon: Icon(Icons.receipt_long),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (val) => context
                      .read<PurchaseBillFormCubit>()
                      .setSupplierInvoiceNo(val),
                ),
                const SizedBox(height: 16),

                // Bill Date and Due Date Pickers
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        key: const Key('bill_date_picker'),
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: state.billDate,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null && context.mounted) {
                            context
                                .read<PurchaseBillFormCubit>()
                                .setBillDate(picked);
                          }
                        },
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: AccountingStrings.billDateLabel,
                            suffixIcon: Icon(Icons.calendar_today),
                            border: OutlineInputBorder(),
                          ),
                          child: Text(_formatDate(state.billDate)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: InkWell(
                        key: const Key('due_date_picker'),
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: state.dueDate ??
                                state.billDate.add(const Duration(days: 30)),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null && context.mounted) {
                            context
                                .read<PurchaseBillFormCubit>()
                                .setDueDate(picked);
                          }
                        },
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: AccountingStrings.dueDateLabel,
                            suffixIcon: Icon(Icons.event),
                            border: OutlineInputBorder(),
                          ),
                          child: Text(
                            state.dueDate != null
                                ? _formatDate(state.dueDate!)
                                : 'No Due Date',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Line Items Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Line Items (${state.lines.length})',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    OutlinedButton.icon(
                      key: const Key('add_line_button'),
                      icon: const Icon(Icons.add),
                      label: const Text(AccountingStrings.addLine),
                      onPressed: () =>
                          context.read<PurchaseBillFormCubit>().addLine(),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Dynamic Line Items List
                for (var i = 0; i < state.lines.length; i++)
                  _PurchaseBillLineItem(
                    key: ValueKey('purchase_bill_line_$i'),
                    index: i,
                    line: state.lines[i],
                    availableTaxCodes: state.availableTaxCodes,
                    canDelete: state.lines.length > 1,
                    onItemChanged: (item) => context
                        .read<PurchaseBillFormCubit>()
                        .setLineItem(i, item),
                    onAccountChanged: (account) => context
                        .read<PurchaseBillFormCubit>()
                        .setLineAccount(i, account),
                    onDescriptionChanged: (desc) => context
                        .read<PurchaseBillFormCubit>()
                        .updateLine(i, description: desc),
                    onQuantityChanged: (qty) => context
                        .read<PurchaseBillFormCubit>()
                        .updateLine(i, quantity: qty),
                    onRateChanged: (rate) => context
                        .read<PurchaseBillFormCubit>()
                        .updateLine(i, rate: rate),
                    onTaxCodeChanged: (taxCode) => context
                        .read<PurchaseBillFormCubit>()
                        .setLineTaxCode(i, taxCode),
                    onDelete: () =>
                        context.read<PurchaseBillFormCubit>().removeLine(i),
                  ),
                const SizedBox(height: 16),

                // Live Subtotal / Tax / Total Summary Card
                Card(
                  key: const Key('preview_summary_card'),
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              AccountingStrings.subtotalLabel,
                              style: TextStyle(fontSize: 14),
                            ),
                            AppCurrencyText(
                              state.subtotal.toString(),
                              key: const Key('subtotal_amount'),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              AccountingStrings.taxAmountLabel,
                              style: TextStyle(fontSize: 14),
                            ),
                            AppCurrencyText(
                              state.taxAmount.toString(),
                              key: const Key('tax_amount'),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              AccountingStrings.totalAmountLabel,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            AppCurrencyText(
                              state.totalAmount.toString(),
                              key: const Key('total_amount'),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Save buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        key: const Key('save_draft_button'),
                        onPressed: state.canSubmit
                            ? () =>
                                context.read<PurchaseBillFormCubit>().saveDraft()
                            : null,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text(AccountingStrings.saveDraft),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        key: const Key('submit_bill_button'),
                        onPressed: state.canSubmit
                            ? () => context
                                .read<PurchaseBillFormCubit>()
                                .saveAndPost()
                            : null,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: state.isSubmitting
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text(AccountingStrings.saveAndPost),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _PurchaseBillLineItem extends StatefulWidget {
  const _PurchaseBillLineItem({
    super.key,
    required this.index,
    required this.line,
    required this.availableTaxCodes,
    required this.canDelete,
    required this.onItemChanged,
    required this.onAccountChanged,
    required this.onDescriptionChanged,
    required this.onQuantityChanged,
    required this.onRateChanged,
    required this.onTaxCodeChanged,
    required this.onDelete,
  });

  final int index;
  final PurchaseBillLineDraft line;
  final List<TaxCode> availableTaxCodes;
  final bool canDelete;
  final ValueChanged<Item?> onItemChanged;
  final ValueChanged<Account?> onAccountChanged;
  final ValueChanged<String> onDescriptionChanged;
  final ValueChanged<String> onQuantityChanged;
  final ValueChanged<String> onRateChanged;
  final ValueChanged<TaxCode?> onTaxCodeChanged;
  final VoidCallback onDelete;

  @override
  State<_PurchaseBillLineItem> createState() => _PurchaseBillLineItemState();
}

class _PurchaseBillLineItemState extends State<_PurchaseBillLineItem> {
  late final TextEditingController _descController;
  late final TextEditingController _qtyController;
  late final TextEditingController _rateController;

  @override
  void initState() {
    super.initState();
    _descController = TextEditingController(text: widget.line.description);
    _qtyController = TextEditingController(text: widget.line.quantity);
    _rateController = TextEditingController(text: widget.line.rate);
  }

  @override
  void didUpdateWidget(covariant _PurchaseBillLineItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.line.description != _descController.text) {
      _descController.text = widget.line.description;
    }
    if (widget.line.quantity != _qtyController.text) {
      _qtyController.text = widget.line.quantity;
    }
    if (widget.line.rate != _rateController.text) {
      _rateController.text = widget.line.rate;
    }
  }

  @override
  void dispose() {
    _descController.dispose();
    _qtyController.dispose();
    _rateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final index = widget.index;
    final line = widget.line;

    final selectedAccount = line.accountId != null
        ? Account(
            id: line.accountId!,
            name: line.accountName ?? line.accountId!,
            type: 'expense',
          )
        : null;

    final selectedItem = line.itemId == null
        ? null
        : Item(
            id: int.tryParse(line.itemId!) ?? 0,
            name: line.itemName ?? line.itemId!,
            kind: line.inventoryTracked ? 'goods' : 'service',
            uomId: 0,
            uomCode: line.uomCode ?? '',
            uomDecimalPlaces: line.uomDecimalPlaces,
            incomeAccountId: 0,
            expenseAccountId: 0,
            inventoryTracked: line.inventoryTracked,
          );
    final qtyPattern = line.uomDecimalPlaces <= 0
        ? RegExp(r'^\d*$')
        : RegExp('^\\d*\\.?\\d{0,${line.uomDecimalPlaces}}\$');

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Line #${index + 1}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  key: Key('remove_line_button_$index'),
                  icon: const Icon(Icons.delete_outline),
                  tooltip: AccountingStrings.removeLine,
                  onPressed: widget.canDelete ? widget.onDelete : null,
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Item picker
            ItemSearchField(
              key: Key('item_picker_$index'),
              fieldKey: Key('item_picker_field_$index'),
              value: selectedItem,
              kind: null,
              onChanged: widget.onItemChanged,
            ),
            const SizedBox(height: 8),

            // Account picker (the server routes tracked items itself)
            if (!line.inventoryTracked) ...[
              AccountPickerField(
                key: Key('account_picker_$index'),
                fieldKey: Key('account_picker_field_$index'),
                value: selectedAccount,
                activeOnly: true,
                onChanged: widget.onAccountChanged,
              ),
              const SizedBox(height: 8),
            ],

            // Description
            TextFormField(
              key: Key('description_field_$index'),
              controller: _descController,
              decoration: const InputDecoration(
                labelText: AccountingStrings.descriptionLabel,
                border: OutlineInputBorder(),
              ),
              onChanged: widget.onDescriptionChanged,
            ),
            const SizedBox(height: 8),

            // Quantity & Rate Row
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    key: Key('quantity_field_$index'),
                    controller: _qtyController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(qtyPattern),
                    ],
                    decoration: InputDecoration(
                      labelText: AccountingStrings.quantityLabel,
                      suffixText: line.uomCode,
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: widget.onQuantityChanged,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppCurrencyField(
                    key: Key('rate_field_$index'),
                    controller: _rateController,
                    label: AccountingStrings.rateLabel,
                    helperText: AccountingStrings.rateExcludesTaxHint,
                    onChanged: widget.onRateChanged,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Tax Code Picker
            DropdownButtonFormField<String>(
              key: Key('tax_code_field_$index'),
              initialValue: line.taxCodeId,
              decoration: const InputDecoration(
                labelText: AccountingStrings.taxCodeLabel,
                border: OutlineInputBorder(),
              ),
              hint: const Text('None (0%)'),
              items: [
                const DropdownMenuItem<String>(
                  value: null,
                  child: Text('None (0%)'),
                ),
                for (final tc in widget.availableTaxCodes)
                  DropdownMenuItem<String>(
                    value: tc.id,
                    child: Text('${tc.name} (${tc.ratePercent}%)'),
                  ),
              ],
              onChanged: (val) {
                if (val == null) {
                  widget.onTaxCodeChanged(null);
                } else {
                  final tc = widget.availableTaxCodes
                      .cast<TaxCode?>()
                      .firstWhere((c) => c?.id == val, orElse: () => null);
                  widget.onTaxCodeChanged(tc);
                }
              },
            ),
            const SizedBox(height: 8),

            // Line preview summary
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text(
                  'Net: ',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                AppCurrencyText(
                  line.netAmount.toString(),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Tax: ',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                AppCurrencyText(
                  line.taxAmount.toString(),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Total: ',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                AppCurrencyText(
                  line.totalAmount.toString(),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
