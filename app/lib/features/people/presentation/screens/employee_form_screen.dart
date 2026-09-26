import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../../core/widgets/unsaved_changes_scope.dart';
import '../../domain/entities/employee_status.dart';
import '../../domain/entities/new_employee_input.dart';
import '../cubit/employee_form_cubit.dart';
import '../people_strings.dart';

/// Admin create/edit employee form.
class EmployeeFormScreen extends StatelessWidget {
  const EmployeeFormScreen.create({super.key}) : employeeId = null;

  const EmployeeFormScreen.edit({super.key, required this.employeeId});

  final int? employeeId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = getIt<EmployeeFormCubit>();
        if (employeeId != null) {
          cubit.initEdit(employeeId!);
        } else {
          cubit.initCreate();
        }
        return cubit;
      },
      child: const _EmployeeFormBody(),
    );
  }
}

class _EmployeeFormBody extends StatefulWidget {
  const _EmployeeFormBody();

  @override
  State<_EmployeeFormBody> createState() => _EmployeeFormBodyState();
}

class _EmployeeFormBodyState extends State<_EmployeeFormBody> {
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  final _jobTitle = TextEditingController();
  final _department = TextEditingController();
  bool _seededEdit = false;

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _email.dispose();
    _phone.dispose();
    _password.dispose();
    _jobTitle.dispose();
    _department.dispose();
    super.dispose();
  }

  void _seedEditControllers(EmployeeFormState state) {
    if (_seededEdit || state.loadedEmployee == null) return;
    _jobTitle.text = state.updateInput.jobTitle ?? '';
    _department.text = state.updateInput.department ?? '';
    _seededEdit = true;
  }

  String? _optional(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  String _statusLabel(EmployeeStatus status) {
    return switch (status) {
      EmployeeStatus.active => PeopleStrings.statusActive,
      EmployeeStatus.onProbation => PeopleStrings.statusOnProbation,
      EmployeeStatus.suspended => PeopleStrings.statusSuspended,
      EmployeeStatus.terminated => PeopleStrings.statusTerminated,
    };
  }

  Future<void> _pickHireDate(EmployeeFormCubit cubit, DateTime? current) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: current ?? DateTime.now(),
      firstDate: DateTime(1970),
      lastDate: DateTime(2100),
    );
    if (picked == null) return;
    if (cubit.state.isCreate) {
      cubit.updateCreateInput((i) => i.copyWith(hireDate: picked));
    } else {
      cubit.updateEditInput((i) => i.copyWith(hireDate: picked));
    }
  }

  Future<void> _changeStatus(EmployeeStatus next) async {
    final cubit = context.read<EmployeeFormCubit>();
    if (next == cubit.state.currentStatus) return;

    if (EmployeeFormCubit.statusRequiresConfirm(next)) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text(PeopleStrings.confirmStatusChangeTitle),
          content: Text(
            next == EmployeeStatus.suspended
                ? PeopleStrings.confirmSuspendBody
                : PeopleStrings.confirmTerminateBody,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text(PeopleStrings.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text(PeopleStrings.confirmStatusChange),
            ),
          ],
        ),
      );
      if (confirmed != true || !mounted) return;
    }

    final ok = await cubit.changeStatus(next);
    if (!mounted || !ok) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text(PeopleStrings.statusUpdated)),
    );
  }

  Future<void> _submit() async {
    final cubit = context.read<EmployeeFormCubit>();
    if (cubit.state.submitting) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(PeopleStrings.alreadySubmitting)),
      );
      return;
    }

    if (cubit.state.isCreate) {
      cubit.updateCreateInput(
        (input) => input.copyWith(
          firstName: _firstName.text.trim(),
          lastName: _lastName.text.trim(),
          email: _email.text.trim(),
          phoneNumber: _optional(_phone.text),
          password: _optional(_password.text),
          jobTitle: _jobTitle.text.trim(),
          department: _optional(_department.text),
        ),
      );
    } else {
      cubit.updateEditInput(
        (input) => input.copyWith(
          jobTitle: _jobTitle.text.trim(),
          department: _optional(_department.text),
        ),
      );
    }

    await cubit.submit();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EmployeeFormCubit, EmployeeFormState>(
      listenWhen: (previous, current) =>
          previous.saved != current.saved || previous.error != current.error,
      listener: (context, state) {
        if (state.saved != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.isCreate
                    ? PeopleStrings.employeeCreated
                    : PeopleStrings.employeeSaved,
              ),
            ),
          );
          context.pop(state.saved!.id);
          return;
        }
        if (state.error != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.error!)));
        }
      },
      builder: (context, state) {
        if (state.initialLoading) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                state.isCreate
                    ? PeopleStrings.addEmployeeTitle
                    : PeopleStrings.editEmployeeTitle,
              ),
            ),
            body: const AppLoading(),
          );
        }

        if (!state.isCreate) {
          _seedEditControllers(state);
        }

        final submitting =
            state.submitting || state.saved != null || state.statusUpdating;
        final dirty = state.isDirty && !submitting;
        final hireDate = state.isCreate
            ? state.createInput.hireDate
            : state.updateInput.hireDate;
        final selectedRoleId = state.isCreate
            ? (state.createInput.roleId > 0 ? state.createInput.roleId : null)
            : state.loadedEmployee?.roleId;
        final loaded = state.loadedEmployee;

        return UnsavedChangesScope(
          hasUnsavedChanges: dirty,
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                state.isCreate
                    ? PeopleStrings.addEmployeeTitle
                    : PeopleStrings.editEmployeeTitle,
              ),
            ),
            body: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (state.isCreate) ...[
                  TextField(
                    controller: _firstName,
                    enabled: !submitting,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      labelText: PeopleStrings.firstName,
                    ),
                    onChanged: (v) => context
                        .read<EmployeeFormCubit>()
                        .updateCreateInput((i) => i.copyWith(firstName: v)),
                  ),
                  TextField(
                    controller: _lastName,
                    enabled: !submitting,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      labelText: PeopleStrings.lastName,
                    ),
                    onChanged: (v) => context
                        .read<EmployeeFormCubit>()
                        .updateCreateInput((i) => i.copyWith(lastName: v)),
                  ),
                  TextField(
                    controller: _email,
                    enabled: !submitting,
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      labelText: PeopleStrings.email,
                    ),
                    onChanged: (v) => context
                        .read<EmployeeFormCubit>()
                        .updateCreateInput((i) => i.copyWith(email: v)),
                  ),
                  TextField(
                    controller: _phone,
                    enabled: !submitting,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: PeopleStrings.phoneNumber,
                    ),
                    onChanged: (v) =>
                        context.read<EmployeeFormCubit>().updateCreateInput(
                          (i) => i.copyWith(phoneNumber: _optional(v)),
                        ),
                  ),
                  TextField(
                    controller: _password,
                    enabled: !submitting,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: PeopleStrings.password,
                    ),
                    onChanged: (v) =>
                        context.read<EmployeeFormCubit>().updateCreateInput(
                          (i) => i.copyWith(password: _optional(v)),
                        ),
                  ),
                ] else if (loaded != null) ...[
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(loaded.fullName),
                    subtitle: const Text(PeopleStrings.createOnlyHint),
                  ),
                  if (loaded.email != null && loaded.email!.isNotEmpty)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text(PeopleStrings.email),
                      subtitle: Text(loaded.email!),
                    ),
                  if (loaded.phoneNumber != null &&
                      loaded.phoneNumber!.isNotEmpty)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text(PeopleStrings.phoneNumber),
                      subtitle: Text(loaded.phoneNumber!),
                    ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<EmployeeStatus>(
                    // ignore: deprecated_member_use
                    value: state.currentStatus,
                    decoration: const InputDecoration(
                      labelText: PeopleStrings.employmentStatus,
                    ),
                    items: [
                      for (final status in EmployeeStatus.values)
                        DropdownMenuItem(
                          value: status,
                          child: Text(_statusLabel(status)),
                        ),
                    ],
                    onChanged: submitting
                        ? null
                        : (value) {
                            if (value == null) return;
                            _changeStatus(value);
                          },
                  ),
                  const SizedBox(height: 8),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.security),
                    title: const Text(PeopleStrings.manageRoles),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: submitting
                        ? null
                        : () => context.push(
                            Routes.adminEmployeeRolesById('${loaded.id}'),
                          ),
                  ),
                ],
                TextField(
                  controller: _jobTitle,
                  enabled: !submitting,
                  decoration: const InputDecoration(
                    labelText: PeopleStrings.jobTitle,
                  ),
                  onChanged: (v) {
                    final cubit = context.read<EmployeeFormCubit>();
                    if (cubit.state.isCreate) {
                      cubit.updateCreateInput((i) => i.copyWith(jobTitle: v));
                    } else {
                      cubit.updateEditInput((i) => i.copyWith(jobTitle: v));
                    }
                  },
                ),
                TextField(
                  controller: _department,
                  enabled: !submitting,
                  decoration: InputDecoration(
                    labelText: PeopleStrings.department,
                    suffixIcon: !state.isCreate &&
                            _department.text.trim().isNotEmpty
                        ? IconButton(
                            tooltip: PeopleStrings.clearDepartment,
                            onPressed: submitting
                                ? null
                                : () {
                                    _department.clear();
                                    context
                                        .read<EmployeeFormCubit>()
                                        .updateEditInput(
                                          (i) => i.copyWith(department: null),
                                        );
                                    setState(() {});
                                  },
                            icon: const Icon(Icons.clear),
                          )
                        : null,
                  ),
                  onChanged: (v) {
                    final cubit = context.read<EmployeeFormCubit>();
                    final value = _optional(v);
                    if (cubit.state.isCreate) {
                      cubit.updateCreateInput(
                        (i) => i.copyWith(department: value),
                      );
                    } else {
                      cubit.updateEditInput(
                        (i) => i.copyWith(department: value),
                      );
                    }
                    setState(() {});
                  },
                ),
                const SizedBox(height: 8),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    hireDate == null
                        ? PeopleStrings.hireDate
                        : '${PeopleStrings.hireDate}: ${DateFormat.yMMMd().format(hireDate)}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (hireDate != null)
                        IconButton(
                          tooltip: PeopleStrings.clearHireDate,
                          onPressed: submitting
                              ? null
                              : () {
                                  final cubit =
                                      context.read<EmployeeFormCubit>();
                                  if (cubit.state.isCreate) {
                                    cubit.updateCreateInput(
                                      (i) => NewEmployeeInput(
                                        firstName: i.firstName,
                                        lastName: i.lastName,
                                        email: i.email,
                                        phoneNumber: i.phoneNumber,
                                        password: i.password,
                                        jobTitle: i.jobTitle,
                                        department: i.department,
                                        hireDate: null,
                                        roleId: i.roleId,
                                      ),
                                    );
                                  } else {
                                    cubit.updateEditInput(
                                      (i) => i.copyWith(hireDate: null),
                                    );
                                  }
                                },
                          icon: const Icon(Icons.clear),
                        ),
                      IconButton(
                        tooltip: PeopleStrings.pickHireDate,
                        onPressed: submitting
                            ? null
                            : () => _pickHireDate(
                                context.read<EmployeeFormCubit>(),
                                hireDate,
                              ),
                        icon: const Icon(Icons.calendar_today),
                      ),
                    ],
                  ),
                ),
                if (state.isCreate) ...[
                  const SizedBox(height: 8),
                  if (state.rolesLoading)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: LinearProgressIndicator(),
                    )
                  else
                    DropdownButtonFormField<int>(
                      // ignore: deprecated_member_use
                      value: selectedRoleId != null &&
                              state.roles.any((r) => r.id == selectedRoleId)
                          ? selectedRoleId
                          : null,
                      decoration: const InputDecoration(
                        labelText: PeopleStrings.role,
                      ),
                      items: [
                        for (final role in state.roles)
                          DropdownMenuItem(
                            value: role.id,
                            child: Text(role.name),
                          ),
                      ],
                      onChanged: submitting
                          ? null
                          : (value) {
                              if (value == null) return;
                              context
                                  .read<EmployeeFormCubit>()
                                  .updateCreateInput(
                                    (i) => i.copyWith(roleId: value),
                                  );
                            },
                      hint: const Text(PeopleStrings.selectRole),
                    ),
                ],
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: submitting ? null : _submit,
                  child: submitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          state.isCreate
                              ? PeopleStrings.createEmployee
                              : PeopleStrings.save,
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
