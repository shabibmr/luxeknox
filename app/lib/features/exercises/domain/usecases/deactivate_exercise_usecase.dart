import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/exercise_repository.dart';

@lazySingleton
class DeactivateExerciseUseCase implements UseCase<void, String> {
  const DeactivateExerciseUseCase(this._repository);

  final ExerciseRepository _repository;

  @override
  Future<Either<Failure, void>> call(String id) {
    return _repository.deactivate(id);
  }
}
