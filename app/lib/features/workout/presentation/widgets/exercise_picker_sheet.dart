import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/presentation/load_status.dart';
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _load() {
    context.read<ExercisePickerCubit>().load(search: _searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExercisePickerCubit, ExercisePickerState>(
      builder: (context, state) {
        return AppPickerSheet<Exercise>(
          searchController: _searchController,
          searchLabel: WorkoutStrings.searchExercises,
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
