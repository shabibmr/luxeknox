import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/pagination/cursor_page.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/membership.dart';
import '../repositories/membership_repository.dart';

class GetMembershipsParams extends Equatable {
  const GetMembershipsParams({
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
class GetMembershipsUseCase
    implements UseCase<CursorPage<Membership>, GetMembershipsParams> {
  const GetMembershipsUseCase(this._repository);

  final MembershipRepository _repository;

  @override
  Future<Either<Failure, CursorPage<Membership>>> call(
    GetMembershipsParams params,
  ) {
    return _repository.getMemberships(
      memberId: params.memberId,
      status: params.status,
      limit: params.limit,
      offset: params.offset,
    );
  }
}
