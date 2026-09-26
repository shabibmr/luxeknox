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

  Future<void> _openCreateEmployee() async {
    final createdId = await context.push<int>(Routes.adminEmployeesCreate);
    if (!mounted || createdId == null) return;
    await context.read<EmployeesDirectoryCubit>().load(
      query: _searchController.text,
    );
    if (!mounted) return;
    context.push(Routes.adminEmployeesEditById(createdId));
  }

  Future<void> _openEmployee(int id) async {
    final updatedId = await context.push<int>(Routes.adminEmployeesEditById(id));
    if (!mounted) return;
    if (updatedId != null) {
      await context.read<EmployeesDirectoryCubit>().load(
        query: _searchController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final canCreate = context.can('employees.create');

    return Scaffold(
      appBar: AppBar(title: const Text(PeopleStrings.employeesTitle)),
      floatingActionButton: canCreate
          ? FloatingActionButton(
              onPressed: _openCreateEmployee,
              tooltip: PeopleStrings.addEmployeeTitle,
              child: const Icon(Icons.person_add_alt_1),
            )
          : null,
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
            child:
                BlocConsumer<EmployeesDirectoryCubit, EmployeesDirectoryState>(
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
                    if (state.items.isEmpty &&
                        state.status == LoadStatus.failure) {
                      return AppErrorView(
                        message: failureMessage(state.failure!),
                        onRetry: () => context
                            .read<EmployeesDirectoryCubit>()
                            .load(query: _searchController.text),
                      );
                    }
                    if (state.items.isEmpty &&
                        state.status != LoadStatus.success) {
                      return const AppLoading();
                    }
                    if (state.items.isEmpty) {
                      return const AppEmptyView(
                        message: PeopleStrings.emptyEmployees,
                      );
                    }
                    return ListView.builder(
                      itemCount: state.items.length + (state.hasMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index >= state.items.length) {
                          final loadingMore = state.loadingMore;
                          return TextButton(
                            onPressed:
                                loadingMore ||
                                    state.status == LoadStatus.loading
                                ? null
                                : () => context
                                      .read<EmployeesDirectoryCubit>()
                                      .loadMore(),
                            child: Text(
                              loadingMore ? '…' : PeopleStrings.loadMore,
                            ),
                          );
                        }
                        final employee = state.items[index];
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
                          onTap: () => _openEmployee(employee.id),
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
