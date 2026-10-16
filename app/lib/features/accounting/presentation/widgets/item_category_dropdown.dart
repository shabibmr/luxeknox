import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart' show Either;

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/item.dart';
import '../../domain/usecases/get_item_categories_usecase.dart';
import '../accounting_strings.dart';

typedef ItemCategoryLoader =
    Future<Either<Failure, List<ItemCategory>>> Function();

Future<Either<Failure, List<ItemCategory>>> _loadCategoriesFromDi() =>
    getIt<GetItemCategoriesUseCase>()(const NoParams());

/// Optional category dropdown. Inactive categories are listed but disabled,
/// except the currently selected one (so an existing value still displays).
class ItemCategoryDropdown extends StatefulWidget {
  const ItemCategoryDropdown({
    super.key,
    required this.value,
    required this.onChanged,
    this.enabled = true,
    this.loader,
  });

  /// Selected category id, or null for none.
  final int? value;
  final ValueChanged<ItemCategory?> onChanged;
  final bool enabled;
  final ItemCategoryLoader? loader;

  @override
  State<ItemCategoryDropdown> createState() => _ItemCategoryDropdownState();
}

class _ItemCategoryDropdownState extends State<ItemCategoryDropdown> {
  List<ItemCategory> _categories = const [];
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final result = await (widget.loader ?? _loadCategoriesFromDi)();
    if (!mounted) return;
    setState(() {
      _error = null;
      result.fold((f) => _error = failureMessage(f), (c) => _categories = c);
    });
  }

  @override
  Widget build(BuildContext context) {
    final selected = _categories.any((c) => c.id == widget.value)
        ? widget.value
        : null;
    return DropdownButtonFormField<int?>(
      key: const Key('item_category_dropdown'),
      initialValue: selected,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: AccountingStrings.itemCategoryLabel,
        border: const OutlineInputBorder(),
        errorText: _error,
      ),
      items: [
        const DropdownMenuItem<int?>(
          value: null,
          child: Text(AccountingStrings.itemCategoryNone),
        ),
        for (final c in _categories)
          DropdownMenuItem<int?>(
            value: c.id,
            enabled: c.isActive || c.id == widget.value,
            child: Text(
              c.isActive
                  ? c.name
                  : '${c.name} (${AccountingStrings.inactiveBadge})',
              overflow: TextOverflow.ellipsis,
            ),
          ),
      ],
      onChanged: widget.enabled
          ? (id) => widget.onChanged(
              id == null ? null : _categories.firstWhere((c) => c.id == id),
            )
          : null,
    );
  }
}
