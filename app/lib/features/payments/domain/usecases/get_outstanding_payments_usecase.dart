import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/pagination/cursor_page.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/payment.dart';
import '../repositories/payments_repository.dart';

class GetOutstandingPaymentsParams extends Equatable {
  const GetOutstandingPaymentsParams({this.limit, this.offset});

  final int? limit;
  final int? offset;

  @override
  List<Object?> get props => [limit, offset];
}

@lazySingleton
class GetOutstandingPaymentsUseCase
    implements UseCase<CursorPage<Payment>, GetOutstandingPaymentsParams> {
  const GetOutstandingPaymentsUseCase(this._repository);

  final PaymentsRepository _repository;

  @override
  Future<Either<Failure, CursorPage<Payment>>> call(
    GetOutstandingPaymentsParams params,
  ) {
    return _repository.getOutstanding(
      limit: params.limit,
      offset: params.offset,
    );
  }
}
