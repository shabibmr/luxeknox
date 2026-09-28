import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/employee_summary.dart';
import '../repositories/people_repository.dart';

@lazySingleton
class GetEmployeeUseCase implements UseCase<EmployeeSummary, int> {
  const GetEmployeeUseCase(this._repository);

  final PeopleRepository _repository;

  @override
  Future<Either<Failure, EmployeeSummary>> call(int id) {
    return _repository.getEmployee(id);
  }
}
