import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/extensions/capability_extension.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/widgets/app_empty_view.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading.dart';
import '../cubit/trainers_directory_cubit.dart';
import '../people_strings.dart';
import 'edit_trainer_profile_screen.dart';

class TrainersDirectoryScreen extends StatelessWidget {
  const TrainersDirectoryScreen({super.key});

  static const double _masterDetailBreakpoint = 840;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<TrainersDirectoryCubit>()..load(),
      child: const _TrainersDirectoryBody(),
    );
  }
}

class _TrainersDirectoryBody extends StatefulWidget {
  const _TrainersDirectoryBody();

  @override
  State<_TrainersDirectoryBody> createState() => _TrainersDirectoryBodyState();
}

class _TrainersDirectoryBodyState extends State<_TrainersDirectoryBody> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  int? _selectedTrainerId;

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
      context.read<TrainersDirectoryCubit>().loadMore();
    }
  }

  Future<void> _openCreateTrainer() async {
    final createdId = await context.push<int>(Routes.adminTrainersCreate);
    if (!mounted || createdId == null) return;
    await context.read<TrainersDirectoryCubit>().load(
      query: _searchController.text,
    );
    if (!mounted) return;
    final isWide =
        MediaQuery.sizeOf(context).width >=
        TrainersDirectoryScreen._masterDetailBreakpoint;
    if (isWide) {
      setState(() => _selectedTrainerId = createdId);
    } else {
      context.push(Routes.adminTrainersEditById(createdId));
    }
  }

  Future<void> _selectTrainer(int id, bool isWide) async {
    if (isWide) {
      setState(() => _selectedTrainerId = id);
    } else {
      await context.push(Routes.adminTrainersEditById(id));
      if (mounted) {
        context.read<TrainersDirectoryCubit>().load(
          query: _searchController.text,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final canCreate = context.can('trainers.create');

    return Scaffold(
      appBar: AppBar(title: const Text(PeopleStrings.trainersTitle)),
      floatingActionButton: canCreate
          ? FloatingActionButton(
              onPressed: _openCreateTrainer,
              tooltip: PeopleStrings.addTrainerTitle,
              child: const Icon(Icons.person_add_alt_1),
            )
          : null,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide =
              constraints.maxWidth >=
              TrainersDirectoryScreen._masterDetailBreakpoint;

          final listPane = _TrainersListPane(
            searchController: _searchController,
            scrollController: _scrollController,
            selectedTrainerId: isWide ? _selectedTrainerId : null,
            onSelectTrainer: (id) => _selectTrainer(id, isWide),
          );

          if (!isWide) return listPane;

          return Row(
            children: [
              SizedBox(width: 400, child: listPane),
              const VerticalDivider(width: 1),
              Expanded(
                child: _selectedTrainerId == null
                    ? const Center(
                        child: Text(PeopleStrings.selectTrainerPrompt),
                      )
                    : EditTrainerProfileScreen(
                        key: ValueKey(_selectedTrainerId),
                        trainerId: _selectedTrainerId!,
                        isAdmin: true,
                        embedded: true,
                        onSaved: () {
                          context.read<TrainersDirectoryCubit>().load(
                            query: _searchController.text,
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _TrainersListPane extends StatelessWidget {
  const _TrainersListPane({
    required this.searchController,
    required this.scrollController,
    required this.selectedTrainerId,
    required this.onSelectTrainer,
  });

  final TextEditingController searchController;
  final ScrollController scrollController;
  final int? selectedTrainerId;
  final void Function(int id) onSelectTrainer;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: PeopleStrings.searchHint,
              prefixIcon: const Icon(Icons.search),
              isDense: true,
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  searchController.clear();
                  context.read<TrainersDirectoryCubit>().load(query: '');
                },
              ),
            ),
            onSubmitted: (value) =>
                context.read<TrainersDirectoryCubit>().load(query: value),
          ),
        ),
        BlocBuilder<TrainersDirectoryCubit, TrainersDirectoryState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ChoiceChip(
                      label: const Text(PeopleStrings.filterAll),
                      selected: state.statusFilter == 'all',
                      onSelected: (selected) {
                        if (selected) {
                          context.read<TrainersDirectoryCubit>().load(
                            query: searchController.text,
                            statusFilter: 'all',
                          );
                        }
                      },
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: const Text(PeopleStrings.filterActive),
                      selected: state.statusFilter == 'active',
                      onSelected: (selected) {
                        if (selected) {
                          context.read<TrainersDirectoryCubit>().load(
                            query: searchController.text,
                            statusFilter: 'active',
                          );
                        }
                      },
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: const Text(PeopleStrings.filterInactive),
                      selected: state.statusFilter == 'inactive',
                      onSelected: (selected) {
                        if (selected) {
                          context.read<TrainersDirectoryCubit>().load(
                            query: searchController.text,
                            statusFilter: 'inactive',
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        Expanded(
          child: BlocConsumer<TrainersDirectoryCubit, TrainersDirectoryState>(
            listener: (context, state) {
              if (state.status == LoadStatus.failure &&
                  state.items.isNotEmpty &&
                  state.failure != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(failureMessage(state.failure!))),
                );
              }
            },
            builder: (context, state) {
              if (state.items.isEmpty && state.status == LoadStatus.failure) {
                return AppErrorView(
                  message: failureMessage(state.failure!),
                  onRetry: () => context.read<TrainersDirectoryCubit>().load(
                    query: searchController.text,
                  ),
                );
              }
              if (state.items.isEmpty && state.status != LoadStatus.success) {
                return const AppLoading();
              }
              if (state.items.isEmpty) {
                return const AppEmptyView(
                  message: PeopleStrings.emptyTrainers,
                );
              }
              return RefreshIndicator(
                onRefresh: () async {
                  await context.read<TrainersDirectoryCubit>().load(
                    query: searchController.text,
                  );
                },
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: state.items.length + (state.hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index >= state.items.length) {
                      final loadingMore = state.loadingMore;
                      return Padding(
                        padding: const EdgeInsets.all(16),
                        child: Center(
                          child: loadingMore
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : TextButton(
                                  onPressed: () => context
                                      .read<TrainersDirectoryCubit>()
                                      .loadMore(),
                                  child: const Text(PeopleStrings.loadMore),
                                ),
                        ),
                      );
                    }
                    final trainer = state.items[index];
                    return ListTile(
                      tileColor: trainer.id == selectedTrainerId
                          ? Theme.of(context).colorScheme.primaryContainer
                          : null,
                      title: Text(trainer.fullName),
                      subtitle: Text(
                        trainer.specializations.isEmpty
                            ? 'ID ${trainer.id}'
                            : trainer.specializations.join(', '),
                      ),
                      trailing: Text(
                        trainer.isActive
                            ? PeopleStrings.filterActive
                            : PeopleStrings.filterInactive,
                      ),
                      onTap: () => onSelectTrainer(trainer.id),
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
