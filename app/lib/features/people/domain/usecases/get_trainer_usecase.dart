import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/trainer_profile.dart';
import '../repositories/people_repository.dart';

@lazySingleton
class GetTrainerUseCase implements UseCase<TrainerProfile, int> {
  const GetTrainerUseCase(this._repository);

  final PeopleRepository _repository;

  @override
  Future<Either<Failure, TrainerProfile>> call(int id) {
    return _repository.getTrainer(id);
  }
}
