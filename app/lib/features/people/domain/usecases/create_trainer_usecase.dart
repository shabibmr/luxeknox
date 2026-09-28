import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/new_trainer_input.dart';
import '../entities/trainer_profile.dart';
import '../repositories/people_repository.dart';

@lazySingleton
class CreateTrainerUseCase implements UseCase<TrainerProfile, NewTrainerInput> {
  const CreateTrainerUseCase(this._repository);

  final PeopleRepository _repository;

  @override
  Future<Either<Failure, TrainerProfile>> call(NewTrainerInput input) {
    return _repository.createTrainer(input);
  }
}
