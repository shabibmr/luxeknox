import 'package:flutter/material.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/widgets/app_picker_form_field.dart';
import '../../../../core/widgets/app_picker_sheet.dart';
import '../../../../core/widgets/app_status_chip.dart';
import '../../domain/entities/vendor.dart';
import '../../domain/usecases/get_vendors_usecase.dart';
import '../accounting_strings.dart';

/// Opens a searchable, paginated bottom sheet to pick a [Vendor].
///
/// Inactive vendors stay visible with an [AccountingStrings.inactiveBadge]
/// chip, cannot be selected, and show an explanatory snackbar if tapped.
Future<Vendor?> showVendorPickerSheet(
  BuildContext context, {
  GetVendorsUseCase? getVendors,
}) {
  return showModalBottomSheet<Vendor>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => VendorPickerSheet(getVendors: getVendors),
  );
}

/// Bottom sheet widget for searching and picking a [Vendor].
class VendorPickerSheet extends StatelessWidget {
  const VendorPickerSheet({
    super.key,
    this.getVendors,
  });

  final GetVendorsUseCase? getVendors;

  @override
  Widget build(BuildContext context) {
    final useCase = getVendors ?? getIt<GetVendorsUseCase>();
    return AppPagedPickerSheet<Vendor>(
      searchLabel: AccountingStrings.searchVendors,
      searchFieldKey: const Key('vendor_picker_search_field'),
      emptyMessage: AccountingStrings.noneFound,
      retryLabel: AccountingStrings.retry,
      heightFactor: 0.85,
      autofocus: true,
      fetcher: ({cursor, query}) {
        final trimmed = query?.trim();
        return useCase(
          GetVendorsParams(
            limit: 50,
            offset: cursor == null ? null : int.tryParse(cursor),
            // Include inactive so historical names remain visible.
            isActive: null,
            search: (trimmed == null || trimmed.isEmpty) ? null : trimmed,
          ),
        );
      },
      itemBuilder: (context, vendor) {
        final isSelectable = vendor.isActive;
        final subtitleChildren = <Widget>[
          if (vendor.phone != null && vendor.phone!.isNotEmpty)
            Text(vendor.phone!, style: Theme.of(context).textTheme.bodySmall),
          if (vendor.taxNumber != null && vendor.taxNumber!.isNotEmpty)
            Text(
              vendor.taxNumber!,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          if (!vendor.isActive)
            const AppStatusChip(
              label: AccountingStrings.inactiveBadge,
              color: Colors.grey,
            ),
        ];

        void showInactiveSnackBar() {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(AccountingStrings.cannotPickInactiveVendor),
            ),
          );
        }

        return ListTile(
          key: Key('vendor_option_${vendor.id}'),
          title: Text(
            vendor.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: isSelectable
                ? null
                : TextStyle(
                    color: Theme.of(context).disabledColor,
                  ),
          ),
          subtitle: subtitleChildren.isEmpty
              ? null
              : Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: subtitleChildren,
                  ),
                ),
          onTap: isSelectable
              ? () => Navigator.of(context).pop(vendor)
              : showInactiveSnackBar,
        );
      },
    );
  }
}

/// A form field for selecting a [Vendor] via [showVendorPickerSheet].
class VendorPickerField extends StatelessWidget {
  const VendorPickerField({
    super.key,
    this.value,
    this.onChanged,
    this.labelText = AccountingStrings.vendorLabel,
    this.hintText = AccountingStrings.selectVendor,
    this.errorText,
    this.enabled = true,
    this.allowClear = true,
    this.fieldKey,
    this.getVendors,
  });

  final Vendor? value;
  final ValueChanged<Vendor?>? onChanged;
  final String labelText;
  final String hintText;
  final String? errorText;
  final bool enabled;
  final bool allowClear;
  final Key? fieldKey;
  final GetVendorsUseCase? getVendors;

  @override
  Widget build(BuildContext context) {
    return AppPickerFormField<Vendor>(
      fieldKey: fieldKey,
      value: value,
      labelText: labelText,
      hintText: hintText,
      errorText: errorText,
      enabled: enabled,
      allowClear: allowClear,
      labelBuilder: (vendor) => vendor.name,
      onPick: (ctx) => showVendorPickerSheet(ctx, getVendors: getVendors),
      onChanged: onChanged ?? (_) {},
    );
  }
}
