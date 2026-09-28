import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/membership.dart';
import '../repositories/membership_repository.dart';
import 'renew_membership_usecase.dart';

@lazySingleton
class CancelMembershipUseCase
    implements UseCase<Membership, MembershipActionParams> {
  const CancelMembershipUseCase(this._repository);

  final MembershipRepository _repository;

  @override
  Future<Either<Failure, Membership>> call(MembershipActionParams params) {
    return _repository.cancel(
      params.membershipId,
      rowVersion: params.rowVersion,
      reason: params.reason,
    );
  }
}
