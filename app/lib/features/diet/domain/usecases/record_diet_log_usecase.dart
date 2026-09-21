import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/diet_log.dart';
import '../repositories/diet_log_repository.dart';

class RecordDietLogParams extends Equatable {
  const RecordDietLogParams({
    required this.memberId,
    required this.date,
    this.dietPlanId,
    this.totalCaloriesConsumed,
    this.adherenceScore,
    this.waterIntakeMl,
    this.memberNotes,
  });

  final String memberId;
  final DateTime date;
  final String? dietPlanId;
  final num? totalCaloriesConsumed;
  final num? adherenceScore;
  final int? waterIntakeMl;
  final String? memberNotes;

  @override
  List<Object?> get props => [
    memberId,
    date,
    dietPlanId,
    totalCaloriesConsumed,
    adherenceScore,
    waterIntakeMl,
    memberNotes,
  ];
}

@lazySingleton
class RecordDietLogUseCase implements UseCase<DietLog, RecordDietLogParams> {
  const RecordDietLogUseCase(this._repository);

  final DietLogRepository _repository;

  @override
  Future<Either<Failure, DietLog>> call(RecordDietLogParams params) {
    return _repository.recordDietLog(
      memberId: params.memberId,
      date: params.date,
      dietPlanId: params.dietPlanId,
      totalCaloriesConsumed: params.totalCaloriesConsumed,
      adherenceScore: params.adherenceScore,
      waterIntakeMl: params.waterIntakeMl,
      memberNotes: params.memberNotes,
    );
  }
}
