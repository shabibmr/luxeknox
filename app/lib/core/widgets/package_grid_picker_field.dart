import 'package:flutter/material.dart';

/// One selectable package in [PackageGridPickerField].
class PackageGridOption<T> {
  const PackageGridOption({
    required this.value,
    required this.title,
    required this.subtitle,
    required this.isCouple,
  });

  final T value;
  final String title;
  final String subtitle;
  final bool isCouple;
}

/// Dropdown-looking field that opens a sheet showing packages in a grid:
/// single packages on one side, couple packages on the other.
class PackageGridPickerField<T> extends StatelessWidget {
  const PackageGridPickerField({
    super.key,
    required this.options,
    required this.value,
    required this.onChanged,
    this.labelText,
    this.hintText,
    this.enabled = true,
  });

  final List<PackageGridOption<T>> options;
  final T? value;
  final ValueChanged<T> onChanged;
  final String? labelText;
  final String? hintText;
  final bool enabled;

  PackageGridOption<T>? get _selected {
    for (final o in options) {
      if (o.value == value) return o;
    }
    return null;
  }

  Future<void> _open(BuildContext context) async {
    final picked = await showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => _PackageGridSheet<T>(options: options, selected: value),
    );
    if (picked != null) onChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    final selected = _selected;
    return InkWell(
      onTap: enabled ? () => _open(context) : null,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          border: const OutlineInputBorder(),
          enabled: enabled,
          suffixIcon: const Icon(Icons.arrow_drop_down),
        ),
        isEmpty: selected == null,
        child: selected == null
            ? null
            : Text(
                '${selected.title} · ${selected.subtitle}',
                overflow: TextOverflow.ellipsis,
              ),
      ),
    );
  }
}

class _PackageGridSheet<T> extends StatelessWidget {
  const _PackageGridSheet({required this.options, required this.selected});

  final List<PackageGridOption<T>> options;
  final T? selected;

  @override
  Widget build(BuildContext context) {
    final single = options.where((o) => !o.isCouple).toList();
    final couple = options.where((o) => o.isCouple).toList();
    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.75,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _Column<T>(
                  heading: 'Single',
                  items: single,
                  selected: selected,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _Column<T>(
                  heading: 'Couple',
                  items: couple,
                  selected: selected,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Column<T> extends StatelessWidget {
  const _Column({
    required this.heading,
    required this.items,
    required this.selected,
  });

  final String heading;
  final List<PackageGridOption<T>> items;
  final T? selected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(heading, style: theme.textTheme.titleSmall),
        const SizedBox(height: 8),
        if (items.isEmpty)
          Text('None', style: theme.textTheme.bodySmall)
        else
          for (final o in items)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Card(
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: o.value == selected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.outlineVariant,
                    width: o.value == selected ? 2 : 1,
                  ),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => Navigator.of(context).pop(o.value),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(o.title, style: theme.textTheme.titleSmall),
                        const SizedBox(height: 4),
                        Text(o.subtitle, style: theme.textTheme.bodySmall),
                      ],
                    ),
                  ),
                ),
              ),
            ),
      ],
    );
  }
}
