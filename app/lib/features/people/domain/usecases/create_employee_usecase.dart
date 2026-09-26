import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/employee_summary.dart';
import '../entities/new_employee_input.dart';
import '../repositories/people_repository.dart';

@lazySingleton
class CreateEmployeeUseCase
    implements UseCase<EmployeeSummary, NewEmployeeInput> {
  const CreateEmployeeUseCase(this._repository);

  final PeopleRepository _repository;

  @override
  Future<Either<Failure, EmployeeSummary>> call(NewEmployeeInput input) {
    return _repository.createEmployee(input);
  }
}
