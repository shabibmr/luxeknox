import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/widgets/app_empty_view.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading.dart';
import '../cubit/employees_directory_cubit.dart';
import '../people_strings.dart';

class EmployeesDirectoryScreen extends StatelessWidget {
  const EmployeesDirectoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<EmployeesDirectoryCubit>()..load(),
      child: const _EmployeesDirectoryBody(),
    );
  }
}

class _EmployeesDirectoryBody extends StatefulWidget {
  const _EmployeesDirectoryBody();

  @override
  State<_EmployeesDirectoryBody> createState() =>
      _EmployeesDirectoryBodyState();
}

class _EmployeesDirectoryBodyState extends State<_EmployeesDirectoryBody> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(PeopleStrings.employeesTitle)),
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
                  onPressed: () => context.read<EmployeesDirectoryCubit>().load(
                    query: _searchController.text,
                  ),
                ),
              ),
              onSubmitted: (value) =>
                  context.read<EmployeesDirectoryCubit>().load(query: value),
            ),
          ),
          Expanded(
            child: BlocBuilder<EmployeesDirectoryCubit, EmployeesDirectoryState>(
              builder: (context, state) {
                return switch (state) {
                  EmployeesDirectoryLoading() => const AppLoading(),
                  EmployeesDirectoryFailure(:final message) => AppErrorView(
                    message: message,
                    onRetry: () =>
                        context.read<EmployeesDirectoryCubit>().load(
                          query: _searchController.text,
                        ),
                  ),
                  EmployeesDirectoryLoaded(
                    :final items,
                    :final hasMore,
                    :final loadingMore,
                  ) =>
                    items.isEmpty
                        ? const AppEmptyView(
                            message: PeopleStrings.emptyEmployees,
                          )
                        : ListView.builder(
                            itemCount: items.length + (hasMore ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index >= items.length) {
                                return TextButton(
                                  onPressed: loadingMore
                                      ? null
                                      : () => context
                                            .read<EmployeesDirectoryCubit>()
                                            .loadMore(),
                                  child: Text(
                                    loadingMore
                                        ? '…'
                                        : PeopleStrings.loadMore,
                                  ),
                                );
                              }
                              final employee = items[index];
                              return ListTile(
                                title: Text(employee.fullName),
                                subtitle: Text(
                                  [
                                    employee.jobTitle,
                                    if (employee.department != null)
                                      employee.department!,
                                  ].join(' · '),
                                ),
                                trailing: employee.status == null
                                    ? null
                                    : Text(employee.status!),
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
