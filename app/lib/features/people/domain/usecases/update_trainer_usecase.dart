import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/trainer_profile.dart';
import '../repositories/people_repository.dart';

@lazySingleton
class UpdateTrainerUseCase implements UseCase<TrainerProfile, TrainerProfile> {
  const UpdateTrainerUseCase(this._repository);

  final PeopleRepository _repository;

  @override
  Future<Either<Failure, TrainerProfile>> call(TrainerProfile trainer) {
    return _repository.updateTrainer(trainer);
  }
}
