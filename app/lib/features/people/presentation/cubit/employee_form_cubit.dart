import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failure_messages.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/employee_status.dart';
import '../../domain/entities/employee_summary.dart';
import '../../domain/entities/employee_update_input.dart';
import '../../domain/entities/new_employee_input.dart';
import '../../domain/entities/role.dart';
import '../../domain/usecases/create_employee_usecase.dart';
import '../../domain/usecases/get_employee_usecase.dart';
import '../../domain/usecases/list_roles_usecase.dart';
import '../../domain/usecases/set_employee_status_usecase.dart';
import '../../domain/usecases/update_employee_usecase.dart';
import '../people_strings.dart';

enum EmployeeFormMode { create, edit }

class EmployeeFormState extends Equatable {
  const EmployeeFormState({
    this.mode = EmployeeFormMode.create,
    this.employeeId,
    this.createInput = const NewEmployeeInput(email: '', roleId: 0),
    this.updateInput = const EmployeeUpdateInput(),
    this.loadedEmployee,
    this.roles = const [],
    this.rolesLoading = false,
    this.initialLoading = false,
    this.submitting = false,
    this.statusUpdating = false,
    this.saved,
    this.error,
  });

  final EmployeeFormMode mode;
  final int? employeeId;
  final NewEmployeeInput createInput;
  final EmployeeUpdateInput updateInput;
  final EmployeeSummary? loadedEmployee;
  final List<Role> roles;
  final bool rolesLoading;
  final bool initialLoading;
  final bool submitting;
  final bool statusUpdating;
  final EmployeeSummary? saved;
  final String? error;

  bool get isCreate => mode == EmployeeFormMode.create;

  EmployeeStatus get currentStatus =>
      EmployeeStatus.fromWire(loadedEmployee?.status);

  bool get isDirty {
    if (mode == EmployeeFormMode.create) {
      return createInput.firstName.trim().isNotEmpty ||
          createInput.lastName.trim().isNotEmpty ||
          createInput.email.trim().isNotEmpty ||
          (createInput.phoneNumber?.trim().isNotEmpty ?? false) ||
          (createInput.password?.trim().isNotEmpty ?? false) ||
          createInput.jobTitle.trim().isNotEmpty ||
          (createInput.department?.trim().isNotEmpty ?? false) ||
          createInput.hireDate != null;
    }
    final loaded = loadedEmployee;
    if (loaded == null) return false;
    return updateInput.jobTitle != loaded.jobTitle ||
        updateInput.department != loaded.department ||
        !_sameDay(updateInput.hireDate, loaded.hireDate);
  }

  static bool _sameDay(DateTime? a, DateTime? b) {
    if (a == null && b == null) return true;
    if (a == null || b == null) return false;
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  EmployeeFormState copyWith({
    EmployeeFormMode? mode,
    int? employeeId,
    NewEmployeeInput? createInput,
    EmployeeUpdateInput? updateInput,
    EmployeeSummary? loadedEmployee,
    List<Role>? roles,
    bool? rolesLoading,
    bool? initialLoading,
    bool? submitting,
    bool? statusUpdating,
    EmployeeSummary? saved,
    String? error,
    bool clearError = false,
    bool clearSaved = false,
    bool clearEmployeeId = false,
    bool clearLoadedEmployee = false,
  }) {
    return EmployeeFormState(
      mode: mode ?? this.mode,
      employeeId: clearEmployeeId ? null : (employeeId ?? this.employeeId),
      createInput: createInput ?? this.createInput,
      updateInput: updateInput ?? this.updateInput,
      loadedEmployee: clearLoadedEmployee
          ? null
          : (loadedEmployee ?? this.loadedEmployee),
      roles: roles ?? this.roles,
      rolesLoading: rolesLoading ?? this.rolesLoading,
      initialLoading: initialLoading ?? this.initialLoading,
      submitting: submitting ?? this.submitting,
      statusUpdating: statusUpdating ?? this.statusUpdating,
      saved: clearSaved ? null : (saved ?? this.saved),
      error: clearError ? null : (error ?? this.error),
    );
  }

  @override
  List<Object?> get props => [
    mode,
    employeeId,
    createInput,
    updateInput,
    loadedEmployee,
    roles,
    rolesLoading,
    initialLoading,
    submitting,
    statusUpdating,
    saved,
    error,
  ];
}

@injectable
class EmployeeFormCubit extends Cubit<EmployeeFormState> {
  EmployeeFormCubit(
    this._createEmployee,
    this._updateEmployee,
    this._getEmployee,
    this._listRoles,
    this._setEmployeeStatus,
  ) : super(const EmployeeFormState());

