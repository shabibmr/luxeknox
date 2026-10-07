import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../core/widgets/app_picker_form_field.dart';
import '../../../../core/widgets/app_picker_sheet.dart';
import '../../../exercises/domain/entities/exercise.dart';
import '../cubit/exercise_picker_cubit.dart';
import '../workout_strings.dart';

/// Modal sheet: search exercises via [ExercisePickerCubit], tap to select.
Future<Exercise?> showExercisePickerSheet(BuildContext context) {
  return showModalBottomSheet<Exercise>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) => const ExercisePickerSheet(),
  );
}

class ExercisePickerSheet extends StatelessWidget {
  const ExercisePickerSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ExercisePickerCubit>()..load(),
      child: const _ExercisePickerView(),
    );
  }
}

class _ExercisePickerView extends StatefulWidget {
  const _ExercisePickerView();

  @override
  State<_ExercisePickerView> createState() => _ExercisePickerViewState();
}

class _ExercisePickerViewState extends State<_ExercisePickerView> {
  final _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _load([String? text]) {
    context.read<ExercisePickerCubit>().load(
      search: text ?? _searchController.text,
    );
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (mounted) {
        _load(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExercisePickerCubit, ExercisePickerState>(
      builder: (context, state) {
        return AppPickerSheet<Exercise>(
          searchController: _searchController,
          searchLabel: WorkoutStrings.searchExercises,
          onSearchChanged: _onSearchChanged,
          onSearchSubmitted: (_) => _load(),
          isLoading: state.status == LoadStatus.loading,
          items: state.items,
          errorMessage: state.status == LoadStatus.failure
              ? failureMessage(state.failure!)
              : null,
          onRetry: _load,
          emptyMessage: WorkoutStrings.noExercises,
          retryLabel: WorkoutStrings.retry,
          heightFactor: 0.7,
          itemBuilder: (context, exercise) => ListTile(
            title: Text(exercise.name),
            subtitle: Text(exercise.primaryMuscleGroup),
            onTap: () => Navigator.of(context).pop(exercise),
          ),
        );
      },
    );
  }
}

/// A form field widget for selecting an exercise.
class ExercisePickerField extends StatelessWidget {
  const ExercisePickerField({
    super.key,
    this.selectedExercise,
    this.onChanged,
    this.enabled = true,
  });

  final Exercise? selectedExercise;
  final ValueChanged<Exercise?>? onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return AppPickerFormField<Exercise>(
      value: selectedExercise,
      labelText: 'Exercise',
      hintText: 'Select an exercise',
      labelBuilder: (exercise) => exercise.name,
      enabled: enabled,
      onPick: (ctx) => showExercisePickerSheet(ctx),
      onChanged: onChanged ?? (_) {},
    );
  }
}
