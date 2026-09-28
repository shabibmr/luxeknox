import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/membership_freeze.dart';
import '../repositories/membership_repository.dart';

class RequestMembershipFreezeParams extends Equatable {
  const RequestMembershipFreezeParams({
    required this.membershipId,
    required this.startDate,
    required this.endDate,
    this.reason,
  });

  final String membershipId;
  final DateTime startDate;
  final DateTime endDate;
  final String? reason;

  @override
  List<Object?> get props => [membershipId, startDate, endDate, reason];
}

/// FR-MEMB-014 (member self-request) and FR-MEMB-016 (admin direct-create,
/// already approved server-side by role) share this one use case — the
/// backend distinguishes intent by actor role, not by request shape.
@lazySingleton
class RequestMembershipFreezeUseCase
    implements UseCase<MembershipFreeze, RequestMembershipFreezeParams> {
  const RequestMembershipFreezeUseCase(this._repository);

  final MembershipRepository _repository;

  @override
  Future<Either<Failure, MembershipFreeze>> call(
    RequestMembershipFreezeParams params,
  ) {
    return _repository.requestFreeze(
      params.membershipId,
      startDate: params.startDate,
      endDate: params.endDate,
      reason: params.reason,
    );
  }
}
