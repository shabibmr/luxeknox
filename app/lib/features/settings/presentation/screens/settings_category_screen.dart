import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../core/widgets/app_empty_view.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../domain/entities/setting_category.dart';
import '../cubit/settings_category_cubit.dart';
import '../settings_strings.dart';

/// Admin editor for the settings supported by the backend catalogue.
class SettingsCategoryScreen extends StatelessWidget {
  const SettingsCategoryScreen({super.key, required this.category});

  final String category;

  @override
  Widget build(BuildContext context) {
    final parsed = parseSettingCategory(category);
    if (parsed == null) {
      return Scaffold(
        appBar: AppBar(title: const Text(SettingsStrings.hubTitle)),
        body: const AppErrorView(message: SettingsStrings.unknownCategory),
      );
    }
    if (!parsed.isImplemented) {
      return Scaffold(
        appBar: AppBar(title: Text(parsed.label)),
        body: const AppEmptyView(
          message: 'No configurable settings are available in this category yet.',
        ),
      );
    }
    return BlocProvider(
      create: (_) => getIt<SettingsCategoryCubit>()..load(parsed),
      child: _SettingsCategoryBody(category: parsed),
    );
  }
}

class _SettingsCategoryBody extends StatelessWidget {
  const _SettingsCategoryBody({required this.category});

