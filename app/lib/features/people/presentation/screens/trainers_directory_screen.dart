import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/presentation/load_status.dart';
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
                      query: _searchController.text,
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
                return ListView.builder(
                  itemCount: state.items.length + (state.hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index >= state.items.length) {
                      final loadingMore = state.loadingMore;
                      return TextButton(
                        onPressed:
                            loadingMore || state.status == LoadStatus.loading
                            ? null
                            : () => context
                                  .read<TrainersDirectoryCubit>()
                                  .loadMore(),
                        child: Text(loadingMore ? '…' : PeopleStrings.loadMore),
                      );
                    }
                    final trainer = state.items[index];
                    return ListTile(
                      title: Text(trainer.fullName),
                      subtitle: Text(
                        trainer.specializations.isEmpty
                            ? 'ID ${trainer.id}'
                            : trainer.specializations.join(', '),
                      ),
                      trailing: Text(trainer.isActive ? 'Active' : 'Inactive'),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
