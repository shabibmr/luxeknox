import 'package:flutter/material.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/widgets/app_picker_form_field.dart';
import '../../../../core/widgets/app_picker_sheet.dart';
import '../../../../core/widgets/app_status_chip.dart';
import '../../domain/entities/item.dart';
import '../../domain/usecases/get_items_usecase.dart';
import '../accounting_strings.dart';

/// Opens a searchable bottom sheet (debounced, by name or code) to pick an
/// [Item]. Inactive items are excluded unless [activeOnly] is false.
Future<Item?> showItemSearchSheet(
  BuildContext context, {
  bool activeOnly = true,
  String? kind,
  GetItemsUseCase? getItems,
}) {
  return showModalBottomSheet<Item>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => ItemSearchSheet(
      activeOnly: activeOnly,
      kind: kind,
      getItems: getItems,
    ),
  );
}

/// Bottom sheet widget for searching and picking an [Item].
class ItemSearchSheet extends StatelessWidget {
  const ItemSearchSheet({
    super.key,
    this.activeOnly = true,
    this.kind,
    this.getItems,
  });

  final bool activeOnly;
  final String? kind;
  final GetItemsUseCase? getItems;

  @override
  Widget build(BuildContext context) {
    final useCase = getItems ?? getIt<GetItemsUseCase>();
    return AppPagedPickerSheet<Item>(
      searchLabel: AccountingStrings.searchItems,
      searchFieldKey: const Key('item_search_field'),
      emptyMessage: AccountingStrings.noneFound,
      retryLabel: AccountingStrings.retry,
      heightFactor: 0.85,
      autofocus: true,
      fetcher: ({cursor, query}) {
        final trimmed = query?.trim();
        return useCase(
          GetItemsParams(
            limit: 50,
            offset: cursor == null ? null : int.tryParse(cursor),
            kind: kind,
            isActive: activeOnly ? true : null,
            search: (trimmed == null || trimmed.isEmpty) ? null : trimmed,
          ),
        );
      },
      itemBuilder: (context, item) => ListTile(
        key: Key('item_option_${item.id}'),
        title: Text(item.name, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Wrap(
            spacing: 6,
            runSpacing: 4,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              if (item.sku != null)
                Text(item.sku!, style: Theme.of(context).textTheme.bodySmall),
              AppStatusChip(label: item.kind, color: Colors.blueGrey),
              if (!item.isActive)
                const AppStatusChip(
                  label: AccountingStrings.inactiveBadge,
                  color: Colors.grey,
                ),
            ],
          ),
        ),
        onTap: () => Navigator.of(context).pop(item),
      ),
    );
  }
}

/// A form field for selecting an [Item] via the search sheet.
class ItemSearchField extends StatelessWidget {
  const ItemSearchField({
    super.key,
    this.value,
    this.onChanged,
    this.activeOnly = true,
    this.kind,
    this.labelText = AccountingStrings.itemLabel,
    this.hintText = AccountingStrings.selectItem,
    this.errorText,
    this.enabled = true,
    this.allowClear = true,
    this.fieldKey,
    this.getItems,
  });

  final Item? value;
  final ValueChanged<Item?>? onChanged;
  final bool activeOnly;
  final String? kind;
  final String labelText;
  final String hintText;
  final String? errorText;
  final bool enabled;
  final bool allowClear;
  final Key? fieldKey;
  final GetItemsUseCase? getItems;

  @override
  Widget build(BuildContext context) {
    return AppPickerFormField<Item>(
      fieldKey: fieldKey,
      value: value,
      labelText: labelText,
      hintText: hintText,
      errorText: errorText,
      enabled: enabled,
      allowClear: allowClear,
      labelBuilder: (item) => item.name,
      onPick: (ctx) => showItemSearchSheet(
        ctx,
        activeOnly: activeOnly,
        kind: kind,
        getItems: getItems,
      ),
      onChanged: onChanged ?? (_) {},
    );
  }
}
