import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/employee_summary.dart';
import '../../domain/entities/role.dart';
import '../../domain/usecases/assign_employee_role_usecase.dart';
import '../../domain/usecases/get_employee_usecase.dart';
import '../../domain/usecases/list_roles_usecase.dart';

sealed class EmployeeRolesState extends Equatable {
  const EmployeeRolesState();

  @override
  List<Object?> get props => [];
}

final class EmployeeRolesLoading extends EmployeeRolesState {
  const EmployeeRolesLoading();
}

final class EmployeeRolesLoaded extends EmployeeRolesState {
  const EmployeeRolesLoaded({
    required this.employee,
    required this.roles,
    this.assigning = false,
    this.assigned = false,
  });

  final EmployeeSummary employee;
  final List<Role> roles;
  final bool assigning;
  final bool assigned;

  EmployeeRolesLoaded copyWith({
    EmployeeSummary? employee,
    List<Role>? roles,
    bool? assigning,
    bool? assigned,
  }) {
    return EmployeeRolesLoaded(
      employee: employee ?? this.employee,
      roles: roles ?? this.roles,
      assigning: assigning ?? this.assigning,
      assigned: assigned ?? false,
    );
  }

  @override
  List<Object?> get props => [employee, roles, assigning, assigned];
}

final class EmployeeRolesFailure extends EmployeeRolesState {
  const EmployeeRolesFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

@injectable
class EmployeeRolesCubit extends Cubit<EmployeeRolesState> {
  EmployeeRolesCubit(this._getEmployee, this._listRoles, this._assignRole)
    : super(const EmployeeRolesLoading());

  final GetEmployeeUseCase _getEmployee;
  final ListRolesUseCase _listRoles;
  final AssignEmployeeRoleUseCase _assignRole;

  Future<void> load(int employeeId) async {
    emit(const EmployeeRolesLoading());
    final employeeResult = await _getEmployee(employeeId);
    await employeeResult.fold(
      (failure) async => emit(EmployeeRolesFailure(_message(failure))),
      (employee) async {
        final rolesResult = await _listRoles(const NoParams());
        rolesResult.fold(
          (failure) => emit(EmployeeRolesFailure(_message(failure))),
          (roles) =>
              emit(EmployeeRolesLoaded(employee: employee, roles: roles)),
        );
      },
    );
  }

  Future<void> assignRole(int roleId) async {
    final current = state;
    if (current is! EmployeeRolesLoaded) return;
    emit(current.copyWith(assigning: true));
    final result = await _assignRole(
      AssignEmployeeRoleParams(employeeId: current.employee.id, roleId: roleId),
    );
    result.fold(
      (failure) => emit(EmployeeRolesFailure(_message(failure))),
      (employee) => emit(
        current.copyWith(employee: employee, assigning: false, assigned: true),
      ),
    );
  }

  String _message(Failure failure) => failureMessage(failure);
}
