import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/widgets/app_empty_view.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading.dart';
import '../cubit/employee_roles_cubit.dart';
import '../people_strings.dart';

/// Staff role & permission assignment for a single employee.
class EmployeeRolesScreen extends StatelessWidget {
  const EmployeeRolesScreen({super.key, required this.employeeId});

  final int employeeId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<EmployeeRolesCubit>()..load(employeeId),
      child: _EmployeeRolesBody(employeeId: employeeId),
    );
  }
}

class _EmployeeRolesBody extends StatelessWidget {
  const _EmployeeRolesBody({required this.employeeId});

  final int employeeId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(PeopleStrings.employeeRolesTitle)),
      body: BlocConsumer<EmployeeRolesCubit, EmployeeRolesState>(
        listener: (context, state) {
          if (state is EmployeeRolesLoaded && state.assigned) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text(PeopleStrings.roleAssigned)),
            );
          }
        },
        builder: (context, state) {
          return switch (state) {
            EmployeeRolesLoading() => const AppLoading(),
            EmployeeRolesFailure(:final message) => AppErrorView(
              message: message,
              onRetry: () =>
                  context.read<EmployeeRolesCubit>().load(employeeId),
            ),
            EmployeeRolesLoaded(
              :final employee,
              :final roles,
              :final assigning,
            ) =>
              ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Text(
                    employee.fullName,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Text(employee.jobTitle),
                  const SizedBox(height: 16),
                  ListTile(
                    title: const Text(PeopleStrings.currentRole),
                    subtitle: Text(
                      roles
                              .where((r) => r.id == employee.roleId)
                              .map((r) => r.name)
                              .firstOrNull ??
                          PeopleStrings.noRoleAssigned,
                    ),
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      PeopleStrings.availableRoles,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  if (roles.isEmpty)
                    const AppEmptyView(message: PeopleStrings.emptyRoles)
                  else
                    ...roles.map(
                      (role) => Card(
                        child: ListTile(
                          title: Text(role.name),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (role.description != null)
                                Text(role.description!),
                              if (role.isSystemRole)
                                const Text(
                                  PeopleStrings.systemRole,
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                              if (role.permissionSlugs.isNotEmpty)
                                Text(
                                  '${PeopleStrings.permissionsLabel}: '
                                  '${role.permissionSlugs.join(', ')}',
                                ),
                            ],
                          ),
                          trailing: role.id == employee.roleId
                              ? const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                )
                              : TextButton(
                                  onPressed: assigning
                                      ? null
                                      : () => context
                                            .read<EmployeeRolesCubit>()
                                            .assignRole(role.id),
                                  child: const Text(PeopleStrings.assign),
                                ),
                        ),
                      ),
                    ),
                ],
              ),
          };
        },
      ),
    );
  }
}
