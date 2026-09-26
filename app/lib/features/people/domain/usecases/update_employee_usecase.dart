import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/employee_summary.dart';
import '../entities/employee_update_input.dart';
import '../repositories/people_repository.dart';

class UpdateEmployeeParams extends Equatable {
  const UpdateEmployeeParams({required this.id, required this.input});

  final int id;
  final EmployeeUpdateInput input;

  @override
  List<Object?> get props => [id, input];
}

@lazySingleton
class UpdateEmployeeUseCase
    implements UseCase<EmployeeSummary, UpdateEmployeeParams> {
  const UpdateEmployeeUseCase(this._repository);

  final PeopleRepository _repository;

  @override
  Future<Either<Failure, EmployeeSummary>> call(UpdateEmployeeParams params) {
    return _repository.updateEmployee(params.id, params.input);
  }
}
