import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/extensions/capability_extension.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../core/widgets/unsaved_changes_scope.dart';
import '../../domain/entities/food.dart';
import '../cubit/food_form_cubit.dart';
import '../foods_strings.dart';

/// Create/edit form, reached only from an admin-gated entry point (the
/// library's add button, the detail screen's edit button). Also guards
/// itself in case it's ever reached directly, since a route can be
/// deep-linked around its caller's check.
class FoodFormScreen extends StatelessWidget {
  const FoodFormScreen({super.key, this.food});

  final Food? food;

  bool get isEditing => food != null;

  @override
  Widget build(BuildContext context) {
    final requiredSlug = isEditing ? 'foods.update' : 'foods.create';

    if (!context.can(requiredSlug)) {
      return Scaffold(
        appBar: AppBar(title: const Text(FoodStrings.formTitle)),
        body: const Center(child: Text(FoodStrings.noPermission)),
      );
    }

    return BlocProvider(
      create: (_) => getIt<FoodFormCubit>(),
      child: _FoodFormView(food: food),
    );
  }
}

class _FoodFormView extends StatefulWidget {
  const _FoodFormView({this.food});

  final Food? food;

  bool get isEditing => food != null;

  @override
  State<_FoodFormView> createState() => _FoodFormViewState();
}

class _FoodFormViewState extends State<_FoodFormView> {
  final _formKey = GlobalKey<FormState>();

  late final _nameController = TextEditingController(text: widget.food?.name);
  late final _servingUnitController = TextEditingController(
    text: widget.food?.servingUnit,
  );
  late final _servingSizeController = TextEditingController(
    text: widget.food?.servingSize?.toString(),
  );
  late final _caloriesController = TextEditingController(
    text: widget.food?.calories?.toString(),
  );
  late final _proteinController = TextEditingController(
    text: widget.food?.proteinGrams?.toString(),
  );
  late final _carbsController = TextEditingController(
    text: widget.food?.carbsGrams?.toString(),
  );
  late final _fatController = TextEditingController(
    text: widget.food?.fatGrams?.toString(),
  );
  late final _fiberController = TextEditingController(
    text: widget.food?.fiberGrams?.toString(),
  );
  late bool _isVerified = widget.food?.isVerified ?? true;
  late final bool _initialIsVerified = _isVerified;

  bool _isDirty = false;

  @override
  void initState() {
    super.initState();
    for (final c in [
      _nameController,
      _servingUnitController,
      _servingSizeController,
      _caloriesController,
      _proteinController,
      _carbsController,
      _fatController,
      _fiberController,
    ]) {
      c.addListener(_markDirty);
    }
  }

  void _markDirty() {
    if (!_isDirty) setState(() => _isDirty = true);
  }

  @override
  void dispose() {
    for (final c in [
      _nameController,
      _servingUnitController,
      _servingSizeController,
      _caloriesController,
      _proteinController,
      _carbsController,
      _fatController,
      _fiberController,
    ]) {
      c.removeListener(_markDirty);
    }
    _nameController.dispose();
    _servingUnitController.dispose();
    _servingSizeController.dispose();
    _caloriesController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fatController.dispose();
    _fiberController.dispose();
    super.dispose();
  }

  String? _numericValidator(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    return double.tryParse(value.trim()) == null
        ? FoodStrings.numericInvalid
        : null;
  }

  double? _parseOrNull(String raw) =>
      raw.trim().isEmpty ? null : double.tryParse(raw.trim());

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final food = Food(
      id: widget.food?.id ?? '',
      name: _nameController.text.trim(),
      servingUnit: _servingUnitController.text.trim(),
      servingSize: _parseOrNull(_servingSizeController.text),
      calories: _parseOrNull(_caloriesController.text),
      proteinGrams: _parseOrNull(_proteinController.text),
      carbsGrams: _parseOrNull(_carbsController.text),
      fatGrams: _parseOrNull(_fatController.text),
      fiberGrams: _parseOrNull(_fiberController.text),
      isVerified: _isVerified,
    );

    final cubit = context.read<FoodFormCubit>();
    if (widget.isEditing) {
      cubit.update(food);
    } else {
      cubit.create(food);
    }
  }

  Future<void> _confirmDeactivate() async {
    final food = widget.food;
    if (food == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text(FoodStrings.deactivateTitle),
        content: Text(FoodStrings.deactivateConfirm(food.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text(FoodStrings.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text(FoodStrings.deactivate),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    await context.read<FoodFormCubit>().deactivate(food.id);
  }

  @override
  Widget build(BuildContext context) {
    final dirty = _isDirty || _isVerified != _initialIsVerified;

    return BlocConsumer<FoodFormCubit, FoodFormState>(
      listenWhen: (previous, current) =>
          previous.status != current.status &&
          current.status == LoadStatus.success,
      listener: (context, state) {
        setState(() => _isDirty = false);
        Navigator.of(context).pop(true);
      },
      builder: (context, state) {
        final submitting =
            state.status == LoadStatus.loading ||
            state.status == LoadStatus.success;

        return UnsavedChangesScope(
          hasUnsavedChanges: dirty && !submitting,
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                widget.isEditing ? FoodStrings.editTitle : FoodStrings.addTitle,
              ),
              actions: [
                if (widget.isEditing)
                  IconButton(
                    icon: const Icon(Icons.block),
                    tooltip: FoodStrings.deactivateTooltip,
                    onPressed: submitting ? null : _confirmDeactivate,
                  ),
              ],
            ),
            body: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  if (state.status == LoadStatus.failure &&
                      state.failure != null) ...[
                    MaterialBanner(
                      content: Text(failureMessage(state.failure!)),
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.errorContainer,
                      actions: const [SizedBox.shrink()],
                    ),
                    const SizedBox(height: 16),
                  ],
                  TextFormField(
                    controller: _nameController,
                    enabled: !submitting,
                    decoration: const InputDecoration(
                      labelText: FoodStrings.nameLabel,
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? FoodStrings.nameRequired
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _servingUnitController,
                    enabled: !submitting,
                    decoration: const InputDecoration(
                      labelText: FoodStrings.servingUnitLabel,
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? FoodStrings.servingUnitRequired
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _servingSizeController,
                    enabled: !submitting,
                    decoration: const InputDecoration(
                      labelText: FoodStrings.servingSizeLabel,
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: _numericValidator,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _caloriesController,
                    enabled: !submitting,
                    decoration: const InputDecoration(
                      labelText: FoodStrings.caloriesLabel,
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: _numericValidator,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _proteinController,
                    enabled: !submitting,
                    decoration: const InputDecoration(
                      labelText: FoodStrings.proteinLabel,
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: _numericValidator,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _carbsController,
                    enabled: !submitting,
                    decoration: const InputDecoration(
                      labelText: FoodStrings.carbsLabel,
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: _numericValidator,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _fatController,
                    enabled: !submitting,
                    decoration: const InputDecoration(
                      labelText: FoodStrings.fatLabel,
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: _numericValidator,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _fiberController,
                    enabled: !submitting,
                    decoration: const InputDecoration(
                      labelText: FoodStrings.fiberLabel,
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: _numericValidator,
                  ),
                  const SizedBox(height: 8),
                  SwitchListTile(
                    title: const Text(FoodStrings.verified),
                    subtitle: const Text(FoodStrings.verifiedSubtitle),
                    value: _isVerified,
                    onChanged: submitting
                        ? null
                        : (v) => setState(() => _isVerified = v),
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: submitting ? null : _submit,
                    child: submitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(
                            widget.isEditing
                                ? FoodStrings.saveChanges
                                : FoodStrings.createFood,
                          ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
