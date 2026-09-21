import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/role.dart';
import '../repositories/people_repository.dart';

@lazySingleton
class ListRolesUseCase implements UseCase<List<Role>, NoParams> {
  const ListRolesUseCase(this._repository);

  final PeopleRepository _repository;

  @override
  Future<Either<Failure, List<Role>>> call(NoParams params) {
    return _repository.listRoles();
  }
}