  final CreateEmployeeUseCase _createEmployee;
  final UpdateEmployeeUseCase _updateEmployee;
  final GetEmployeeUseCase _getEmployee;
  final ListRolesUseCase _listRoles;
  final SetEmployeeStatusUseCase _setEmployeeStatus;

  /// Create-mode entry: load assignable roles.
  Future<void> initCreate() async {
    emit(
      state.copyWith(
        mode: EmployeeFormMode.create,
        clearEmployeeId: true,
        clearLoadedEmployee: true,
        clearSaved: true,
        clearError: true,
        createInput: const NewEmployeeInput(email: '', roleId: 0),
        updateInput: const EmployeeUpdateInput(),
      ),
    );
    await _loadRoles();
  }

  /// Edit-mode entry: prefill from `getEmployee`.
  Future<void> initEdit(int employeeId) async {
    emit(
      state.copyWith(
        mode: EmployeeFormMode.edit,
        employeeId: employeeId,
        initialLoading: true,
        clearSaved: true,
        clearError: true,
        clearLoadedEmployee: true,
      ),
    );

    final employeeResult = await _getEmployee(employeeId);
    if (isClosed) return;
    await employeeResult.fold(
      (failure) async {
        emit(
          state.copyWith(
            initialLoading: false,
            error: _message(failure),
          ),
        );
      },
      (employee) async {
        emit(
          state.copyWith(
            loadedEmployee: employee,
            updateInput: EmployeeUpdateInput(
              jobTitle: employee.jobTitle,
              department: employee.department,
              hireDate: employee.hireDate,
            ),
            initialLoading: false,
          ),
        );
      },
    );
  }

  void updateCreateInput(NewEmployeeInput Function(NewEmployeeInput) update) {
    emit(
      state.copyWith(
        createInput: update(state.createInput),
        clearError: true,
      ),
    );
  }

  void updateEditInput(EmployeeUpdateInput Function(EmployeeUpdateInput) update) {
    emit(
      state.copyWith(
        updateInput: update(state.updateInput),
        clearError: true,
      ),
    );
  }

  /// Clears [EmployeeFormState.saved] after an embedded save snackbar.
  void acknowledgeSaved() {
    if (state.saved == null) return;
    emit(state.copyWith(clearSaved: true));
  }

  /// Returns false when a submit is already in flight (double-submit guard).
  Future<bool> submit() async {
    if (state.submitting) return false;

    if (state.mode == EmployeeFormMode.create) {
      return _submitCreate();
    }
    return _submitEdit();
  }

  static bool statusRequiresConfirm(EmployeeStatus status) {
    return status == EmployeeStatus.suspended ||
        status == EmployeeStatus.terminated;
  }

  /// Updates employment status via `setEmployeeStatus`.
  Future<bool> changeStatus(EmployeeStatus status) async {
    if (state.mode != EmployeeFormMode.edit) return false;
    final id = state.employeeId;
    if (id == null) {
      emit(state.copyWith(error: PeopleStrings.employeeMissing));
      return false;
    }
    if (state.statusUpdating || state.submitting) return false;
    if (status == state.currentStatus) return true;

    emit(
      state.copyWith(statusUpdating: true, clearError: true, clearSaved: true),
    );
    final result = await _setEmployeeStatus(
      SetEmployeeStatusParams(id: id, status: status),
    );
    if (isClosed) return false;
    return result.fold(
      (failure) {
        emit(state.copyWith(statusUpdating: false, error: _message(failure)));
        return false;
      },
      (employee) {
        emit(
          state.copyWith(
            statusUpdating: false,
            loadedEmployee: employee,
            updateInput: EmployeeUpdateInput(
              jobTitle: employee.jobTitle,
              department: employee.department,
              hireDate: employee.hireDate,
            ),
          ),
        );
        return true;
      },
    );
  }

