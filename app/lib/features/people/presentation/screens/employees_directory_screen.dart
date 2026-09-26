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
import 'employee_form_screen.dart';

class EmployeesDirectoryScreen extends StatelessWidget {
  const EmployeesDirectoryScreen({super.key});

  static const double _masterDetailBreakpoint = 840;

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
  final _scrollController = ScrollController();
  int? _selectedEmployeeId;

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
      context.read<EmployeesDirectoryCubit>().loadMore();
    }
  }

  Future<void> _openCreateEmployee() async {
    final createdId = await context.push<int>(Routes.adminEmployeesCreate);
    if (!mounted || createdId == null) return;
    await context.read<EmployeesDirectoryCubit>().load(
      query: _searchController.text,
    );
    if (!mounted) return;
    final isWide =
        MediaQuery.sizeOf(context).width >=
        EmployeesDirectoryScreen._masterDetailBreakpoint;
    if (isWide) {
      setState(() => _selectedEmployeeId = createdId);
    } else {
      context.push(Routes.adminEmployeesEditById(createdId));
    }
  }

  void _selectEmployee(int id, bool isWide) {
    if (isWide) {
      setState(() => _selectedEmployeeId = id);
    } else {
      context.push(Routes.adminEmployeesEditById(id));
    }
  }

  @override
  Widget build(BuildContext context) {
    final canCreate = context.can('employees.create');

    return Scaffold(
      appBar: AppBar(
        title: const Text(PeopleStrings.employeesTitle),
        actions: [
          if (canCreate)
            IconButton(
              icon: const Icon(Icons.add),
              tooltip: PeopleStrings.addEmployeeTooltip,
              onPressed: _openCreateEmployee,
            ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide =
              constraints.maxWidth >=
              EmployeesDirectoryScreen._masterDetailBreakpoint;

          final listPane = _EmployeesListPane(
            searchController: _searchController,
            scrollController: _scrollController,
            selectedEmployeeId: isWide ? _selectedEmployeeId : null,
            onSelectEmployee: (id) => _selectEmployee(id, isWide),
          );

          if (!isWide) return listPane;

          return Row(
            children: [
              SizedBox(width: 400, child: listPane),
              const VerticalDivider(width: 1),
              Expanded(
                child: _selectedEmployeeId == null
                    ? const Center(
                        child: Text(PeopleStrings.selectEmployeePrompt),
                      )
                    : EmployeeFormScreen.edit(
                        key: ValueKey(_selectedEmployeeId),
                        employeeId: _selectedEmployeeId!,
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

class _EmployeesListPane extends StatelessWidget {
  const _EmployeesListPane({
    required this.searchController,
    required this.scrollController,
    required this.selectedEmployeeId,
    required this.onSelectEmployee,
  });

  final TextEditingController searchController;
  final ScrollController scrollController;
  final int? selectedEmployeeId;
  final void Function(int id) onSelectEmployee;

  static const _statusFilters = <(String, String)>[
    ('all', PeopleStrings.filterAll),
    ('active', PeopleStrings.statusActive),
    ('on_probation', PeopleStrings.statusOnProbation),
    ('suspended', PeopleStrings.statusSuspended),
    ('terminated', PeopleStrings.statusTerminated),
  ];

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
                  context.read<EmployeesDirectoryCubit>().load(query: '');
                },
              ),
            ),
            onSubmitted: (value) =>
                context.read<EmployeesDirectoryCubit>().load(query: value),
          ),
        ),
        BlocBuilder<EmployeesDirectoryCubit, EmployeesDirectoryState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (var i = 0; i < _statusFilters.length; i++) ...[
                      if (i > 0) const SizedBox(width: 8),
                      ChoiceChip(
                        label: Text(_statusFilters[i].$2),
                        selected: state.statusFilter == _statusFilters[i].$1,
                        onSelected: (selected) {
                          if (!selected) return;
                          context.read<EmployeesDirectoryCubit>().load(
                            query: searchController.text,
                            statusFilter: _statusFilters[i].$1,
                          );
                        },
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
        Expanded(
          child: BlocConsumer<EmployeesDirectoryCubit, EmployeesDirectoryState>(
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
                  onRetry: () => context.read<EmployeesDirectoryCubit>().load(
                    query: searchController.text,
                  ),
                );
              }
              if (state.items.isEmpty && state.status != LoadStatus.success) {
                return const AppLoading();
              }
              if (state.items.isEmpty) {
                return const AppEmptyView(
                  message: PeopleStrings.emptyEmployees,
                );
              }
              return RefreshIndicator(
                onRefresh: () async {
                  await context.read<EmployeesDirectoryCubit>().load(
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
                                      .read<EmployeesDirectoryCubit>()
                                      .loadMore(),
                                  child: const Text(PeopleStrings.loadMore),
                                ),
                        ),
                      );
                    }
                    final employee = state.items[index];
                    return ListTile(
                      tileColor: employee.id == selectedEmployeeId
                          ? Theme.of(context).colorScheme.primaryContainer
                          : null,
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
                      onTap: () => onSelectEmployee(employee.id),
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
