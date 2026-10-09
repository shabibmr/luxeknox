import 'package:flutter/material.dart';
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

class _SettingRowState extends State<_SettingRow> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(covariant _SettingRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value && _controller.text != widget.value) {
      _controller.value = TextEditingValue(
        text: widget.value,
        selection: TextSelection.collapsed(offset: widget.value.length),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  TextInputType get _keyboardType {
    if (widget.settingKey == 'tax_rate_percent') {
      return const TextInputType.numberWithOptions(decimal: true);
    }
    const numericKeys = {
      'default_page_size',
      'schedule_booking_lead_time_minutes',
      'schedule_cancellation_cutoff_minutes',
      'schedule_member_booking_cap',
      'attendance_pass_ttl_minutes',
      'attendance_debounce_seconds',
      'attendance_daily_checkin_cap',
      'attendance_auto_checkout_hours',
    };
    return numericKeys.contains(widget.settingKey)
        ? TextInputType.number
        : TextInputType.text;
  }

  @override
  Widget build(BuildContext context) {
    final isBoolean = widget.value == 'true' || widget.value == 'false';
    if (isBoolean) {
      return SwitchListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        title: Text(_label(widget.settingKey)),
        subtitle: Text(widget.settingKey),
        value: widget.value == 'true',
        onChanged: widget.enabled
            ? (value) {
                _controller.text = value.toString();
                widget.onChanged(value.toString());
              }
            : null,
      );
    }
    return TextField(
      controller: _controller,
      enabled: widget.enabled,
      keyboardType: _keyboardType,
      decoration: InputDecoration(
        labelText: _label(widget.settingKey),
        helperText: widget.settingKey,
        border: const OutlineInputBorder(),
      ),
      onChanged: widget.onChanged,
    );
  }

  String _label(String key) => key
      .split('_')
      .map((part) =>
          part.isEmpty ? part : '${part[0].toUpperCase()}${part.substring(1)}')
      .join(' ');
}
