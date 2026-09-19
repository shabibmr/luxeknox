import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/extensions/capability_extension.dart';
import '../../domain/entities/exercise_filter.dart';
import '../bloc/exercise_list_bloc.dart';
import '../bloc/exercise_list_event.dart';
import '../bloc/exercise_list_state.dart';
import '../widgets/exercise_filter_sheet.dart';
import '../widgets/exercise_list_item.dart';
import 'exercise_detail_screen.dart';
import 'exercise_form_screen.dart';

/// Exercise Library screen (screen 29). Member and trainer get browse-only;
/// admin also sees the add button (K5). At 840dp and above, selecting an
/// exercise shows it in a side pane instead of pushing (K11).
class ExerciseLibraryScreen extends StatelessWidget {
  const ExerciseLibraryScreen({super.key});

  static const double _masterDetailBreakpoint = 840;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<ExerciseListBloc>()..add(const ExerciseListStarted()),
      child: const _ExerciseLibraryView(),
    );
  }
}

class _ExerciseLibraryView extends StatefulWidget {
  const _ExerciseLibraryView();

  @override
  State<_ExerciseLibraryView> createState() => _ExerciseLibraryViewState();
}

class _ExerciseLibraryViewState extends State<_ExerciseLibraryView> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  String? _selectedExerciseId;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 200) {
      context.read<ExerciseListBloc>().add(
        const ExerciseListNextPageRequested(),
      );
    }
  }

  Future<void> _openFilterSheet(ExerciseFilter current) async {
    final result = await ExerciseFilterSheet.show(context, current);
    if (!mounted || result == null) return;
    context.read<ExerciseListBloc>().add(ExerciseListFilterChanged(result));
  }

  void _selectExercise(String id, bool isWide) {
    if (isWide) {
      setState(() => _selectedExerciseId = id);
    } else {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => ExerciseDetailScreen(exerciseId: id),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final canCreate = context.can('exercises.create');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise Library'),
        actions: [
          if (canCreate)
            IconButton(
              icon: const Icon(Icons.add),
              tooltip: 'Add exercise',
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const ExerciseFormScreen(),
                ),
              ),
            ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide =
              constraints.maxWidth >=
              ExerciseLibraryScreen._masterDetailBreakpoint;

          final listPane = _ExerciseListPane(
            searchController: _searchController,
            scrollController: _scrollController,
            onOpenFilters: _openFilterSheet,
            onSelectExercise: (id) => _selectExercise(id, isWide),
            selectedExerciseId: isWide ? _selectedExerciseId : null,
          );

          if (!isWide) return listPane;

          return Row(
            children: [
              SizedBox(width: 400, child: listPane),
              const VerticalDivider(width: 1),
              Expanded(
                child: _selectedExerciseId == null
                    ? const Center(
                        child: Text('Select an exercise to view details'),
                      )
                    : ExerciseDetailScreen(
                        key: ValueKey(_selectedExerciseId),
                        exerciseId: _selectedExerciseId!,
                        embedded: true,
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ExerciseListPane extends StatelessWidget {
  const _ExerciseListPane({
    required this.searchController,
    required this.scrollController,
    required this.onOpenFilters,
    required this.onSelectExercise,
    required this.selectedExerciseId,
  });

  final TextEditingController searchController;
  final ScrollController scrollController;
  final void Function(ExerciseFilter current) onOpenFilters;
  final void Function(String id) onSelectExercise;
  final String? selectedExerciseId;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: searchController,
                  decoration: const InputDecoration(
                    hintText: 'Search exercises',
                    prefixIcon: Icon(Icons.search),
                    isDense: true,
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (query) => context.read<ExerciseListBloc>().add(
                    ExerciseListSearchChanged(query),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              BlocSelector<ExerciseListBloc, ExerciseListState, ExerciseFilter>(
                selector: (state) => state.filter,
                builder: (context, filter) => IconButton(
                  icon: Icon(
                    Icons.filter_list,
                    color: filter.isEmpty
                        ? null
                        : Theme.of(context).colorScheme.primary,
                  ),
                  tooltip: 'Filter',
                  onPressed: () => onOpenFilters(filter),
                ),
              ),
            ],
          ),
        ),
        BlocSelector<ExerciseListBloc, ExerciseListState, ExerciseFilter>(
          selector: (state) => state.filter,
          builder: (context, filter) {
            if (filter.isEmpty) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Wrap(
                spacing: 8,
                children: [
                  if (filter.muscleGroup != null)
                    Chip(
                      label: Text(filter.muscleGroup!),
                      onDeleted: () => context.read<ExerciseListBloc>().add(
                        ExerciseListFilterChanged(
                          filter.copyWith(muscleGroup: null),
                        ),
                      ),
                    ),
                  if (filter.equipment != null)
                    Chip(
                      label: Text(filter.equipment!),
                      onDeleted: () => context.read<ExerciseListBloc>().add(
                        ExerciseListFilterChanged(
                          filter.copyWith(equipment: null),
                        ),
                      ),
                    ),
                  if (filter.difficulty != null)
                    Chip(
                      label: Text(filter.difficulty!),
                      onDeleted: () => context.read<ExerciseListBloc>().add(
                        ExerciseListFilterChanged(
                          filter.copyWith(difficulty: null),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
        Expanded(
          child: BlocBuilder<ExerciseListBloc, ExerciseListState>(
            builder: (context, state) {
              if (state.status == ExerciseListStatus.loading &&
                  state.items.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state.status == ExerciseListStatus.failure &&
                  state.items.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          failureMessage(state.failure!),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        FilledButton(
                          onPressed: () => context.read<ExerciseListBloc>().add(
                            const ExerciseListRefreshed(),
                          ),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (state.status == ExerciseListStatus.success &&
                  state.items.isEmpty) {
                return const Center(child: Text('No exercises found.'));
              }

              return RefreshIndicator(
                onRefresh: () async {
                  final bloc = context.read<ExerciseListBloc>();
                  bloc.add(const ExerciseListRefreshed());
                  await bloc.stream.firstWhere(
                    (s) => s.status != ExerciseListStatus.loading,
                  );
                },
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: state.items.length + (state.hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index >= state.items.length) {
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                      );
                    }
                    final exercise = state.items[index];
                    return Container(
                      color: exercise.id == selectedExerciseId
                          ? Theme.of(context).colorScheme.primaryContainer
                          : null,
                      child: ExerciseListItem(
                        exercise: exercise,
                        onTap: () => onSelectExercise(exercise.id),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
