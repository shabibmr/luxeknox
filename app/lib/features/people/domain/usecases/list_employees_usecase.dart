import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/pagination/cursor_page.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/employee_summary.dart';
import '../repositories/people_repository.dart';

class ListEmployeesParams extends Equatable {
  const ListEmployeesParams({this.query, this.cursor});

  final String? query;
  final String? cursor;

  @override
  List<Object?> get props => [query, cursor];
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
      cursor: params.cursor,
    );
  }
}
