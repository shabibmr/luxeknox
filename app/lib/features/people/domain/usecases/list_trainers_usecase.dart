import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/pagination/cursor_page.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/trainer_summary.dart';
import '../repositories/people_repository.dart';

class ListTrainersParams extends Equatable {
  const ListTrainersParams({this.query, this.cursor});

  final String? query;
  final String? cursor;

  @override
  List<Object?> get props => [query, cursor];
}

@lazySingleton
class ListTrainersUseCase
    implements UseCase<CursorPage<TrainerSummary>, ListTrainersParams> {
  const ListTrainersUseCase(this._repository);

  final PeopleRepository _repository;

  @override
  Future<Either<Failure, CursorPage<TrainerSummary>>> call(
    ListTrainersParams params,
  ) {
    return _repository.listTrainers(query: params.query, cursor: params.cursor);
  }
}
