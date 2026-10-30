import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/exercise_history_session.dart';
import '../repositories/workout_session_repository.dart';

class GetExerciseHistoryParams extends Equatable {
  const GetExerciseHistoryParams({this.memberId, required this.exerciseId});

  final String? memberId;
  final String exerciseId;

  @override
  List<Object?> get props => [memberId, exerciseId];
}

@lazySingleton
class GetExerciseHistoryUseCase
    implements UseCase<List<ExerciseHistorySession>, GetExerciseHistoryParams> {
  const GetExerciseHistoryUseCase(this._repository);

  final WorkoutSessionRepository _repository;

  @override
  Future<Either<Failure, List<ExerciseHistorySession>>> call(
    GetExerciseHistoryParams params,
  ) {
    return _repository.getExerciseHistory(
      memberId: params.memberId,
      exerciseId: params.exerciseId,
    );
  }
}