  final SettingCategory category;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(category.label)),
      body: BlocConsumer<SettingsCategoryCubit, SettingsCategoryState>(
        listenWhen: (previous, next) =>
            (next.saved && !previous.saved) ||
            (next.failure != previous.failure && next.failure != null),
        listener: (context, state) {
          if (state.saved) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text(SettingsStrings.saved)),
            );
            return;
          }
          final failure = state.failure;
          if (failure != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(failureMessage(failure))),
            );
          }
        },
        builder: (context, state) {
          if (state.status == LoadStatus.loading && state.items.isEmpty) {
            return const AppLoading();
          }
          if (state.status == LoadStatus.failure && state.items.isEmpty) {
            return AppErrorView(
              message: state.failure == null
                  ? ''
                  : failureMessage(state.failure!),
              onRetry: () =>
                  context.read<SettingsCategoryCubit>().load(category),
            );
          }
          final items = state.items;
          if (items.isEmpty) {
            return const AppEmptyView(message: SettingsStrings.emptyCategory);
          }
          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: items.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return _SettingRow(
                      key: ValueKey(item.key),
                      settingKey: item.key,
                      value: item.value,
                      enabled: !state.saving,
                      onChanged: (value) => context
                          .read<SettingsCategoryCubit>()
                          .editValue(item.key, value),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: state.saving
                            ? null
                            : () async {
                                if (!state.dirty) {
                                  context
                                      .read<SettingsCategoryCubit>()
                                      .load(category);
                                  return;
                                }
                                final shouldDiscard = await showDialog<bool>(
                                  context: context,
                                  builder: (dialogContext) => AlertDialog(
                                    title: const Text('Discard changes?'),
                                    content: const Text(
                                      'Your unsaved settings changes will be lost.',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(dialogContext)
                                                .pop(false),
                                        child: const Text('Keep editing'),
                                      ),
                                      FilledButton(
                                        onPressed: () =>
                                            Navigator.of(dialogContext)
                                                .pop(true),
                                        child: const Text('Discard changes'),
                                      ),
                                    ],
                                  ),
                                );
                                if (context.mounted && shouldDiscard == true) {
                                  context
                                      .read<SettingsCategoryCubit>()
                                      .load(category);
                                }
                              },
                        child: const Text(SettingsStrings.discard),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: state.saving || !state.dirty
                            ? null
                            : () => context
                                .read<SettingsCategoryCubit>()
                                .save(),
                        child: state.saving
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(SettingsStrings.save),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SettingRow extends StatefulWidget {
  const _SettingRow({
    super.key,
    required this.settingKey,
    required this.value,
    required this.enabled,
    required this.onChanged,
  });

  final String settingKey;
  final String value;
  final bool enabled;
  final ValueChanged<String> onChanged;

  @override
  State<_SettingRow> createState() => _SettingRowState();
}

enum _SettingInputKind { text, integer, decimal, duration, boolean, choice, integerList }

class _SettingFieldDefinition {
  const _SettingFieldDefinition({
    required this.label,
    required this.description,
    required this.kind,
    this.unit,
    this.minimum,
    this.maximum,
    this.maxLength,
    this.options = const <String>[],
  });

  final String label;
  final String description;
  final _SettingInputKind kind;
  final String? unit;
  final int? minimum;
  final int? maximum;
  final int? maxLength;
  final List<String> options;
}

/// Presentation metadata mirrors the supported backend settings catalogue.
/// Persisted values remain strings so the API contract stays unchanged.
const Map<String, _SettingFieldDefinition> _settingFields = {
  'business_name': _SettingFieldDefinition(
    label: 'Business name',
    description: 'Name shown on gym documents and communications.',
    kind: _SettingInputKind.text,
    maxLength: 255,
  ),
  'timezone': _SettingFieldDefinition(
    label: 'Operating time zone',
    description: 'IANA time zone, for example Asia/Kolkata.',
    kind: _SettingInputKind.text,
    maxLength: 100,
  ),
  'default_page_size': _SettingFieldDefinition(
    label: 'Default page size',
    description: 'Number of records shown per page.',
    kind: _SettingInputKind.integer,
    minimum: 1,
    maximum: 200,
  ),
  'currency': _SettingFieldDefinition(
    label: 'Billing currency',
    description: 'Three-letter ISO 4217 currency code, for example INR.',
    kind: _SettingInputKind.text,
    maxLength: 3,
  ),
  'tax_rate_percent': _SettingFieldDefinition(
    label: 'Tax rate',
    description: 'Percentage applied to invoices.',
    kind: _SettingInputKind.decimal,
    unit: '%',
    minimum: 0,
    maximum: 100,
  ),
  'payments_activate_membership_on_partial': _SettingFieldDefinition(
    label: 'Activate membership on partial payment',
    description: 'Allow membership activation before the invoice is fully paid.',
    kind: _SettingInputKind.boolean,
  ),
  'schedule_booking_lead_time_minutes': _SettingFieldDefinition(
    label: 'Booking lead time',
    description: 'Minimum time before a session that members can book.',
    kind: _SettingInputKind.duration,
    unit: 'minutes',
    minimum: 0,
    maximum: 10080,
  ),
  'schedule_cancellation_cutoff_minutes': _SettingFieldDefinition(
    label: 'Cancellation cutoff',
    description: 'Minimum time before a session when cancellation is allowed.',
    kind: _SettingInputKind.duration,
    unit: 'minutes',
    minimum: 0,
    maximum: 10080,
  ),
  'schedule_member_booking_cap': _SettingFieldDefinition(
    label: 'Member booking limit',
    description: 'Maximum concurrent active bookings per member.',
    kind: _SettingInputKind.integer,
    minimum: 1,
    maximum: 100,
  ),
  'attendance_pass_ttl_minutes': _SettingFieldDefinition(
    label: 'Attendance pass validity',
    description: 'How long a digital attendance pass remains valid.',
    kind: _SettingInputKind.duration,
    unit: 'minutes',
    minimum: 1,
    maximum: 1440,
  ),
  'attendance_debounce_seconds': _SettingFieldDefinition(
    label: 'Duplicate check-in window',
    description: 'Ignore repeated check-ins within this time window.',
    kind: _SettingInputKind.duration,
    unit: 'seconds',
    minimum: 0,
    maximum: 86400,
  ),
  'attendance_daily_checkin_cap': _SettingFieldDefinition(
    label: 'Daily check-in limit',
    description: 'Maximum gate check-ins per member per day.',
    kind: _SettingInputKind.integer,
    minimum: 1,
    maximum: 100,
  ),
  'attendance_auto_checkout_hours': _SettingFieldDefinition(
    label: 'Automatic checkout after',
    description: 'Hours before an open gate visit is checked out automatically.',
    kind: _SettingInputKind.duration,
    unit: 'hours',
    minimum: 1,
    maximum: 168,
  ),
  'diet_adherence_formula': _SettingFieldDefinition(
    label: 'Diet adherence formula',
    description: 'Formula used to calculate diet adherence.',
    kind: _SettingInputKind.choice,
    options: ['calorie_ratio'],
  ),
  'mandatory_measurement_metrics': _SettingFieldDefinition(
    label: 'Required measurement metric IDs',
    description: 'Comma-separated positive metric IDs required in each session. Leave empty for none.',
    kind: _SettingInputKind.integerList,
  ),
};

class _SettingRowState extends State<_SettingRow> {
  late final TextEditingController _controller;

  _SettingFieldDefinition get _definition => _settingFields[widget.settingKey] ??
      _SettingFieldDefinition(
        label: _label(widget.settingKey),
        description: 'Setting value',
        kind: _SettingInputKind.text,
        maxLength: 255,
      );

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _displayValue(widget.value));
  }

  @override
  void didUpdateWidget(covariant _SettingRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value && _controller.text != _displayValue(widget.value)) {
      _controller.value = TextEditingValue(
        text: _displayValue(widget.value),
        selection: TextSelection.collapsed(offset: _displayValue(widget.value).length),
      );
    }
  }

  String _displayValue(String value) {
    if (widget.settingKey == 'mandatory_measurement_metrics') {
      try {
        final decoded = value.startsWith('[') ? value : '[]';
        final ids = (jsonDecode(decoded) as List).map((item) => item.toString());
        return ids.join(', ');
      } catch (_) {
        return value;
      }
    }
    return value;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  static String _label(String key) => key
      .split('_')
      .map((part) =>
          part.isEmpty ? part : '${part[0].toUpperCase()}${part.substring(1)}')
      .join(' ');

  String _storedValue(String value) {
    if (widget.settingKey == 'mandatory_measurement_metrics') {
      final ids = value
          .split(',')
          .map((part) => part.trim())
          .where((part) => part.isNotEmpty)
          .toList(growable: false);
      return jsonEncode(ids.map(int.parse).toList(growable: false));
    }
    return value;
  }

  void _update(String value) {
    // Only commit valid values into the shared edit state. This prevents Save
    // from sending an invalid intermediate value while the user is typing.
    if (_validate(value) != null) return;
    widget.onChanged(_storedValue(value));
  }

  String? _validate(String? raw) {
    final value = raw?.trim() ?? '';
    final definition = _definition;
    if (definition.kind == _SettingInputKind.integerList) {
      if (value.isEmpty) return null;
      final parts = value.split(',');
      for (final part in parts) {
        final id = int.tryParse(part.trim());
        if (id == null || id <= 0) return 'Enter positive metric IDs separated by commas.';
      }
      return null;
    }
    if (definition.kind == _SettingInputKind.integer ||
        definition.kind == _SettingInputKind.duration) {
      final number = int.tryParse(value);
      if (number == null) return 'Enter a whole number.';
      if (definition.minimum != null && number < definition.minimum!) {
        return 'Minimum is ${definition.minimum}.';
      }
      if (definition.maximum != null && number > definition.maximum!) {
        return 'Maximum is ${definition.maximum}.';
      }
    }
    if (definition.kind == _SettingInputKind.decimal) {
      final number = double.tryParse(value);
      if (number == null || number < (definition.minimum ?? 0) || number > (definition.maximum ?? 100)) {
        return 'Enter a value between ${definition.minimum ?? 0} and ${definition.maximum ?? 100}.';
      }
    }
    if (widget.settingKey == 'currency' && !RegExp(r'^[A-Z]{3}$').hasMatch(value)) {
      return 'Use a three-letter uppercase currency code.';
    }
    if (widget.settingKey == 'timezone' && value.isEmpty) {
      return 'Time zone is required.';
    }
    if (definition.maxLength != null && value.length > definition.maxLength!) {
      return 'Maximum ${definition.maxLength} characters.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final definition = _definition;
    switch (definition.kind) {
      case _SettingInputKind.boolean:
        return CheckboxListTile(
          value: widget.value == 'true' || widget.value == '1',
          onChanged: widget.enabled
              ? (checked) => widget.onChanged(checked == true ? 'true' : 'false')
              : null,
          title: Text(definition.label),
          subtitle: Text(definition.description),
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        );
      case _SettingInputKind.choice:
        return InputDecorator(
          decoration: InputDecoration(
            labelText: definition.label,
            helperText: definition.description,
            border: const OutlineInputBorder(),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: definition.options.contains(widget.value)
                  ? widget.value
                  : definition.options.first,
              isExpanded: true,
              onChanged: widget.enabled && definition.options.length > 1
                  ? (value) {
                      if (value != null) widget.onChanged(value);
                    }
                  : null,
              items: definition.options
                  .map((value) => DropdownMenuItem(value: value, child: Text(value)))
                  .toList(growable: false),
            ),
          ),
        );
      case _SettingInputKind.text:
      case _SettingInputKind.integer:
      case _SettingInputKind.decimal:
      case _SettingInputKind.duration:
      case _SettingInputKind.integerList:
        final numeric = definition.kind == _SettingInputKind.integer ||
            definition.kind == _SettingInputKind.duration;
        final decimal = definition.kind == _SettingInputKind.decimal;
        final integerList = definition.kind == _SettingInputKind.integerList;
        return TextFormField(
          controller: _controller,
          enabled: widget.enabled,
          keyboardType: numeric || integerList
              ? TextInputType.number
              : decimal
                  ? const TextInputType.numberWithOptions(decimal: true)
                  : TextInputType.text,
          inputFormatters: [
            if (numeric) FilteringTextInputFormatter.digitsOnly,
            if (decimal) FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
            if (integerList) FilteringTextInputFormatter.allow(RegExp(r'[\d,\s]')),
            if (widget.settingKey == 'currency') _UpperCaseTextFormatter(),
          ],
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: _validate,
          onChanged: _update,
          maxLength: definition.maxLength,
          decoration: InputDecoration(
            labelText: definition.label,
            helperText: definition.description,
            suffixText: definition.unit,
            border: const OutlineInputBorder(),
          ),
        );
    }
  }
}

/// Uppercases currency codes as the administrator types them.
class _UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return newValue.copyWith(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
      composing: TextRange.empty,
    );
  }
}
