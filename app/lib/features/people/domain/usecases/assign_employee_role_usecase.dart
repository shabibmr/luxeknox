import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/employee_summary.dart';
import '../repositories/people_repository.dart';

class AssignEmployeeRoleParams extends Equatable {
  const AssignEmployeeRoleParams({
    required this.employeeId,
    required this.roleId,
  });

  final int employeeId;
  final int roleId;

  @override
  List<Object?> get props => [employeeId, roleId];
}

@lazySingleton
class AssignEmployeeRoleUseCase
    implements UseCase<EmployeeSummary, AssignEmployeeRoleParams> {
  const AssignEmployeeRoleUseCase(this._repository);

  final PeopleRepository _repository;

  @override
  Future<Either<Failure, EmployeeSummary>> call(
    AssignEmployeeRoleParams params,
  ) {
    return _repository.assignEmployeeRole(
      employeeId: params.employeeId,
      roleId: params.roleId,
    );
  }
}
