import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/performed_set_metrics.dart';
import '../entities/workout_session_set.dart';
import '../repositories/workout_session_repository.dart';

class UpdateWorkoutSetParams extends Equatable {
  const UpdateWorkoutSetParams({
    required this.sessionId,
    required this.setId,
    this.metrics = const PerformedSetMetrics(),
  });

  factory UpdateWorkoutSetParams.fromFields({
    required String sessionId,
    required String setId,
    int? reps,
    num? weightKg,
    num? rpe,
    num? actualRir,
    int? actualDurationSeconds,
    bool? isCompleted,
    String? notes,
  }) {
    return UpdateWorkoutSetParams(
      sessionId: sessionId,
      setId: setId,
      metrics: PerformedSetMetrics(
        repsCompleted: reps,
        weightLiftedKg: weightKg,
        rpeScore: rpe,
        actualRir: actualRir,
        actualDurationSeconds: actualDurationSeconds,
        isCompleted: isCompleted,
        notes: notes,
      ),
    );
  }

  final String sessionId;
  final String setId;
  final PerformedSetMetrics metrics;

  int? get reps => metrics.repsCompleted;
  num? get weightKg => metrics.weightLiftedKg;
  num? get rpe => metrics.rpeScore;
  num? get actualRir => metrics.actualRir;
  int? get actualDurationSeconds => metrics.actualDurationSeconds;
  bool? get isCompleted => metrics.isCompleted;
  String? get notes => metrics.notes;

  @override
  List<Object?> get props => [sessionId, setId, metrics];
}

@lazySingleton
class UpdateWorkoutSetUseCase
    implements UseCase<WorkoutSessionSet, UpdateWorkoutSetParams> {
  const UpdateWorkoutSetUseCase(this._repository);

  final WorkoutSessionRepository _repository;

  @override
  Future<Either<Failure, WorkoutSessionSet>> call(
    UpdateWorkoutSetParams params,
  ) {
    return _repository.updateSet(
      params.sessionId,
      params.setId,
      metrics: params.metrics,
    );
  }
}
