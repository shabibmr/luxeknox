import 'package:fpdart/fpdart.dart' show Either;
import 'package:flutter/material.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/widgets/app_picker_form_field.dart';
import '../../../../core/widgets/app_picker_sheet.dart';
import '../../../../core/widgets/app_status_chip.dart';
import '../../domain/entities/item.dart';
import '../../domain/usecases/get_uoms_usecase.dart';
import '../accounting_strings.dart';

typedef UomLoader = Future<Either<Failure, List<Uom>>> Function();

Future<Either<Failure, List<Uom>>> _loadUomsFromDi() =>
    getIt<GetUomsUseCase>()(const NoParams());

/// Shows a modal bottom sheet to search and pick a [Uom].
///
/// Inactive units stay visible but cannot be selected.
Future<Uom?> showUomPickerSheet(BuildContext context, {UomLoader? loader}) {
  return showModalBottomSheet<Uom>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => UomPickerSheet(loader: loader),
  );
}

class UomPickerSheet extends StatefulWidget {
  const UomPickerSheet({super.key, this.loader});

  final UomLoader? loader;

  @override
  State<UomPickerSheet> createState() => _UomPickerSheetState();
}

class _UomPickerSheetState extends State<UomPickerSheet> {
  final _searchController = TextEditingController();
  List<Uom> _uoms = const [];
  String? _error;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final result = await (widget.loader ?? _loadUomsFromDi)();
    if (!mounted) return;
    setState(() {
      _loading = false;
      result.fold((f) => _error = failureMessage(f), (u) => _uoms = u);
    });
  }

  List<Uom> get _visible {
    final q = _searchController.text.trim().toLowerCase();
    if (q.isEmpty) return _uoms;
    return _uoms
        .where(
          (u) =>
              u.code.toLowerCase().contains(q) ||
              u.name.toLowerCase().contains(q),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return AppPickerSheet<Uom>(
      searchController: _searchController,
      searchLabel: AccountingStrings.searchUoms,
      searchFieldKey: const Key('uom_picker_search_field'),
      onSearchChanged: (_) => setState(() {}),
      isLoading: _loading,
      items: _visible,
      errorMessage: _error,
      onRetry: _load,
      emptyMessage: AccountingStrings.noneFound,
      retryLabel: AccountingStrings.retry,
      itemBuilder: (context, uom) {
        return ListTile(
          key: Key('uom_row_${uom.id}'),
          enabled: uom.isActive,
          title: Text('${uom.code} · ${uom.name}'),
          trailing: uom.isActive
              ? null
              : const AppStatusChip(
                  label: AccountingStrings.inactiveBadge,
                  color: Colors.grey,
                ),
          onTap: uom.isActive ? () => Navigator.of(context).pop(uom) : null,
        );
      },
    );
  }
}

/// Form field that opens [UomPickerSheet].
class UomPickerField extends StatelessWidget {
  const UomPickerField({
    super.key,
    this.value,
    required this.onChanged,
    this.errorText,
    this.enabled = true,
    this.loader,
  });

  final Uom? value;
  final ValueChanged<Uom?> onChanged;
  final String? errorText;
  final bool enabled;
  final UomLoader? loader;

  @override
  Widget build(BuildContext context) {
    return AppPickerFormField<Uom>(
      fieldKey: const Key('uom_picker_field'),
      value: value,
      labelText: AccountingStrings.itemUomLabel,
      hintText: AccountingStrings.itemUomLabel,
      errorText: errorText,
      enabled: enabled,
      allowClear: false,
      labelBuilder: (u) => '${u.code} · ${u.name}',
      onPick: (ctx) => showUomPickerSheet(ctx, loader: loader),
      onChanged: onChanged,
    );
  }
}
