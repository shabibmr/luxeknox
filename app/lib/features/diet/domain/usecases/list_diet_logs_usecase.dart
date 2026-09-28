import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/pagination/cursor_page.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/diet_log.dart';
import '../repositories/diet_log_repository.dart';

class ListDietLogsParams extends Equatable {
  const ListDietLogsParams({
    required this.memberId,
    this.limit,
    this.cursor,
  });

  final String memberId;
  final int? limit;
  final String? cursor;

  @override
  List<Object?> get props => [memberId, limit, cursor];
}

@lazySingleton
class ListDietLogsUseCase
    implements UseCase<CursorPage<DietLog>, ListDietLogsParams> {
  const ListDietLogsUseCase(this._repository);

  final DietLogRepository _repository;

  @override
  Future<Either<Failure, CursorPage<DietLog>>> call(ListDietLogsParams params) {
    return _repository.listDietLogs(
      memberId: params.memberId,
      limit: params.limit,
      cursor: params.cursor,
    );
  }
}
