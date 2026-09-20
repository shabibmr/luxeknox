import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/person.dart';
import '../repositories/people_repository.dart';

@lazySingleton
class GetMemberUseCase implements UseCase<Person, int> {
  const GetMemberUseCase(this._repository);

  final PeopleRepository _repository;

  @override
  Future<Either<Failure, Person>> call(int id) {
    return _repository.getMember(id);
  }
}
