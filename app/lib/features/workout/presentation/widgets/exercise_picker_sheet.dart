import 'package:flutter/material.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../exercises/domain/entities/exercise.dart';
import '../../../exercises/domain/entities/exercise_filter.dart';
import '../../../exercises/domain/usecases/get_exercises_usecase.dart';
import '../workout_strings.dart';

/// Modal sheet: search exercises via [GetExercisesUseCase], tap to select.
Future<Exercise?> showExercisePickerSheet(BuildContext context) {
  return showModalBottomSheet<Exercise>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) => const ExercisePickerSheet(),
  );
}

class ExercisePickerSheet extends StatefulWidget {
  const ExercisePickerSheet({super.key});

  @override
  State<ExercisePickerSheet> createState() => _ExercisePickerSheetState();
}

class _ExercisePickerSheetState extends State<ExercisePickerSheet> {
  final _searchController = TextEditingController();
  late final GetExercisesUseCase _getExercises = getIt<GetExercisesUseCase>();

  List<Exercise> _items = const [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _load({String? search}) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final result = await _getExercises(
      GetExercisesParams(
        filter: ExerciseFilter(
          searchText: (search == null || search.isEmpty) ? null : search,
        ),
      ),
    );
    if (!mounted) return;
    result.fold(
      (failure) => setState(() {
        _loading = false;
        _error = failureMessage(failure);
        _items = const [];
      }),
      (page) => setState(() {
        _loading = false;
        _items = page.items;
      }),
    );
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
              onSubmitted: (value) => _load(search: value.trim()),
            ),
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(_error!),
                        TextButton(
                          onPressed: () => _load(
                            search: _searchController.text.trim(),
                          ),
                          child: const Text(WorkoutStrings.retry),
                        ),
                      ],
                    ),
                  )
                : _items.isEmpty
                ? const Center(child: Text(WorkoutStrings.noExercises))
                : ListView.builder(
                    itemCount: _items.length,
                    itemBuilder: (context, index) {
                      final exercise = _items[index];
                      return ListTile(
                        title: Text(exercise.name),
                        subtitle: Text(exercise.primaryMuscleGroup),
                        onTap: () => Navigator.of(context).pop(exercise),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
