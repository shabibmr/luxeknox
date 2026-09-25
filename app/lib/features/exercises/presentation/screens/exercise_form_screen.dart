import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/extensions/capability_extension.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../core/widgets/unsaved_changes_scope.dart';
import '../../domain/entities/exercise.dart';
import '../cubit/exercise_form_cubit.dart';
import '../exercise_strings.dart';

/// Create/edit form, reached only from an admin-gated entry point (K5's add
/// button, K8's edit button). Also guards itself in case it's ever reached
/// directly, since a route can be deep-linked around its caller's check.
class ExerciseFormScreen extends StatelessWidget {
  const ExerciseFormScreen({super.key, this.exercise});

  final Exercise? exercise;

  bool get isEditing => exercise != null;

  @override
  Widget build(BuildContext context) {
    final requiredSlug = isEditing ? 'exercises.update' : 'exercises.create';

    if (!context.can(requiredSlug)) {
      return Scaffold(
        appBar: AppBar(title: const Text(ExerciseStrings.formTitle)),
        body: const Center(child: Text(ExerciseStrings.noPermission)),
      );
    }

    return BlocProvider(
      create: (_) => getIt<ExerciseFormCubit>(),
      child: _ExerciseFormView(exercise: exercise),
    );
  }
}

class _ExerciseFormView extends StatefulWidget {
  const _ExerciseFormView({this.exercise});

  final Exercise? exercise;

  bool get isEditing => exercise != null;

  @override
  State<_ExerciseFormView> createState() => _ExerciseFormViewState();
}

class _ExerciseFormViewState extends State<_ExerciseFormView> {
  final _formKey = GlobalKey<FormState>();

  late final _nameController = TextEditingController(
    text: widget.exercise?.name,
  );
  late final _primaryMuscleController = TextEditingController(
    text: widget.exercise?.primaryMuscleGroup,
  );
  late final _secondaryMusclesController = TextEditingController(
    text: widget.exercise?.secondaryMuscles.join(', '),
  );
  late final _equipmentController = TextEditingController(
    text: widget.exercise?.equipmentNeeded.join(', '),
  );
  late final _instructionsController = TextEditingController(
    text: widget.exercise?.instructions,
  );
  late final _difficultyController = TextEditingController(
    text: widget.exercise?.difficultyLevel,
  );
  late final _videoUrlController = TextEditingController(
    text: widget.exercise?.videoUrl,
  );
  late final _gifUrlController = TextEditingController(
    text: widget.exercise?.gifUrl,
  );
  late bool _isActive = widget.exercise?.isActive ?? true;
  late final bool _initialIsActive = _isActive;

  bool _isDirty = false;

  @override
  void initState() {
    super.initState();
    for (final c in [
      _nameController,
      _primaryMuscleController,
      _secondaryMusclesController,
      _equipmentController,
      _instructionsController,
      _difficultyController,
      _videoUrlController,
      _gifUrlController,
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
      _primaryMuscleController,
      _secondaryMusclesController,
      _equipmentController,
      _instructionsController,
      _difficultyController,
      _videoUrlController,
      _gifUrlController,
    ]) {
      c.removeListener(_markDirty);
    }
    _nameController.dispose();
    _primaryMuscleController.dispose();
    _secondaryMusclesController.dispose();
    _equipmentController.dispose();
    _instructionsController.dispose();
    _difficultyController.dispose();
    _videoUrlController.dispose();
    _gifUrlController.dispose();
    super.dispose();
  }

  List<String> _splitList(String raw) =>
      raw.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();

  String? _urlOrNull(String raw) => raw.trim().isEmpty ? null : raw.trim();

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final exercise = Exercise(
      id: widget.exercise?.id ?? '',
      name: _nameController.text.trim(),
      primaryMuscleGroup: _primaryMuscleController.text.trim(),
      secondaryMuscles: _splitList(_secondaryMusclesController.text),
      equipmentNeeded: _splitList(_equipmentController.text),
      instructions: _instructionsController.text.trim(),
      videoUrl: _urlOrNull(_videoUrlController.text),
      gifUrl: _urlOrNull(_gifUrlController.text),
      difficultyLevel: _difficultyController.text.trim(),
      isActive: _isActive,
    );

    final cubit = context.read<ExerciseFormCubit>();
    if (widget.isEditing) {
      cubit.update(exercise);
    } else {
      cubit.create(exercise);
    }
  }

  Future<void> _confirmDeactivate() async {
    final exercise = widget.exercise;
    if (exercise == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text(ExerciseStrings.deactivateTitle),
        content: Text(ExerciseStrings.deactivateConfirm(exercise.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text(ExerciseStrings.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text(ExerciseStrings.deactivate),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    await context.read<ExerciseFormCubit>().deactivate(exercise.id);
  }

  @override
  Widget build(BuildContext context) {
    final dirty = _isDirty || _isActive != _initialIsActive;

    return BlocConsumer<ExerciseFormCubit, ExerciseFormState>(
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
                widget.isEditing
                    ? ExerciseStrings.editTitle
                    : ExerciseStrings.addTitle,
              ),
              actions: [
                if (widget.isEditing)
                  IconButton(
                    icon: const Icon(Icons.block),
                    tooltip: ExerciseStrings.deactivateTooltip,
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
                      labelText: ExerciseStrings.nameLabel,
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? ExerciseStrings.nameRequired
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _primaryMuscleController,
                    enabled: !submitting,
                    decoration: const InputDecoration(
                      labelText: ExerciseStrings.primaryMuscleLabel,
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? ExerciseStrings.primaryMuscleRequired
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _secondaryMusclesController,
                    enabled: !submitting,
                    decoration: const InputDecoration(
                      labelText: ExerciseStrings.secondaryMusclesLabel,
                      helperText: ExerciseStrings.commaSeparatedHelper,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _equipmentController,
                    enabled: !submitting,
                    decoration: const InputDecoration(
                      labelText: ExerciseStrings.equipmentNeededLabel,
                      helperText: ExerciseStrings.commaSeparatedHelper,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _difficultyController,
                    enabled: !submitting,
                    decoration: const InputDecoration(
                      labelText: ExerciseStrings.difficultyLabel,
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? ExerciseStrings.difficultyRequired
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _instructionsController,
                    enabled: !submitting,
                    minLines: 3,
                    maxLines: 8,
                    decoration: const InputDecoration(
                      labelText: ExerciseStrings.instructionsLabel,
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? ExerciseStrings.instructionsRequired
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _videoUrlController,
                    enabled: !submitting,
                    decoration: const InputDecoration(
                      labelText: ExerciseStrings.videoUrlLabel,
                    ),
                    keyboardType: TextInputType.url,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _gifUrlController,
                    enabled: !submitting,
                    decoration: const InputDecoration(
                      labelText: ExerciseStrings.gifUrlLabel,
                    ),
                    keyboardType: TextInputType.url,
                  ),
                  const SizedBox(height: 8),
                  SwitchListTile(
                    title: const Text(ExerciseStrings.active),
                    subtitle: const Text(ExerciseStrings.activeSubtitle),
                    value: _isActive,
                    onChanged: submitting
                        ? null
                        : (v) => setState(() => _isActive = v),
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
                                ? ExerciseStrings.saveChanges
                                : ExerciseStrings.createExercise,
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
