import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/person.dart';
import '../repositories/people_repository.dart';

@lazySingleton
class UpdateMemberUseCase implements UseCase<Person, Person> {
  const UpdateMemberUseCase(this._repository);

  final PeopleRepository _repository;

  @override
  Future<Either<Failure, Person>> call(Person person) {
    return _repository.updateMember(person);
  }
}
