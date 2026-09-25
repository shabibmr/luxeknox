import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/presentation/load_status.dart';
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
    final height = MediaQuery.sizeOf(context).height * 0.7;
    return SizedBox(
      height: height,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: WorkoutStrings.searchExercises,
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _load(),
            ),
          ),
          Expanded(
            child: BlocBuilder<ExercisePickerCubit, ExercisePickerState>(
              builder: (context, state) {
                if (state.status == LoadStatus.loading &&
                    state.items.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.status == LoadStatus.failure &&
                    state.items.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(failureMessage(state.failure!)),
                        TextButton(
                          onPressed: _load,
                          child: const Text(WorkoutStrings.retry),
                        ),
                      ],
                    ),
                  );
                }

                if (state.items.isEmpty) {
                  return const Center(
                    child: Text(WorkoutStrings.noExercises),
                  );
                }

                return Column(
                  children: [
                    if (state.status == LoadStatus.failure &&
                        state.failure != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(failureMessage(state.failure!)),
                            ),
                            TextButton(
                              onPressed: _load,
                              child: const Text(WorkoutStrings.retry),
                            ),
                          ],
                        ),
                      ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: state.items.length,
                        itemBuilder: (context, index) {
                          final exercise = state.items[index];
                          return ListTile(
                            title: Text(exercise.name),
                            subtitle: Text(exercise.primaryMuscleGroup),
                            onTap: () => Navigator.of(context).pop(exercise),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
