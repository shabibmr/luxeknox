import 'package:flutter/material.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/extensions/capability_extension.dart';
import '../../../../core/widgets/unsaved_changes_scope.dart';
import '../../domain/entities/exercise.dart';
import '../../domain/usecases/create_exercise_usecase.dart';
import '../../domain/usecases/deactivate_exercise_usecase.dart';
import '../../domain/usecases/update_exercise_usecase.dart';
import '../exercise_strings.dart';

/// Create/edit form, reached only from an admin-gated entry point (K5's add
/// button, K8's edit button). Also guards itself in case it's ever reached
/// directly, since a route can be deep-linked around its caller's check.
class ExerciseFormScreen extends StatefulWidget {
  const ExerciseFormScreen({super.key, this.exercise});

  final Exercise? exercise;

  bool get isEditing => exercise != null;

  @override
  State<ExerciseFormScreen> createState() => _ExerciseFormScreenState();
}

class _ExerciseFormScreenState extends State<ExerciseFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final _createUseCase = getIt<CreateExerciseUseCase>();
  late final _updateUseCase = getIt<UpdateExerciseUseCase>();
  late final _deactivateUseCase = getIt<DeactivateExerciseUseCase>();

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

  bool _isSubmitting = false;
  bool _isDirty = false;
  String? _errorMessage;

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

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

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

    final result = widget.isEditing
        ? await _updateUseCase(exercise)
        : await _createUseCase(exercise);

    if (!mounted) return;
    result.fold(
      (failure) => setState(() {
        _isSubmitting = false;
        _errorMessage = failureMessage(failure);
      }),
      (_) {
        setState(() => _isDirty = false);
        Navigator.of(context).pop(true);
      },
    );
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
    if (confirmed != true) return;

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    final result = await _deactivateUseCase(exercise.id);
    if (!mounted) return;
    result.fold(
      (failure) => setState(() {
        _isSubmitting = false;
        _errorMessage = failureMessage(failure);
      }),
      (_) {
        setState(() => _isDirty = false);
        Navigator.of(context).pop(true);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final requiredSlug = widget.isEditing
        ? 'exercises.update'
        : 'exercises.create';

    if (!context.can(requiredSlug)) {
      return Scaffold(
        appBar: AppBar(title: const Text(ExerciseStrings.formTitle)),
        body: const Center(child: Text(ExerciseStrings.noPermission)),
      );
    }

    final dirty = _isDirty || _isActive != _initialIsActive;

    return UnsavedChangesScope(
      hasUnsavedChanges: dirty && !_isSubmitting,
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
                onPressed: _isSubmitting ? null : _confirmDeactivate,
              ),
          ],
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              if (_errorMessage != null) ...[
                MaterialBanner(
                  content: Text(_errorMessage!),
                  backgroundColor: Theme.of(context).colorScheme.errorContainer,
                  actions: const [SizedBox.shrink()],
                ),
                const SizedBox(height: 16),
              ],
              TextFormField(
                controller: _nameController,
                enabled: !_isSubmitting,
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
                enabled: !_isSubmitting,
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
                enabled: !_isSubmitting,
                decoration: const InputDecoration(
                  labelText: ExerciseStrings.secondaryMusclesLabel,
                  helperText: ExerciseStrings.commaSeparatedHelper,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _equipmentController,
                enabled: !_isSubmitting,
                decoration: const InputDecoration(
                  labelText: ExerciseStrings.equipmentNeededLabel,
                  helperText: ExerciseStrings.commaSeparatedHelper,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _difficultyController,
                enabled: !_isSubmitting,
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
                enabled: !_isSubmitting,
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
                enabled: !_isSubmitting,
                decoration: const InputDecoration(
                  labelText: ExerciseStrings.videoUrlLabel,
                ),
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _gifUrlController,
                enabled: !_isSubmitting,
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
                onChanged: _isSubmitting
                    ? null
                    : (v) => setState(() => _isActive = v),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _isSubmitting ? null : _submit,
                child: _isSubmitting
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
  }
}
