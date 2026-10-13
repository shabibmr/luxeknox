import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/accounting_reports.dart';
import '../repositories/accounting_repository.dart';

class GetDayBookParams extends Equatable {
  const GetDayBookParams({
    required this.date,
  });

  final DateTime date;

  @override
  List<Object?> get props => [date];
}

@lazySingleton
class GetDayBookUseCase implements UseCase<DayBookReport, GetDayBookParams> {
  const GetDayBookUseCase(this._repository);

  final AccountingRepository _repository;

  @override
  Future<Either<Failure, DayBookReport>> call(GetDayBookParams params) {
    return _repository.getDayBook(
      date: params.date,
    );
  }
}
