import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/performed_set_metrics.dart';
import '../entities/workout_session_set.dart';
import '../repositories/workout_session_repository.dart';

class LogWorkoutSetParams extends Equatable {
  const LogWorkoutSetParams({
    required this.sessionId,
    required this.exerciseId,
    required this.setNumber,
    this.metrics = const PerformedSetMetrics(),
  });

  factory LogWorkoutSetParams.fromFields({
    required String sessionId,
    required String exerciseId,
    required int setNumber,
    int? repsCompleted,
    num? weightLiftedKg,
    num? rpeScore,
    num? actualRir,
    int? actualDurationSeconds,
    bool? isCompleted = true,
    String? notes,
  }) {
    return LogWorkoutSetParams(
      sessionId: sessionId,
      exerciseId: exerciseId,
      setNumber: setNumber,
      metrics: PerformedSetMetrics(
        repsCompleted: repsCompleted,
        weightLiftedKg: weightLiftedKg,
        rpeScore: rpeScore,
        actualRir: actualRir,
        actualDurationSeconds: actualDurationSeconds,
        isCompleted: isCompleted,
        notes: notes,
      ),
    );
  }

  final String sessionId;
  final String exerciseId;
  final int setNumber;
  final PerformedSetMetrics metrics;

  int? get repsCompleted => metrics.repsCompleted;
  num? get weightLiftedKg => metrics.weightLiftedKg;
  num? get rpeScore => metrics.rpeScore;
  num? get actualRir => metrics.actualRir;
  int? get actualDurationSeconds => metrics.actualDurationSeconds;
  bool? get isCompleted => metrics.isCompleted;
  String? get notes => metrics.notes;

  @override
  List<Object?> get props => [sessionId, exerciseId, setNumber, metrics];
}

@lazySingleton
class LogWorkoutSetUseCase
    implements UseCase<WorkoutSessionSet, LogWorkoutSetParams> {
  const LogWorkoutSetUseCase(this._repository);

  final WorkoutSessionRepository _repository;

  @override
  Future<Either<Failure, WorkoutSessionSet>> call(LogWorkoutSetParams params) {
    return _repository.logSet(
      params.sessionId,
      exerciseId: params.exerciseId,
      setNumber: params.setNumber,
      metrics: params.metrics,
    );
  }
}
