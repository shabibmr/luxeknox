import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/widgets/app_empty_view.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading.dart';
import '../cubit/trainers_directory_cubit.dart';
import '../people_strings.dart';

class TrainersDirectoryScreen extends StatelessWidget {
  const TrainersDirectoryScreen({super.key});

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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(PeopleStrings.trainersTitle)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: PeopleStrings.searchHint,
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => context.read<TrainersDirectoryCubit>().load(
                    query: _searchController.text,
                  ),
                ),
              ),
              onSubmitted: (value) =>
                  context.read<TrainersDirectoryCubit>().load(query: value),
            ),
          ),
          Expanded(
            child: BlocBuilder<TrainersDirectoryCubit, TrainersDirectoryState>(
              builder: (context, state) {
                return switch (state) {
                  TrainersDirectoryLoading() => const AppLoading(),
                  TrainersDirectoryFailure(:final message) => AppErrorView(
                    message: message,
                    onRetry: () => context.read<TrainersDirectoryCubit>().load(
                      query: _searchController.text,
                    ),
                  ),
                  TrainersDirectoryLoaded(
                    :final items,
                    :final hasMore,
                    :final loadingMore,
                  ) =>
                    items.isEmpty
                        ? const AppEmptyView(
                            message: PeopleStrings.emptyTrainers,
                          )
                        : ListView.builder(
                            itemCount: items.length + (hasMore ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index >= items.length) {
                                return TextButton(
                                  onPressed: loadingMore
                                      ? null
                                      : () => context
                                            .read<TrainersDirectoryCubit>()
                                            .loadMore(),
                                  child: Text(
                                    loadingMore
                                        ? '…'
                                        : PeopleStrings.loadMore,
                                  ),
                                );
                              }
                              final trainer = items[index];
                              return ListTile(
                                title: Text(trainer.fullName),
                                subtitle: Text(
                                  trainer.specializations.isEmpty
                                      ? 'ID ${trainer.id}'
                                      : trainer.specializations.join(', '),
                                ),
                                trailing: Text(
                                  trainer.isActive ? 'Active' : 'Inactive',
                                ),
                              );
                            },
                          ),
                };
              },
            ),
          ),
        ],
      ),
    );
  }
}
