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

/// Generic key/value editor for a single settings category.
class SettingsCategoryScreen extends StatelessWidget {
  const SettingsCategoryScreen({super.key, required this.category});

  /// Path category segment (`general`, `booking_rules`, `gym`, …).
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

  Future<void> _addSettingDialog(BuildContext context) async {
    final cubit = context.read<SettingsCategoryCubit>();
    final keyController = TextEditingController();
    final valueController = TextEditingController();
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text(SettingsStrings.addSetting),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: keyController,
              decoration: const InputDecoration(
                labelText: SettingsStrings.settingKey,
              ),
            ),
            TextField(
              controller: valueController,
              decoration: const InputDecoration(
                labelText: SettingsStrings.settingValue,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text(SettingsStrings.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text(SettingsStrings.add),
          ),
        ],
      ),
    );
    if (result == true) {
      cubit.addSetting(keyController.text, valueController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(category.label)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addSettingDialog(context),
        child: const Icon(Icons.add),
      ),
      body: BlocConsumer<SettingsCategoryCubit, SettingsCategoryState>(
        listenWhen: (previous, next) {
          if (next.saved && !previous.saved) return true;
          return next.failure != previous.failure &&
              next.failure != null &&
              next.items.isNotEmpty &&
              next.status != LoadStatus.failure;
        },
        listener: (context, state) {
          if (state.saved) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text(SettingsStrings.saved)),
            );
            return;
          }
          final failure = state.failure;
          if (failure == null) return;
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(failureMessage(failure))));
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
          final saving = state.saving;
          if (items.isEmpty) {
            return const AppEmptyView(message: SettingsStrings.emptyCategory);
          }
          return Column(
                      children: [
                        Expanded(
                          child: ListView.separated(
                            padding: const EdgeInsets.all(16),
                            itemCount: items.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(height: 8),
                            itemBuilder: (context, index) {
                              final item = items[index];
                              return _SettingRow(
                                settingKey: item.key,
                                value: item.value,
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: FilledButton(
                            onPressed: saving
                                ? null
                                : () => context
                                      .read<SettingsCategoryCubit>()
                                      .save(),
                            child: saving
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
                    );
        },
      ),
    );
  }
}

class _SettingRow extends StatefulWidget {
  const _SettingRow({required this.settingKey, required this.value});

  final String settingKey;
  final String value;

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
      _controller.text = widget.value;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SettingsCategoryCubit>();
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        labelText: widget.settingKey,
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          tooltip: SettingsStrings.delete,
          icon: const Icon(Icons.close),
          onPressed: () => cubit.removeSetting(widget.settingKey),
        ),
      ),
      onChanged: (value) => cubit.editValue(widget.settingKey, value),
    );
  }
}
