import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/pagination/cursor_page.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/payment.dart';
import '../repositories/payments_repository.dart';

class GetPaymentsParams extends Equatable {
  const GetPaymentsParams({
    this.memberId,
    this.status,
    this.limit,
    this.offset,
  });

  final String? memberId;
  final String? status;
  final int? limit;
  final int? offset;

  @override
  List<Object?> get props => [memberId, status, limit, offset];
}

@lazySingleton
class GetPaymentsUseCase
    implements UseCase<CursorPage<Payment>, GetPaymentsParams> {
  const GetPaymentsUseCase(this._repository);

  final PaymentsRepository _repository;

  @override
  Future<Either<Failure, CursorPage<Payment>>> call(GetPaymentsParams params) {
    return _repository.getPayments(
      memberId: params.memberId,
      status: params.status,
      limit: params.limit,
      offset: params.offset,
    );
  }
}
