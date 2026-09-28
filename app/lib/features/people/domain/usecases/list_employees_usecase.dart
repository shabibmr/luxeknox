import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/pagination/cursor_page.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/employee_summary.dart';
import '../repositories/people_repository.dart';

class ListEmployeesParams extends Equatable {
  const ListEmployeesParams({this.query, this.status, this.cursor});

  final String? query;
  final String? status;
  final String? cursor;

  @override
  List<Object?> get props => [query, status, cursor];
}

@lazySingleton
class ListEmployeesUseCase
    implements UseCase<CursorPage<EmployeeSummary>, ListEmployeesParams> {
  const ListEmployeesUseCase(this._repository);

  final PeopleRepository _repository;

  @override
  Future<Either<Failure, CursorPage<EmployeeSummary>>> call(
    ListEmployeesParams params,
  ) {
    return _repository.listEmployees(
      query: params.query,
      status: params.status,
      cursor: params.cursor,
    );
  }
}
