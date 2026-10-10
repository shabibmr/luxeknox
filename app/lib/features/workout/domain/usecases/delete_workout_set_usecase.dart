import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/workout_session_repository.dart';

class DeleteWorkoutSetParams extends Equatable {
  const DeleteWorkoutSetParams({required this.sessionId, required this.setId});

  final String sessionId;
  final String setId;

  @override
  List<Object?> get props => [sessionId, setId];
}

@lazySingleton
class DeleteWorkoutSetUseCase implements UseCase<Unit, DeleteWorkoutSetParams> {
  const DeleteWorkoutSetUseCase(this._repository);

  final WorkoutSessionRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(DeleteWorkoutSetParams params) {
    return _repository.deleteSet(params.sessionId, params.setId);
  }
}
