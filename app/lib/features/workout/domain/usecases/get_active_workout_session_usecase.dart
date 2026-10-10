import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/workout_session.dart';
import '../repositories/workout_session_repository.dart';

class GetActiveWorkoutSessionParams extends Equatable {
  const GetActiveWorkoutSessionParams({required this.memberId});

  final String memberId;

  @override
  List<Object?> get props => [memberId];
}

@lazySingleton
class GetActiveWorkoutSessionUseCase
    implements UseCase<WorkoutSession?, GetActiveWorkoutSessionParams> {
  const GetActiveWorkoutSessionUseCase(this._repository);

  final WorkoutSessionRepository _repository;

  @override
  Future<Either<Failure, WorkoutSession?>> call(
    GetActiveWorkoutSessionParams params,
  ) {
    return _repository.getActiveSession(params.memberId);
  }
}
