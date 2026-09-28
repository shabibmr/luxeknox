import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/pagination/cursor_page.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/system_alert.dart';
import '../repositories/alerts_repository.dart';

class ListSystemAlertsParams extends Equatable {
  const ListSystemAlertsParams({this.cursor});

  final String? cursor;

  @override
  List<Object?> get props => [cursor];
}

@lazySingleton
class ListSystemAlertsUseCase
    implements UseCase<CursorPage<SystemAlert>, ListSystemAlertsParams> {
  const ListSystemAlertsUseCase(this._repository);

  final AlertsRepository _repository;

  @override
  Future<Either<Failure, CursorPage<SystemAlert>>> call(
    ListSystemAlertsParams params,
  ) {
    return _repository.listAlerts(cursor: params.cursor);
  }
}
