import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/exercise.dart';
import '../repositories/exercise_repository.dart';

@lazySingleton
class UpdateExerciseUseCase implements UseCase<Exercise, Exercise> {
  const UpdateExerciseUseCase(this._repository);

  final ExerciseRepository _repository;

  @override
  Future<Either<Failure, Exercise>> call(Exercise exercise) {
    return _repository.update(exercise);
  }
}
