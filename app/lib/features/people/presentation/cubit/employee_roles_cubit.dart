import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/employee_summary.dart';
import '../../domain/entities/role.dart';
import '../../domain/usecases/assign_employee_role_usecase.dart';
import '../../domain/usecases/get_employee_usecase.dart';
import '../../domain/usecases/list_roles_usecase.dart';

part 'employee_roles_cubit.freezed.dart';

@freezed
abstract class EmployeeRolesState with _$EmployeeRolesState {
  const factory EmployeeRolesState({
    @Default(LoadStatus.initial) LoadStatus status,
    EmployeeSummary? employee,
    @Default(<Role>[]) List<Role> roles,
    @Default(false) bool assigning,
    @Default(false) bool assigned,
    Failure? failure,
  }) = _EmployeeRolesState;
}

@injectable
class EmployeeRolesCubit extends Cubit<EmployeeRolesState> {
  EmployeeRolesCubit(this._getEmployee, this._listRoles, this._assignRole)
    : super(const EmployeeRolesState());

  final GetEmployeeUseCase _getEmployee;
  final ListRolesUseCase _listRoles;
  final AssignEmployeeRoleUseCase _assignRole;

  Future<void> load(int employeeId) async {
    emit(
      state.copyWith(
        status: LoadStatus.loading,
        failure: null,
        assigning: false,
        assigned: false,
      ),
    );
    final employeeResult = await _getEmployee(employeeId);
    await employeeResult.fold(
      (failure) async =>
          emit(state.copyWith(status: LoadStatus.failure, failure: failure)),
      (employee) async {
        final rolesResult = await _listRoles(const NoParams());
        rolesResult.fold(
          (failure) => emit(
            state.copyWith(status: LoadStatus.failure, failure: failure),
          ),
          (roles) => emit(
            state.copyWith(
              status: LoadStatus.success,
              employee: employee,
              roles: roles,
              failure: null,
              assigning: false,
              assigned: false,
            ),
          ),
        );
      },
    );
  }

  Future<void> assignRole(int roleId) async {
    final employee = state.employee;
    if (employee == null) return;
    emit(state.copyWith(assigning: true, assigned: false, failure: null));
    final result = await _assignRole(
      AssignEmployeeRoleParams(employeeId: employee.id, roleId: roleId),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: LoadStatus.failure,
          failure: failure,
          assigning: false,
          assigned: false,
        ),
      ),
      (updated) => emit(
        state.copyWith(
          status: LoadStatus.success,
          employee: updated,
          assigning: false,
          assigned: true,
          failure: null,
        ),
      ),
    );
  }
}
