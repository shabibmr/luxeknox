import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/exercise.dart';
import '../repositories/exercise_repository.dart';

@lazySingleton
class GetExerciseUseCase implements UseCase<Exercise, String> {
  const GetExerciseUseCase(this._repository);

  final ExerciseRepository _repository;

  @override
  Future<Either<Failure, Exercise>> call(String id) {
    return _repository.getExercise(id);
  }
}
