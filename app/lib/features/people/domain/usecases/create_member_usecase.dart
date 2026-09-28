import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/new_member_input.dart';
import '../entities/person.dart';
import '../repositories/people_repository.dart';

@lazySingleton
class CreateMemberUseCase implements UseCase<Person, NewMemberInput> {
  const CreateMemberUseCase(this._repository);

  final PeopleRepository _repository;

  @override
  Future<Either<Failure, Person>> call(NewMemberInput input) {
    return _repository.createMember(input);
  }
}