  Future<bool> _submitCreate() async {
    final validationError = _validateCreate(state.createInput);
    if (validationError != null) {
      emit(state.copyWith(error: validationError));
      return false;
    }

    emit(state.copyWith(submitting: true, clearError: true, clearSaved: true));
    final result = await _createEmployee(state.createInput);
    if (isClosed) return false;
    return result.fold(
      (failure) {
        emit(state.copyWith(submitting: false, error: _message(failure)));
        return false;
      },
      (employee) {
        emit(state.copyWith(submitting: false, saved: employee));
        return true;
      },
    );
  }

  Future<bool> _submitEdit() async {
    final id = state.employeeId;
    if (id == null) {
      emit(state.copyWith(error: PeopleStrings.employeeMissing));
      return false;
    }

    final validationError = _validateEdit(state.updateInput);
    if (validationError != null) {
      emit(state.copyWith(error: validationError));
      return false;
    }

    emit(state.copyWith(submitting: true, clearError: true, clearSaved: true));
    final result = await _updateEmployee(
      UpdateEmployeeParams(id: id, input: state.updateInput),
    );
    if (isClosed) return false;
    return result.fold(
      (failure) {
        emit(state.copyWith(submitting: false, error: _message(failure)));
        return false;
      },
      (employee) {
        emit(
          state.copyWith(
            submitting: false,
            saved: employee,
            loadedEmployee: employee,
            updateInput: EmployeeUpdateInput(
              jobTitle: employee.jobTitle,
              department: employee.department,
              hireDate: employee.hireDate,
            ),
          ),
        );
        return true;
      },
    );
  }

  Future<void> _loadRoles() async {
    emit(state.copyWith(rolesLoading: true, clearError: true));
    final result = await _listRoles(const NoParams());
    if (isClosed) return;
    result.fold(
      (failure) => emit(
        state.copyWith(rolesLoading: false, error: _message(failure)),
      ),
      (roles) {
        final defaultRole = _findEmployeeRole(roles);
        final nextCreateInput = defaultRole != null && state.createInput.roleId <= 0
            ? state.createInput.copyWith(roleId: defaultRole.id)
            : state.createInput;
        emit(
          state.copyWith(
            rolesLoading: false,
            roles: roles,
            createInput: nextCreateInput,
          ),
        );
      },
    );
  }

  static Role? _findEmployeeRole(List<Role> roles) {
    if (roles.isEmpty) return null;
    for (final role in roles) {
      if (role.name.trim().toLowerCase() == 'employee / front desk') {
        return role;
      }
    }
    for (final role in roles) {
      final lower = role.name.toLowerCase();
      if (lower.contains('employee') || lower.contains('front desk')) {
        return role;
      }
    }
    return roles.first;
  }

  String? _validateCreate(NewEmployeeInput input) {
    if (input.firstName.trim().isEmpty) {
      return PeopleStrings.firstNameRequired;
    }
    if (input.lastName.trim().isEmpty) {
      return PeopleStrings.lastNameRequired;
    }
    if (input.email.trim().isEmpty) {
      return PeopleStrings.emailRequired;
    }
    final password = input.password?.trim() ?? '';
    if (password.isEmpty) {
      return PeopleStrings.passwordRequired;
    }
    if (input.jobTitle.trim().isEmpty) {
      return PeopleStrings.jobTitleRequired;
    }
    if (input.roleId <= 0) {
      return PeopleStrings.roleRequired;
    }
    return null;
  }

  String? _validateEdit(EmployeeUpdateInput input) {
    final title = input.jobTitle?.trim() ?? '';
    if (title.isEmpty) {
      return PeopleStrings.jobTitleRequired;
    }
    return null;
  }

  String _message(Failure failure) => failureMessage(failure);
}
