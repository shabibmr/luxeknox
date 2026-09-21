import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/pagination/cursor_page.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/workout_session.dart';
import '../repositories/workout_session_repository.dart';

class ListWorkoutSessionsParams extends Equatable {
  const ListWorkoutSessionsParams({
    this.memberId,
    this.limit,
    this.cursor,
  });

  final String? memberId;
  final int? limit;
  final String? cursor;

  @override
  List<Object?> get props => [memberId, limit, cursor];
}

@lazySingleton
class ListWorkoutSessionsUseCase
    implements UseCase<CursorPage<WorkoutSession>, ListWorkoutSessionsParams> {
  const ListWorkoutSessionsUseCase(this._repository);

  final WorkoutSessionRepository _repository;

  @override
  Future<Either<Failure, CursorPage<WorkoutSession>>> call(
    ListWorkoutSessionsParams params,
  ) {
    return _repository.listSessions(
      memberId: params.memberId,
      limit: params.limit,
      cursor: params.cursor,
    );
  }
}
