import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/employee_status.dart';
import '../entities/employee_summary.dart';
import '../repositories/people_repository.dart';

class SetEmployeeStatusParams extends Equatable {
  const SetEmployeeStatusParams({required this.id, required this.status});

  final int id;
  final EmployeeStatus status;

  @override
  List<Object?> get props => [id, status];
}

@lazySingleton
class SetEmployeeStatusUseCase
    implements UseCase<EmployeeSummary, SetEmployeeStatusParams> {
  const SetEmployeeStatusUseCase(this._repository);

  final PeopleRepository _repository;

  @override
  Future<Either<Failure, EmployeeSummary>> call(
    SetEmployeeStatusParams params,
  ) {
    return _repository.setEmployeeStatus(params.id, params.status);
  }
}
