import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/pagination/cursor_page.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/exercise.dart';
import '../entities/exercise_filter.dart';
import '../repositories/exercise_repository.dart';

class GetExercisesParams extends Equatable {
  const GetExercisesParams({this.filter = const ExerciseFilter(), this.cursor});

  final ExerciseFilter filter;
  final String? cursor;

  @override
  List<Object?> get props => [filter, cursor];
}

@lazySingleton
class GetExercisesUseCase
    implements UseCase<CursorPage<Exercise>, GetExercisesParams> {
  const GetExercisesUseCase(this._repository);

  final ExerciseRepository _repository;

  @override
  Future<Either<Failure, CursorPage<Exercise>>> call(
    GetExercisesParams params,
  ) {
    return _repository.getExercises(params.filter, params.cursor);
  }
}
