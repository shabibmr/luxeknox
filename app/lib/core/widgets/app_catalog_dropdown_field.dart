import 'package:flutter/material.dart';

import 'picker_field_states.dart';

/// A dropdown field backed by a short, unpaged catalog that is loaded once
/// and filtered/selected client-side (e.g. facilities, schedule types).
///
/// Handles the load/error/empty/loaded state machine and delegates catalog
/// fetching to [load]. Callers only provide how to fetch, id, and label.
class AppCatalogDropdownField<T> extends StatefulWidget {
  const AppCatalogDropdownField({
    super.key,
    required this.label,
    required this.load,
    required this.itemId,
    required this.itemLabel,
    required this.onChanged,
    this.value,
    this.errorText,
    this.enabled = true,
    this.placeholder,
    this.emptyMessage,
    this.fieldKey,
  });

  /// Field label, shown on the skeleton, retry, empty, and loaded states.
  final String label;

  /// Fetches the full catalog. Should throw or return a [Future] that
  /// resolves to an error message on failure.
  final Future<List<T>> Function() load;

  final String Function(T item) itemId;
  final String Function(T item) itemLabel;
  final ValueChanged<T?> onChanged;
  final T? value;
  final String? errorText;
  final bool enabled;
  final String? placeholder;
  final String? emptyMessage;
  final Key? fieldKey;

  @override
  State<AppCatalogDropdownField<T>> createState() =>
      _AppCatalogDropdownFieldState<T>();
}

class _AppCatalogDropdownFieldState<T>
    extends State<AppCatalogDropdownField<T>> {
  bool _loading = true;
  String? _loadError;
  List<T> _items = const [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _loadError = null;
    });
    try {
      final items = await widget.load();
      if (!mounted) return;
      setState(() {
        _loading = false;
        _items = items;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _loadError = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return PickerFieldSkeleton(label: widget.label);
    }
    if (_loadError != null) {
      return PickerFieldRetry(
        label: widget.label,
        message: _loadError!,
        onRetry: _load,
      );
    }
    if (_items.isEmpty) {
      return InputDecorator(
        decoration: InputDecoration(labelText: widget.label),
        child: Text(widget.emptyMessage ?? ''),
      );
    }
    return DropdownButtonFormField<String>(
      key: widget.fieldKey,
      initialValue: widget.value != null ? widget.itemId(widget.value as T) : null,
      decoration: InputDecoration(
        labelText: widget.label,
        errorText: widget.errorText,
      ),
      hint: widget.placeholder == null ? null : Text(widget.placeholder!),
      items: [
        for (final item in _items)
          DropdownMenuItem(
            value: widget.itemId(item),
            child: Text(widget.itemLabel(item)),
          ),
      ],
      onChanged: widget.enabled
          ? (id) => widget.onChanged(
              id == null
                  ? null
                  : _items.firstWhere((i) => widget.itemId(i) == id),
            )
          : null,
    );
  }
}
